package com.srilambo.vpn

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import com.srilambo.vpn.ui.navigation.VpnNavGraph
import com.srilambo.vpn.ui.theme.SrilamboVPNTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            SrilamboVPNTheme {
                Surface(modifier = Modifier.fillMaxSize()) {
                    VpnNavGraph()
                }
            }
        }
    }
}
