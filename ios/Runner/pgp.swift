import Foundation
import DMSOpenPGP
import BouncyCastle_ObjC

class  Pgp {
    
    func decrypt(_ input:JavaIoInputStream,_ output:JavaIoOutputStream,_ privateKey:String,_ password:String) throws {
        let secretKeyRing = try DMSPGPKeyRing.secretKeyRing(from: privateKey, password: password)
        let privateKey = secretKeyRing.getSecretKey()
        let decryptor = try ByteDMSPGPDecryptor(input)
        try decryptor.decrypt( privateKey!,  password,output)
    }
    
    func encrypt(_ input:JavaIoInputStream,_ input2:JavaIoInputStream,_ output:JavaIoOutputStream,_ publicKey: BCOpenpgpPGPPublicKeyRing) throws  {
        let encryptor = try DMSPGPEncryptor(publicKeyRings: [publicKey])
        try encryptor.encrypt(input,input2,output)
    }
    
    func getKeyDescription(_ key:Data) throws->KeyInfo {
        do {
            let key = try readPublicKey(key)
            let userIds = key.userIDs
            let length = key.getBitStrength()
            return KeyInfo(emails:userIds,length: Int(length),isPrivate: false)
        } catch  {
            let key = try readPrivateKey(key)
            let userIds = key.userIDs
            let length = key.getPublicKey().getBitStrength()
            return KeyInfo(emails:userIds,length: Int(length),isPrivate: true)
        }
    }
    
    func createKeys(_ length:Int32,_ email:String,_ password:String)throws ->[String]{
        let generateData = GenerateKeyData(name: "", email: email, password: password, masterKey: KeyData(strength: Int(length)), subkey: KeyData(strength: Int(length)))
        let pair = try DMSPGPKeyRingFactory(generateKeyData: generateData).keyRing
        
        return [pair.publicKeyRing.armored(),pair.secretKeyRing!.armored()]
    }
    
    func readPublicKey(_ key:Data) throws->BCOpenpgpPGPPublicKey {
        let byteArray = IOSByteArray(nsData: key)!
        var input:JavaIoInputStream = JavaIoByteArrayInputStream(byteArray: byteArray)
        input = BCOpenpgpPGPUtil.getDecoderStream(with: input)
        let ring=BCOpenpgpPGPPublicKeyRingCollection.init(javaIoInputStream: input,with: BCOpenpgpOperatorBcBcKeyFingerprintCalculator())
        let rIt =  ring.getKeyRings()!
        
        while ( rIt.hasNext()){
            let kRing=rIt.next() as! BCOpenpgpPGPPublicKeyRing
            let kIt = kRing.getPublicKeys()!
            while( kIt.hasNext()){
                let k  = kIt.next() as! BCOpenpgpPGPPublicKey
                if(k.isEncryptionKey()){
                    return k;
                }
            }
        }
        throw CryptionError();
    }
    func readPrivateKey(_ key:Data)throws->BCOpenpgpPGPSecretKey{
        let byteArray = IOSByteArray(nsData: key)!
        let input:JavaIoInputStream = JavaIoByteArrayInputStream(byteArray: byteArray)

       return BCOpenpgpPGPSecretKeyRing(
            javaIoInputStream:BCOpenpgpPGPUtil.getDecoderStream(with: input),
            with: BCOpenpgpOperatorBcBcKeyFingerprintCalculator()
            ).getSecretKey()
        
    }
}

class KeyInfo {
    let emails:[String]
    let length:Int
    let isPrivate:Bool
    
    init(emails:[String],length:Int,isPrivate:Bool) {
        self.emails=emails
        self.length=length
        self.isPrivate=isPrivate
    }
}

extension DMSPGPEncryptor {
    
    
    public func encrypt(_ input:JavaIoInputStream,_ input2:JavaIoInputStream,_ output:JavaIoOutputStream) throws ->Void {
        
        let armoredOutput = TCMessageArmoredOutputStream(javaIoOutputStream: output)
        
        let signer = self.signer
        
        switch (encryptedDataGenerator, signer) {
        // encrypt and sign if possiable
        case let (encryptedDataGenerator?, _):
            let encryptDate = JavaUtilDate()
            let encryptedOutput = encryptedDataGenerator.open(with: armoredOutput, with: IOSByteArray(length: 1 << 16))
            let compressedDataGenerator = BCOpenpgpPGPCompressedDataGenerator(int: compressAlgorithm)
            let bcpgOutputStream = encryptedOutput.flatMap { encryptedOutput -> BCBcpgBCPGOutputStream in
                guard compressAlgorithm != BCBcpgCompressionAlgorithmTags.UNCOMPRESSED else {
                    return BCBcpgBCPGOutputStream(javaIoOutputStream: encryptedOutput)
                }
                let compressedOutput = compressedDataGenerator.open(with: encryptedOutput)
                return BCBcpgBCPGOutputStream(javaIoOutputStream: compressedOutput)
            }
            
            guard let bcpgOutput = bcpgOutputStream else {
                compressedDataGenerator.close()
                encryptedOutput?.close()
                
                armoredOutput.close()
                output.close()
                throw DMSPGPError.internal
            }
            
            signer?.signatureGenerator.generateOnePassVersion(withBoolean: false)?.encode(with: bcpgOutput)
            
            let literalDataGenerator = BCOpenpgpPGPLiteralDataGenerator()
            guard let literalDataOutput = literalDataGenerator
                .open(with: bcpgOutput,
                      withChar: BCOpenpgpPGPLiteralData.UTF8,
                      with: BCOpenpgpPGPLiteralData.CONSOLE,
                      with: encryptDate,
                      with: IOSByteArray(length: 1 << 16)) else {
                        literalDataGenerator.close()
                        bcpgOutput.close()
                        compressedDataGenerator.close()
                        encryptedOutput?.close()
                        
                        armoredOutput.close()
                        output.close()
                        throw DMSPGPError.internal
            }
            let buffer=IOSByteArray(length: 4096)
            var length:jint
            while true {
                length = input.read(with: buffer)
                if(length <= 0){
                    break
                }
                literalDataOutput.write(with: buffer)
            }
       
            literalDataOutput.write(with: IOSByteArray(nsData: Data("\r\n".utf8)))
            if(signer != nil){
                while true {
                    length = input2.read(with: buffer)
                    if(length <= 0){
                        break
                    }
                    signer?.signatureGenerator.update(with: buffer)
                }
                signer?.signatureGenerator.update(with: IOSByteArray(nsData: Data("\r\n".utf8)))
            }
            literalDataOutput.close()
            signer?.signatureGenerator.generate()?.encode(with: literalDataOutput)
            
            bcpgOutput.close()
            compressedDataGenerator.close()
            encryptedOutput?.close()
            encryptedDataGenerator.close()
            
        default:
            throw DMSPGPError.internal
        }
        
        armoredOutput.close()
        output.close()
    }
    
}
public class ByteDMSPGPDecryptor {
    
    
    public let encryptingKeyIDs: [String]
    
    public let encryptedDataDict: [String: BCOpenpgpPGPPublicKeyEncryptedData]
    public let hiddenRecipientsDataList: [BCOpenpgpPGPPublicKeyEncryptedData]
    
    private(set) public var onePassSignatureList: BCOpenpgpPGPOnePassSignatureList?
    private(set) public var signatureList: BCOpenpgpPGPSignatureList?
    private(set) public var modificationTime: Date?
    
    public init(_ input: JavaIoInputStream) throws {
        guard let armoredInput = BCOpenpgpPGPUtil.getDecoderStream(with: input) as? BCBcpgArmoredInputStream else {
            throw DMSPGPError.notArmoredInput
        }
        defer {
            input.close()
            armoredInput.close()
        }
        
        // Get encrypted data list
        var encryptedDataList: BCOpenpgpPGPEncryptedDataList?
        do {
            let result = try ExceptionCatcher.catchException {
                let objectFactory = BCOpenpgpPGPObjectFactory(javaIoInputStream: armoredInput, with: BCOpenpgpOperatorJcajceJcaKeyFingerprintCalculator())
                
                var object = objectFactory.nextObject()
                while object != nil {
                    guard let list = object as? BCOpenpgpPGPEncryptedDataList else {
                        object = objectFactory.nextObject()
                        continue
                    }
                    
                    return list
                }
                
                return nil
            }
            
            encryptedDataList = result as? BCOpenpgpPGPEncryptedDataList
        } catch {
            // continue decrypt if got encryptedDataList
        }
        
        guard let iterator = encryptedDataList?.iterator() else {
            throw DMSPGPError.invalidMessage
        }
        
        // Get encrypted data
        var keyIDs = Set<String>()
        var encryptedDataDict: [String: BCOpenpgpPGPPublicKeyEncryptedData] = [:]
        var hiddenRecipientsDataList = [BCOpenpgpPGPPublicKeyEncryptedData]()
        while iterator.hasNext() {
            guard let data = iterator.next() as? BCOpenpgpPGPPublicKeyEncryptedData else {
                continue
            }
            
            let keyID = String(fromPGPKeyID: data.getKeyID())
            if keyID.isHiddenRecipientID {
                hiddenRecipientsDataList.append(data)
            } else {
                keyIDs.insert(keyID)
                encryptedDataDict[keyID] = data
            }
        }
        
        guard (!keyIDs.isEmpty && !encryptedDataDict.isEmpty) || !hiddenRecipientsDataList.isEmpty else {
            throw DMSPGPError.invalidMessage
        }
        
        self.encryptingKeyIDs = Array(keyIDs)
        self.encryptedDataDict = encryptedDataDict
        self.hiddenRecipientsDataList = hiddenRecipientsDataList
    }
    
    public func decrypt(_ secretKey: BCOpenpgpPGPSecretKey,_ password: String,_ output:JavaIoOutputStream) throws {
        
        guard let privateKey = secretKey.getEncryptingPrivateKey(password: password) else {
            throw DMSPGPError.invalidSecrectKeyPassword
        }
        
        guard let encryptedData = encryptedDataDict[secretKey.keyID] else {
            throw DMSPGPError.invalidPrivateKey
        }
        
        var literalData: BCOpenpgpPGPLiteralData?
        
        
        let inputStream: JavaIoInputStream? = try! ExceptionCatcher.catchException {
            let object = encryptedData.getDataStream(with: BCOpenpgpOperatorBcBcPublicKeyDataDecryptorFactory(bcOpenpgpPGPPrivateKey: privateKey))
            return object
            } as? JavaIoInputStream
        guard let input = inputStream else {
            throw DMSPGPError.invalidPrivateKey
        }
        defer {
            input.close()
        }
        var factory = BCOpenpgpPGPObjectFactory(javaIoInputStream: input, with: BCOpenpgpOperatorJcajceJcaKeyFingerprintCalculator())
        var object: Any? = try? ExceptionCatcher.catchException {
            return factory.nextObject()
        }
        while object != nil {
            switch object {
            case let data as BCOpenpgpPGPCompressedData:
                guard let dataStream = data.getStream() else {
                    throw DMSPGPError.internal
                }
                factory = SkipMarkerPGPObjectFactory(javaIoInputStream: dataStream, with: BCOpenpgpOperatorJcajceJcaKeyFingerprintCalculator())
            case let list as BCOpenpgpPGPOnePassSignatureList:
                onePassSignatureList = list
            case let list as BCOpenpgpPGPSignatureList:
                signatureList = list
            case let data as BCOpenpgpPGPLiteralData:
                literalData = data
                guard let input = data.getInputStream() else { return  }
                
                let buffer=IOSByteArray(length: 4096)
                var length:jint
                while true {
                    length = input.read(with: buffer)
                    if(length <= 0){
                        break
                    }
                    output.write(with: buffer)
                }
                
                output.close()
                input.close()
            default:
                break
            }
            
            object = try? ExceptionCatcher.catchException {
                return factory.nextObject()
            }
        }
        
        if let modificationTime = literalData?.getModificationTime() {
            self.modificationTime = Date(javaUtilDate: modificationTime)
        }
        
    }
}

fileprivate extension String {
    var isHiddenRecipientID: Bool {
        return replacingOccurrences(of: "0", with: "").isEmpty
    }
}
