package com.example.embeddedflutter

import android.graphics.Color
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View
import android.widget.ProgressBar
import android.widget.SeekBar
import android.widget.TextView
import android.widget.VideoView
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.button.MaterialButton
import com.google.android.material.chip.Chip
import com.google.android.material.chip.ChipGroup
import com.uxcam.UXCam

class VideoPlayerActivity : AppCompatActivity() {

    private lateinit var videoView: VideoView
    private lateinit var seekBar: SeekBar
    private lateinit var txtCurrentTime: TextView
    private lateinit var txtDuration: TextView
    private lateinit var txtTitle: TextView
    private lateinit var btnPlayPause: MaterialButton
    private lateinit var loadingIndicator: ProgressBar

    private val handler = Handler(Looper.getMainLooper())
    private var currentIndex = 0

    private data class VideoItem(val title: String, val url: String)

    private val videos = listOf(
        VideoItem("Big Blazes",      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"),
        VideoItem("Big Escapes",     "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"),
        VideoItem("Big Fun",         "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4"),
        VideoItem("Joyrides",        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4"),
        VideoItem("Big Meltdowns",   "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4"),
        VideoItem("On Bullrun",      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4"),
        VideoItem("Subaru vs VW",    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackVsVWTiguanA.mp4"),
        VideoItem("VW GTI Review",   "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4"),
        VideoItem("What Car?",       "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4"),
        VideoItem("Tears of Steel",  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4"),
    )

    private val progressUpdater = object : Runnable {
        override fun run() {
            try {
                val pos = videoView.currentPosition
                val dur = videoView.duration
                if (dur > 0) seekBar.progress = pos
                txtCurrentTime.text = formatTime(pos)
            } catch (_: IllegalStateException) {}
            handler.postDelayed(this, 250)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_video_player)

        UXCam.tagScreenName("NativeVideoPlayer")

        val toolbar = findViewById<androidx.appcompat.widget.Toolbar>(R.id.toolbar)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        toolbar.setNavigationOnClickListener { finish() }

        videoView        = findViewById(R.id.video_view)
        videoView.setBackgroundColor(Color.BLACK)
        seekBar          = findViewById(R.id.seek_bar)
        txtCurrentTime   = findViewById(R.id.txt_current_time)
        txtDuration      = findViewById(R.id.txt_duration)
        txtTitle         = findViewById(R.id.txt_video_title)
        btnPlayPause     = findViewById(R.id.btn_play_pause)
        loadingIndicator = findViewById(R.id.loading_indicator)

        videoView.setOnPreparedListener { mp ->
            videoView.background = null
            loadingIndicator.visibility = View.GONE
            mp.isLooping = false
            val dur = videoView.duration
            seekBar.max = dur
            txtDuration.text = formatTime(dur)
            videoView.start()
            btnPlayPause.text = "⏸"
            handler.post(progressUpdater)
        }

        videoView.setOnCompletionListener {
            btnPlayPause.text = "▶"
            if (currentIndex < videos.size - 1) {
                handler.postDelayed({ loadVideo(currentIndex + 1) }, 600)
            }
        }

        videoView.setOnErrorListener { _, _, _ ->
            loadingIndicator.visibility = View.GONE
            true
        }

        seekBar.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
            override fun onProgressChanged(sb: SeekBar, progress: Int, fromUser: Boolean) {
                if (fromUser) {
                    videoView.seekTo(progress)
                    txtCurrentTime.text = formatTime(progress)
                }
            }
            override fun onStartTrackingTouch(sb: SeekBar) = Unit
            override fun onStopTrackingTouch(sb: SeekBar) = Unit
        })

        btnPlayPause.setOnClickListener {
            if (videoView.isPlaying) {
                videoView.pause()
                btnPlayPause.text = "▶"
            } else {
                videoView.start()
                btnPlayPause.text = "⏸"
            }
        }

        findViewById<MaterialButton>(R.id.btn_previous).setOnClickListener {
            if (currentIndex > 0) loadVideo(currentIndex - 1)
        }

        findViewById<MaterialButton>(R.id.btn_next).setOnClickListener {
            if (currentIndex < videos.size - 1) loadVideo(currentIndex + 1)
        }

        buildChips()
        loadVideo(0)
    }

    private fun loadVideo(index: Int) {
        currentIndex = index
        handler.removeCallbacks(progressUpdater)
        loadingIndicator.visibility = View.VISIBLE
        seekBar.progress = 0
        txtCurrentTime.text = "0:00"
        txtDuration.text = "0:00"
        btnPlayPause.text = "▶"
        txtTitle.text = videos[index].title
        videoView.setBackgroundColor(Color.BLACK)
        videoView.stopPlayback()
        videoView.setVideoURI(Uri.parse(videos[index].url))

        val chipGroup = findViewById<ChipGroup>(R.id.chip_group_videos)
        repeat(chipGroup.childCount) { i ->
            (chipGroup.getChildAt(i) as? Chip)?.isChecked = (i == index)
        }
    }

    private fun buildChips() {
        val chipGroup = findViewById<ChipGroup>(R.id.chip_group_videos)
        videos.forEachIndexed { index, video ->
            chipGroup.addView(Chip(this).apply {
                text = video.title
                isCheckable = true
                isChecked = (index == 0)
                setOnClickListener { loadVideo(index) }
            })
        }
    }

    private fun formatTime(ms: Int): String {
        if (ms <= 0) return "0:00"
        return "%d:%02d".format((ms / 1000) / 60, (ms / 1000) % 60)
    }

    override fun onPause() {
        super.onPause()
        videoView.pause()
        btnPlayPause.text = "▶"
    }

    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacks(progressUpdater)
        videoView.stopPlayback()
    }
}
