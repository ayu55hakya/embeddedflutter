package com.example.embeddedflutter

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityOptionsCompat
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.google.android.material.card.MaterialCardView

class ImageGalleryActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_image_gallery)

        val recycler = findViewById<RecyclerView>(R.id.recycler)
        recycler.layoutManager = GridLayoutManager(this, 2)
        recycler.adapter = ImageAdapter(ImageRepository.items) { item, sharedView ->
            val intent = Intent(this, ImageDetailActivity::class.java)
                .putExtra("image_id", item.id)
            val options = ActivityOptionsCompat.makeSceneTransitionAnimation(
                this, sharedView, "image_transition"
            )
            startActivity(intent, options.toBundle())
        }
    }
}

class ImageAdapter(
    private val items: List<ImageItem>,
    private val onClick: (ImageItem, View) -> Unit
) : RecyclerView.Adapter<ImageAdapter.VH>() {

    inner class VH(view: View) : RecyclerView.ViewHolder(view) {
        val card: MaterialCardView = view.findViewById(R.id.card_root)
        val image: ImageView = view.findViewById(R.id.img_thumb)
        val category: TextView = view.findViewById(R.id.txt_category)
        val title: TextView = view.findViewById(R.id.txt_title)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH =
        VH(LayoutInflater.from(parent.context).inflate(R.layout.item_image_card, parent, false))

    override fun getItemCount() = items.size

    override fun onBindViewHolder(holder: VH, position: Int) {
        val item = items[position]
        holder.category.text = item.category
        holder.title.text = item.title
        Glide.with(holder.image)
            .load(item.thumbUrl)
            .centerCrop()
            .into(holder.image)
        holder.card.setOnClickListener { onClick(item, holder.image) }
    }
}
