package com.vdocipher.sample_flutter_app;

import android.os.Build;

import io.flutter.embedding.android.FlutterFragmentActivity;

public class MainActivity extends FlutterFragmentActivity {

    private static final String TAG = "com.vdocipher.aegis.ui.view.VdoPlayerUIFragment";

    //Add this to implement picture in picture mode. Adding this will take player in picture in picture mode
    // when activity is about to go into the background as the result of user choice.
    @Override
    public void onUserLeaveHint() {
        super.onUserLeaveHint();
        //Check if player is attached to the activity currently.
        if (this.getSupportFragmentManager().findFragmentByTag(TAG) != null) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                enterPictureInPictureMode();
            }
        }
    }
}