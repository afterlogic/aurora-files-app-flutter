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
    
    func encrypt(_ input:JavaIoInputStream,_ input2:JavaIoInputStream,_ output:JavaIoOutputStream,_ publicKey: [String],_ privateKey:String?,_ passwordForSign:String?) throws  {
        var publicKeys:[BCOpenpgpPGPPublicKeyRing]=[]
        publicKey.forEach { (key) in
            publicKeys.append( DMSPGPKeyRing.publicKeyRing(from: data!))
        }

        var secretKeyRing:BCOpenpgpPGPSecretKeyRing?
        var encryptor:DMSPGPEncryptor?
        if(privateKey != nil && passwordForSign != nil){
            secretKeyRing =  try DMSPGPKeyRing.secretKeyRing(
                from: privateKey!,
                password: passwordForSign!
            )
            encryptor = try DMSPGPEncryptor(
                publicKeyRings: publicKeys,
                secretKeyRing:secretKeyRing!,
                password: passwordForSign!
            )
        }else{
            encryptor = try DMSPGPEncryptor(publicKeyRings: publicKeys )
        }
        
        try encryptor!.encrypt(input,input2,output)
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
    
    func checkPassword(_ password:String,_ privateKey:String) -> Bool {
        do {
            try DMSPGPKeyRing.secretKeyRing(from: privateKey, password: password)
            return true
        } catch  {
            return false
            
        }
    }
    func decryptSymmetric(
        _ input:JavaIoInputStream,
        _ output:JavaIoOutputStream,
        _ password:String,
        _ length:jlong){
        SymmetricPgp.decrypt(input,output,password,length)
    }
    func encryptSymetric(
        _ input:JavaIoInputStream,
        _ output:JavaIoOutputStream,
        _ password:String,
        _ length:jlong ){
          SymmetricPgp.encrypt(input,output,password,length)
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
