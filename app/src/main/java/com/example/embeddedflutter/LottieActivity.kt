package com.example.embeddedflutter

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.airbnb.lottie.LottieAnimationView
import com.google.android.material.button.MaterialButton

class LottieActivity : AppCompatActivity() {

    private lateinit var lottieView: LottieAnimationView
    private lateinit var btnPlayPause: MaterialButton

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_lottie)
        supportActionBar?.title = "Lottie Animations"

        lottieView = findViewById(R.id.lottie_view)
        btnPlayPause = findViewById(R.id.btn_play_pause)

        // Animation selectors
        val animButtons = mapOf(
            R.id.btn_bounce to "bounce.json",
            R.id.btn_spinner to "spinner.json",
            R.id.btn_pulse to "pulse.json"
        )
        animButtons.forEach { (id, file) ->
            findViewById<MaterialButton>(id).setOnClickListener { loadAnimation(file) }
        }

        // Speed controls
        mapOf(
            R.id.btn_half to 0.5f,
            R.id.btn_normal to 1f,
            R.id.btn_double to 2f
        ).forEach { (id, speed) ->
            findViewById<MaterialButton>(id).setOnClickListener { lottieView.speed = speed }
        }

        btnPlayPause.setOnClickListener {
            if (lottieView.isAnimating) {
                lottieView.pauseAnimation()
                btnPlayPause.text = "Play"
            } else {
                lottieView.resumeAnimation()
                btnPlayPause.text = "Pause"
            }
        }
    }

    private fun loadAnimation(fileName: String) {
        lottieView.setAnimation(fileName)
        lottieView.playAnimation()
        btnPlayPause.text = "Pause"
    }
}
