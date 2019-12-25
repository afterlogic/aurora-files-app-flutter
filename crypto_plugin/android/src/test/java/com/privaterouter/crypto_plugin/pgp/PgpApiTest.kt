package com.privaterouter.crypto_plugin.pgp

import org.junit.Test
import java.io.File

class PgpApiTest {

    @Test
    fun testGetUserUid() {
        val pgpHelper = PgpApi()
        val keys = pgpHelper.createKeys(2000, "test@afterlogic.com", "111")
        val result = pgpHelper.getKeyDescription(keys.first())
        assert(result.emails.size == 1 && result.emails[0] == "test@afterlogic.com")
    }

    @Test
    fun testGenerateKey() {
        val pgpHelper = PgpApi()
        val keys = pgpHelper.createKeys(8000, "test@afterlogic.com", "111")
        pgpHelper.setPrivateKey(keys[1])
        pgpHelper.setPublicKey(keys[0])
        pgpHelper.setTempFile("/home/dikiy/test_pgp")
        val message = "message".toByteArray()
        val messageD = pgpHelper.encriptBytes(message)
        val messageE = pgpHelper.decryptBytes(messageD, password)
        assert(String(messageE) == String(message))
    }

    @Test
    fun testPgpHelper() {
        val pgpHelper = PgpApi()
        pgpHelper.setPrivateKey(privateKey)
        pgpHelper.setPublicKey(publicKey)
        pgpHelper.setTempFile("/home/dikiy/test_pgp")
        val message = "message".toByteArray()
        val messageEncrypted = pgpHelper.encriptBytes(message)
        val messageDecrypted = pgpHelper.decryptBytes(messageEncrypted, password)
        assert(String(messageDecrypted) == String(message))
    }

    @Test
    fun testFilePgpHelper() {
        val pgpHelper = PgpApi()
        val file = "/home/dikiy/Загрузки/tester.zip"
        val fileD = "/home/dikiy/Загрузки/tester.zip.d"
        val fileC = "/home/dikiy/Загрузки/copy_tester.zip"
        pgpHelper.setPrivateKey(privateKey)
        pgpHelper.setPublicKey(publicKey)
        pgpHelper.setTempFile("/home/dikiy/test_pgp")

        pgpHelper.encriptFile(file, fileD)
        pgpHelper.decryptFile(fileD, fileC, password)
        assert(File(file).length() == File(fileC).length())
    }


    @Test
    fun testEncryptSymmetric() {
        val pgpHelper = PgpApi()
        val file = File("/home/dikiy/test/test.png")
        val outFile = File("/home/dikiy/test/test.png.gpg")
        pgpHelper.setTempFile("/home/dikiy/test_pgp")
        pgpHelper.encryptSymmetricFile(file.path, outFile.path, "test")

    }


    @Test
    fun testDecryptSymmetric() {
        val pgpHelper = PgpApi()
        val file = File("/home/dikiy/test/test.png.gpg")
        val outFile = File("/home/dikiy/test/test.png")

        pgpHelper.decryptSymmetricFile(file.path, outFile.path, "test")
    }

    companion object {
        const val password = "111"
        const val privateKey = "-----BEGIN PGP PRIVATE KEY BLOCK-----\nVersion: OpenPGP.js v4.5.5\nComment: https://openpgpjs.org\n\n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\nkiDE\n=JfKa\n-----END PGP PRIVATE KEY BLOCK-----"
        const val publicKey = "-----BEGIN PGP PUBLIC KEY BLOCK-----\nVersion: OpenPGP.js v4.5.5\nComment: https://openpgpjs.org\n\nxsBNBF2bSLIBCACQPD0/sROI7sdCtDxC21CLZPBM9ZBJAsqpOjuL8yYyuzyO\nypr+eS+XyI3yggq6G/fQHvY7zrDXTz+Nlr0lU7wYr93pKzbjNgmhQjWSKN47\nn20h1vXM9GIUeXlTrQB+Bv/xfGawHaWAwo5RpEB9vk8EYYzAPy8GCVCPcpYw\nO8civ6IYSdDur+yymPcc07OCSIslsIG3sG+B1N4zTcQATZLCC5QD2KZO8kDJ\nsbl3haz+IJjIsnwGHyahagpHM1YvLpsb5Bkehs7zTgmM+NEeAjLaFCsN28Vd\nMre7jxbpCP0ZSXbyn8DYWuYo8iJ19QplqRBNogpeet5Yttv0Jif9lT09ABEB\nAAHNGlRlc3QgPHRlc3RAYWZ0ZXJsb2dpYy5jb20+wsB1BBABCAAfBQJdm0iy\nBgsJBwgDAgQVCAoCAxYCAQIZAQIbAwIeAQAKCRCdhr39jokMLo1QB/9t2DEI\nEOkCgTxeDUEQfHzTfzoCnBXV7uXqQw1aqRdEW7zCCKnAR1+NxoGIa4dsd4H/\nYuNHrh9B0Uh3ywE4Y8e4JDHfj9g1G27FAHbW6VAlgeDc0qt1GFX9ib9Z+fk1\nbxfNwyBj0h4iZXlxQslMIMJqw1IcLWB0cN3xjzKTUHaNV9zd8hAUp4Tqru4B\n6rb1Xzg61RAsg4Ks+jacfzIc3lr05yGBaVn3dkcn5pKL46sPBBb3eawe5NoG\nKgoTe616y0mn6SzMU/1NG+Ul3L8lR8fi90a6zy0UIBbhWGtj8+RfLjmdKVcu\nYYz9ij6kX3PmVDK47ABA3/qFqusKmw+bate8zsBNBF2bSLIBCADXOrcU44W5\nodCPeYbxGqB5pFj4fqWnMi6vzv4DWl+Tb7gu3fneL8/pwM/0l0cMyIEZJThc\nEJ2pF8zk+hV6cwTrNTgO+VCMOcedzlJ43T5dsPtlIec3NQT573d/HE3DL7kK\nAdLOZTlJ/N26RVvluM9za1IDkhKzxCHNNK3Y+AfmgKfKu3VB4jnYVX2B9R0D\nhUOMKfVQV4uBvxTqxVWVEyu+s6EJCDufk9dVSDmbUu0dtOEprtPCqy2bU7Y9\nBvVeAakiExRF0I0QuT43JShv7iuGQYOpR0TqJCTLbXSHaWngkVsOw3PilDYa\n0v+3w8O60XEvxHFLX7x6g47tBbfkrUHzABEBAAHCwF8EGAEIAAkFAl2bSLIC\nGwwACgkQnYa9/Y6JDC7d2Qf/dIgQqcliWOkuldsfIZ+O4pufBGX4BWsb+x4O\nd2ccnt13s22190wkfq/fjd0Rfhpn/OUaL3HLjE+f/nXq6MUvWpx2ISO90AAy\nGXITp2b80Dna3GOaEJRJ1sfXQ8+i0F0iRPHSESieYL5FDoDIdo5PtJwiEysM\nU3+DR9oHgFBgd8b6LtZsgzEj5VXC7r0WJX4EaNVY9be2kO2sJIr5vJukntkj\nWRwqXezF9HKanu7vZGL6JhYpcEL9SiDxCVdZ+I6bL+zQM5+DxjfjvLpctGl3\nYNeUf2hCfeJq0+X9liefXQUwYmm2kkmuNq1zM/ZwiRz9s+yRnrBWEa1ez+lK\nLJIgxA==\n=c5ef\n-----END PGP PUBLIC KEY BLOCK-----"

    }
}