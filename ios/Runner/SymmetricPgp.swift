import Foundation
import BouncyCastle_ObjC
class SymmetricPgp {
   static func encrypt(
        _ input:JavaIoInputStream,
        _ output:JavaIoOutputStream,
        _ password:String,
        _ length:jlong )  {
        
        let aes256 = 9
        let encGen = BCOpenpgpPGPEncryptedDataGenerator(
            bcOpenpgpOperatorPGPDataEncryptorBuilder:
            BCOpenpgpOperatorJcajceJcePGPDataEncryptorBuilder
                .init(int: jint(aes256))
                .setWithIntegrityPacketWithBoolean(true)?
                .setSecureRandomWith(JavaSecuritySecureRandom())?
                .setProviderWith("BC")
        )
        encGen.addMethod(with:
            BCOpenpgpOperatorJcajceJcePBEKeyEncryptionMethodGenerator
                .init(charArray: IOSCharArray.init(nsString:password))
                .setProviderWith("BC")
        )
        let encOut=encGen.open(with: output, withLong: length)
        BCUtilIoStreams.pipeAll(with: input, with: encOut)
        encOut?.close()
    }
  static  func decrypt(
        _ input:JavaIoInputStream,
        _ output:JavaIoOutputStream,
        _ password:String,
        _ length:jlong ){
        //todo
    }
}
