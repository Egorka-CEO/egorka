package com.example.egorka

import android.app.Application
import android.os.Bundle
import android.os.PersistableBundle
import androidx.annotation.NonNull
import com.jivosite.sdk.Jivo
import com.jivosite.sdk.ui.chat.JivoChatFragment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {

  override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
    super.onCreate(savedInstanceState, persistentState)
    Jivo.init(
      appContext = this,
      widgetId = "kLQah8XzK3"
    )
  }
  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    MapKitFactory.setApiKey("d56975e0-35ed-4be0-84c9-2766e15664e4")
    super.configureFlutterEngine(flutterEngine)
  }
}