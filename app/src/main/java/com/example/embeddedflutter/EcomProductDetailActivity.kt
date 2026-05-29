package com.example.embeddedflutter

import android.content.Intent
import android.graphics.Color
import android.graphics.Paint
import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.button.MaterialButton
import com.google.android.material.chip.Chip
import com.google.android.material.chip.ChipGroup
import com.google.android.material.snackbar.Snackbar
import com.uxcam.UXCam

class EcomProductDetailActivity : AppCompatActivity() {

    private var quantity = 1
    private var isWishlisted = false
    private lateinit var product: EcomFeedActivity.Product

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_ecom_product_detail)

        val productId = intent.getIntExtra("product_id", 1)
        product = EcomFeedActivity.PRODUCTS.find { it.id == productId }
            ?: EcomFeedActivity.PRODUCTS.first()

        UXCam.tagScreenName("EcomProductDetail")
        UXCam.logEvent("ecom_product_viewed", mapOf("name" to product.name, "price" to product.price))

        val toolbar = findViewById<androidx.appcompat.widget.Toolbar>(R.id.toolbar)
        setSupportActionBar(toolbar)
        supportActionBar?.title = ""
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        toolbar.setNavigationOnClickListener { finish() }

        // Header
        val flHeader = findViewById<android.widget.FrameLayout>(R.id.fl_header)
        flHeader.setBackgroundColor(Color.parseColor(product.colorHex))
        findViewById<TextView>(R.id.tv_product_emoji).text = product.emoji

        // Info
        findViewById<TextView>(R.id.tv_category_chip).text = product.category
        findViewById<TextView>(R.id.tv_product_name).text = product.name
        val tvPrice = findViewById<TextView>(R.id.tv_price)
        tvPrice.text = product.price
        val tvOriginal = findViewById<TextView>(R.id.tv_original_price)
        tvOriginal.text = "  ${product.originalPrice}"
        tvOriginal.paintFlags = tvOriginal.paintFlags or Paint.STRIKE_THRU_TEXT_FLAG
        findViewById<TextView>(R.id.tv_description).text = product.description

        val ratingParts = product.rating.split(" ")
        val ratingVal = ratingParts[0].toFloatOrNull() ?: 4.5f
        val stars = "★".repeat(ratingVal.toInt()) + if (ratingVal % 1 >= 0.5f) "½" else ""
        findViewById<TextView>(R.id.tv_rating).text = "$stars ${ratingParts[0]}"
        val reviews = ratingParts.getOrElse(1) { "(1k)" }
        findViewById<TextView>(R.id.tv_reviews).text = "  $reviews reviews"

        // Discount note
        val origNum = product.originalPrice.replace("$", "").replace(",", "").toDoubleOrNull() ?: 0.0
        val priceNum = product.price.replace("$", "").replace(",", "").toDoubleOrNull() ?: 0.0
        val saving = origNum - priceNum
        val pct = if (origNum > 0) ((saving / origNum) * 100).toInt() else 0
        if (saving > 0) {
            findViewById<TextView>(R.id.tv_discount_note).text =
                "You save \$${String.format("%.2f", saving)} ($pct% off)"
        }

        // Size chips
        val cgSizes = findViewById<ChipGroup>(R.id.cg_sizes)
        val sizes = when (product.category) {
            "Footwear" -> listOf("6", "7", "8", "9", "10", "11", "12")
            "Wearables" -> listOf("S", "M", "L", "XL")
            "Sports" -> listOf("S", "M", "L", "XL", "One Size")
            "Accessories" -> listOf("One Size")
            else -> emptyList()
        }
        if (sizes.isEmpty()) {
            findViewById<com.google.android.material.card.MaterialCardView>(R.id.cv_sizes).visibility =
                android.view.View.GONE
        } else {
            sizes.forEachIndexed { idx, size ->
                val chip = Chip(this).apply {
                    text = size
                    isCheckable = true
                    isChecked = idx == 1
                }
                cgSizes.addView(chip)
            }
        }

        // Quantity
        val tvQty = findViewById<TextView>(R.id.tv_qty)
        tvQty.text = "1"
        findViewById<MaterialButton>(R.id.btn_qty_minus).setOnClickListener {
            if (quantity > 1) { quantity--; tvQty.text = quantity.toString() }
        }
        findViewById<MaterialButton>(R.id.btn_qty_plus).setOnClickListener {
            if (quantity < 10) { quantity++; tvQty.text = quantity.toString() }
        }

        // Wishlist
        val tvWishlist = findViewById<TextView>(R.id.tv_wishlist)
        findViewById<com.google.android.material.card.MaterialCardView>(R.id.cv_wishlist).setOnClickListener {
            isWishlisted = !isWishlisted
            tvWishlist.text = if (isWishlisted) "♥" else "♡"
            UXCam.logEvent("ecom_wishlist_toggled", mapOf("product" to product.name, "wishlisted" to isWishlisted.toString()))
        }

        // Add to Cart
        findViewById<MaterialButton>(R.id.btn_add_cart).setOnClickListener {
            UXCam.logEvent("ecom_add_to_cart", mapOf("name" to product.name, "price" to product.price, "qty" to quantity.toString()))
            Snackbar.make(it, "Added to cart ✓", Snackbar.LENGTH_SHORT)
                .setBackgroundTint(Color.parseColor("#E65100"))
                .setTextColor(Color.WHITE)
                .show()
        }

        // Buy Now → Checkout
        findViewById<MaterialButton>(R.id.btn_buy_now).setOnClickListener {
            UXCam.logEvent("ecom_buy_now", mapOf("name" to product.name, "price" to product.price, "qty" to quantity.toString()))
            val intent = Intent(this, EcomCheckoutActivity::class.java)
            intent.putExtra("product_id", product.id)
            intent.putExtra("quantity", quantity)
            startActivity(intent)
        }
    }
}
