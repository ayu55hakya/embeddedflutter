package com.example.embeddedflutter

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.ActionBarDrawerToggle
import androidx.appcompat.app.AppCompatActivity
import androidx.drawerlayout.widget.DrawerLayout
import com.google.android.material.button.MaterialButton
import com.google.android.material.navigation.NavigationView
import com.uxcam.UXCam
import com.uxcam.datamodel.UXConfig

class MainActivity : AppCompatActivity() {

    private lateinit var drawerLayout: DrawerLayout

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // --- UXCam Initialization ---
        val config = UXConfig.Builder("leoadf73n5drfy0-us")
            .enableCrashHandling(true)
            .enableIntegrationLogging(true)
            .build()
        UXCam.startWithConfiguration(config)
        UXCam.tagScreenName("NativeHome")

        val statusText = findViewById<TextView>(R.id.status_text)
        statusText.text = "UXCam: initialized from native Android"

        // ── Toolbar & Navigation Drawer ────────────────────────────────────
        val toolbar = findViewById<androidx.appcompat.widget.Toolbar>(R.id.toolbar)
        setSupportActionBar(toolbar)

        drawerLayout = findViewById(R.id.drawer_layout)
        val navView = findViewById<NavigationView>(R.id.nav_view)

        val toggle = ActionBarDrawerToggle(
            this, drawerLayout, toolbar,
            R.string.nav_open, R.string.nav_close
        )
        drawerLayout.addDrawerListener(toggle)
        toggle.syncState()

        drawerLayout.addDrawerListener(object : DrawerLayout.SimpleDrawerListener() {
            override fun onDrawerOpened(drawerView: View) {
                UXCam.logEvent("nav_drawer_opened")
            }
            override fun onDrawerClosed(drawerView: View) {
                UXCam.logEvent("nav_drawer_closed")
            }
        })

        navView.setNavigationItemSelectedListener { item ->
            UXCam.logEvent("nav_item_selected", mapOf("item" to (item.title?.toString() ?: "")))
            when (item.itemId) {
                R.id.nav_flutter        -> startActivity(Intent(this, CustomFlutterActivity::class.java))
                R.id.nav_webview        -> startActivity(Intent(this, WebViewActivity::class.java))
                R.id.nav_animation      -> startActivity(Intent(this, AnimationActivity::class.java))
                R.id.nav_lottie         -> startActivity(Intent(this, LottieActivity::class.java))
                R.id.nav_dialogs        -> startActivity(Intent(this, DialogActivity::class.java))
                R.id.nav_compose        -> startActivity(Intent(this, ComposeActivity::class.java))
                R.id.nav_gallery        -> startActivity(Intent(this, ImageGalleryActivity::class.java))
                R.id.nav_scroll         -> startActivity(Intent(this, ScrollDemoActivity::class.java))
                R.id.nav_dropdown       -> startActivity(Intent(this, DropdownDemoActivity::class.java))
                R.id.nav_video          -> startActivity(Intent(this, VideoPlayerActivity::class.java))
                R.id.nav_live_activity  -> startActivity(Intent(this, LiveActivityActivity::class.java))
                R.id.nav_chat           -> startActivity(Intent(this, ChatActivity::class.java))
                R.id.nav_ecom           -> startActivity(Intent(this, EcomLoginActivity::class.java))
                R.id.nav_short_break    -> startActivity(Intent(this, ShortBreakActivity::class.java))
            }
            drawerLayout.closeDrawers()
            true
        }

        // Occlude email in drawer header
        val headerView = navView.getHeaderView(0)
        UXCam.occludeSensitiveView(headerView.findViewById<TextView>(R.id.tv_nav_email))

        // ── PII Masking ────────────────────────────────────────────────────
        UXCam.occludeSensitiveView(findViewById<EditText>(R.id.email_field))
        UXCam.occludeSensitiveView(findViewById<EditText>(R.id.password_field))

        // ── Screen Tagging ─────────────────────────────────────────────────
        findViewById<MaterialButton>(R.id.btn_tag_screen).setOnClickListener {
            UXCam.tagScreenName("NativeHome")
            statusText.text = "Screen tagged: NativeHome"
        }

        // ── Event Tracking ─────────────────────────────────────────────────
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

        // ── User Identity ──────────────────────────────────────────────────
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

        // ── Navigation buttons ─────────────────────────────────────────────
        findViewById<MaterialButton>(R.id.open_flutter_button).setOnClickListener {
            startActivity(Intent(this, CustomFlutterActivity::class.java))
        }
        findViewById<MaterialButton>(R.id.open_webview_button).setOnClickListener {
            startActivity(Intent(this, WebViewActivity::class.java))
        }
        findViewById<MaterialButton>(R.id.open_animation_button).setOnClickListener {
            startActivity(Intent(this, AnimationActivity::class.java))
        }
        findViewById<MaterialButton>(R.id.open_lottie_button).setOnClickListener {
            startActivity(Intent(this, LottieActivity::class.java))
        }
        findViewById<MaterialButton>(R.id.open_dialogs_button).setOnClickListener {
            startActivity(Intent(this, DialogActivity::class.java))
        }
        findViewById<MaterialButton>(R.id.open_compose_button).setOnClickListener {
            startActivity(Intent(this, ComposeActivity::class.java))
        }
        findViewById<MaterialButton>(R.id.open_gallery_button).setOnClickListener {
            startActivity(Intent(this, ImageGalleryActivity::class.java))
        }
        findViewById<MaterialButton>(R.id.open_scroll_button).setOnClickListener {
            startActivity(Intent(this, ScrollDemoActivity::class.java))
        }
        findViewById<MaterialButton>(R.id.open_dropdown_button).setOnClickListener {
            startActivity(Intent(this, DropdownDemoActivity::class.java))
        }
        findViewById<MaterialButton>(R.id.open_short_break_button).setOnClickListener {
            startActivity(Intent(this, ShortBreakActivity::class.java))
        }
        findViewById<MaterialButton>(R.id.open_video_player_button).setOnClickListener {
            startActivity(Intent(this, VideoPlayerActivity::class.java))
        }
        findViewById<MaterialButton>(R.id.open_live_activity_button).setOnClickListener {
            startActivity(Intent(this, LiveActivityActivity::class.java))
        }
        findViewById<MaterialButton>(R.id.open_chat_button).setOnClickListener {
            startActivity(Intent(this, ChatActivity::class.java))
        }
        findViewById<MaterialButton>(R.id.open_ecom_button).setOnClickListener {
            startActivity(Intent(this, EcomLoginActivity::class.java))
        }
    }

    override fun onBackPressed() {
        if (drawerLayout.isDrawerOpen(androidx.core.view.GravityCompat.START)) {
            drawerLayout.closeDrawer(androidx.core.view.GravityCompat.START)
        } else {
            super.onBackPressed()
        }
    }
}
