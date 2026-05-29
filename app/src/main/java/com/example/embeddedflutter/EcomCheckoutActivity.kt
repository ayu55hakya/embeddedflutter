package com.example.embeddedflutter

import android.graphics.Color
import android.os.Bundle
import android.widget.FrameLayout
import android.widget.RadioGroup
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.button.MaterialButton
import com.google.android.material.textfield.TextInputEditText
import com.uxcam.UXCam

class EcomCheckoutActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_ecom_checkout)
        UXCam.tagScreenName("EcomCheckout")

        val toolbar = findViewById<androidx.appcompat.widget.Toolbar>(R.id.toolbar)
        setSupportActionBar(toolbar)
        supportActionBar?.title = "Checkout"
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        toolbar.setNavigationOnClickListener { finish() }

        val productId = intent.getIntExtra("product_id", 1)
        val quantity = intent.getIntExtra("quantity", 1)
        val product = EcomFeedActivity.PRODUCTS.find { it.id == productId }
            ?: EcomFeedActivity.PRODUCTS.first()

        // Order summary
        val flOrderImg = findViewById<FrameLayout>(R.id.fl_order_img)
        flOrderImg.setBackgroundColor(Color.parseColor(product.colorHex))
        findViewById<TextView>(R.id.tv_order_emoji).text = product.emoji
        findViewById<TextView>(R.id.tv_order_name).text = product.name
        findViewById<TextView>(R.id.tv_order_variant).text = "Qty: $quantity"
        val priceNum = product.price.replace("$", "").replace(",", "").toDoubleOrNull() ?: 0.0
        val lineTotal = priceNum * quantity
        val tax = lineTotal * 0.085
        val total = lineTotal + tax
        findViewById<TextView>(R.id.tv_order_price).text = "$${String.format("%.2f", lineTotal)}"
        findViewById<TextView>(R.id.tv_subtotal).text = "$${String.format("%.2f", lineTotal)}"
        findViewById<TextView>(R.id.tv_tax).text = "$${String.format("%.2f", tax)}"
        findViewById<TextView>(R.id.tv_total).text = "$${String.format("%.2f", total)}"

        // Occlude PII fields
        val fields = listOf(
            R.id.et_ship_name, R.id.et_ship_address, R.id.et_ship_city, R.id.et_ship_zip,
            R.id.et_card_name, R.id.et_card_number, R.id.et_card_expiry, R.id.et_card_cvv
        )
        fields.forEach { id ->
            val et = findViewById<TextInputEditText>(id)
            UXCam.occludeSensitiveView(et)
        }

        // Toggle card details visibility
        val llCardDetails = findViewById<android.widget.LinearLayout>(R.id.ll_card_details)
        val rgPayment = findViewById<RadioGroup>(R.id.rg_payment)
        rgPayment.setOnCheckedChangeListener { _, checkedId ->
            llCardDetails.visibility = if (checkedId == R.id.rb_saved_card) android.view.View.VISIBLE else android.view.View.GONE
        }

        // Place Order
        findViewById<MaterialButton>(R.id.btn_place_order).setOnClickListener {
            val paymentMethod = when (rgPayment.checkedRadioButtonId) {
                R.id.rb_paypal -> "paypal"
                R.id.rb_cod -> "cash_on_delivery"
                else -> "credit_card"
            }
            UXCam.logEvent("ecom_order_placed", mapOf(
                "product" to product.name,
                "total" to String.format("%.2f", total),
                "payment" to paymentMethod,
                "qty" to quantity.toString()
            ))
            showOrderSuccess(total, paymentMethod)
        }
    }

    private fun showOrderSuccess(total: Double, paymentMethod: String) {
        AlertDialog.Builder(this)
            .setTitle("Order Placed! 🎉")
            .setMessage(
                "Your order has been confirmed.\n\n" +
                "Order #SN${(100000..999999).random()}\n" +
                "Total: $${String.format("%.2f", total)}\n" +
                "Payment: ${paymentMethod.replace('_', ' ').replaceFirstChar { it.uppercase() }}\n\n" +
                "Expected delivery: 2–4 business days."
            )
            .setPositiveButton("Continue Shopping") { _, _ ->
                finishAffinity()
            }
            .setCancelable(false)
            .show()
    }
}
