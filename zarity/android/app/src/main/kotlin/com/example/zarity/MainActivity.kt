package com.example.zarity

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.deepLink"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Ensure flutterEngine is non-null before accessing dartExecutor
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialLink" -> {
                        // Handle the initial link if it exists
                        val initialLink = handleIntent(intent)
                        result.success(initialLink)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent) // Update the current intent

        // Handle new deep links received while the app is running
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, CHANNEL).invokeMethod("onLink", handleIntent(intent))
        }
    }

    /**
     * Extracts the deep link URL from the provided intent.
     */
    private fun handleIntent(intent: Intent?): String? {
        val data: Uri? = intent?.data
        return data?.toString()
    }
}
