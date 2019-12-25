package com.privaterouter.crypto_plugin.pgp


import KeyDescription
import org.bouncycastle.bcpg.ArmoredOutputStream
import java.util.Date

import org.bouncycastle.jce.provider.BouncyCastleProvider
import org.bouncycastle.openpgp.*
import org.bouncycastle.openpgp.operator.KeyFingerPrintCalculator
import org.bouncycastle.openpgp.operator.bc.BcKeyFingerprintCalculator
import java.security.*
import org.bouncycastle.openpgp.operator.jcajce.*
import java.io.*
import org.bouncycastle.openpgp.PGPPublicKey
import org.bouncycastle.openpgp.bc.BcPGPObjectFactory
import org.bouncycastle.openpgp.operator.bc.BcPBEDataDecryptorFactory
import org.bouncycastle.openpgp.operator.bc.BcPGPDigestCalculatorProvider
import org.bouncycastle.util.io.Streams
import org.pgpainless.PGPainless
import org.pgpainless.algorithm.CompressionAlgorithm
import org.pgpainless.algorithm.SymmetricKeyAlgorithm
import org.pgpainless.key.generation.type.RSA_GENERAL
import org.pgpainless.key.generation.type.length.RsaLength
import org.pgpainless.symmetric_encryption.SymmetricEncryptorDecryptor
import org.pgpainless.util.Passphrase


/**
 * Taken from org.bouncycastle.openpgp.examples
 *
 * @author seamans
 * @author jdamico <damico></damico>@dcon.com.br>
 */
class Pgp {

    private val provider: Provider
    private val calculator: KeyFingerPrintCalculator
    var progress: Progress? = null
        private set

    init {
        provider = BouncyCastleProvider()
        Security.addProvider(provider)
        calculator = BcKeyFingerprintCalculator()
    }

    @Throws(IOException::class, PGPException::class)
    fun readPublicKey(inputStream: InputStream): PGPPublicKey {
        var inputStream1 = inputStream
        inputStream1 = PGPUtil.getDecoderStream(inputStream1)
        val pgpPub = PGPPublicKeyRingCollection(inputStream1, calculator)
        //
        // we just loop through the collection till we find a key suitable for encryption, inputStream the real
        // world you would probably want to be a bit smarter about this.
        //
        var key: PGPPublicKey? = null

        //
        // iterate through the key rings.
        //
        val rIt = pgpPub.keyRings

        while (key == null && rIt.hasNext()) {
            val kRing = rIt.next()
            val kIt = kRing.publicKeys
            while (key == null && kIt.hasNext()) {
                val k = kIt.next()

                if (k.isEncryptionKey) {
                    key = k
                }
            }
        }

        requireNotNull(key) { "Can't find encryption key inputStream key ring." }

        return key!!
    }

    /**
     * Load a secret key ring collection from keyIn and find the secret key corresponding to
     * keyID if it exists.
     *
     * @param keyIn input stream representing a key ring collection.
     * @param keyID keyID we want.
     * @param pass  passphrase to decrypt secret key with.
     * @return
     * @throws IOException
     * @throws PGPException
     * @throws NoSuchProviderException
     */
    @Throws(IOException::class, PGPException::class, NoSuchProviderException::class)
    fun findSecretKey(keyIn: InputStream, keyID: Long, pass: CharArray): PGPPrivateKey? {
        val pgpSec = PGPSecretKeyRingCollection(
                PGPUtil.getDecoderStream(keyIn), calculator)

        val pgpSecKey = pgpSec.getSecretKey(keyID) ?: return null

        val a = JcePBESecretKeyDecryptorBuilder(JcaPGPDigestCalculatorProviderBuilder()
                .setProvider(provider)
                .build())
                .setProvider(provider)
                .build(pass)

        return pgpSecKey.extractPrivateKey(a)
    }

    /**
     * decrypt the passed inputStream message stream
     */
    @Throws(Exception::class)
    fun decrypt(inputStream: InputStream, out: OutputStream, keyIn: InputStream, passwd: CharArray, length: Long) {
        this.progress?.stop = true
        val progress = Progress()
        this.progress = progress
        try {
            progress.total = length
            var inputStream1 = inputStream
            inputStream1 = PGPUtil.getDecoderStream(inputStream1)
            val pgpF = PGPObjectFactory(inputStream1, calculator)
            val enc: PGPEncryptedDataList
            val o = pgpF.nextObject()
            //
            // the first object might be a PGP marker packet.
            //
            enc = if (o is PGPEncryptedDataList) {
                o
            } else {
                pgpF.nextObject() as PGPEncryptedDataList
            }

            //
            // find the secret key
            //
            val it = enc.encryptedDataObjects
            var sKey: PGPPrivateKey? = null
            var pbe: PGPPublicKeyEncryptedData? = null

            while (sKey == null && it.hasNext()) {
                val next = it.next()
                pbe = next as PGPPublicKeyEncryptedData?
                sKey = findSecretKey(keyIn, pbe!!.keyID, passwd)
            }

            requireNotNull(sKey) { "Secret key for message not found." }

            val b = JcePublicKeyDataDecryptorFactoryBuilder()
                    .setProvider(provider)
                    .setContentProvider(provider)
                    .build(sKey)

            val clear = pbe!!.getDataStream(b)

            val plainFact = PGPObjectFactory(clear, calculator)

            var message = plainFact.nextObject()

            if (message is PGPCompressedData) {
                val pgpFact = PGPObjectFactory(message.dataStream, calculator)

                message = pgpFact.nextObject()
                if (message is PGPOnePassSignatureList) {
                    message = pgpFact.nextObject()
                }
            }

            if (message is PGPLiteralData) {
                val unc = message.inputStream
                var ch: Int
                while (true) {
                    ch = unc.read()
                    if (ch < 0) {
                        break
                    }
                    progress.update(1)
                    out.write(ch)
                }
            } else if (message is PGPOnePassSignatureList) {
                throw PGPException("Encrypted message contains a signed message - not literal data.")
            } else {
                throw PGPException("Message is not a simple encrypted file - type unknown.")
            }

            if (pbe.isIntegrityProtected) {
                if (!pbe.verify()) {
                    throw PGPException("Message failed integrity check")
                }
            }
            progress.complete = true
        } catch (e: Throwable) {
            progress.complete = true
            throw  e
        }
    }

    @Throws(IOException::class, NoSuchProviderException::class, PGPException::class)
    fun encrypt(output: OutputStream, prepareEncrypt: File, input: InputStream,
                encKey: PGPPublicKey, fileLength: Long) {
        this.progress?.stop = true
        val progress = Progress()
        this.progress = progress
        try {
            val output = ArmoredOutputStream(output)
            val comData = PGPCompressedDataGenerator(
                    PGPCompressedData.ZIP)

            prepareEncrypt.deleteOnExit()

            writeFileToLiteralData(comData.open(FileOutputStream(prepareEncrypt)), input, fileLength)

            comData.close()

            val c = JcePGPDataEncryptorBuilder(PGPEncryptedData.CAST5)
                    .setWithIntegrityPacket(false)
                    .setSecureRandom(SecureRandom())
                    .setProvider(provider)

            val cPk = PGPEncryptedDataGenerator(c)

            val d = JcePublicKeyKeyEncryptionMethodGenerator(encKey)
                    .setProvider(provider)
                    .setSecureRandom(SecureRandom())

            cPk.addMethod(d)
            val cOut = cPk.open(output, prepareEncrypt.length())

            val fileInput = FileInputStream(prepareEncrypt)

            progress.total = prepareEncrypt.length()
            val byffer = ByteArray(4096)
            var length: Int
            while (true) {
                length = fileInput.read(byffer)
                if (length <= 0) {
                    break
                }
                progress.update(length)
                cOut.write(byffer, 0, length)
            }

            prepareEncrypt.deleteOnExit()
            cOut.close()
            output.close()
            fileInput.close()
            progress.complete = true
        } catch (e: Throwable) {
            progress.complete = true
            throw e
        }
    }


    @Throws(IOException::class)
    private fun writeFileToLiteralData(outputStream: OutputStream, inputStream: InputStream, length: Long) {
        val var3 = PGPLiteralDataGenerator()
        val var4 = var3.open(outputStream, PGPLiteralData.BINARY, "temp", length, Date(System.currentTimeMillis()))
        pipeFileContents(inputStream, var4)
    }

    @Throws(IOException::class)
    private fun pipeFileContents(inputStream: InputStream, var1: OutputStream) {
        val var4 = ByteArray(4096)

        var var5: Int
        while (true) {
            var5 = inputStream.read(var4)
            if (var5 <= 0) {
                break
            }
            var1.write(var4, 0, var5)
        }

        var1.close()
        inputStream.close()
    }


    fun getEmailFromKey(inputStream: InputStream): KeyDescription {
        val key = readPublicKey(inputStream)
        val userIDs = key.userIDs
        val users = ArrayList<String>()
        while (userIDs.hasNext())
            users.add(userIDs.next())
        return KeyDescription(users, key.bitStrength)
    }

    fun createKeys(length: Int, email: String, password: String): List<ByteArray> {
        val rsaLength = when {
            length <= 1024 -> RsaLength._1024
            length <= 2048 -> RsaLength._2048
            length <= 3072 -> RsaLength._3072
            length <= 4096 -> RsaLength._4096
            else -> RsaLength._8192
        }

        val keyRing = PGPainless.generateKeyRing().withMasterKey(
                org.pgpainless.key.generation.KeySpec.getBuilder(RSA_GENERAL.withLength(rsaLength))
                        .withDefaultKeyFlags()
                        .withDefaultAlgorithms())
                .withPrimaryUserId(email)
                .withPassphrase(Passphrase(password.toCharArray()))
                .build()
        val secretOut = ByteArrayOutputStream()
        val publicOut = ByteArrayOutputStream()
        val armoredSecretOut = ArmoredOutputStream(secretOut)
        val armoredPublicOut = ArmoredOutputStream(publicOut)
        armoredSecretOut.write(keyRing.secretKeys!!.encoded)
        armoredSecretOut.close()
        armoredPublicOut.write(keyRing.publicKeys!!.encoded)
        armoredPublicOut.close()

        return arrayListOf<ByteArray>(publicOut.toByteArray(), secretOut.toByteArray())
    }


    fun symmetricallyEncrypt(inputStream: InputStream,
                             outputStream: OutputStream,
                             prepareEncrypt: File,
                             length: Long,
                             password: String) {

        val encryptionAlgorithm = SymmetricKeyAlgorithm.AES_256
        val compressionAlgorithm = CompressionAlgorithm.ZIP
        val passphrase = Passphrase(password.toCharArray())
        compress(inputStream, FileOutputStream(prepareEncrypt), compressionAlgorithm.algorithmId, length)
        val preparedInputStream = FileInputStream(prepareEncrypt)

        val encGen = PGPEncryptedDataGenerator(
                JcePGPDataEncryptorBuilder(encryptionAlgorithm.algorithmId)
                        .setWithIntegrityPacket(true)
                        .setSecureRandom(SecureRandom())
                        .setProvider(provider))

        encGen.addMethod(JcePBEKeyEncryptionMethodGenerator(passphrase.chars).setProvider(provider))

        val encOut = encGen.open(outputStream, prepareEncrypt.length())

        Streams.pipeAll(preparedInputStream, encOut)

        encOut.close()
    }

    @Throws(IOException::class, PGPException::class)
    fun symmetricallyDecrypt(inputStream: InputStream, outputStream: OutputStream, password: String) {
        val passphrase = Passphrase(password.toCharArray())
        val pbe: PGPPBEEncryptedData

        val decoderInput = PGPUtil.getDecoderStream(inputStream)

        try {
            val pgpF = BcPGPObjectFactory(decoderInput)
            val enc: PGPEncryptedDataList
            var o = pgpF.nextObject()

            if (o is PGPEncryptedDataList) {
                enc = o
            } else {
                enc = pgpF.nextObject() as PGPEncryptedDataList
            }

            pbe = enc.get(0) as PGPPBEEncryptedData

            val clear = pbe.getDataStream(
                    BcPBEDataDecryptorFactory(passphrase.chars, BcPGPDigestCalculatorProvider()))

            var pgpFact = BcPGPObjectFactory(clear)

            o = pgpFact.nextObject()
            if (o is PGPCompressedData) {
                pgpFact = BcPGPObjectFactory(o.dataStream)
                o = pgpFact.nextObject()
            }

            val ld = o as PGPLiteralData
            val unc = ld.inputStream

            try {

                Streams.pipeAll(unc, outputStream)
            } finally {
                outputStream?.close()
            }
        } finally {
            decoderInput.close()
        }

        if (pbe.isIntegrityProtected) {
            if (!pbe.verify()) {
                throw PGPException("Integrity check failed.")
            }
        } else {
            throw PGPException("Symmetrically encrypted data is not integrity protected.")
        }
    }

    @Throws(IOException::class)
    private fun compress(inputStream: InputStream, outputStream: OutputStream, algorithm: Int, size: Long) {
        val comData = PGPCompressedDataGenerator(algorithm)
        val cos = comData.open(outputStream)

        val lData = PGPLiteralDataGenerator()

        val pOut = lData.open(cos,
                PGPLiteralData.BINARY,
                PGPLiteralDataGenerator.CONSOLE,
                size,
                Date()
        )
        Streams.pipeAll(inputStream, pOut)
        pOut.close()

        comData.close()
    }

}
