package com.example.embeddedflutter

import android.os.Bundle
import android.widget.EditText
import android.widget.TextView
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.google.android.material.button.MaterialButton
import com.uxcam.UXCam
import com.uxcam.datamodel.UXConfig
import com.uxcam.screenshot.model.UXCamOverlay
import io.flutter.embedding.android.FlutterActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main)

        // --- UXCam Initialization (Native side) ---
        val config = UXConfig.Builder("n5ctt823s8qihkk-us")
            .enableCrashHandling(true)
            .enableIntegrationLogging(true)
            .build()
        UXCam.startWithConfiguration(config)

        val statusText = findViewById<TextView>(R.id.status_text)
        statusText.text = "UXCam: initialized from native Android"

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        // --- PII Masking (Native side) ---
        val emailField = findViewById<EditText>(R.id.email_field)
        val passwordField = findViewById<EditText>(R.id.password_field)
        UXCam.occludeSensitiveView(emailField)
        UXCam.occludeSensitiveView(passwordField)

        // --- Screen Tagging (Native side) ---
        findViewById<MaterialButton>(R.id.btn_tag_screen).setOnClickListener {
            UXCam.tagScreenName("NativeHome")
            statusText.text = "Screen tagged: NativeHome"
        }

        // --- Event Tracking (Native side) ---
        findViewById<MaterialButton>(R.id.btn_log_event).setOnClickListener {
            UXCam.logEvent("native_button_tap")
            statusText.text = "Event logged: native_button_tap"
        }

        findViewById<MaterialButton>(R.id.btn_log_event_props).setOnClickListener {
            UXCam.logEvent("native_purchase", mapOf(
                "item" to "premium_plan",
                "price" to "9.99",
                "source" to "native_android"
            ))
            statusText.text = "Event logged: native_purchase with properties"
        }

        // --- User Identity & Properties (Native side) ---
        findViewById<MaterialButton>(R.id.btn_set_identity).setOnClickListener {
            UXCam.setUserIdentity("native-user-42")
            statusText.text = "User identity set: native-user-42"
        }

        findViewById<MaterialButton>(R.id.btn_set_properties).setOnClickListener {
            UXCam.setUserProperty("plan", "premium")
            UXCam.setUserProperty("source", "native_android")
            UXCam.setSessionProperty("native_session_flag", "true")
            statusText.text = "User & session properties set from native"
        }

        // --- Navigation to Flutter ---
        findViewById<MaterialButton>(R.id.open_flutter_button).setOnClickListener {
            startActivity(FlutterActivity.createDefaultIntent(this))
        }
    }
}
