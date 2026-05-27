package com.example.embeddedflutter

import android.content.Context
import android.view.View
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeComposeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView =
        NativeComposePlatformView(context)
}

class NativeComposePlatformView(context: Context) : PlatformView {
    private val view = ComposeView(context).apply {
        setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnDetachedFromWindowOrReleasedFromPool)
        setContent {
            MaterialTheme {
                EmbeddedComposeCard()
            }
        }
    }

    override fun getView(): View = view
    override fun dispose() {}
}

@Composable
private fun EmbeddedComposeCard() {
    var clicks by remember { mutableIntStateOf(0) }
    var color by remember { mutableStateOf(Color(0xFF6750A4)) }
    val colors = listOf(Color(0xFF6750A4), Color(0xFF2196F3), Color(0xFF4CAF50), Color(0xFFE91E63))

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        // Header badge
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(color, RoundedCornerShape(12.dp))
                .padding(16.dp)
        ) {
            Column {
                Text(
                    "Native Compose View",
                    color = Color.White,
                    fontWeight = FontWeight.Bold,
                    fontSize = 16.sp
                )
                Text(
                    "Embedded in Flutter via PlatformView",
                    color = Color.White.copy(alpha = 0.85f),
                    fontSize = 12.sp
                )
            }
        }

        // Click counter
        ElevatedCard(modifier = Modifier.fillMaxWidth()) {
            Row(
                modifier = Modifier.padding(16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text("Compose Button Taps", fontWeight = FontWeight.SemiBold)
                    Text("$clicks taps so far", style = MaterialTheme.typography.bodySmall, color = Color.Gray)
                }
                FilledTonalButton(onClick = { clicks++ }) {
                    Text("Tap me")
                }
            }
        }

        // Color picker
        Text("Change color:", style = MaterialTheme.typography.labelMedium)
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            colors.forEach { c ->
                Button(
                    onClick = { color = c },
                    colors = ButtonDefaults.buttonColors(containerColor = c),
                    modifier = Modifier.size(40.dp),
                    contentPadding = PaddingValues(0.dp)
                ) {}
            }
        }
    }
}
