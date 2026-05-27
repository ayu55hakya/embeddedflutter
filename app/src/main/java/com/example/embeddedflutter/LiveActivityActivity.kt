package com.example.embeddedflutter

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.google.android.material.progressindicator.LinearProgressIndicator
import com.uxcam.UXCam
import java.util.Locale

class LiveActivityActivity : AppCompatActivity() {

    private val handler = Handler(Looper.getMainLooper())
    private var tick = 0
    private var livePulse = true

    // ── Ride state ─────────────────────────────────────────────────────────────
    private var rideEtaSec = 360   // 6:00
    private var rideStep = 1        // start mid-ride
    private val rideStepLabels = listOf("Assigned", "Pickup", "Riding", "Done")
    private val rideStatusText = listOf(
        "Driver Assigned",
        "En Route to Pickup",
        "Driver Arrived — Boarding",
        "Ride in Progress",
        "Arrived at Destination ✓"
    )

    // ── Sports state ───────────────────────────────────────────────────────────
    private var homeScore = 1
    private var awayScore = 0
    private var gameMin = 32
    private var gameSec = 14
    private var isSecondHalf = false
    private var lastEventIdx = 0
    private val matchEvents = listOf(
        "⚽ 32' — GOAL! Müller scored (GER)",
        "🟡 38' — Yellow card: Mbappé (FRA)",
        "⚽ 45+2' — GOAL! Giroud scored (FRA)",
        "🔄 48' — Sub: Gnabry on for Werner (GER)",
        "⚽ 56' — GOAL! Kroos scored (GER)",
        "🎯 63' — Shot on target: Griezmann (FRA)",
        "⚽ 71' — GOAL! Benzema scored (FRA)",
        "🟡 78' — Yellow card: Kante (FRA)",
        "⚽ 85' — GOAL! Sané scored (GER)",
        "🔴 90+1' — Red card: Varane (FRA)",
    )

    // ── Delivery state ─────────────────────────────────────────────────────────
    private var deliveryStep = 3    // start at "Out for Delivery"
    private var deliveryEtaSec = 1080 // 18:00
    private val deliveryStepNames = listOf(
        "Order Confirmed",
        "Picked Up from Seller",
        "At Sorting Facility",
        "Out for Delivery",
        "Delivered ✓"
    )

    private val ticker = object : Runnable {
        override fun run() {
            tick++
            livePulse = !livePulse
            updateRide()
            updateSports()
            updateDelivery()
            renderAll()
            handler.postDelayed(this, 1000)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_live_activity)
        UXCam.tagScreenName("NativeLiveActivity")

        val toolbar = findViewById<androidx.appcompat.widget.Toolbar>(R.id.toolbar)
        setSupportActionBar(toolbar)
        supportActionBar?.title = "Live Activities"
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        toolbar.setNavigationOnClickListener { finish() }

        renderAll()
        handler.postDelayed(ticker, 1000)
    }

    private fun updateRide() {
        if (rideEtaSec > 0) rideEtaSec--
        if (rideEtaSec == 0 && rideStep < 3) rideStep = 3
        else if (tick == 20 && rideStep < 2) rideStep = 2
        else if (tick == 40 && rideStep < 3) rideStep = 3
    }

    private fun updateSports() {
        gameSec++
        if (gameSec >= 60) { gameSec = 0; gameMin++ }
        if (gameMin == 45 && !isSecondHalf) {
            isSecondHalf = true
            gameMin = 45
        }
        if (gameMin > 45 && !isSecondHalf) gameMin = 46
        if (gameMin >= 90) gameMin = 90
        // Fire events at specific ticks
        val eventTick = listOf(0, 6, 13, 16, 24, 31, 39, 46, 53, 58)
        val idx = eventTick.indexOf(tick % 60)
        if (idx >= 0) {
            lastEventIdx = idx % matchEvents.size
            // Update scores based on event
            when (lastEventIdx) {
                0 -> { /* initial */ }
                2 -> awayScore++   // FRA scores
                4 -> homeScore++   // GER scores
                6 -> awayScore++   // FRA scores
                8 -> homeScore++   // GER scores
            }
        }
    }

    private fun updateDelivery() {
        if (deliveryEtaSec > 0) deliveryEtaSec--
        if (tick == 50 && deliveryStep < 4) deliveryStep = 4
    }

    private fun renderAll() {
        val liveAlpha = if (livePulse) 1f else 0.35f
        listOf(
            R.id.tv_live_ride,
            R.id.tv_live_sports,
            R.id.tv_live_delivery
        ).forEach { id -> findViewById<TextView>(id).alpha = liveAlpha }

        renderRide()
        renderSports()
        renderDelivery()

        val secs = tick % 60
        val min = tick / 60
        findViewById<TextView>(R.id.tv_last_update).text =
            if (tick < 60) "Updated ${tick}s ago" else "Updated ${min}m ago"
    }

    private fun renderRide() {
        val min = rideEtaSec / 60
        val sec = rideEtaSec % 60
        val etaText = if (rideEtaSec <= 0) "Here!" else
            String.format(Locale.getDefault(), "%d:%02d", min, sec)

        findViewById<TextView>(R.id.tv_ride_eta).text = etaText
        val statusIdx = when (rideStep) {
            0 -> 0; 1 -> 1; 2 -> 2; 3 -> if (rideEtaSec <= 0) 4 else 3; else -> 3
        }
        findViewById<TextView>(R.id.tv_ride_status).text = rideStatusText[statusIdx]

        val progress = when (rideStep) {
            0 -> 10; 1 -> 35; 2 -> 65; else -> if (rideEtaSec <= 0) 100 else 85
        }
        findViewById<LinearProgressIndicator>(R.id.pb_ride).setProgressCompat(progress, true)

        val steps = listOf(R.id.tv_ride_s0, R.id.tv_ride_s1, R.id.tv_ride_s2, R.id.tv_ride_s3)
        steps.forEachIndexed { i, id ->
            val tv = findViewById<TextView>(id)
            when {
                i < rideStep -> { tv.setTextColor(ContextCompat.getColor(this, android.R.color.holo_green_dark)); tv.text = "✓ ${rideStepLabels[i]}" }
                i == rideStep -> { tv.setTextColor(ContextCompat.getColor(this, android.R.color.holo_purple)); tv.text = "→ ${rideStepLabels[i]}" }
                else -> { tv.setTextColor(-0x444445); tv.text = rideStepLabels[i] }
            }
        }
    }

    private fun renderSports() {
        val clock = String.format(Locale.getDefault(), "%02d:%02d", gameMin, gameSec)
        findViewById<TextView>(R.id.tv_game_clock).text = clock
        findViewById<TextView>(R.id.tv_home_score).text = homeScore.toString()
        findViewById<TextView>(R.id.tv_away_score).text = awayScore.toString()
        findViewById<TextView>(R.id.tv_match_event).text = matchEvents[lastEventIdx]
        findViewById<TextView>(R.id.tv_sport_half).text =
            if (isSecondHalf) "2nd Half" else "1st Half"
    }

    private fun renderDelivery() {
        val min = deliveryEtaSec / 60
        val sec = deliveryEtaSec % 60
        val etaText = if (deliveryEtaSec <= 0) "Delivered!" else
            String.format(Locale.getDefault(), "%d:%02d", min, sec)

        val green = ContextCompat.getColor(this, android.R.color.holo_green_dark)
        val purple = ContextCompat.getColor(this, android.R.color.holo_purple)
        val gray = -0x444445

        val dotIds = listOf(R.id.tv_del_dot_0, R.id.tv_del_dot_1, R.id.tv_del_dot_2, R.id.tv_del_dot_3, R.id.tv_del_dot_4)
        val textIds = listOf(R.id.tv_del_step_0, R.id.tv_del_step_1, R.id.tv_del_step_2, R.id.tv_del_step_3, R.id.tv_del_step_4)

        dotIds.forEachIndexed { i, id ->
            val dot = findViewById<TextView>(id)
            val txt = findViewById<TextView>(textIds[i])
            when {
                i < deliveryStep -> {
                    dot.text = "✓"; dot.setTextColor(-0x1); dot.setBackgroundColor(green)
                    txt.setTextColor(green); txt.setTypeface(null, android.graphics.Typeface.NORMAL)
                }
                i == deliveryStep -> {
                    dot.text = "→"; dot.setTextColor(-0x1); dot.setBackgroundColor(purple)
                    txt.setTextColor(purple); txt.setTypeface(null, android.graphics.Typeface.BOLD)
                }
                else -> {
                    dot.text = "○"; dot.setTextColor(gray); dot.setBackgroundColor(-0x111112)
                    txt.setTextColor(gray); txt.setTypeface(null, android.graphics.Typeface.NORMAL)
                }
            }
        }

        val currentStepName = if (deliveryStep < deliveryStepNames.size) deliveryStepNames[deliveryStep] else "Delivered ✓"
        findViewById<TextView>(R.id.tv_delivery_current).text = currentStepName
        findViewById<TextView>(R.id.tv_delivery_eta).text = etaText
    }

    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacks(ticker)
    }
}
