package com.privaterouter.crypto_plugin

import com.privaterouter.crypto_plugin.aes.Aes
import com.privaterouter.crypto_plugin.pgp.PgpApi
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.reactivex.*
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.internal.schedulers.SingleScheduler

class CryptoPlugin : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "crypto_plugin")
            channel.setMethodCallHandler(CryptoPlugin())
        }
    }

    private var pgp = PgpApi()
    private val getterScheduler: Scheduler = SingleScheduler()
    private val executionScheduler: Scheduler = SingleScheduler()
    private val disposable = CompositeDisposable()

    override fun onMethodCall(call: MethodCall, result: Result) {

        val arguments = call.arguments as List<*>
        val route = call.method.split(".")
        val algorithm = route.first()
        val method = route.last()

        println("$algorithm.$method")

        Single.create<Any> {
            try {
                it.onSuccess(execute(algorithm, method, arguments))
            } catch (e: Throwable) {
                it.onError(e)
            }
        }
                .subscribeOn(if (arguments.isEmpty()) getterScheduler else executionScheduler)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe({
                    result.success(it)
                }, {
                    it.printStackTrace()
                    if (it is NotImplemented) {
                        result.notImplemented()
                    } else {
                        result.error("", it.message, "")
                    }
                }).let {
                    disposable.add(it)
                }

    }

    private fun execute(algorithm: String, method: String, arguments: List<*>): Any {
        when (algorithm) {
            "aes" -> {
                val fileData = arguments[0] as ByteArray
                val rawKey = arguments[1] as String
                val iv = arguments[2] as String
                val isLast = arguments[3] as Boolean
                val isDecrypt = method == "decrypt"

                return Aes.performCryption(fileData, rawKey, iv, isLast, isDecrypt)
            }
            "pgp" -> {
                when (method) {
                    "clear" -> {
                        pgp = PgpApi()
                        disposable.clear()
                        return ""
                    }
                    "stop" -> {
                        val progress = pgp.getProgress()
                        progress?.stop = true
                        return ""
                    }
                    "getProgress" -> {
                        val progress = pgp.getProgress()
                        return if (progress == null) {
                            ""
                        } else {
                            arrayListOf(progress.total, progress.current)
                        }

                    }
                    "getKeyDescription" -> {
                        val key = arguments[0] as String
                        val description = pgp.getKeyDescription(key)
                        return arrayListOf(description.emails, description.length)
                    }
                    "setTempFile" -> {
                        val tempFile = arguments[0] as String?
                        pgp.setTempFile(tempFile)
                        return ""
                    }
                    "setPrivateKey" -> {
                        val privateKey = arguments[0] as String?
                        pgp.setPrivateKey(privateKey)
                        return ""
                    }
                    "setPublicKey" -> {
                        val publicKey = arguments[0] as String?
                        pgp.setPublicKey(publicKey)
                        return ""
                    }
                    "decryptBytes" -> {
                        val array = arguments[0] as ByteArray
                        val password = arguments[1] as String
                        return pgp.decryptBytes(array, password)

                    }
                    "decryptFile" -> {
                        val inputFile = arguments[0] as String
                        val outputFile = arguments[1] as String
                        val password = arguments[2] as String
                        pgp.decryptFile(inputFile, outputFile, password)
                        return ""
                    }
                    "encryptFile" -> {
                        val inputFile = arguments[0] as String
                        val outputFile = arguments[1] as String
                        pgp.encriptFile(inputFile, outputFile)
                        return ""
                    }
                    "encryptBytes" -> {
                        val text = arguments[0] as ByteArray
                        return pgp.encriptBytes(text)

                    }
                    "decryptSymmetricBytes" -> {
                        val array = arguments[0] as ByteArray
                        val password = arguments[1] as String
                        return pgp.decryptSymmetricBytes(array, password)

                    }
                    "decryptSymmetricFile" -> {
                        val inputFile = arguments[0] as String
                        val outputFile = arguments[1] as String
                        val password = arguments[2] as String
                        pgp.decryptSymmetricFile(inputFile, outputFile, password)
                        return ""
                    }
                    "encryptSymmetricFile" -> {
                        val inputFile = arguments[0] as String
                        val outputFile = arguments[1] as String
                        val password = arguments[2] as String
                        pgp.encryptSymmetricFile(inputFile, outputFile, password)
                        return ""
                    }
                    "encryptSymmetricBytes" -> {
                        val text = arguments[0] as ByteArray
                        val password = arguments[1] as String
                        return pgp.encryptSymmetricBytes(text, password)

                    }
                    "createKeys" -> {
                        val length = arguments[0] as Int
                        val email = arguments[1] as String
                        val password = arguments[2] as String
                        return pgp.createKeys(length, email, password)
                    }
                }
            }
        }
        throw  NotImplemented()
    }

    private class NotImplemented : Throwable()

}
