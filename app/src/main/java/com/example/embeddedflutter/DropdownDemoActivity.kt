package com.example.embeddedflutter

import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.PopupMenu
import android.widget.Spinner
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.card.MaterialCardView
import com.google.android.material.textfield.MaterialAutoCompleteTextView
import com.uxcam.UXCam

class DropdownDemoActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_dropdown_demo)

        UXCam.tagScreenName("NativeDropdownDemo")

        val toolbar = findViewById<androidx.appcompat.widget.Toolbar>(R.id.toolbar)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        toolbar.setNavigationOnClickListener { finish() }

        val resultText = findViewById<TextView>(R.id.txt_result)
        fun show(label: String, value: String) {
            resultText.text = "$label  →  $value"
        }

        // 1. Spinner — dropdown mode
        val fruits = listOf("Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape")
        setupSpinner(R.id.spinner_dropdown, fruits) { show("Spinner (dropdown)", it) }

        // 2. Spinner — dialog mode
        val seasons = listOf("Spring", "Summer", "Autumn", "Winter")
        setupSpinner(R.id.spinner_dialog, seasons) { show("Spinner (dialog)", it) }

        // 3. Material Exposed Dropdown — non-editable
        val countries = listOf(
            "Australia", "Brazil", "Canada", "France", "Germany",
            "India", "Japan", "Mexico", "Spain", "United Kingdom", "United States"
        )
        val countryView = findViewById<MaterialAutoCompleteTextView>(R.id.dropdown_country)
        countryView.setAdapter(
            ArrayAdapter(this, android.R.layout.simple_dropdown_item_1line, countries)
        )
        countryView.setOnItemClickListener { _, _, pos, _ -> show("Exposed Dropdown", countries[pos]) }

        // 4. Searchable AutoComplete — editable filter
        val cities = listOf(
            "Amsterdam", "Bangkok", "Berlin", "Chicago", "Dubai", "Istanbul",
            "London", "Los Angeles", "Mumbai", "New York", "Paris",
            "Singapore", "Sydney", "Tokyo", "Toronto"
        )
        val cityView = findViewById<MaterialAutoCompleteTextView>(R.id.autocomplete_city)
        cityView.threshold = 1
        cityView.setAdapter(
            ArrayAdapter(this, android.R.layout.simple_dropdown_item_1line, cities)
        )
        cityView.setOnItemClickListener { _, _, pos, _ ->
            val filtered = cities.filter { it.startsWith(cityView.text.toString(), ignoreCase = true) }
            show("AutoComplete", if (pos < filtered.size) filtered[pos] else cityView.text.toString())
        }

        // 5. Popup Menu button
        val popupItems = listOf("Edit", "Duplicate", "Share", "Archive", "Delete")
        findViewById<View>(R.id.btn_popup).setOnClickListener { anchor ->
            val popup = PopupMenu(this, anchor)
            popupItems.forEachIndexed { i, label -> popup.menu.add(0, i, i, label) }
            popup.setOnMenuItemClickListener { item ->
                show("Popup Menu", popupItems[item.itemId])
                true
            }
            popup.show()
        }

        // 6. Long-press context menu on card
        val contextItems = listOf("Copy", "Cut", "Paste", "Select All", "Translate")
        registerForContextMenu(findViewById<MaterialCardView>(R.id.card_context))
        findViewById<MaterialCardView>(R.id.card_context).setOnCreateContextMenuListener { menu, _, _ ->
            contextItems.forEachIndexed { i, label -> menu.add(0, i, i, label) }
        }
        // Intercept the selection via onContextItemSelected
        _contextCallback = { show("Context Menu", it) }
        _contextItems = contextItems
    }

    private var _contextCallback: ((String) -> Unit)? = null
    private var _contextItems: List<String> = emptyList()

    override fun onContextItemSelected(item: android.view.MenuItem): Boolean {
        val label = _contextItems.getOrNull(item.itemId) ?: return super.onContextItemSelected(item)
        _contextCallback?.invoke(label)
        return true
    }

    private fun setupSpinner(id: Int, items: List<String>, onSelect: (String) -> Unit) {
        val spinner = findViewById<Spinner>(id)
        spinner.adapter = ArrayAdapter(
            this, android.R.layout.simple_spinner_item, items
        ).also { it.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item) }
        spinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(p: AdapterView<*>, v: View?, pos: Int, id: Long) = onSelect(items[pos])
            override fun onNothingSelected(p: AdapterView<*>) = Unit
        }
    }
}
