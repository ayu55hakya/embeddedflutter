package com.example.embeddedflutter

import android.os.Bundle
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.bumptech.glide.Glide

class ImageDetailActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_image_detail)

        val item = ImageRepository.find(intent.getIntExtra("image_id", 10))

        Glide.with(this)
            .load(item.fullUrl)
            .centerCrop()
            .into(findViewById<ImageView>(R.id.img_detail))

        findViewById<TextView>(R.id.txt_detail_category).text = item.category
        findViewById<TextView>(R.id.txt_detail_title).text = item.title
        findViewById<TextView>(R.id.txt_detail_description).text = item.description
        findViewById<TextView>(R.id.txt_likes).text = item.likes.toString()
        findViewById<TextView>(R.id.txt_views).text = item.views.toString()
    }
}
