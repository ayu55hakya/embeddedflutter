package com.example.embeddedflutter

import android.content.Intent
import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.button.MaterialButton
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import com.uxcam.UXCam

class EcomSignupActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_ecom_signup)
        UXCam.tagScreenName("EcomSignup")

        val etName = findViewById<TextInputEditText>(R.id.et_name)
        val etEmail = findViewById<TextInputEditText>(R.id.et_email)
        val etPassword = findViewById<TextInputEditText>(R.id.et_password)
        val etConfirm = findViewById<TextInputEditText>(R.id.et_confirm)
        val tilName = findViewById<TextInputLayout>(R.id.til_name)
        val tilEmail = findViewById<TextInputLayout>(R.id.til_email)
        val tilPassword = findViewById<TextInputLayout>(R.id.til_password)
        val tilConfirm = findViewById<TextInputLayout>(R.id.til_confirm)

        UXCam.occludeSensitiveView(etEmail)
        UXCam.occludeSensitiveView(etPassword)
        UXCam.occludeSensitiveView(etConfirm)

        findViewById<MaterialButton>(R.id.btn_signup).setOnClickListener {
            val name = etName.text.toString().trim()
            val email = etEmail.text.toString().trim()
            val pass = etPassword.text.toString()
            val confirm = etConfirm.text.toString()

            if (name.isEmpty()) { tilName.error = "Name required"; return@setOnClickListener }
            if (email.isEmpty()) { tilEmail.error = "Email required"; return@setOnClickListener }
            if (pass.length < 6) { tilPassword.error = "At least 6 characters"; return@setOnClickListener }
            if (pass != confirm) { tilConfirm.error = "Passwords do not match"; return@setOnClickListener }

            tilName.error = null; tilEmail.error = null; tilPassword.error = null; tilConfirm.error = null

            UXCam.logEvent("ecom_signup", mapOf("source" to "email"))
            startActivity(Intent(this, EcomFeedActivity::class.java))
            finish()
        }

        findViewById<TextView>(R.id.tv_login).setOnClickListener { finish() }
    }
}
