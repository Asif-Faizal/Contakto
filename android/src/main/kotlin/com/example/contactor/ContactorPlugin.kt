package com.example.contactor

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.provider.ContactsContract
import androidx.core.app.ActivityCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class ContactorPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "contact_fetcher")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getContacts" -> getContacts(result)
            else -> result.notImplemented()
        }
    }

    private fun getContacts(result: Result) {
    if (activity == null || ActivityCompat.checkSelfPermission(activity!!, Manifest.permission.READ_CONTACTS) != PackageManager.PERMISSION_GRANTED) {
        result.error("PERMISSION_DENIED", "Contacts permission is required", null)
        return
    }

    val contactsList = mutableListOf<Map<String, String>>()

    val cursor = activity!!.contentResolver.query(
        ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
        null,
        null,
        null,
        null
    )

    cursor?.use { 
        while (it.moveToNext()) {
            val name = it.getString(it.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME)) ?: "Unknown"
            val number = it.getString(it.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER)) ?: "No number"

            val contact = mapOf<String, String>("name" to name, "number" to number)
            contactsList.add(contact)
        }
    }

    result.success(contactsList)
}

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}