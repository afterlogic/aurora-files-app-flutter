package com.privaterouter.crypto_plugin.pgp

import org.bouncycastle.openpgp.PGPPublicKey
import java.io.*

open class PgpApi {
    private val pgp = Pgp()
    private var publicKey: PGPPublicKey? = null
    private var privateKey: ByteArray? = null
    private var tempFile: File? = null

    fun getEmailFromKey(key: String): List<String> {
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

    private fun encript(outputStream: OutputStream, inputStream: InputStream, length: Long) {
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
        encript(FileOutputStream(outputFile), FileInputStream(inputFile), inputFile.length())
    }

    fun encriptBytes(array: ByteArray): ByteArray {
        val outStream = ByteArrayOutputStream(4000)
        encript(outStream, ByteArrayInputStream(array), array.size.toLong())
        return outStream.toByteArray()
    }
    
}