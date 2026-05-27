package com.example.embeddedflutter

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.chip.ChipGroup
import com.google.android.material.materialswitch.MaterialSwitch
import com.uxcam.UXCam

class ShortBreakActivity : AppCompatActivity() {

    // Duration map: chip id → milliseconds
    private val durationMap = mapOf(
        R.id.chip_30s to 30_000,
        R.id.chip_1m  to 60_000,
        R.id.chip_2m  to 120_000,
        R.id.chip_3m  to 180_000,
        R.id.chip_5m  to 300_000,
    )
    private val durationLabels = mapOf(
        R.id.chip_30s to "30 sec",
        R.id.chip_1m  to "1 min",
        R.id.chip_2m  to "2 min",
        R.id.chip_3m  to "3 min (default)",
        R.id.chip_5m  to "5 min",
    )

    private var selectedDurationMs = 180_000  // default 3 min
    private var selectedDurationLabel = "3 min (default)"
    private var shortBreakEnabled = false
    private var shortBreakLaunched = false

    private lateinit var statusText: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_short_break)

        UXCam.tagScreenName("NativeShortBreakDemo")

        val toolbar = findViewById<androidx.appcompat.widget.Toolbar>(R.id.toolbar)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        toolbar.setNavigationOnClickListener { finish() }

        statusText = findViewById(R.id.txt_status)

        // ── Section 1: enable/disable toggle ──────────────────────────────────
        val toggle = findViewById<MaterialSwitch>(R.id.switch_short_break)
        toggle.setOnCheckedChangeListener { _, isChecked ->
            shortBreakEnabled = isChecked
            UXCam.allowShortBreakForAnotherApp(isChecked)
            statusText.text = if (isChecked)
                "Short break: enabled  |  Duration: $selectedDurationLabel"
            else
                "Short break: disabled"
        }

        // ── Section 2: duration chip group ────────────────────────────────────
        val chipGroup = findViewById<ChipGroup>(R.id.chip_group_duration)
        chipGroup.setOnCheckedStateChangeListener { _, checkedIds ->
            val chipId = checkedIds.firstOrNull() ?: return@setOnCheckedStateChangeListener
            selectedDurationMs = durationMap[chipId] ?: 180_000
            selectedDurationLabel = durationLabels[chipId] ?: "3 min (default)"
            UXCam.allowShortBreakForAnotherApp(selectedDurationMs)
            statusText.text = if (shortBreakEnabled)
                "Short break: enabled  |  Duration: $selectedDurationLabel"
            else
                "Duration set: $selectedDurationLabel (enable toggle to activate)"
        }

        // ── Section 3: manual resume ──────────────────────────────────────────
        findViewById<com.google.android.material.button.MaterialButton>(R.id.btn_resume)
            .setOnClickListener {
                UXCam.resumeShortBreakForAnotherApp()
                statusText.text = "Session resumed manually"
            }

        // ── Section 4: real-world demo ────────────────────────────────────────
        findViewById<com.google.android.material.button.MaterialButton>(R.id.btn_launch_apple)
            .setOnClickListener {
                UXCam.allowShortBreakForAnotherApp(true)
                shortBreakLaunched = true
                statusText.text = "Short break enabled — opening Apple.com…"
                startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://www.apple.com")))
            }
    }

    override fun onResume() {
        super.onResume()
        if (shortBreakLaunched) {
            shortBreakLaunched = false
            UXCam.resumeShortBreakForAnotherApp()
            statusText.text = "Returned from Apple.com — session resumed ✓"
        }
    }
}
