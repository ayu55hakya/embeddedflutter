package com.example.embeddedflutter

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

class ComposeActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                ComposeShowcaseScreen()
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ComposeShowcaseScreen() {
    var counter by remember { mutableIntStateOf(0) }
    var switchOn by remember { mutableStateOf(false) }
    var sliderValue by remember { mutableFloatStateOf(0.5f) }
    var expanded by remember { mutableStateOf(false) }
    val rotation by animateFloatAsState(targetValue = if (expanded) 45f else 0f, label = "fab_rotate")

    val cards = listOf(
        Triple("Text & Typography", Color(0xFF6750A4), "Headline\nTitle\nBody text sample"),
        Triple("Buttons", Color(0xFF2196F3), "Filled · Tonal · Outlined · Text"),
        Triple("Cards", Color(0xFF4CAF50), "Elevated · Filled · Outlined"),
        Triple("Indicators", Color(0xFFFF9800), "Linear · Circular progress"),
    )

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Jetpack Compose Screen") },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer
                )
            )
        },
        floatingActionButton = {
            FloatingActionButton(onClick = { expanded = !expanded; counter++ }) {
                Icon(Icons.Default.Add, contentDescription = null, modifier = Modifier.rotate(rotation))
            }
        }
    ) { padding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
            contentPadding = PaddingValues(vertical = 16.dp)
        ) {
            // Counter card
            item {
                ElevatedCard(modifier = Modifier.fillMaxWidth()) {
                    Column(modifier = Modifier.padding(16.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("FAB Counter", style = MaterialTheme.typography.titleMedium)
                        Spacer(Modifier.height(8.dp))
                        Text("$counter", fontSize = 48.sp, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary)
                        Text("Tap the + button", style = MaterialTheme.typography.bodySmall, color = Color.Gray)
                    }
                }
            }

            // Controls card
            item {
                ElevatedCard(modifier = Modifier.fillMaxWidth()) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Text("Controls", style = MaterialTheme.typography.titleMedium)
                        Spacer(Modifier.height(12.dp))

                        Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.fillMaxWidth()) {
                            Text("Switch", modifier = Modifier.weight(1f))
                            Switch(checked = switchOn, onCheckedChange = { switchOn = it })
                        }

                        Spacer(Modifier.height(8.dp))
                        Text("Slider: ${"%.2f".format(sliderValue)}", style = MaterialTheme.typography.bodySmall)
                        Slider(value = sliderValue, onValueChange = { sliderValue = it })

                        AnimatedVisibility(visible = switchOn) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Icon(Icons.Default.Favorite, contentDescription = null, tint = Color.Red)
                                Spacer(Modifier.width(8.dp))
                                Text("Switch is ON", color = Color.Red)
                            }
                        }
                    }
                }
            }

            // Chip row
            item {
                Text("Chips", style = MaterialTheme.typography.titleMedium)
                Spacer(Modifier.height(8.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    listOf("Flutter", "Kotlin", "Compose").forEach { label ->
                        AssistChip(onClick = {}, label = { Text(label) })
                    }
                }
            }

            // Info cards
            items(cards) { (title, color, subtitle) ->
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Row(modifier = Modifier.padding(16.dp), verticalAlignment = Alignment.CenterVertically) {
                        Box(
                            modifier = Modifier
                                .size(48.dp)
                                .background(color, RoundedCornerShape(8.dp))
                        )
                        Spacer(Modifier.width(12.dp))
                        Column {
                            Text(title, fontWeight = FontWeight.SemiBold)
                            Text(subtitle, style = MaterialTheme.typography.bodySmall, color = Color.Gray)
                        }
                    }
                }
            }

            // Progress indicators
            item {
                ElevatedCard(modifier = Modifier.fillMaxWidth()) {
                    Column(modifier = Modifier.padding(16.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Progress", style = MaterialTheme.typography.titleMedium)
                        Spacer(Modifier.height(12.dp))
                        LinearProgressIndicator(progress = { sliderValue }, modifier = Modifier.fillMaxWidth())
                        Spacer(Modifier.height(12.dp))
                        CircularProgressIndicator(progress = { sliderValue })
                    }
                }
            }
        }
    }
}
