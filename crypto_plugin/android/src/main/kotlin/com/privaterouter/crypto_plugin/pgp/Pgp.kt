package com.privaterouter.crypto_plugin.pgp


import KeyDescription
import org.bouncycastle.bcpg.ArmoredOutputStream
import org.bouncycastle.crypto.params.AsymmetricKeyParameter
import org.bouncycastle.crypto.util.PrivateKeyInfoFactory
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
import org.pgpainless.algorithm.HashAlgorithm
import org.pgpainless.algorithm.SymmetricKeyAlgorithm
import org.pgpainless.decryption_verification.DecryptionBuilder
import org.pgpainless.decryption_verification.DecryptionStream
import org.pgpainless.encryption_signing.EncryptionBuilder
import org.pgpainless.encryption_signing.EncryptionStream
import org.pgpainless.key.generation.type.RSA_GENERAL
import org.pgpainless.key.generation.type.length.RsaLength
import org.pgpainless.key.parsing.KeyRingReader
import org.pgpainless.key.protection.KeyRingProtectionSettings
import org.pgpainless.key.protection.PasswordBasedSecretKeyRingProtector
import org.pgpainless.key.protection.SecretKeyPassphraseProvider
import org.pgpainless.util.BCUtil
import org.pgpainless.util.Passphrase


class Pgp {
    private val digestCalculator = BcPGPDigestCalculatorProvider()
    private val provider = BouncyCastleProvider()
    private val calculator: KeyFingerPrintCalculator = BcKeyFingerprintCalculator()
    var progress: Progress? = null
        private set

    init {
        Security.addProvider(provider)
    }

    @Throws(IOException::class, PGPException::class)
    fun readPublicKey(inputStream: InputStream): PGPPublicKey {
        var inputStream1 = inputStream
        inputStream1 = PGPUtil.getDecoderStream(inputStream1)

        val pgpPub = PGPPublicKeyRingCollection(inputStream1, calculator)

        var key: PGPPublicKey? = null

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

    fun readPrivateKey(inputStream: InputStream): PGPSecretKey {
        var inputStream1 = inputStream
        inputStream1 = PGPUtil.getDecoderStream(inputStream1)
        return requireNotNull(KeyRingReader.readSecretKeyRing(inputStream1).secretKey)
    }

    @Throws(Exception::class)
    fun decrypt(inputStream: InputStream, output: OutputStream, privateKey: String?, password: String, fileLength: Long, publicKey: String?) {
        this.progress?.stop = true
        val progress = Progress()
        this.progress = progress
        progress.total = fileLength
        var decryptionStream: DecryptionStream? = null
        try {

            decryptionStream = DecryptionBuilder()
                    .onInputStream(inputStream)
                    .let {
                        if (privateKey != null) {
                            val settings = KeyRingProtectionSettings(SymmetricKeyAlgorithm.AES_256, HashAlgorithm.MD5, 0)
                            val secretKeys = KeyRingReader().secretKeyRing(privateKey)
                            val secretKeyDecryptor = PasswordBasedSecretKeyRingProtector(settings, SecretKeyPassphraseProvider { Passphrase(password.toCharArray()) })
                            it.decryptWith(
                                    secretKeyDecryptor,
                                    BCUtil.keyRingsToKeyRingCollection(secretKeys)
                            )
                        } else {
                            it.doNotDecrypt()
                        }
                    }
                    .let {
                        if (publicKey != null) {
                            val keyStream = PGPUtil.getDecoderStream(ByteArrayInputStream(publicKey.toByteArray()))
                            val pgpPub = PGPPublicKeyRingCollection(keyStream, calculator)
                            it
                                    .verifyWith(pgpPub)
                                    .handleMissingPublicKeysWith {
                                        throw SignError()
                                    }
                        } else {
                            it.doNotVerify()
                        }
                    }
                    .build()

            if (privateKey == null) {
                decryptionStream?.result?.isSigned
            }

            val byffer = ByteArray(4096)
            var length: Int
            while (true) {
                length = decryptionStream.read(byffer)
                if (length <= 0) {
                    break
                }
                progress.update(length)
                output.write(byffer, 0, length)
            }
        } catch (e: Throwable) {
            throw  e
        } finally {
            decryptionStream?.close()
            output.close()
            inputStream.close()
            progress.complete = true
        }
    }

    @Throws(IOException::class, NoSuchProviderException::class, PGPException::class)
    fun encrypt(
            output: OutputStream,
            input: InputStream,
            publicKey: String?,
            privateKey: String?,
            password: String,
            fileLength: Long
    ) {

        this.progress?.stop = true
        val progress = Progress()
        this.progress = progress
        progress.total = fileLength

        var encryptionStream: EncryptionStream? = null
        try {

            encryptionStream = EncryptionBuilder()
                    .onOutputStream(output)
                    .let {
                        if (publicKey != null) {
                            val encKey = readPublicKey(ByteArrayInputStream(publicKey.toByteArray()))
                            it
                                    .toRecipients(encKey)
                                    .usingAlgorithms(
                                            SymmetricKeyAlgorithm.AES_256,
                                            HashAlgorithm.SHA512,
                                            CompressionAlgorithm.ZIP
                                    )
                        } else {
                            it.doNotEncrypt()
                        }
                    }
                    .let {
                        if (privateKey == null) {
                            it.doNotSign()
                        } else {
                            val settings = KeyRingProtectionSettings(SymmetricKeyAlgorithm.AES_256, HashAlgorithm.MD5, 0)
                            val secretKeys = KeyRingReader().secretKeyRing(privateKey)
                            val secretKeyDecryptor = PasswordBasedSecretKeyRingProtector(settings, SecretKeyPassphraseProvider { Passphrase(password.toCharArray()) })

                            it.signWith<Any>(secretKeyDecryptor, secretKeys)
                        }
                    }
                    .asciiArmor()

            val byffer = ByteArray(4096)
            var length: Int
            while (true) {
                length = input.read(byffer)
                if (length <= 0) {
                    break
                }
                progress.update(length)
                encryptionStream.write(byffer, 0, length)
            }

        } catch (e: Throwable) {
            throw e
        } finally {
            encryptionStream?.close()
            input.close()
            output.close()
            progress.complete = true
        }
    }

    fun getEmailFromKey(inputStream: InputStream): KeyDescription {
        var userIDs: Iterator<String>
        var bitStrength: Int
        var isPrivate: Boolean
        try {
            val key = readPublicKey(inputStream)
            userIDs = key.userIDs
            bitStrength = key.bitStrength
            isPrivate = false
        } catch (e: PGPException) {
            inputStream.reset()
            val key = readPrivateKey(inputStream)
            userIDs = key.userIDs
            bitStrength = key.publicKey.bitStrength
            isPrivate = true
        }
        val users = ArrayList<String>()
        while (userIDs.hasNext())
            users.add(userIDs.next())
        return KeyDescription(users, bitStrength, isPrivate)
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
                             fileLength: Long,
                             password: String,
                             privateKey: String?,
                             privateKeyPassword: String?) {
        this.progress?.stop = true
        val progress = Progress()
        this.progress = progress
        progress.total = fileLength
        var preparedInputStream: InputStream? = null
        var encOut: OutputStream? = null
        try {
            val encryptionAlgorithm = SymmetricKeyAlgorithm.AES_256
            val compressionAlgorithm = CompressionAlgorithm.ZIP
            val passphrase = Passphrase(password.toCharArray())
            compress(inputStream, FileOutputStream(prepareEncrypt), compressionAlgorithm.algorithmId, fileLength)
            preparedInputStream = FileInputStream(prepareEncrypt)

            val encGen = PGPEncryptedDataGenerator(
                    JcePGPDataEncryptorBuilder(encryptionAlgorithm.algorithmId)
                            .setWithIntegrityPacket(true)
                            .setSecureRandom(SecureRandom())

            )

            encGen.addMethod(
                    JcePBEKeyEncryptionMethodGenerator(passphrase.chars)
                            .setProvider(provider)
            )

            encOut = if (privateKey != null && privateKeyPassword != null) {
                sign(encGen.open(outputStream, prepareEncrypt.length()), privateKey, privateKeyPassword)
            } else {
                encGen.open(outputStream, prepareEncrypt.length())!!
            }

            val byffer = ByteArray(4096)
            var length: Int
            while (true) {
                length = preparedInputStream.read(byffer)
                if (length <= 0) {
                    break
                }
                progress.update(length)
                encOut.write(byffer, 0, length)
            }
            encOut.close()
        } catch (e: Throwable) {
            throw  e
        } finally {
            prepareEncrypt.delete()
            encOut?.close()
            preparedInputStream?.close()
            inputStream.close()
            outputStream.close()
            progress.complete = true
        }
    }

    @Throws(IOException::class, PGPException::class)
    fun symmetricallyDecrypt(inputStream: InputStream, outputStream: OutputStream, password: String, publicKey: String?) {
        this.progress?.stop = true
        val progress = Progress()
        this.progress = progress
        val passphrase = Passphrase(password.toCharArray())
        val pbe: PGPPBEEncryptedData

        val decoderInput = PGPUtil.getDecoderStream(inputStream)

        try {
            val pgpF = BcPGPObjectFactory(decoderInput)
            val enc: PGPEncryptedDataList
            var o = pgpF.nextObject()

            enc = if (o !is PGPEncryptedDataList) {
                pgpF.nextObject() as PGPEncryptedDataList
            } else {
                o
            }

            pbe = enc.get(0) as PGPPBEEncryptedData

            val clear = pbe.getDataStream(
                    BcPBEDataDecryptorFactory(passphrase.chars, digestCalculator))

            var pgpFact = BcPGPObjectFactory(clear)

            o = pgpFact.nextObject()
            if (o is PGPCompressedData) {
                pgpFact = BcPGPObjectFactory(o.dataStream)
                o = pgpFact.nextObject()
            }

            val ld = o as PGPLiteralData
            val unc = if (publicKey == null) {
                ld.inputStream
            } else {
                checkSign(ld.inputStream, publicKey)
            }

            val byffer = ByteArray(4096)
            var length: Int
            while (true) {
                length = unc.read(byffer)
                if (length <= 0) {
                    break
                }
                progress.update(length)
                outputStream.write(byffer, 0, length)
            }


        } finally {
            outputStream.close()
            decoderInput.close()
            progress.complete = true
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

    fun checkSign(input: InputStream, publicKey: String): DecryptionStream {
        return DecryptionBuilder()
                .onInputStream(input)
                .doNotDecrypt()
                .let {
                    val keyStream = PGPUtil.getDecoderStream(ByteArrayInputStream(publicKey.toByteArray()))
                    val pgpPub = PGPPublicKeyRingCollection(keyStream, calculator)
                    it
                            .verifyWith(pgpPub)
                            .handleMissingPublicKeysWith {
                                throw SignError()
                            }
                }
                .build()
    }


    fun sign(output: OutputStream, privateKey: String, password: String): EncryptionStream {
        return EncryptionBuilder()
                .onOutputStream(output)
                .doNotEncrypt()
                .let {
                    val settings = KeyRingProtectionSettings(SymmetricKeyAlgorithm.AES_256, HashAlgorithm.MD5, 0)
                    val secretKeys = KeyRingReader().secretKeyRing(privateKey)
                    val secretKeyDecryptor = PasswordBasedSecretKeyRingProtector(settings, SecretKeyPassphraseProvider { Passphrase(password.toCharArray()) })

                    it.signWith<Any>(secretKeyDecryptor, secretKeys)
                }
                .asciiArmor()
    }
}
