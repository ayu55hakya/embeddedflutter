package com.example.embeddedflutter

import android.animation.AnimatorSet
import android.animation.ObjectAnimator
import android.animation.ValueAnimator
import android.graphics.Color
import android.os.Bundle
import android.view.View
import android.view.animation.BounceInterpolator
import android.view.animation.OvershootInterpolator
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.button.MaterialButton

class AnimationActivity : AppCompatActivity() {

    private lateinit var box: View

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_animation)
        supportActionBar?.title = "Animations"

        box = findViewById(R.id.animated_box)

        findViewById<MaterialButton>(R.id.btn_fade).setOnClickListener { animateFade() }
        findViewById<MaterialButton>(R.id.btn_scale).setOnClickListener { animateScale() }
        findViewById<MaterialButton>(R.id.btn_rotate).setOnClickListener { animateRotate() }
        findViewById<MaterialButton>(R.id.btn_translate).setOnClickListener { animateTranslate() }
        findViewById<MaterialButton>(R.id.btn_bounce).setOnClickListener { animateBounce() }
        findViewById<MaterialButton>(R.id.btn_color).setOnClickListener { animateColor() }
        findViewById<MaterialButton>(R.id.btn_reset).setOnClickListener { reset() }
    }

    private fun animateFade() {
        val fadeOut = ObjectAnimator.ofFloat(box, View.ALPHA, 1f, 0f).apply { duration = 600 }
        val fadeIn = ObjectAnimator.ofFloat(box, View.ALPHA, 0f, 1f).apply { duration = 600 }
        AnimatorSet().apply {
            playSequentially(fadeOut, fadeIn)
            start()
        }
    }

    private fun animateScale() {
        val scaleX = ObjectAnimator.ofFloat(box, View.SCALE_X, 1f, 1.8f, 1f).apply { duration = 700 }
        val scaleY = ObjectAnimator.ofFloat(box, View.SCALE_Y, 1f, 1.8f, 1f).apply { duration = 700 }
        AnimatorSet().apply {
            playTogether(scaleX, scaleY)
            interpolator = OvershootInterpolator()
            start()
        }
    }

    private fun animateRotate() {
        ObjectAnimator.ofFloat(box, View.ROTATION, 0f, 360f).apply {
            duration = 800
            start()
        }
    }

    private fun animateTranslate() {
        val right = ObjectAnimator.ofFloat(box, View.TRANSLATION_X, 0f, 200f).apply { duration = 400 }
        val back = ObjectAnimator.ofFloat(box, View.TRANSLATION_X, 200f, 0f).apply { duration = 400 }
        AnimatorSet().apply {
            playSequentially(right, back)
            start()
        }
    }

    private fun animateBounce() {
        ObjectAnimator.ofFloat(box, View.TRANSLATION_Y, 0f, -150f, 0f).apply {
            duration = 900
            interpolator = BounceInterpolator()
            start()
        }
    }

    private fun animateColor() {
        val colorFrom = Color.parseColor("#6750A4")
        val colorTo = Color.parseColor("#E91E63")
        ValueAnimator.ofArgb(colorFrom, colorTo, colorFrom).apply {
            duration = 1200
            addUpdateListener { box.setBackgroundColor(it.animatedValue as Int) }
            start()
        }
    }

    private fun reset() {
        box.animate().cancel()
        box.alpha = 1f
        box.scaleX = 1f
        box.scaleY = 1f
        box.rotation = 0f
        box.translationX = 0f
        box.translationY = 0f
        box.setBackgroundColor(Color.parseColor("#6750A4"))
    }
}
