package com.PrivateRouter.PrivateMailFiles

import android.os.Bundle
import android.util.Base64

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
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
//            println("VO:: ${call.method}")
            if (call.method == "decrypt") {
                GlobalScope.launch {
                    try {
                        val decryptedBytes = performCryption(arguments, true)
                        runOnUiThread { result.success(decryptedBytes) }
                    } catch (ex: Exception) {
                        runOnUiThread { result.error(ex.message, null, ex) }
                    }
                }

            } else if (call.method == "encrypt") {
                GlobalScope.launch {
                    try {
                        val encryptedBytes = performCryption(arguments, false)
                        runOnUiThread { result.success(encryptedBytes) }
                    } catch (ex: Exception) {
                        runOnUiThread { result.error(ex.message, null, ex) }
                    }
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private suspend fun performCryption(arguments: List<*>, isDecrypt: Boolean): ByteArray {
        val deferred = GlobalScope.async {

            val fileData = arguments[0] as ByteArray?
            val rawKey = arguments[1] as String?
            val iv = arguments[2] as String?
            val isLast = arguments[3] as Boolean?
            println("VO:: $iv")

            val skeySpec = SecretKeySpec(Base64.decode(rawKey, Base64.DEFAULT), "AES")
            val padding = if (isLast == true) "PKCS5Padding" else "NoPadding"
            val cipher = Cipher.getInstance("AES/CBC/$padding")
            val mode = if (isDecrypt) Cipher.DECRYPT_MODE else Cipher.ENCRYPT_MODE
            cipher.init(mode, skeySpec, IvParameterSpec(Base64.decode(iv, Base64.DEFAULT)))

            cipher.doFinal(fileData)
        }

        return deferred.await()
    }
}
