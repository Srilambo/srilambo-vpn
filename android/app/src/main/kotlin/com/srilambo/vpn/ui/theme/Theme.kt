package com.srilambo.vpn.ui.theme

import android.app.Activity
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat

private val VpnDarkColorScheme = darkColorScheme(
    primary = VpnGreen,
    onPrimary = BackgroundDeep,
    primaryContainer = Color(0xFF003020),
    onPrimaryContainer = VpnGreenLight,
    secondary = VpnBlue,
    onSecondary = BackgroundDeep,
    secondaryContainer = Color(0xFF00294A),
    onSecondaryContainer = Color(0xFF93CEFF),
    tertiary = Color(0xFFBB86FC),
    background = BackgroundDeep,
    onBackground = TextPrimary,
    surface = BackgroundCard,
    onSurface = TextPrimary,
    surfaceVariant = BackgroundElevated,
    onSurfaceVariant = TextSecondary,
    error = VpnRed,
    onError = Color.White,
    outline = Color(0xFF2A3050),
    outlineVariant = Color(0xFF1E2438)
)

@Composable
fun SrilamboVPNTheme(content: @Composable () -> Unit) {
    val colorScheme = VpnDarkColorScheme
    val view = LocalView.current
    if (!view.isInEditMode) {
        SideEffect {
            val window = (view.context as Activity).window
            window.statusBarColor = BackgroundDeep.toArgb()
            window.navigationBarColor = BackgroundDeep.toArgb()
            WindowCompat.getInsetsController(window, view).apply {
                isAppearanceLightStatusBars = false
                isAppearanceLightNavigationBars = false
            }
        }
    }
    MaterialTheme(
        colorScheme = colorScheme,
        typography = VpnTypography,
        content = content
    )
}
