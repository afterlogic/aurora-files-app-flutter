package com.PrivateRouter.PrivateMailFiles

import android.os.Bundle
import android.util.Base64

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import javax.crypto.Cipher
import javax.crypto.spec.SecretKeySpec
import javax.crypto.spec.IvParameterSpec



class MainActivity : FlutterActivity() {
    private val channel = "PrivateMailFiles.PrivateRouter.com/encryption"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, channel).setMethodCallHandler { call, result ->
            val arguments = call.arguments as List<*>
            if (call.method == "decrypt") {
                val decryptedBytes = decryptFile(arguments)
                result.success(decryptedBytes)
            } else if (call.method == "encrypt") {
                val encryptedBytes = encryptFile(arguments)
                result.success(encryptedBytes)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun encryptFile(arguments: List<*>): ByteArray {
        val fileData = arguments[0] as String?
        val rawKey = arguments[1] as String?
        val iv = arguments[2] as String?

        val skeySpec = SecretKeySpec(Base64.decode(rawKey, Base64.DEFAULT), "AES")
        val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec, IvParameterSpec(Base64.decode(iv, Base64.DEFAULT)))

        return cipher.doFinal(Base64.decode(fileData, Base64.DEFAULT))
    }

    private fun decryptFile(arguments: List<*>): ByteArray {
        val fileData = arguments[0] as String?
        val rawKey = arguments[1] as String?
        val iv = arguments[2] as String?

        val skeySpec = SecretKeySpec(Base64.decode(rawKey, Base64.DEFAULT), "AES")
        val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
        cipher.init(Cipher.DECRYPT_MODE, skeySpec, IvParameterSpec(Base64.decode(iv, Base64.DEFAULT)))

        return cipher.doFinal(Base64.decode(fileData, Base64.DEFAULT))
    }
}
