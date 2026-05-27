package com.example.embeddedflutter

import android.animation.ObjectAnimator
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.text.Editable
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.button.MaterialButton
import com.uxcam.UXCam

class ChatActivity : AppCompatActivity() {

    // ── Message model ─────────────────────────────────────────────────────────
    sealed class Msg {
        abstract val id: Int
        abstract val reactions: MutableList<String>
        data class Text(override val id: Int, val text: String, val time: String,
                        val sent: Boolean, override val reactions: MutableList<String> = mutableListOf()) : Msg()
        data class Attach(override val id: Int, val name: String, val size: String,
                          val emoji: String, val time: String, val sent: Boolean,
                          override val reactions: MutableList<String> = mutableListOf()) : Msg()
        data class Voice(override val id: Int, val duration: String, val time: String,
                         val sent: Boolean, override val reactions: MutableList<String> = mutableListOf(),
                         var playing: Boolean = false, var progress: Int = 0) : Msg()
        data class System(override val id: Int, val label: String,
                          override val reactions: MutableList<String> = mutableListOf()) : Msg()
    }

    private var nextId = 20
    private val messages = mutableListOf(
        Msg.System(0, "Today"),
        Msg.Text(1, "Hey! How are you doing? 👋", "10:30", false),
        Msg.Text(2, "I'm doing great, thanks! Working on the new app 😄", "10:31", true),
        Msg.Text(3, "Nice! Can you share the design files?", "10:32", false),
        Msg.Attach(4, "design_mockup.png", "2.4 MB", "🖼️", "10:33", true),
        Msg.Text(5, "Looks absolutely amazing! 🔥", "10:34", false,
            mutableListOf("❤️", "🎉")),
        Msg.Voice(6, "0:23", "10:35", true),
        Msg.Text(7, "Got your voice note! Sounds good 👍", "10:36", false),
        Msg.Attach(8, "project_brief.pdf", "512 KB", "📄", "10:37", false),
        Msg.Text(9, "I'll review and get back to you 🙏", "10:38", true),
    )

    private val autoReplies = listOf(
        "Got it! 👍", "Sure, I'll check it out", "That looks great!",
        "Thanks for the update 🙏", "Can you elaborate?", "Perfect!",
        "Noted, will update accordingly 📝", "Interesting! Tell me more",
        "On it! 🚀", "Makes sense, thanks!",
    )
    private var replyIdx = 0

    private val handler = Handler(Looper.getMainLooper())
    private lateinit var adapter: ChatAdapter
    private lateinit var rv: RecyclerView
    private lateinit var llTyping: LinearLayout
    private lateinit var etMessage: EditText
    private lateinit var btnMicSend: ImageButton
    private val dotViews = arrayOfNulls<View>(3)
    private val dotAnimators = arrayOfNulls<ObjectAnimator>(3)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_chat)
        UXCam.tagScreenName("NativeChat")

        val toolbar = findViewById<androidx.appcompat.widget.Toolbar>(R.id.toolbar)
        setSupportActionBar(toolbar)
        supportActionBar?.title = "Alex"
        supportActionBar?.subtitle = "Online"
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        toolbar.setNavigationOnClickListener { finish() }

        rv = findViewById(R.id.rv_chat)
        llTyping = findViewById(R.id.ll_typing)
        etMessage = findViewById(R.id.et_message)
        btnMicSend = findViewById(R.id.btn_mic_send)
        dotViews[0] = findViewById(R.id.tv_dot1)
        dotViews[1] = findViewById(R.id.tv_dot2)
        dotViews[2] = findViewById(R.id.tv_dot3)

        adapter = ChatAdapter()
        rv.layoutManager = LinearLayoutManager(this).apply { stackFromEnd = true }
        rv.adapter = adapter
        rv.scrollToPosition(messages.size - 1)

        // Toggle mic/send icon based on input text
        etMessage.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(s: Editable?) {
                btnMicSend.setImageResource(
                    if (s.isNullOrBlank()) android.R.drawable.ic_btn_speak_now
                    else android.R.drawable.ic_menu_send
                )
            }
            override fun beforeTextChanged(s: CharSequence?, st: Int, c: Int, a: Int) {}
            override fun onTextChanged(s: CharSequence?, st: Int, b: Int, c: Int) {}
        })

        btnMicSend.setOnClickListener {
            val text = etMessage.text.toString().trim()
            if (text.isNotEmpty()) {
                sendText(text)
                etMessage.setText("")
            } else {
                sendVoice()
            }
        }

        btnMicSend.setOnLongClickListener {
            if (etMessage.text.isBlank()) {
                Toast.makeText(this, "Hold to record voice note…", Toast.LENGTH_SHORT).show()
                handler.postDelayed({ sendVoice() }, 1500)
                true
            } else false
        }

        findViewById<ImageButton>(R.id.btn_attach).setOnClickListener { showAttachPicker() }
    }

    private fun sendText(text: String) {
        val time = currentTime()
        messages.add(Msg.Text(nextId++, text, time, true))
        adapter.notifyItemInserted(messages.size - 1)
        scrollBottom()
        UXCam.logEvent("chat_message_sent")
        triggerAutoReply()
    }

    private fun sendVoice() {
        val durations = listOf("0:08", "0:12", "0:19", "0:31", "0:45")
        val msg = Msg.Voice(nextId++, durations.random(), currentTime(), true)
        messages.add(msg)
        adapter.notifyItemInserted(messages.size - 1)
        scrollBottom()
        UXCam.logEvent("chat_voice_note_sent")
        triggerAutoReply()
    }

    private fun showAttachPicker() {
        val sheet = BottomSheetDialog(this)
        val view = layoutInflater.inflate(android.R.layout.simple_list_item_1, null)
        // Build a quick attach sheet manually
        val layout = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(24, 24, 24, 48)
        }
        val title = TextView(this).apply {
            text = "Share"; textSize = 18f; setPadding(0, 0, 0, 24)
            setTypeface(null, android.graphics.Typeface.BOLD)
        }
        layout.addView(title)
        val options = listOf(
            "🖼️  Photo / Image" to true,
            "📄  Document / File" to false,
            "📍  Location" to false,
        )
        options.forEach { (label, isImage) ->
            val btn = MaterialButton(this).apply {
                text = label
                setOnClickListener {
                    sheet.dismiss()
                    val (name, size, emoji) = if (isImage)
                        Triple("photo_${nextId}.jpg", "1.${(2..9).random()} MB", "🖼️")
                    else if (label.contains("Document"))
                        Triple("document_${nextId}.pdf", "${(100..900).random()} KB", "📄")
                    else
                        Triple("Location pin", "Google Maps", "📍")
                    messages.add(Msg.Attach(nextId++, name, size, emoji, currentTime(), true))
                    adapter.notifyItemInserted(messages.size - 1)
                    scrollBottom()
                    UXCam.logEvent("chat_attachment_sent")
                    triggerAutoReply()
                }
            }
            layout.addView(btn)
        }
        sheet.setContentView(layout)
        sheet.show()
    }

    private fun triggerAutoReply() {
        handler.postDelayed({ showTyping(true) }, 1500)
        handler.postDelayed({
            showTyping(false)
            val reply = autoReplies[replyIdx % autoReplies.size]
            replyIdx++
            messages.add(Msg.Text(nextId++, reply, currentTime(), false))
            adapter.notifyItemInserted(messages.size - 1)
            scrollBottom()
        }, 3800)
    }

    private fun showTyping(show: Boolean) {
        llTyping.visibility = if (show) View.VISIBLE else View.GONE
        if (show) {
            dotViews.forEachIndexed { i, v ->
                dotAnimators[i]?.cancel()
                val anim = ObjectAnimator.ofFloat(v, "scaleX", 0.5f, 1.3f, 1f).apply {
                    duration = 600
                    startDelay = (i * 180).toLong()
                    repeatCount = ObjectAnimator.INFINITE
                    repeatMode = ObjectAnimator.REVERSE
                }
                val animY = ObjectAnimator.ofFloat(v, "scaleY", 0.5f, 1.3f, 1f).apply {
                    duration = 600
                    startDelay = (i * 180).toLong()
                    repeatCount = ObjectAnimator.INFINITE
                    repeatMode = ObjectAnimator.REVERSE
                }
                anim.start(); animY.start()
                dotAnimators[i] = anim
            }
        } else {
            dotAnimators.forEach { it?.cancel() }
        }
    }

    private fun showReactionPicker(position: Int) {
        val emojis = listOf("❤️", "👍", "😂", "😮", "😢", "🔥", "👏", "🎉")
        AlertDialog.Builder(this)
            .setTitle("React")
            .setItems(emojis.toTypedArray()) { _, which ->
                val msg = messages[position]
                msg.reactions.add(emojis[which])
                adapter.notifyItemChanged(position)
                UXCam.logEvent("chat_reaction_added")
            }
            .show()
    }

    private fun scrollBottom() {
        rv.post { rv.scrollToPosition(messages.size - 1) }
    }

    private fun currentTime(): String {
        val cal = java.util.Calendar.getInstance()
        return String.format("%02d:%02d", cal.get(java.util.Calendar.HOUR_OF_DAY), cal.get(java.util.Calendar.MINUTE))
    }

    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacksAndMessages(null)
        dotAnimators.forEach { it?.cancel() }
    }

    // ── Adapter ───────────────────────────────────────────────────────────────

    inner class ChatAdapter : RecyclerView.Adapter<RecyclerView.ViewHolder>() {
        private val TYPE_SYSTEM = 0
        private val TYPE_LEFT = 1
        private val TYPE_RIGHT = 2

        override fun getItemViewType(pos: Int) = when (val m = messages[pos]) {
            is Msg.System -> TYPE_SYSTEM
            is Msg.Text -> if (m.sent) TYPE_RIGHT else TYPE_LEFT
            is Msg.Attach -> if (m.sent) TYPE_RIGHT else TYPE_LEFT
            is Msg.Voice -> if (m.sent) TYPE_RIGHT else TYPE_LEFT
        }

        override fun onCreateViewHolder(parent: ViewGroup, vt: Int): RecyclerView.ViewHolder {
            fun inflate(id: Int) = LayoutInflater.from(parent.context).inflate(id, parent, false)
            return when (vt) {
                TYPE_SYSTEM -> SystemVH(inflate(R.layout.item_chat_system))
                TYPE_LEFT -> BubbleVH(inflate(R.layout.item_chat_left), false)
                else -> BubbleVH(inflate(R.layout.item_chat_right), true)
            }
        }

        override fun onBindViewHolder(holder: RecyclerView.ViewHolder, pos: Int) {
            when (holder) {
                is SystemVH -> holder.bind(messages[pos] as Msg.System)
                is BubbleVH -> holder.bind(messages[pos], pos)
            }
        }

        override fun getItemCount() = messages.size

        inner class SystemVH(view: View) : RecyclerView.ViewHolder(view) {
            fun bind(m: Msg.System) {
                itemView.findViewById<TextView>(R.id.tv_system).text = m.label
            }
        }

        inner class BubbleVH(view: View, private val sent: Boolean) : RecyclerView.ViewHolder(view) {
            private val tvText: TextView = view.findViewById(R.id.tv_msg_text)
            private val llAttach: LinearLayout = view.findViewById(R.id.ll_attachment)
            private val tvFileName: TextView = view.findViewById(R.id.tv_file_name)
            private val tvFileSize: TextView = view.findViewById(R.id.tv_file_size)
            private val tvAttachIcon: TextView = view.findViewById(R.id.tv_attach_icon)
            private val llVoice: LinearLayout = view.findViewById(R.id.ll_voice)
            private val btnPlay: ImageButton = view.findViewById(R.id.btn_play)
            private val seekVoice: SeekBar = view.findViewById(R.id.seek_voice)
            private val tvDuration: TextView = view.findViewById(R.id.tv_duration)
            private val tvTime: TextView = view.findViewById(R.id.tv_time)
            private val llReactions: LinearLayout = view.findViewById(R.id.ll_reactions)

            fun bind(msg: Msg, pos: Int) {
                // Reset visibility
                tvText.visibility = View.GONE
                llAttach.visibility = View.GONE
                llVoice.visibility = View.GONE

                when (msg) {
                    is Msg.Text -> {
                        tvText.visibility = View.VISIBLE
                        tvText.text = msg.text
                        tvTime.text = msg.time
                    }
                    is Msg.Attach -> {
                        llAttach.visibility = View.VISIBLE
                        tvAttachIcon.text = msg.emoji
                        tvFileName.text = msg.name
                        tvFileSize.text = msg.size
                        tvTime.text = msg.time
                    }
                    is Msg.Voice -> {
                        llVoice.visibility = View.VISIBLE
                        tvDuration.text = msg.duration
                        seekVoice.progress = msg.progress
                        tvTime.text = msg.time
                        btnPlay.setImageResource(
                            if (msg.playing) android.R.drawable.ic_media_pause
                            else android.R.drawable.ic_media_play
                        )
                        btnPlay.setOnClickListener {
                            if (!msg.playing) {
                                msg.playing = true
                                btnPlay.setImageResource(android.R.drawable.ic_media_pause)
                                simulateVoicePlay(msg, pos)
                                UXCam.logEvent("chat_voice_note_played")
                            } else {
                                msg.playing = false
                                btnPlay.setImageResource(android.R.drawable.ic_media_play)
                            }
                        }
                    }
                    is Msg.System -> {}
                }

                // Reactions
                llReactions.removeAllViews()
                if (msg.reactions.isNotEmpty()) {
                    llReactions.visibility = View.VISIBLE
                    msg.reactions.forEach { emoji ->
                        val chip = TextView(itemView.context).apply {
                            text = emoji
                            textSize = 16f
                            setPadding(6, 2, 6, 2)
                        }
                        llReactions.addView(chip)
                    }
                } else {
                    llReactions.visibility = View.GONE
                }

                // Long press to react
                itemView.setOnLongClickListener {
                    showReactionPicker(pos)
                    true
                }
            }

            private fun simulateVoicePlay(msg: Msg.Voice, pos: Int) {
                val runnable = object : Runnable {
                    override fun run() {
                        if (!msg.playing) return
                        msg.progress += 5
                        seekVoice.progress = msg.progress
                        if (msg.progress >= 100) {
                            msg.playing = false
                            msg.progress = 0
                            btnPlay.setImageResource(android.R.drawable.ic_media_play)
                        } else {
                            handler.postDelayed(this, 150)
                        }
                    }
                }
                handler.postDelayed(runnable, 150)
            }
        }
    }
}
