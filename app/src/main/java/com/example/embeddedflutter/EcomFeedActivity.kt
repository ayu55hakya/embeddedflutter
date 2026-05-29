package com.example.embeddedflutter

import android.content.Intent
import android.graphics.Color
import android.graphics.Paint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.chip.Chip
import com.google.android.material.chip.ChipGroup
import com.uxcam.UXCam

class EcomFeedActivity : AppCompatActivity() {

    data class Product(
        val id: Int, val name: String, val category: String,
        val price: String, val originalPrice: String, val discount: String,
        val rating: String, val emoji: String, val colorHex: String, val description: String
    )

    companion object {
        val PRODUCTS = listOf(
            Product(1, "Nike Air Max 270", "Footwear", "\$129.99", "\$159.99", "-19%", "4.8 (2.3k)", "👟", "#FFF3E0", "Lightweight, breathable running shoes with Air Max cushioning for all-day comfort on any terrain."),
            Product(2, "MacBook Pro 14\"", "Electronics", "\$1,299.99", "\$1,499.99", "-13%", "4.9 (876)", "💻", "#E3F2FD", "Apple M3 chip with 16GB RAM and 512GB SSD. The ultimate professional laptop for creators."),
            Product(3, "Sony WH-1000XM5", "Electronics", "\$279.99", "\$349.99", "-20%", "4.7 (3.2k)", "🎧", "#E8EAF6", "Industry-leading noise cancellation with crystal-clear sound and 30-hour battery life."),
            Product(4, "Apple Watch S9", "Wearables", "\$249.99", "\$299.99", "-17%", "4.7 (1.5k)", "⌚", "#F3E5F5", "Advanced health monitoring, crash detection, and an always-on Retina display."),
            Product(5, "Adidas Ultraboost 23", "Footwear", "\$89.99", "\$119.99", "-25%", "4.5 (1.8k)", "🏃", "#FFF8E1", "Responsive Boost midsole with a sock-like Primeknit upper for the ultimate running experience."),
            Product(6, "AirPods Pro 3rd Gen", "Electronics", "\$189.99", "\$249.99", "-24%", "4.8 (4.6k)", "🎵", "#E0F2F1", "Active Noise Cancellation and Transparency mode with Adaptive Audio and spatial sound."),
            Product(7, "Leather Tote Bag", "Accessories", "\$79.99", "\$99.99", "-20%", "4.3 (432)", "👜", "#FCE4EC", "Handcrafted genuine leather tote with a spacious interior and a dedicated laptop sleeve."),
            Product(8, "Smart Coffee Maker", "Home", "\$149.99", "\$199.99", "-25%", "4.6 (987)", "☕", "#FFECB3", "Wi-Fi enabled coffee maker with scheduling, temperature control, and auto-clean mode."),
            Product(9, "Premium Yoga Mat", "Sports", "\$34.99", "\$49.99", "-30%", "4.5 (1.2k)", "🧘", "#E8F5E9", "Non-slip, eco-friendly cork yoga mat with alignment lines and carry strap included."),
            Product(10, "Ray-Ban Aviators", "Accessories", "\$169.99", "\$199.99", "-15%", "4.6 (654)", "😎", "#E3F2FD", "Classic gold-frame aviators with G-15 polarized lenses for 100% UV protection."),
            Product(11, "Hiking Backpack 40L", "Sports", "\$89.99", "\$119.99", "-25%", "4.5 (2.1k)", "🎒", "#E8EAF6", "Water-resistant 40L hiking pack with ergonomic frame, hip belt, and hydration reservoir pocket."),
            Product(12, "Fujifilm Instax Mini", "Electronics", "\$89.99", "\$109.99", "-18%", "4.4 (789)", "📷", "#F1F8E9", "Instant film camera with automatic exposure, built-in flash, and selfie mirror.")
        )
    }

    private lateinit var adapter: ProductAdapter
    private val categories = listOf("All", "Footwear", "Electronics", "Wearables", "Accessories", "Home", "Sports")
    private var selectedCategory = "All"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_ecom_feed)
        UXCam.tagScreenName("EcomFeed")

        val toolbar = findViewById<androidx.appcompat.widget.Toolbar>(R.id.toolbar)
        setSupportActionBar(toolbar)
        supportActionBar?.title = "🛍️ ShopNow"
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        toolbar.setNavigationOnClickListener { finish() }

        val cgCategories = findViewById<ChipGroup>(R.id.cg_categories)
        categories.forEach { cat ->
            val chip = Chip(this).apply {
                text = cat
                isCheckable = true
                isChecked = cat == "All"
                setOnCheckedChangeListener { _, checked ->
                    if (checked) {
                        selectedCategory = cat
                        adapter.updateProducts(filteredProducts())
                        UXCam.logEvent("ecom_category_selected", mapOf("category" to cat))
                    }
                }
            }
            cgCategories.addView(chip)
        }

        adapter = ProductAdapter(filteredProducts()) { product ->
            UXCam.logEvent("ecom_product_viewed", mapOf("name" to product.name, "price" to product.price))
            val intent = Intent(this, EcomProductDetailActivity::class.java)
            intent.putExtra("product_id", product.id)
            startActivity(intent)
        }

        val glm = GridLayoutManager(this, 2)
        val rv = findViewById<RecyclerView>(R.id.rv_products)
        rv.layoutManager = glm
        rv.adapter = adapter
    }

    private fun filteredProducts(): List<Product> =
        if (selectedCategory == "All") PRODUCTS else PRODUCTS.filter { it.category == selectedCategory }

    inner class ProductAdapter(
        private var products: List<Product>,
        private val onClick: (Product) -> Unit
    ) : RecyclerView.Adapter<ProductAdapter.PVH>() {

        inner class PVH(view: android.view.View) : RecyclerView.ViewHolder(view) {
            val flImage: FrameLayout = view.findViewById(R.id.fl_image)
            val tvEmoji: TextView = view.findViewById(R.id.tv_emoji)
            val tvBadge: TextView = view.findViewById(R.id.tv_badge)
            val tvName: TextView = view.findViewById(R.id.tv_name)
            val tvCategory: TextView = view.findViewById(R.id.tv_category)
            val tvPrice: TextView = view.findViewById(R.id.tv_price)
            val tvOriginal: TextView = view.findViewById(R.id.tv_original_price)
            val tvRating: TextView = view.findViewById(R.id.tv_rating)
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PVH {
            val v = LayoutInflater.from(parent.context).inflate(R.layout.item_product_card, parent, false)
            return PVH(v)
        }

        override fun onBindViewHolder(holder: PVH, position: Int) {
            val p = products[position]
            holder.flImage.setBackgroundColor(Color.parseColor(p.colorHex))
            holder.tvEmoji.text = p.emoji
            holder.tvBadge.text = p.discount
            holder.tvName.text = p.name
            holder.tvCategory.text = p.category
            holder.tvPrice.text = p.price
            holder.tvOriginal.text = p.originalPrice
            holder.tvOriginal.paintFlags = holder.tvOriginal.paintFlags or Paint.STRIKE_THRU_TEXT_FLAG
            holder.tvRating.text = "⭐ ${p.rating}"
            holder.itemView.setOnClickListener { onClick(p) }
        }

        override fun getItemCount() = products.size

        fun updateProducts(newList: List<Product>) {
            products = newList
            notifyDataSetChanged()
        }
    }
}
