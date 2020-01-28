package com.afterlogic.crypto_plugin.aes

import org.bouncycastle.util.encoders.Base64
import javax.crypto.Cipher
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

object Aes {

    fun performCryption(fileData: ByteArray, rawKey: String, iv: String, isLast: Boolean, isDecrypt: Boolean): ByteArray {

        val skeySpec = SecretKeySpec(Base64.decode(rawKey), "AES")
        val padding = if (isLast) "PKCS5Padding" else "NoPadding"
        val cipher = Cipher.getInstance("AES/CBC/$padding")
        val mode = if (isDecrypt) Cipher.DECRYPT_MODE else Cipher.ENCRYPT_MODE
        cipher.init(mode, skeySpec, IvParameterSpec(Base64.decode(iv)))

        return cipher.doFinal(fileData)

    }
}