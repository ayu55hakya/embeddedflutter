package com.example.embeddedflutter

import android.content.Intent
import android.os.Bundle
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.button.MaterialButton
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import com.uxcam.UXCam

class EcomLoginActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_ecom_login)
        UXCam.tagScreenName("EcomLogin")

        val etEmail = findViewById<TextInputEditText>(R.id.et_email)
        val etPassword = findViewById<TextInputEditText>(R.id.et_password)
        val tilEmail = findViewById<TextInputLayout>(R.id.til_email)
        val tilPassword = findViewById<TextInputLayout>(R.id.til_password)

        UXCam.occludeSensitiveView(etEmail)
        UXCam.occludeSensitiveView(etPassword)

        findViewById<MaterialButton>(R.id.btn_login).setOnClickListener {
            val email = etEmail.text.toString().trim()
            val pass = etPassword.text.toString()
            if (email.isEmpty()) { tilEmail.error = "Email required"; return@setOnClickListener }
            if (pass.isEmpty()) { tilPassword.error = "Password required"; return@setOnClickListener }
            tilEmail.error = null; tilPassword.error = null
            UXCam.logEvent("ecom_login", mapOf("source" to "email"))
            openFeed()
        }

        findViewById<MaterialButton>(R.id.btn_google).setOnClickListener {
            UXCam.logEvent("ecom_login", mapOf("source" to "google"))
            openFeed()
        }

        findViewById<TextView>(R.id.tv_signup).setOnClickListener {
            startActivity(Intent(this, EcomSignupActivity::class.java))
        }

        findViewById<TextView>(R.id.tv_forgot).setOnClickListener {
            Toast.makeText(this, "Password reset email sent!", Toast.LENGTH_SHORT).show()
            UXCam.logEvent("ecom_forgot_password")
        }
    }

    private fun openFeed() {
        startActivity(Intent(this, EcomFeedActivity::class.java))
        finish()
    }
}
