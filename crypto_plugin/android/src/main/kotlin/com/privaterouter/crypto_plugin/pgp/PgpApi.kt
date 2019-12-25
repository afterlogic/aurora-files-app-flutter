package com.privaterouter.crypto_plugin.pgp

import KeyDescription
import org.bouncycastle.openpgp.PGPPublicKey
import java.io.*

open class PgpApi {
    private val pgp = Pgp()
    private var publicKey: PGPPublicKey? = null
    private var privateKey: ByteArray? = null
    private var tempFile: File? = null

    fun getKeyDescription(key: String): KeyDescription {
        return pgp.getEmailFromKey(ByteArrayInputStream(key.toByteArray()))
    }

    fun setPrivateKey(key: String?) {
        privateKey = key?.toByteArray()
    }

    fun setPublicKey(key: String?) {
        publicKey =
                key?.let { pgp.readPublicKey(ByteArrayInputStream(it.toByteArray())) }
    }

    fun setTempFile(filePath: String?) {
        tempFile =
                filePath?.let {
                    File(it).apply {
                        createNewFile()
                        assert(isFile)
                        assert(canWrite())
                    }
                }

    }

    fun getProgress(): Progress? {
        return if (pgp.progress?.complete == false) {
            pgp.progress
        } else {
            null
        }
    }

    private fun decrypt(inputStream: InputStream, outputStream: OutputStream, password: String, length: Long) {
        assert(privateKey != null)
        val privateKeyStream = ByteArrayInputStream(privateKey)
        pgp.decrypt(inputStream, outputStream, privateKeyStream, password.toCharArray(), length)
        privateKeyStream.close()
    }

    fun decryptBytes(array: ByteArray, password: String): ByteArray {
        val outStream = ByteArrayOutputStream()
        decrypt(ByteArrayInputStream(array), outStream, password, array.size.toLong())
        return outStream.toByteArray()
    }


    fun decryptFile(inputFilePath: String, outputFilePath: String, password: String) {
        val inputFile = File(inputFilePath)
        val outputFile = File(outputFilePath)
        assert(inputFile.isFile)
        assert(inputFile.exists())
        outputFile.createNewFile()
        assert(outputFile.isFile)
        assert(outputFile.canWrite())
        decrypt(FileInputStream(inputFile), FileOutputStream(outputFile), password, inputFile.length())

    }

    private fun encrypt(outputStream: OutputStream, inputStream: InputStream, length: Long) {
        assert(publicKey != null)
        assert(tempFile != null)
        pgp.encrypt(
                outputStream,
                tempFile!!,
                inputStream,
                publicKey!!,
                length
        )
    }

    fun encriptFile(inputFilePath: String, outputFilePath: String) {
        val inputFile = File(inputFilePath)
        val outputFile = File(outputFilePath)
        assert(inputFile.isFile)
        assert(inputFile.exists())
        assert(inputFile.canRead())
        outputFile.createNewFile()
        assert(outputFile.isFile)
        assert(outputFile.canWrite())
        encrypt(FileOutputStream(outputFile), FileInputStream(inputFile), inputFile.length())
    }

    fun encriptBytes(array: ByteArray): ByteArray {
        val outStream = ByteArrayOutputStream()
        encrypt(outStream, ByteArrayInputStream(array), array.size.toLong())
        return outStream.toByteArray()
    }

    fun createKeys(length: Int, email: String, password: String): List<String> {
//        assert(length in 512..4096)
        return pgp.createKeys(length, email, password).mapIndexed { i, it ->
            it.toString(Charsets.UTF_8)
        }
    }


    fun decryptSymmetric(inputStream: InputStream, outputStream: OutputStream, password: String) {
        pgp.symmetricallyDecrypt(inputStream, outputStream, password)
    }

    fun encryptSymmetric(inputStream: InputStream, outputStream: OutputStream, length: Long, password: String) {
        assert(tempFile != null)
        pgp.symmetricallyEncrypt(inputStream, outputStream, tempFile!!, length, password)
    }

    fun encryptSymmetricBytes(array: ByteArray, password: String): ByteArray {
        val outStream = ByteArrayOutputStream()
        encryptSymmetric(ByteArrayInputStream(array), outStream, array.size.toLong(), password)
        return outStream.toByteArray()
    }

    fun encryptSymmetricFile(inputFilePath: String, outputFilePath: String, password: String) {
        val inputFile = File(inputFilePath)
        val outputFile = File(outputFilePath)
        assert(inputFile.isFile)
        assert(inputFile.exists())
        assert(inputFile.canRead())
        outputFile.createNewFile()
        assert(outputFile.isFile)
        assert(outputFile.canWrite())
        encryptSymmetric(FileInputStream(inputFile), FileOutputStream(outputFile), inputFile.length(), password)
    }

    fun decryptSymmetricBytes(array: ByteArray, password: String): ByteArray {
        val outStream = ByteArrayOutputStream()
        decryptSymmetric(ByteArrayInputStream(array), outStream, password)
        return outStream.toByteArray()
    }

    fun decryptSymmetricFile(inputFilePath: String, outputFilePath: String, password: String) {
        val inputFile = File(inputFilePath)
        val outputFile = File(outputFilePath)
        assert(inputFile.isFile)
        assert(inputFile.exists())
        outputFile.createNewFile()
        assert(outputFile.isFile)
        assert(outputFile.canWrite())
        decryptSymmetric(FileInputStream(inputFile), FileOutputStream(outputFile), password)
    }

    companion object {
        const val privateKeyStart = "-----BEGIN PGP PRIVATE KEY BLOCK-----\n" +
                "Version: OpenPGP.js v4.5.5\n\n"
        const val privateKeyEnd = "\n\n-----END PGP PRIVATE KEY BLOCK-----"
        const val publicKeyStart = "-----BEGIN PGP PUBLIC KEY BLOCK-----\n" +
                "Version: OpenPGP.js v4.5.5\n\n"
        const val publicKeyEnd = "\n\n-----END PGP PUBLIC KEY BLOCK-----"
    }
}