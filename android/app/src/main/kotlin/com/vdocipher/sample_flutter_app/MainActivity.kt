package com.vdocipher.sample_flutter_app

import android.os.Build
import android.view.ViewGroup
import android.view.WindowManager.LayoutParams.FLAG_SECURE
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterFragmentActivity() {
    //Add this to implement picture in picture mode. Adding this will take player in picture in picture mode
    // when activity is about to go into the background as the result of user choice.
    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        //Check if player is attached to the activity currently.
        if (this.supportFragmentManager.findFragmentByTag(com.vdocipher.sample_flutter_app.MainActivity.Companion.TAG) != null) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                enterPictureInPictureMode()
            }
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        window.addFlags(FLAG_SECURE)
        super.configureFlutterEngine(flutterEngine)
    }

    companion object {
        private const val TAG = "com.vdocipher.aegis.ui.view.VdoPlayerUIFragment"
    }
}