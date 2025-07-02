// ...existing imports...
import android.os.Build;
import android.os.Bundle;
import android.content.Intent;
import android.net.Uri;
import android.os.PowerManager;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "battery_optimizations";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("requestIgnoreBatteryOptimizations")) {
                        try {
                            PowerManager pm = (PowerManager) getSystemService(POWER_SERVICE);
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                if (!pm.isIgnoringBatteryOptimizations(getPackageName())) {
                                    Intent intent = new Intent(android.provider.Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
                                    intent.setData(Uri.parse("package:" + getPackageName()));
                                    startActivity(intent);
                                }
                            }
                            result.success(null);
                        } catch (Exception e) {
                            result.error("UNAVAILABLE", "Could not request battery optimizations", null);
                        }
                    } else {
                        result.notImplemented();
                    }
                }
            );
    }
}
