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
import android.content.Intent

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main)

        // --- UXCam Initialization (Native side) ---
        val config = UXConfig.Builder("leoadf73n5drfy0-us")
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
            startActivity(Intent(this, CustomFlutterActivity::class.java))
        }

        // --- Navigation to WebView ---
        findViewById<MaterialButton>(R.id.open_webview_button).setOnClickListener {
            startActivity(Intent(this, WebViewActivity::class.java))
        }

        // --- Navigation to Animation Screen ---
        findViewById<MaterialButton>(R.id.open_animation_button).setOnClickListener {
            startActivity(Intent(this, AnimationActivity::class.java))
        }

        // --- Navigation to Lottie Screen ---
        findViewById<MaterialButton>(R.id.open_lottie_button).setOnClickListener {
            startActivity(Intent(this, LottieActivity::class.java))
        }

        // --- Navigation to Dialogs Screen ---
        findViewById<MaterialButton>(R.id.open_dialogs_button).setOnClickListener {
            startActivity(Intent(this, DialogActivity::class.java))
        }

        // --- Navigation to Compose Screen ---
        findViewById<MaterialButton>(R.id.open_compose_button).setOnClickListener {
            startActivity(Intent(this, ComposeActivity::class.java))
        }

        // --- Navigation to Image Gallery ---
        findViewById<MaterialButton>(R.id.open_gallery_button).setOnClickListener {
            startActivity(Intent(this, ImageGalleryActivity::class.java))
        }

        // --- Navigation to Scroll Demo ---
        findViewById<MaterialButton>(R.id.open_scroll_button).setOnClickListener {
            startActivity(Intent(this, ScrollDemoActivity::class.java))
        }

        // --- Navigation to Dropdown Demo ---
        findViewById<MaterialButton>(R.id.open_dropdown_button).setOnClickListener {
            startActivity(Intent(this, DropdownDemoActivity::class.java))
        }

        // --- Navigation to Short Break Demo ---
        findViewById<MaterialButton>(R.id.open_short_break_button).setOnClickListener {
            startActivity(Intent(this, ShortBreakActivity::class.java))
        }

        // --- Navigation to Video Player ---
        findViewById<MaterialButton>(R.id.open_video_player_button).setOnClickListener {
            startActivity(Intent(this, VideoPlayerActivity::class.java))
        }

        // --- Navigation to Live Activity ---
        findViewById<MaterialButton>(R.id.open_live_activity_button).setOnClickListener {
            startActivity(Intent(this, LiveActivityActivity::class.java))
        }

        // --- Navigation to Chat ---
        findViewById<MaterialButton>(R.id.open_chat_button).setOnClickListener {
            startActivity(Intent(this, ChatActivity::class.java))
        }
    }
}
