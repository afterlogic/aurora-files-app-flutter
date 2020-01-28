package com.afterlogic.receive_sharing

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.media.ThumbnailUtils
import android.net.Uri
import android.provider.MediaStore
import android.webkit.MimeTypeMap
import androidx.core.content.MimeTypeFilter
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.io.FileOutputStream
import java.net.URLConnection


class ReceiveSharingPlugin(val registrar: Registrar) :
        MethodCallHandler,
        EventChannel.StreamHandler,
        PluginRegistry.NewIntentListener {

    private var latestMedia: JSONArray? = null

    private var latestText: JSONArray? = null

    private var eventSinkMedia: EventChannel.EventSink? = null
    private var eventSinkText: EventChannel.EventSink? = null

    init {
        handleIntent(registrar.context(), registrar.activity().intent)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        when (arguments) {
            "media" -> eventSinkMedia = events
            "text" -> eventSinkText = events
        }
    }

    override fun onCancel(arguments: Any?) {
        when (arguments) {
            "media" -> eventSinkMedia = null
            "text" -> eventSinkText = null
        }
    }

    override fun onNewIntent(intent: Intent): Boolean {
        handleIntent(registrar.context(), intent)
        return false
    }

    companion object {
        private const val MESSAGES_CHANNEL = "receive_sharing/messages"
        private const val EVENTS_CHANNEL_MEDIA = "receive_sharing/events-media"
        private const val EVENTS_CHANNEL_TEXT = "receive_sharing/events-text"

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            // Detect if we've been launched in background
            if (registrar.activity() == null) {
                return
            }

            val instance = ReceiveSharingPlugin(registrar)

            val mChannel = MethodChannel(registrar.messenger(), MESSAGES_CHANNEL)
            mChannel.setMethodCallHandler(instance)

            val eChannelMedia = EventChannel(registrar.messenger(), EVENTS_CHANNEL_MEDIA)
            eChannelMedia.setStreamHandler(instance)

            val eChannelText = EventChannel(registrar.messenger(), EVENTS_CHANNEL_TEXT)
            eChannelText.setStreamHandler(instance)

            registrar.addNewIntentListener(instance)
        }
    }


    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method == "getInitialMedia" -> result.success(latestMedia?.toString())
            call.method == "getInitialText" -> result.success(latestText)
            call.method == "reset" -> {
                latestMedia = null
                latestText = null
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun handleIntent(context: Context, intent: Intent) {
        try {
            if (intent.action == Intent.ACTION_SEND || intent.action == Intent.ACTION_SEND_MULTIPLE) {
                val value = getMediaUris(context, intent)
                latestMedia = value
                latestMedia?.let {
                    eventSinkMedia?.success(it.toString())
                }
            }
        } catch (e: Throwable) {
            e.printStackTrace()
        }
    }

    private fun getTextJson(intent: Intent): JSONArray? {
        var subject = intent.getStringExtra(Intent.EXTRA_SUBJECT) ?: "text"
        if (subject.isEmpty()) {
            subject = "text"
        }
        val text = intent.getStringExtra(Intent.EXTRA_TEXT) ?: return null
        return JSONArray().put(
                JSONObject()
                        .put("name", subject)
                        .put("text", text)
                        .put("type", MimeType.Text.ordinal)
        )
    }

    private fun getMediaUris(context: Context, intent: Intent): JSONArray? {
        if (intent.type?.startsWith("text") == true) {
            getTextJson(intent)?.let {
                return it
            }
        }
        val uri = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)
        val uris = intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM) ?: arrayListOf()
        uri?.let { uris.add(it) }
        val value = uris.mapNotNull { item ->
            val path = FileDirectory.getAbsolutePath(context, item) ?: return@mapNotNull null
            val name = path.split("/").last()
            val type = getMediaType(path)
            JSONObject()
                    .put("name", name)
                    .put("path", path)
                    .put("type", type.ordinal)
        }.toList()
        return JSONArray(value)
    }

    private fun getMediaType(path: String?): MimeType {
        val mimeType = URLConnection.guessContentTypeFromName(path) ?: return MimeType.Any
        return when {
            mimeType.startsWith("image") -> {
                MimeType.Image
            }
            mimeType.startsWith("video") -> {
                MimeType.Video
            }
            mimeType.startsWith("text") -> {
                MimeType.Text
            }
            else -> {
                MimeType.Any
            }
        }
    }
}
