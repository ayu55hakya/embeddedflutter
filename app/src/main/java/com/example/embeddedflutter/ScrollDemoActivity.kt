package com.example.embeddedflutter

import android.graphics.Typeface
import android.os.Bundle
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.bumptech.glide.Glide
import com.google.android.material.card.MaterialCardView
import com.google.android.material.chip.Chip
import com.uxcam.UXCam

class ScrollDemoActivity : AppCompatActivity() {

    private val Float.dp get() = (this * resources.displayMetrics.density).toInt()
    private val Int.dp get() = (this * resources.displayMetrics.density).toInt()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_scroll_demo)

        UXCam.tagScreenName("NativeScrollDemo")

        val toolbar = findViewById<androidx.appcompat.widget.Toolbar>(R.id.toolbar)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        toolbar.setNavigationOnClickListener { finish() }

        Glide.with(this)
            .load("https://picsum.photos/id/15/800/400")
            .centerCrop()
            .into(findViewById<ImageView>(R.id.header_image))

        buildHorizontalCards()
        buildCategoryChips()
        buildVerticalCards()
    }

    private fun buildHorizontalCards() {
        val container = findViewById<LinearLayout>(R.id.horizontal_container)
        ImageRepository.items.forEach { item ->
            val card = MaterialCardView(this).apply {
                radius = 12f.dp.toFloat()
                cardElevation = 4f.dp.toFloat()
                layoutParams = LinearLayout.LayoutParams(140.dp, 150.dp).also {
                    it.marginEnd = 12.dp
                }
            }
            val img = ImageView(this).apply {
                scaleType = ImageView.ScaleType.CENTER_CROP
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.MATCH_PARENT
                )
            }
            Glide.with(this).load(item.thumbUrl).centerCrop().into(img)
            card.addView(img)
            container.addView(card)
        }
    }

    private fun buildCategoryChips() {
        val container = findViewById<LinearLayout>(R.id.chips_container)
        val categories = listOf("All", "Nature", "Landscape", "Architecture", "Travel", "Lifestyle")
        categories.forEachIndexed { index, label ->
            val chip = Chip(this).apply {
                text = label
                isCheckable = true
                isChecked = index == 0
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                ).also { it.marginEnd = 8.dp }
            }
            container.addView(chip)
        }
    }

    private fun buildVerticalCards() {
        val container = findViewById<LinearLayout>(R.id.vertical_container)
        val items = listOf(
            "CollapsingToolbarLayout" to "The header shrinks from 220dp to a compact toolbar as you scroll up, with the title animating in size.",
            "Parallax Effect" to "The header image scrolls at a slower rate than the content, creating depth.",
            "Pinned Toolbar" to "Once fully collapsed, the toolbar sticks at the top so navigation is always accessible.",
            "CoordinatorLayout" to "Coordinates scroll-based behaviors between the AppBar and the NestedScrollView.",
            "Horizontal Scroll" to "The featured section above scrolls independently in the horizontal axis.",
            "NestedScrollView" to "Allows deeply nested scrollable content while cooperating with the CoordinatorLayout.",
            "Chip Row" to "A horizontally scrollable row of filter chips sits between sections.",
            "Content Scrim" to "A colored scrim fades in over the image as the toolbar collapses.",
        )
        items.forEach { (title, desc) ->
            val card = MaterialCardView(this).apply {
                radius = 10f.dp.toFloat()
                cardElevation = 2f.dp.toFloat()
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                ).also { it.bottomMargin = 12.dp }
            }
            val inner = LinearLayout(this).apply {
                orientation = LinearLayout.VERTICAL
                setPadding(16.dp, 14.dp, 16.dp, 14.dp)
            }
            val titleView = TextView(this).apply {
                text = title
                textSize = 15f
                setTypeface(null, Typeface.BOLD)
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                ).also { it.bottomMargin = 4.dp }
            }
            val descView = TextView(this).apply {
                text = desc
                textSize = 13f
                setTextColor(0xFF666666.toInt())
                setLineSpacing(0f, 1.4f)
            }
            inner.addView(titleView)
            inner.addView(descView)
            card.addView(inner)
            container.addView(card)
        }
    }
}
