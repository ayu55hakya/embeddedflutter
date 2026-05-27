package com.example.embeddedflutter

import android.os.Bundle
import android.view.KeyEvent
import android.view.View
import android.webkit.WebChromeClient
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.EditText
import android.widget.ProgressBar
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.button.MaterialButton

class WebViewActivity : AppCompatActivity() {

    private lateinit var webView: WebView
    private lateinit var pageTitle: TextView
    private lateinit var pageUrl: TextView
    private lateinit var loadProgress: ProgressBar

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_webview)

        webView = findViewById(R.id.webview)
        pageTitle = findViewById(R.id.page_title)
        pageUrl = findViewById(R.id.page_url)
        loadProgress = findViewById(R.id.load_progress)

        webView.settings.javaScriptEnabled = true

        webView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView, request: WebResourceRequest) = false
            override fun onPageFinished(view: WebView, url: String) {
                pageUrl.text = url
                loadProgress.visibility = View.GONE
            }
        }

        webView.webChromeClient = object : WebChromeClient() {
            override fun onReceivedTitle(view: WebView, title: String) {
                pageTitle.text = title
            }
            override fun onProgressChanged(view: WebView, newProgress: Int) {
                loadProgress.visibility = if (newProgress < 100) View.VISIBLE else View.GONE
                loadProgress.progress = newProgress
            }
        }

        val urlInput = findViewById<EditText>(R.id.url_input)
        findViewById<MaterialButton>(R.id.btn_go).setOnClickListener {
            val url = urlInput.text.toString().trim()
            if (url.isNotEmpty()) {
                webView.loadUrl(if (url.startsWith("http")) url else "https://$url")
            }
        }

        findViewById<MaterialButton>(R.id.btn_reload).setOnClickListener {
            webView.reload()
        }

        findViewById<MaterialButton>(R.id.btn_back_fwd).setOnClickListener {
            if (webView.canGoBack()) webView.goBack()
        }

        findViewById<MaterialButton>(R.id.btn_inject_js).setOnClickListener {
            webView.evaluateJavascript(
                "document.body.style.border = '4px solid #6750A4'; alert('Native JS injected!');",
                null
            )
        }

        webView.loadUrl("https://www.google.com")
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_BACK && webView.canGoBack()) {
            webView.goBack()
            return true
        }
        return super.onKeyDown(keyCode, event)
    }
}
