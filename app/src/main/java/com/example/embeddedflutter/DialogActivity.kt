package com.example.embeddedflutter

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.os.Bundle
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.button.MaterialButton
import com.google.android.material.snackbar.Snackbar
import java.util.Calendar

class DialogActivity : AppCompatActivity() {

    private lateinit var resultText: TextView
    private lateinit var rootView: android.view.View

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_dialog)
        supportActionBar?.title = "Dialogs & Alerts"

        resultText = findViewById(R.id.dialog_result)
        rootView = findViewById(android.R.id.content)

        findViewById<MaterialButton>(R.id.btn_basic_alert).setOnClickListener { showBasicAlert() }
        findViewById<MaterialButton>(R.id.btn_confirm_dialog).setOnClickListener { showConfirmDialog() }
        findViewById<MaterialButton>(R.id.btn_single_choice).setOnClickListener { showSingleChoice() }
        findViewById<MaterialButton>(R.id.btn_multi_choice).setOnClickListener { showMultiChoice() }
        findViewById<MaterialButton>(R.id.btn_input_dialog).setOnClickListener { showInputDialog() }
        findViewById<MaterialButton>(R.id.btn_bottom_sheet).setOnClickListener { showBottomSheet() }
        findViewById<MaterialButton>(R.id.btn_snackbar).setOnClickListener { showSnackbar() }
        findViewById<MaterialButton>(R.id.btn_snackbar_action).setOnClickListener { showSnackbarWithAction() }
        findViewById<MaterialButton>(R.id.btn_toast).setOnClickListener { showToast() }
        findViewById<MaterialButton>(R.id.btn_date_picker).setOnClickListener { showDatePicker() }
        findViewById<MaterialButton>(R.id.btn_time_picker).setOnClickListener { showTimePicker() }
        findViewById<MaterialButton>(R.id.btn_progress).setOnClickListener { showProgressDialog() }
    }

    private fun setResult(msg: String) { resultText.text = msg }

    private fun showBasicAlert() {
        AlertDialog.Builder(this)
            .setTitle("Info")
            .setMessage("This is a basic alert dialog with a single dismiss button.")
            .setPositiveButton("OK") { _, _ -> setResult("Basic alert: OK tapped") }
            .show()
    }

    private fun showConfirmDialog() {
        AlertDialog.Builder(this)
            .setTitle("Confirm")
            .setMessage("Do you want to proceed with this action?")
            .setPositiveButton("Proceed") { _, _ -> setResult("Confirm: Proceed tapped") }
            .setNegativeButton("Cancel") { _, _ -> setResult("Confirm: Cancel tapped") }
            .setNeutralButton("Later") { _, _ -> setResult("Confirm: Later tapped") }
            .show()
    }

    private fun showSingleChoice() {
        val options = arrayOf("Option A", "Option B", "Option C", "Option D")
        var selected = 0
        AlertDialog.Builder(this)
            .setTitle("Pick one")
            .setSingleChoiceItems(options, selected) { _, which -> selected = which }
            .setPositiveButton("OK") { _, _ -> setResult("Single choice: ${options[selected]}") }
            .setNegativeButton("Cancel", null)
            .show()
    }

    private fun showMultiChoice() {
        val options = arrayOf("Flutter", "Kotlin", "Java", "Dart")
        val checked = booleanArrayOf(true, false, false, true)
        AlertDialog.Builder(this)
            .setTitle("Pick multiple")
            .setMultiChoiceItems(options, checked) { _, which, isChecked -> checked[which] = isChecked }
            .setPositiveButton("OK") { _, _ ->
                val chosen = options.filterIndexed { i, _ -> checked[i] }.joinToString()
                setResult("Multi choice: $chosen")
            }
            .setNegativeButton("Cancel", null)
            .show()
    }

    private fun showInputDialog() {
        val input = EditText(this).apply {
            hint = "Type something…"
            setPadding(48, 32, 48, 16)
        }
        AlertDialog.Builder(this)
            .setTitle("Enter text")
            .setView(input)
            .setPositiveButton("Submit") { _, _ -> setResult("Input: \"${input.text}\"") }
            .setNegativeButton("Cancel", null)
            .show()
    }

    private fun showBottomSheet() {
        val sheet = BottomSheetDialog(this)
        val layout = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(48, 40, 48, 48)
        }
        listOf("Share", "Edit", "Duplicate", "Delete").forEach { label ->
            android.widget.TextView(this).apply {
                text = label
                textSize = 16f
                setPadding(0, 24, 0, 24)
                setTextColor(android.graphics.Color.BLACK)
                setOnClickListener {
                    setResult("Bottom sheet: $label")
                    sheet.dismiss()
                }
                layout.addView(this)
            }
        }
        sheet.setContentView(layout)
        sheet.show()
    }

    private fun showSnackbar() {
        Snackbar.make(rootView, "This is a simple Snackbar", Snackbar.LENGTH_SHORT).show()
        setResult("Snackbar shown")
    }

    private fun showSnackbarWithAction() {
        Snackbar.make(rootView, "Item deleted", Snackbar.LENGTH_LONG)
            .setAction("UNDO") { setResult("Snackbar action: UNDO tapped") }
            .show()
        setResult("Snackbar with action shown")
    }

    private fun showToast() {
        Toast.makeText(this, "This is a Toast message", Toast.LENGTH_SHORT).show()
        setResult("Toast shown")
    }

    private fun showDatePicker() {
        val c = Calendar.getInstance()
        DatePickerDialog(this, { _, y, m, d ->
            setResult("Date picked: ${d}/${m + 1}/$y")
        }, c.get(Calendar.YEAR), c.get(Calendar.MONTH), c.get(Calendar.DAY_OF_MONTH)).show()
    }

    private fun showTimePicker() {
        val c = Calendar.getInstance()
        TimePickerDialog(this, { _, h, m ->
            setResult("Time picked: %02d:%02d".format(h, m))
        }, c.get(Calendar.HOUR_OF_DAY), c.get(Calendar.MINUTE), true).show()
    }

    private fun showProgressDialog() {
        val dialog = AlertDialog.Builder(this)
            .setTitle("Loading")
            .setMessage("Please wait…")
            .setCancelable(false)
            .create()
        dialog.show()
        rootView.postDelayed({
            dialog.dismiss()
            setResult("Progress dialog auto-dismissed after 2s")
        }, 2000)
    }
}
