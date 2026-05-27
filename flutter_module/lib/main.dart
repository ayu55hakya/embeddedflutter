import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- UXCam Initialization (Flutter side) ---
  FlutterUxConfig config = FlutterUxConfig(
    userAppKey: "leoadf73n5drfy0-us",
    enableAutomaticScreenNameTagging: false,
    enableSmartEvents: true,
  );

  FlutterUxcam.startWithConfiguration(config).then(
    (status) => print('Flutter UXCam status: $status'),
    onError: (e) => print('Flutter UXCam error: $e'),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Module',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const FlutterHomePage(),
    );
  }
}

class FlutterHomePage extends StatefulWidget {
  const FlutterHomePage({super.key});

  @override
  State<FlutterHomePage> createState() => _FlutterHomePageState();
}

class _FlutterHomePageState extends State<FlutterHomePage> {
  String _status = 'Flutter view loaded';
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    // --- Screen Tagging (Flutter side) ---
    FlutterUxcam.tagScreenName('FlutterHome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Screen')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Flutter Embedded View Test',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              _status,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // --- PII Masking (Flutter side) ---
            const Text('PII Masking',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            OccludeWrapper(
              child: const TextField(
                decoration: InputDecoration(
                  labelText: 'Email (occluded)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 8),
            OccludeWrapper(
              child: const TextField(
                decoration: InputDecoration(
                  labelText: 'Credit Card (occluded)',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 24),

            // --- Event Tracking (Flutter side) ---
            const Text('Event Tracking',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                FlutterUxcam.logEvent('flutter_button_tap');
                setState(() => _status = 'Event: flutter_button_tap');
              },
              child: const Text('Log Flutter Event'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                FlutterUxcam.logEventWithProperties('flutter_purchase', {
                  'item': 'premium_plan',
                  'price': '9.99',
                  'source': 'flutter_module',
                });
                setState(
                    () => _status = 'Event: flutter_purchase with properties');
              },
              child: const Text('Log Event With Properties'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                FlutterUxcam.logEventWithProperties('item', {
                  'name': 'book',
                  'value': 400,
                });
                setState(() => _status = 'Event: item with properties');
              },
              child: const Text('Log Item Event'),
            ),
            const SizedBox(height: 24),

            // --- User Identity & Properties (Flutter side) ---
            const Text('User Identity',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                FlutterUxcam.setUserIdentity('flutter-user-99');
                setState(() => _status = 'Identity: flutter-user-99');
              },
              child: const Text('Set User Identity (Flutter)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                FlutterUxcam.setUserProperty('theme', 'dark');
                FlutterUxcam.setUserProperty('source', 'flutter_module');
                FlutterUxcam.setSessionProperty('flutter_session_flag', 'true');
                setState(() => _status = 'User & session properties set');
              },
              child: const Text('Set User Properties (Flutter)'),
            ),
            const SizedBox(height: 24),

            // --- Screen Tagging (Flutter side) ---
            const Text('Screen Tagging',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                FlutterUxcam.tagScreenName('FlutterSettings');
                setState(() => _status = 'Screen tagged: FlutterSettings');
              },
              child: const Text('Tag Screen: FlutterSettings'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const FlutterSecondPage()),
                );
              },
              child: const Text('Navigate to Second Flutter Page'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlutterWebViewPage()),
                );
              },
              child: const Text('Open WebView'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlutterLottiePage()),
                );
              },
              child: const Text('Open Lottie Animations'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlutterDialogsPage()),
                );
              },
              child: const Text('Open Dialogs & Alerts'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlutterComposeViewPage()),
                );
              },
              child: const Text('Open Native Compose View'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlutterImageGalleryPage()),
                );
              },
              child: const Text('Open Image Gallery'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlutterScrollDemoPage()),
                );
              },
              child: const Text('Open Scroll Demo'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlutterDropdownDemoPage()),
                );
              },
              child: const Text('Open Dropdown Demo'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4527A0), foregroundColor: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlutterShortBreakPage()),
                );
              },
              child: const Text('UXCam Short Break'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF212121), foregroundColor: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlutterVideoPlayerPage()),
                );
              },
              child: const Text('Open Video Player'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00695C), foregroundColor: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlutterFABDemoPage()),
                );
              },
              child: const Text('Open FAB Demo'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFAD1457), foregroundColor: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlutterCarouselPage()),
                );
              },
              child: const Text('Open Carousel / Slider'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20), foregroundColor: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlutterMapDemoPage()),
                );
              },
              child: const Text('Open Map View'),
            ),
            const SizedBox(height: 24),

            // --- Counter (to test interaction tracking) ---
            const Text('Interaction Test',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Counter: $_counter',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _counter++);
          FlutterUxcam.logEvent('flutter_counter_increment');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FlutterSecondPage extends StatefulWidget {
  const FlutterSecondPage({super.key});

  @override
  State<FlutterSecondPage> createState() => _FlutterSecondPageState();
}

class FlutterWebViewPage extends StatefulWidget {
  const FlutterWebViewPage({super.key});

  @override
  State<FlutterWebViewPage> createState() => _FlutterWebViewPageState();
}

class _FlutterWebViewPageState extends State<FlutterWebViewPage> {
  late final WebViewController _controller;
  final TextEditingController _urlController =
      TextEditingController(text: 'https://www.google.com');
  String _pageTitle = 'Loading…';
  String _pageUrl = '';
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    FlutterUxcam.tagScreenName('FlutterWebView');
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) => setState(() { _pageUrl = url; _progress = 0; _pageTitle = 'Loading…'; }),
        onProgress: (p) => setState(() => _progress = p),
        onPageFinished: (url) async {
          final title = await _controller.getTitle();
          if (mounted) setState(() { _pageUrl = url; _progress = 100; _pageTitle = title ?? url; });
        },
      ))
      ..loadRequest(Uri.parse('https://www.google.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebView')),
      body: Column(
        children: [
          // URL bar
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      hintText: 'https://...',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    keyboardType: TextInputType.url,
                    onSubmitted: _loadUrl,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _loadUrl(_urlController.text),
                  child: const Text('Go'),
                ),
              ],
            ),
          ),
          // WebView + native Flutter overlay
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),

                // Progress bar at the top
                if (_progress < 100)
                  Positioned(
                    top: 0, left: 0, right: 0,
                    child: LinearProgressIndicator(
                      value: _progress / 100,
                      minHeight: 3,
                      backgroundColor: Colors.transparent,
                    ),
                  ),

                // Native Flutter overlay card at the bottom
                Positioned(
                  bottom: 12, left: 12, right: 12,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _pageTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (_pageUrl.isNotEmpty)
                            Text(
                              _pageUrl,
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.tonal(
                                  onPressed: () => _controller.reload(),
                                  child: const Text('Reload'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    if (await _controller.canGoBack()) _controller.goBack();
                                  },
                                  child: const Text('← Back'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _injectJs,
                                  child: const Text('Inject JS'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _loadUrl(String url) {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    _controller.loadRequest(uri);
  }

  void _injectJs() {
    _controller.runJavaScript(
      "document.body.style.outline = '4px solid #6750A4';"
      "alert('Flutter JS injected!');",
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}

class _FlutterSecondPageState extends State<FlutterSecondPage> {
  @override
  void initState() {
    super.initState();
    FlutterUxcam.tagScreenName('FlutterSecondPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Flutter Page')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'This is a second Flutter page to test screen tagging across navigation.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OccludeWrapper(
              child: const TextField(
                decoration: InputDecoration(
                  labelText: 'SSN (occluded)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                FlutterUxcam.logEvent('flutter_second_page_action');
              },
              child: const Text('Log Event From Second Page'),
            ),
          ],
        ),
      ),
    );
  }
}

class FlutterLottiePage extends StatefulWidget {
  const FlutterLottiePage({super.key});

  @override
  State<FlutterLottiePage> createState() => _FlutterLottiePageState();
}

class _FlutterLottiePageState extends State<FlutterLottiePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  String _currentAsset = 'assets/bounce.json';
  double _speed = 1.0;
  bool _playing = true;

  @override
  void initState() {
    super.initState();
    FlutterUxcam.tagScreenName('FlutterLottiePage');
    _controller = AnimationController(vsync: this);
  }

  void _loadAnimation(String asset) {
    setState(() {
      _currentAsset = asset;
      _playing = true;
    });
  }

  void _togglePlayPause() {
    setState(() => _playing = !_playing);
    if (_playing) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  void _setSpeed(double speed) {
    setState(() => _speed = speed);
    _controller.duration = _controller.duration != null
        ? Duration(milliseconds: (_controller.duration!.inMilliseconds / speed).round())
        : null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lottie Animations')),
      body: Column(
        children: [
          Expanded(
            child: Lottie.asset(
              _currentAsset,
              controller: _controller,
              onLoaded: (composition) {
                _controller
                  ..duration = Duration(
                      milliseconds:
                          (composition.duration.inMilliseconds / _speed).round())
                  ..repeat();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Animation',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _animBtn('Bounce', 'assets/bounce.json'),
                    const SizedBox(width: 8),
                    _animBtn('Spinner', 'assets/spinner.json'),
                    const SizedBox(width: 8),
                    _animBtn('Pulse', 'assets/pulse.json'),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Speed',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _speedBtn('0.5×', 0.5),
                    const SizedBox(width: 8),
                    _speedBtn('1×', 1.0),
                    const SizedBox(width: 8),
                    _speedBtn('2×', 2.0),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _togglePlayPause,
                  child: Text(_playing ? 'Pause' : 'Play'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _animBtn(String label, String asset) => Expanded(
        child: _currentAsset == asset
            ? FilledButton(
                onPressed: () => _loadAnimation(asset), child: Text(label))
            : OutlinedButton(
                onPressed: () => _loadAnimation(asset), child: Text(label)),
      );

  Widget _speedBtn(String label, double speed) => Expanded(
        child: _speed == speed
            ? FilledButton(
                onPressed: () => _setSpeed(speed), child: Text(label))
            : OutlinedButton(
                onPressed: () => _setSpeed(speed), child: Text(label)),
      );
}

// ─── Dialogs & Alerts Page ───────────────────────────────────────────────────

class FlutterDialogsPage extends StatefulWidget {
  const FlutterDialogsPage({super.key});

  @override
  State<FlutterDialogsPage> createState() => _FlutterDialogsPageState();
}

class _FlutterDialogsPageState extends State<FlutterDialogsPage> {
  String _result = 'Tap a button to show a dialog';

  @override
  void initState() {
    super.initState();
    FlutterUxcam.tagScreenName('FlutterDialogsPage');
  }

  void _setResult(String msg) => setState(() => _result = msg);

  // ── Alert Dialog ──────────────────────────────────────────────────────────
  void _showBasicAlert() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Info'),
        content: const Text('This is a basic alert dialog.'),
        actions: [
          TextButton(
            onPressed: () { Navigator.pop(context); _setResult('Basic alert: OK'); },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Do you want to proceed with this action?'),
        actions: [
          TextButton(onPressed: () { Navigator.pop(context); _setResult('Confirm: Cancel'); }, child: const Text('Cancel')),
          TextButton(onPressed: () { Navigator.pop(context); _setResult('Confirm: Later'); }, child: const Text('Later')),
          FilledButton(onPressed: () { Navigator.pop(context); _setResult('Confirm: Proceed'); }, child: const Text('Proceed')),
        ],
      ),
    );
  }

  void _showSingleChoiceDialog() {
    final options = ['Option A', 'Option B', 'Option C', 'Option D'];
    int selected = 0;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: const Text('Pick one'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(options.length, (i) => RadioListTile<int>(
              title: Text(options[i]),
              value: i,
              groupValue: selected,
              onChanged: (v) => setSt(() => selected = v!),
            )),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(onPressed: () { Navigator.pop(ctx); _setResult('Single choice: ${options[selected]}'); }, child: const Text('OK')),
          ],
        ),
      ),
    );
  }

  void _showMultiChoiceDialog() {
    final options = ['Flutter', 'Kotlin', 'Java', 'Dart'];
    final checked = [true, false, false, true];
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: const Text('Pick multiple'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(options.length, (i) => CheckboxListTile(
              title: Text(options[i]),
              value: checked[i],
              onChanged: (v) => setSt(() => checked[i] = v!),
            )),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final chosen = [for (var i = 0; i < options.length; i++) if (checked[i]) options[i]].join(', ');
                Navigator.pop(ctx);
                _setResult('Multi choice: $chosen');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showInputDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter text'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Type something…', border: OutlineInputBorder()),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () { Navigator.pop(ctx); _setResult('Input: "${controller.text}"'); },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  // ── Bottom Sheet ─────────────────────────────────────────────────────────
  void _showBottomSheet() {
    final items = ['Share', 'Edit', 'Duplicate', 'Delete'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items.map((label) => ListTile(
            title: Text(label),
            onTap: () { Navigator.pop(ctx); _setResult('Bottom sheet: $label'); },
          )).toList(),
        ),
      ),
    );
  }

  // ── Snackbar ─────────────────────────────────────────────────────────────
  void _showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This is a simple Snackbar')),
    );
    _setResult('Snackbar shown');
  }

  void _showSnackbarWithAction() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item deleted'),
        action: SnackBarAction(label: 'UNDO', onPressed: () => _setResult('Snackbar: UNDO tapped')),
      ),
    );
    _setResult('Snackbar with action shown');
  }

  // ── Pickers ───────────────────────────────────────────────────────────────
  void _showDatePicker() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (!mounted) return;
    if (picked != null) _setResult('Date picked: ${picked.day}/${picked.month}/${picked.year}');
  }

  void _showTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (!mounted) return;
    if (picked != null) _setResult('Time picked: ${picked.format(context)}');
  }

  // ── Progress ─────────────────────────────────────────────────────────────
  void _showProgressDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        title: Text('Loading'),
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Please wait…'),
          ],
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) { Navigator.pop(context); _setResult('Progress dialog dismissed after 2s'); }
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialogs & Alerts')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
            child: Text(_result, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ),
          const SizedBox(height: 16),
          _section('Alert Dialogs'),
          _btn('Basic Alert', _showBasicAlert),
          _btn('Confirm Dialog (OK / Cancel / Later)', _showConfirmDialog),
          _btn('Single Choice List', _showSingleChoiceDialog),
          _btn('Multi Choice List', _showMultiChoiceDialog),
          _btn('Input Dialog', _showInputDialog),
          _section('Bottom Sheet'),
          _btn('Modal Bottom Sheet', _showBottomSheet),
          _section('Snackbar'),
          _btn('Snackbar', _showSnackbar),
          _btn('Snackbar with Action', _showSnackbarWithAction),
          _section('Pickers'),
          _btn('Date Picker', _showDatePicker),
          _btn('Time Picker', _showTimePicker),
          _section('Progress'),
          _btn('Progress Dialog (auto-dismisses)', _showProgressDialog),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      );

  Widget _btn(String label, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: ElevatedButton(onPressed: onTap, child: Text(label)),
      );
}

// ─── Image Gallery data ───────────────────────────────────────────────────────

class ImageItem {
  final int id;
  final String title;
  final String category;
  final String description;
  final int likes;
  final int views;

  const ImageItem({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.likes,
    required this.views,
  });

  String get thumbUrl => 'https://picsum.photos/id/$id/400/400';
  String get fullUrl => 'https://picsum.photos/id/$id/800/1000';
}

const _galleryImages = [
  ImageItem(id: 10,  title: 'Forest Path',    category: 'Nature',       description: 'A winding trail disappears into the heart of an ancient forest, where sunlight filters gently through the canopy.', likes: 1240, views: 8930),
  ImageItem(id: 29,  title: 'Mountain Lake',  category: 'Landscape',    description: 'Crystal-clear alpine waters mirror the jagged peaks above in perfect symmetry.', likes: 3410, views: 21500),
  ImageItem(id: 37,  title: 'City Rooftops',  category: 'Architecture', description: 'A maze of terracotta rooftops stretches toward the horizon under a warm golden sky.', likes: 870,  views: 6200),
  ImageItem(id: 65,  title: 'Ocean Horizon',  category: 'Travel',       description: 'Where the endless blue ocean meets the sky, a sense of infinite possibility opens up.', likes: 5600, views: 43000),
  ImageItem(id: 96,  title: 'Urban Geometry', category: 'Architecture', description: 'Bold lines and angular shadows define the facade of a modernist building downtown.', likes: 2100, views: 15800),
  ImageItem(id: 102, title: 'Morning Coffee', category: 'Lifestyle',    description: 'Steam rises from a freshly brewed cup on a quiet morning table, promising a gentle start.', likes: 4830, views: 32100),
  ImageItem(id: 110, title: 'Sandy Shore',    category: 'Travel',       description: 'Fine white sand meets turquoise water in a secluded cove far from the tourist trail.', likes: 7200, views: 58000),
  ImageItem(id: 119, title: 'Misty Peaks',    category: 'Landscape',    description: 'Dawn mist clings to the valley between sharp ridgelines, softening the scene like watercolour.', likes: 3950, views: 27400),
  ImageItem(id: 167, title: 'Autumn Leaves',  category: 'Nature',       description: 'A burst of red and amber foliage signals the arrival of autumn in this quiet park.', likes: 2760, views: 19600),
  ImageItem(id: 180, title: 'Desert Dunes',   category: 'Travel',       description: 'Sculpted by the wind, enormous sand dunes cast dramatic shadows across the desert floor.', likes: 6100, views: 47200),
];

// ─── Image Gallery Page ───────────────────────────────────────────────────────

class FlutterImageGalleryPage extends StatelessWidget {
  const FlutterImageGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Gallery')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: _galleryImages.length,
        itemBuilder: (context, index) {
          final item = _galleryImages[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FlutterImageDetailPage(item: item)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'image_${item.id}',
                    child: Image.network(item.thumbUrl, fit: BoxFit.cover),
                  ),
                  Positioned(
                    bottom: 0, left: 0, right: 0, height: 70,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black87],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8, left: 8, right: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.category,
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.title,
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Image Detail Page ────────────────────────────────────────────────────────

class FlutterImageDetailPage extends StatelessWidget {
  final ImageItem item;
  const FlutterImageDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'image_${item.id}',
              child: Image.network(
                item.fullUrl,
                width: double.infinity,
                height: 320,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0x1A6750A4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF6750A4)),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(color: Color(0xFF6750A4), fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 15, color: Color(0xFF444444), height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(
                                  item.likes.toString(),
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFE91E63)),
                                ),
                                const Text('Likes', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(
                                  item.views.toString(),
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6750A4)),
                                ),
                                const Text('Views', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Scroll Demo Page ─────────────────────────────────────────────────────────

class FlutterScrollDemoPage extends StatefulWidget {
  const FlutterScrollDemoPage({super.key});

  @override
  State<FlutterScrollDemoPage> createState() => _FlutterScrollDemoPageState();
}

class _FlutterScrollDemoPageState extends State<FlutterScrollDemoPage> {
  int _selectedCategory = 0;

  static const _categories = ['All', 'Nature', 'Landscape', 'Architecture', 'Travel', 'Lifestyle'];

  static const _concepts = [
    ('SliverAppBar', 'Expands and collapses the header as you scroll, with a background image and parallax effect.'),
    ('CustomScrollView', 'A scrollable area that accepts slivers — mixing lists, grids, and fixed content.'),
    ('SliverToBoxAdapter', 'Wraps a normal widget (like a horizontal scroll row) inside a CustomScrollView.'),
    ('SliverList', 'Efficiently renders a lazily-loaded vertical list inside a CustomScrollView.'),
    ('SliverGrid', 'Renders a lazily-loaded grid of items that scrolls as part of the same scroll view.'),
    ('Horizontal ScrollView', 'The featured row above uses a SingleChildScrollView with horizontal axis.'),
    ('pinned AppBar', 'The app bar stays visible at the top once collapsed — set pinned: true on SliverAppBar.'),
    ('FlexibleSpaceBar', 'Provides the expanding title and background image inside a SliverAppBar.'),
  ];

  @override
  void initState() {
    super.initState();
    FlutterUxcam.tagScreenName('FlutterScrollDemo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Expanding app bar with background image ──
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Scroll Demo'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://picsum.photos/id/15/800/400',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Featured horizontal scroll ──
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Text('Featured', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    itemCount: _galleryImages.length,
                    itemBuilder: (context, index) {
                      final item = _galleryImages[index];
                      return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(item.thumbUrl, fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── Category chip row ──
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final selected = _selectedCategory == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_categories[index]),
                          selected: selected,
                          onSelected: (_) => setState(() => _selectedCategory = index),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Text('Scroll Concepts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // ── Vertical sliver list ──
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final (title, desc) = _concepts[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(desc, style: const TextStyle(fontSize: 13, color: Color(0xFF666666), height: 1.4)),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: _concepts.length,
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}

// ─── UXCam Short Break Page ───────────────────────────────────────────────────

class FlutterShortBreakPage extends StatefulWidget {
  const FlutterShortBreakPage({super.key});

  @override
  State<FlutterShortBreakPage> createState() => _FlutterShortBreakPageState();
}

class _FlutterShortBreakPageState extends State<FlutterShortBreakPage>
    with WidgetsBindingObserver {
  bool _enabled = false;
  int _selectedDurationMs = 180000;
  String _status = 'Short break: disabled';
  bool _shortBreakLaunched = false;

  static const _durations = [
    (label: '30 sec',          ms: 30000),
    (label: '1 min',           ms: 60000),
    (label: '2 min',           ms: 120000),
    (label: '3 min (default)', ms: 180000),
    (label: '5 min',           ms: 300000),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FlutterUxcam.tagScreenName('FlutterShortBreakDemo');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _shortBreakLaunched) {
      _shortBreakLaunched = false;
      FlutterUxcam.resumeShortBreakForAnotherApp();
      setState(() => _status = 'Returned from Apple.com — session resumed ✓');
    }
  }

  Future<void> _launchApple() async {
    await FlutterUxcam.allowShortBreakForAnotherApp(true);
    setState(() {
      _enabled = true;
      _shortBreakLaunched = true;
      _status = 'Short break enabled — opening Apple.com…';
    });
    await launchUrl(
      Uri.parse('https://www.apple.com'),
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _onToggle(bool value) async {
    await FlutterUxcam.allowShortBreakForAnotherApp(value);
    setState(() {
      _enabled = value;
      _status = value
          ? 'Short break: enabled  |  Duration: ${_durationLabel(_selectedDurationMs)}'
          : 'Short break: disabled';
    });
  }

  Future<void> _onDurationSelected(int ms) async {
    await FlutterUxcam.allowShortBreakForAnotherAppWithDuration(ms);
    setState(() {
      _selectedDurationMs = ms;
      _status = _enabled
          ? 'Short break: enabled  |  Duration: ${_durationLabel(ms)}'
          : 'Duration set: ${_durationLabel(ms)} (enable toggle to activate)';
    });
  }

  Future<void> _onResume() async {
    await FlutterUxcam.resumeShortBreakForAnotherApp();
    setState(() => _status = 'Session resumed manually');
  }

  String _durationLabel(int ms) =>
      _durations.firstWhere((d) => d.ms == ms, orElse: () => (label: '${ms ~/ 1000}s', ms: ms)).label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Short Break Demo')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Status card
          Card(
            color: const Color(0xFFEDE7F6),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF6750A4), fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // What is Short Break?
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('What is Short Break?',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    'When a user briefly leaves your app, UXCam would normally end the session. '
                    'Short Break pauses recording instead, resuming seamlessly when the user returns — keeping the session intact.',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF555555), height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section 1: allowShortBreakForAnotherApp(bool)
          _apiCard(
            method: 'allowShortBreakForAnotherApp(bool)',
            description: 'Enable or disable short break. Pass true to pause the session when the app goes to background.',
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Enable Short Break'),
              value: _enabled,
              onChanged: _onToggle,
            ),
          ),
          const SizedBox(height: 16),

          // Section 2: allowShortBreakForAnotherAppWithDuration(int ms)
          _apiCard(
            method: 'allowShortBreakForAnotherAppWithDuration(int ms)',
            description: 'Android only. Maximum wait time in milliseconds before UXCam ends the session. Default is 180 000 ms (3 min).',
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _durations.map((d) {
                  final selected = _selectedDurationMs == d.ms;
                  return FilterChip(
                    label: Text(d.label),
                    selected: selected,
                    onSelected: (_) => _onDurationSelected(d.ms),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section 3: resumeShortBreakForAnotherApp()
          _apiCard(
            method: 'resumeShortBreakForAnotherApp()',
            description: 'Manually resume the paused session when the user returns. Useful when your app manages its own foreground/background detection.',
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: FilledButton.tonal(
                onPressed: _onResume,
                child: const Text('Resume Session Now'),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section 4: Real-World Demo
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Color(0xFF6750A4)),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Real-World Demo — apple.com',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF6750A4)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tap the button to see Short Break in action. UXCam pauses recording, '
                    'the browser opens apple.com, and the session resumes automatically '
                    'when you return to the app.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF666666), height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  _stepRow('①', 'allowShortBreakForAnotherApp(true)', const Color(0xFF6750A4)),
                  _stepRow('②', 'apple.com opens in external browser', Colors.blue),
                  _stepRow('③', 'User returns to app', Colors.orange),
                  _stepRow('④', 'resumeShortBreakForAnotherApp() auto-called', Colors.green),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _launchApple,
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text('Enable Short Break & Open Apple.com'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _stepRow(String step, String label, Color color) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Text(step, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          ],
        ),
      );

  Widget _apiCard({
    required String method,
    required String description,
    required Widget child,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              method,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6750A4),
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 4),
            Text(description,
                style: const TextStyle(fontSize: 12, color: Color(0xFF666666), height: 1.4)),
            child,
          ],
        ),
      ),
    );
  }
}

// ─── Dropdown Demo Page ───────────────────────────────────────────────────────

class FlutterDropdownDemoPage extends StatefulWidget {
  const FlutterDropdownDemoPage({super.key});

  @override
  State<FlutterDropdownDemoPage> createState() => _FlutterDropdownDemoPageState();
}

class _FlutterDropdownDemoPageState extends State<FlutterDropdownDemoPage> {
  String _result = 'Make a selection';

  String? _dropdownValue;
  String? _formFieldValue;

  static const _fruits = [
    'Apple', 'Banana', 'Cherry', 'Date', 'Elderberry', 'Fig', 'Grape',
  ];
  static const _seasons = ['Spring', 'Summer', 'Autumn', 'Winter'];
  static const _countries = [
    'Australia', 'Brazil', 'Canada', 'France', 'Germany',
    'India', 'Japan', 'Mexico', 'Spain', 'United Kingdom', 'United States',
  ];
  static const _popupOptions = ['Edit', 'Duplicate', 'Share', 'Archive', 'Delete'];

  @override
  void initState() {
    super.initState();
    FlutterUxcam.tagScreenName('FlutterDropdownDemo');
  }

  void _show(String label, String value) =>
      setState(() => _result = '$label  →  $value');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dropdown Demo')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Result card
          Card(
            color: const Color(0xFFEDE7F6),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                _result,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF6750A4), fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 1. DropdownButton
          _sectionLabel('DropdownButton'),
          DropdownButtonFormField<String>(
            initialValue: _dropdownValue,
            decoration: const InputDecoration(
              labelText: 'Fruit',
              border: OutlineInputBorder(),
            ),
            hint: const Text('Select a fruit'),
            items: _fruits
                .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                .toList(),
            onChanged: (v) {
              setState(() => _dropdownValue = v);
              if (v != null) _show('DropdownButton', v);
            },
          ),
          const SizedBox(height: 20),

          // 2. DropdownButtonFormField (seasons)
          _sectionLabel('DropdownButtonFormField'),
          DropdownButtonFormField<String>(
            initialValue: _formFieldValue,
            decoration: const InputDecoration(
              labelText: 'Season',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.wb_sunny_outlined),
            ),
            items: _seasons
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) {
              setState(() => _formFieldValue = v);
              if (v != null) _show('FormField Dropdown', v);
            },
          ),
          const SizedBox(height: 20),

          // 3. DropdownMenu — Material 3 searchable
          _sectionLabel('DropdownMenu (Material 3 — searchable)'),
          DropdownMenu<String>(
            expandedInsets: EdgeInsets.zero,
            hintText: 'Search country…',
            label: const Text('Country'),
            onSelected: (v) {
              if (v != null) _show('DropdownMenu', v);
            },
            dropdownMenuEntries: _countries
                .map((c) => DropdownMenuEntry(value: c, label: c))
                .toList(),
          ),
          const SizedBox(height: 20),

          // 4. PopupMenuButton
          _sectionLabel('PopupMenuButton'),
          Align(
            alignment: Alignment.centerLeft,
            child: PopupMenuButton<String>(
              onSelected: (v) => _show('PopupMenu', v),
              itemBuilder: (_) => _popupOptions
                  .map((o) => PopupMenuItem(value: o, child: Text(o)))
                  .toList(),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Show Options'),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 5. Long-press context menu
          _sectionLabel('Long-Press Context Menu'),
          GestureDetector(
            onLongPress: () => _showContextMenu(context),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: const Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'Long-press this card for context menu',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    final options = ['Copy', 'Cut', 'Paste', 'Select All', 'Translate'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          ...options.map((o) => ListTile(
                title: Text(o),
                onTap: () {
                  Navigator.pop(context);
                  _show('Context Menu', o);
                },
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      );
}

// ─── Native Compose View embedded via PlatformView ───────────────────────────

class FlutterComposeViewPage extends StatelessWidget {
  const FlutterComposeViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Native Compose in Flutter')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PlatformView Bridge',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'The view below is a Jetpack Compose widget '
                      'rendered natively by Android and embedded here '
                      'via Flutter\'s AndroidView / PlatformView API.',
                      style: TextStyle(fontSize: 12, color: Colors.deepPurple.shade400),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Native Compose view fills the remaining space
          const Expanded(
            child: AndroidView(
              viewType: 'native-compose-view',
              layoutDirection: TextDirection.ltr,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Flutter Video Player ─────────────────────────────────────────────────────

class FlutterVideoPlayerPage extends StatefulWidget {
  const FlutterVideoPlayerPage({super.key});

  @override
  State<FlutterVideoPlayerPage> createState() => _FlutterVideoPlayerPageState();
}

class _FlutterVideoPlayerPageState extends State<FlutterVideoPlayerPage> {
  static const _videos = [
    ('Big Blazes',  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4'),
    ('Big Escapes', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4'),
    ('Big Fun',     'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4'),
    ('Joyrides',    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4'),
  ];

  VideoPlayerController? _controller;
  int _currentIndex = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    FlutterUxcam.tagScreenName('FlutterVideoPlayer');
    _loadVideo(0);
  }

  Future<void> _loadVideo(int index) async {
    final old = _controller;
    setState(() { _isInitialized = false; _currentIndex = index; });
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(_videos[index].$2),
    );
    _controller = controller;
    await controller.initialize();
    if (!mounted) { controller.dispose(); return; }
    controller.addListener(() { if (mounted) setState(() {}); });
    setState(() => _isInitialized = true);
    controller.play();
    await old?.dispose();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          _isInitialized ? _videos[_currentIndex].$1 : 'Loading…',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Video area
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_isInitialized)
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                else
                  const CircularProgressIndicator(color: Color(0xFF6750A4)),
              ],
            ),
          ),

          // Progress bar
          if (_isInitialized)
            VideoProgressIndicator(
              _controller!,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Color(0xFF6750A4),
                bufferedColor: Color(0x556750A4),
                backgroundColor: Color(0xFF333333),
              ),
              padding: EdgeInsets.zero,
            ),

          // Time labels
          if (_isInitialized)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Text(
                    _formatDuration(_controller!.value.position),
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    _formatDuration(_controller!.value.duration),
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white, size: 32),
                onPressed: _currentIndex > 0 ? () => _loadVideo(_currentIndex - 1) : null,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(
                  _isInitialized && _controller!.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: const Color(0xFF6750A4),
                  size: 56,
                ),
                onPressed: _isInitialized
                    ? () {
                        _controller!.value.isPlaying
                            ? _controller!.pause()
                            : _controller!.play();
                      }
                    : null,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white, size: 32),
                onPressed: _currentIndex < _videos.length - 1
                    ? () => _loadVideo(_currentIndex + 1)
                    : null,
              ),
            ],
          ),

          // Video chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: List.generate(_videos.length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_videos[i].$1),
                    selected: i == _currentIndex,
                    onSelected: (_) => _loadVideo(i),
                    selectedColor: const Color(0xFF6750A4),
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: i == _currentIndex ? Colors.white : Colors.white70,
                    ),
                    backgroundColor: const Color(0xFF222222),
                    side: BorderSide.none,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── FAB Demo ─────────────────────────────────────────────────────────────────

class FlutterFABDemoPage extends StatefulWidget {
  const FlutterFABDemoPage({super.key});

  @override
  State<FlutterFABDemoPage> createState() => _FlutterFABDemoPageState();
}

class _FlutterFABDemoPageState extends State<FlutterFABDemoPage> {
  final List<String> _log = [];
  bool _extendedFabExpanded = true;
  int _speedDialOpen = 0; // 0 = closed, 1 = open

  void _record(String msg) => setState(() => _log.insert(0, msg));

  @override
  void initState() {
    super.initState();
    FlutterUxcam.tagScreenName('FlutterFABDemo');
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: Text(text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAB Demo')),
      // Speed-dial FAB (main FAB)
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Speed-dial child actions
          if (_speedDialOpen == 1) ...[
            _SpeedDialItem(
              icon: Icons.share,
              label: 'Share',
              color: Colors.orange,
              onTap: () {
                setState(() => _speedDialOpen = 0);
                _record('Speed-dial: Share tapped');
                FlutterUxcam.logEvent('fab_speed_dial_share');
              },
            ),
            const SizedBox(height: 8),
            _SpeedDialItem(
              icon: Icons.edit,
              label: 'Edit',
              color: Colors.teal,
              onTap: () {
                setState(() => _speedDialOpen = 0);
                _record('Speed-dial: Edit tapped');
                FlutterUxcam.logEvent('fab_speed_dial_edit');
              },
            ),
            const SizedBox(height: 8),
            _SpeedDialItem(
              icon: Icons.delete,
              label: 'Delete',
              color: Colors.red,
              onTap: () {
                setState(() => _speedDialOpen = 0);
                _record('Speed-dial: Delete tapped');
                FlutterUxcam.logEvent('fab_speed_dial_delete');
              },
            ),
            const SizedBox(height: 8),
          ],
          FloatingActionButton(
            heroTag: 'speed_dial',
            backgroundColor: Colors.deepPurple,
            onPressed: () {
              setState(() => _speedDialOpen = _speedDialOpen == 0 ? 1 : 0);
              FlutterUxcam.logEvent('fab_speed_dial_toggle');
            },
            child: AnimatedRotation(
              turns: _speedDialOpen == 1 ? 0.125 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Regular FAB ───────────────────────────────────────────────
            _sectionLabel('1. Regular FAB'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'regular',
                      onPressed: () {
                        _record('Regular FAB tapped');
                        FlutterUxcam.logEvent('fab_regular_tap');
                      },
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 6),
                    const Text('Default', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'regular_primary',
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      onPressed: () {
                        _record('Regular FAB (teal) tapped');
                        FlutterUxcam.logEvent('fab_regular_teal_tap');
                      },
                      child: const Icon(Icons.favorite),
                    ),
                    const SizedBox(height: 6),
                    const Text('Custom color', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'regular_outlined',
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Colors.deepPurple, width: 1.5),
                      ),
                      onPressed: () {
                        _record('Regular FAB (outlined) tapped');
                        FlutterUxcam.logEvent('fab_regular_outlined_tap');
                      },
                      child: const Icon(Icons.star),
                    ),
                    const SizedBox(height: 6),
                    const Text('Outlined', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),

            // ── Small FAB ─────────────────────────────────────────────────
            _sectionLabel('2. Small FAB'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'small_1',
                      onPressed: () {
                        _record('Small FAB tapped');
                        FlutterUxcam.logEvent('fab_small_tap');
                      },
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 6),
                    const Text('Small', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'small_2',
                      backgroundColor: Colors.orange,
                      onPressed: () {
                        _record('Small FAB (orange) tapped');
                        FlutterUxcam.logEvent('fab_small_orange_tap');
                      },
                      child: const Icon(Icons.notifications, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    const Text('Small colored', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'small_3',
                      backgroundColor: Colors.red,
                      onPressed: () {
                        _record('Small FAB (delete) tapped');
                        FlutterUxcam.logEvent('fab_small_delete_tap');
                      },
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    const Text('Small delete', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),

            // ── Large FAB ─────────────────────────────────────────────────
            _sectionLabel('3. Large FAB'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FloatingActionButton.large(
                      heroTag: 'large_1',
                      onPressed: () {
                        _record('Large FAB tapped');
                        FlutterUxcam.logEvent('fab_large_tap');
                      },
                      child: const Icon(Icons.upload),
                    ),
                    const SizedBox(height: 6),
                    const Text('Large', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton.large(
                      heroTag: 'large_2',
                      backgroundColor: Colors.indigo,
                      onPressed: () {
                        _record('Large FAB (indigo) tapped');
                        FlutterUxcam.logEvent('fab_large_indigo_tap');
                      },
                      child: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    const Text('Large colored', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),

            // ── Extended FAB ──────────────────────────────────────────────
            _sectionLabel('4. Extended FAB'),
            Center(
              child: FloatingActionButton.extended(
                heroTag: 'extended_1',
                onPressed: () {
                  _record('Extended FAB tapped');
                  FlutterUxcam.logEvent('fab_extended_tap');
                },
                icon: const Icon(Icons.add),
                label: const Text('Create new'),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: FloatingActionButton.extended(
                heroTag: 'extended_2',
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                onPressed: () {
                  _record('Extended FAB (teal) tapped');
                  FlutterUxcam.logEvent('fab_extended_teal_tap');
                },
                icon: const Icon(Icons.send),
                label: const Text('Send message'),
              ),
            ),
            const SizedBox(height: 12),
            // Collapsible extended FAB
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _extendedFabExpanded
                    ? FloatingActionButton.extended(
                        key: const ValueKey('expanded'),
                        heroTag: 'extended_collapse',
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        onPressed: () {
                          setState(() => _extendedFabExpanded = false);
                          _record('Extended FAB collapsed');
                          FlutterUxcam.logEvent('fab_extended_collapse');
                        },
                        icon: const Icon(Icons.compress),
                        label: const Text('Tap to collapse'),
                      )
                    : FloatingActionButton(
                        key: const ValueKey('collapsed'),
                        heroTag: 'extend_expand',
                        backgroundColor: Colors.deepPurple,
                        onPressed: () {
                          setState(() => _extendedFabExpanded = true);
                          _record('Extended FAB expanded');
                          FlutterUxcam.logEvent('fab_extended_expand');
                        },
                        child: const Icon(Icons.expand, color: Colors.white),
                      ),
              ),
            ),

            // ── Speed Dial hint ───────────────────────────────────────────
            _sectionLabel('5. Speed Dial FAB'),
            Card(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.deepPurple.shade400),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'The speed dial FAB is in the bottom-right corner. '
                        'Tap the + button to expand sub-actions (Share, Edit, Delete).',
                        style: TextStyle(fontSize: 13, color: Colors.deepPurple.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Event log ─────────────────────────────────────────────────
            _sectionLabel('Event Log'),
            if (_log.isEmpty)
              const Text('Tap any FAB to see events here.',
                  style: TextStyle(color: Colors.grey, fontSize: 13))
            else
              ...List.generate(
                _log.length > 8 ? 8 : _log.length,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 6, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(_log[i], style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SpeedDialItem extends StatelessWidget {
  const _SpeedDialItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 8),
        FloatingActionButton.small(
          heroTag: 'speed_$label',
          backgroundColor: color,
          onPressed: onTap,
          child: Icon(icon, color: Colors.white),
        ),
      ],
    );
  }
}

// ─── Carousel / Slider ────────────────────────────────────────────────────────

class FlutterCarouselPage extends StatefulWidget {
  const FlutterCarouselPage({super.key});

  @override
  State<FlutterCarouselPage> createState() => _FlutterCarouselPageState();
}

class _FlutterCarouselPageState extends State<FlutterCarouselPage> {
  // Banner auto-scroll
  final _bannerController = PageController();
  int _bannerPage = 0;
  Timer? _bannerTimer;

  // Featured products
  final _productController = PageController(viewportFraction: 0.82);
  int _productPage = 0;

  // Stories
  final List<int> _viewedStories = [];

  static const _banners = [
    _BannerItem('Summer Sale', '50% off on all electronics', Color(0xFF6A1B9A), Icons.flash_on),
    _BannerItem('New Arrivals', 'Check out the latest collection', Color(0xFF00838F), Icons.new_releases),
    _BannerItem('Free Shipping', 'On orders above \$50', Color(0xFFAD1457), Icons.local_shipping),
    _BannerItem('Refer & Earn', 'Get \$10 for every referral', Color(0xFF2E7D32), Icons.card_giftcard),
  ];

  static const _products = [
    _ProductItem('Wireless Headphones', '\$129', 4.8, Color(0xFF1A237E), Icons.headphones, 'Electronics'),
    _ProductItem('Running Shoes', '\$89', 4.5, Color(0xFF880E4F), Icons.directions_run, 'Sports'),
    _ProductItem('Smart Watch', '\$249', 4.9, Color(0xFF004D40), Icons.watch, 'Electronics'),
    _ProductItem('Backpack', '\$59', 4.3, Color(0xFF4A148C), Icons.backpack, 'Accessories'),
    _ProductItem('Sunglasses', '\$45', 4.6, Color(0xFFBF360C), Icons.wb_sunny, 'Fashion'),
  ];

  static const _stories = [
    _StoryItem('You', Icons.add, Color(0xFF9E9E9E), isAdd: true),
    _StoryItem('Alice', Icons.person, Color(0xFF6A1B9A)),
    _StoryItem('Bob', Icons.person, Color(0xFF00838F)),
    _StoryItem('Carol', Icons.person, Color(0xFFAD1457)),
    _StoryItem('Dave', Icons.person, Color(0xFF2E7D32)),
    _StoryItem('Eve', Icons.person, Color(0xFFE65100)),
    _StoryItem('Frank', Icons.person, Color(0xFF0277BD)),
    _StoryItem('Grace', Icons.person, Color(0xFF558B2F)),
  ];

  @override
  void initState() {
    super.initState();
    FlutterUxcam.tagScreenName('FlutterCarouselDemo');
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final next = (_bannerPage + 1) % _banners.length;
      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _productController.dispose();
    super.dispose();
  }

  Widget _sectionHeader(String title, String subtitle) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle,
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('See all')),
          ],
        ),
      );

  Widget _dotIndicator(int count, int current) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count,
          (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == current ? 20 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: i == current
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      );

  // ── Section 1: Banners ─────────────────────────────────────────────────────
  Widget _buildBanners() => Column(
        children: [
          _sectionHeader('Banners', 'Auto-scrolling promotional banners'),
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: _bannerController,
              itemCount: _banners.length,
              onPageChanged: (i) {
                setState(() => _bannerPage = i);
                FlutterUxcam.logEventWithProperties('carousel_banner_swipe', {'index': i});
              },
              itemBuilder: (_, i) {
                final b = _banners[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [b.color, b.color.withValues(alpha: 0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('PROMO',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2)),
                              ),
                              const SizedBox(height: 8),
                              Text(b.title,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(b.subtitle,
                                  style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      fontSize: 13)),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: b.color,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                onPressed: () =>
                                    FlutterUxcam.logEventWithProperties('carousel_banner_cta', {'index': i}),
                                child: const Text('Shop Now',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        Icon(b.icon, color: Colors.white.withValues(alpha: 0.4), size: 72),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          _dotIndicator(_banners.length, _bannerPage),
        ],
      );

  // ── Section 2: Stories ─────────────────────────────────────────────────────
  Widget _buildStories() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Stories', 'Tap to view'),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _stories.length,
              itemBuilder: (_, i) {
                final s = _stories[i];
                final viewed = _viewedStories.contains(i);
                return GestureDetector(
                  onTap: () {
                    if (!s.isAdd) {
                      setState(() => _viewedStories.add(i));
                      FlutterUxcam.logEventWithProperties('carousel_story_tap', {'user': s.name});
                    } else {
                      FlutterUxcam.logEvent('carousel_story_add');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: s.isAdd || viewed
                                ? null
                                : const LinearGradient(
                                    colors: [Color(0xFFE040FB), Color(0xFFFF6D00)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            color: s.isAdd || viewed ? Colors.grey.shade200 : null,
                          ),
                          padding: const EdgeInsets.all(2.5),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(2.5),
                            child: CircleAvatar(
                              backgroundColor: s.isAdd ? Colors.grey.shade300 : s.color,
                              child: Icon(
                                s.isAdd ? Icons.add : s.icon,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(s.name,
                            style: TextStyle(
                                fontSize: 11,
                                color: viewed ? Colors.grey : Colors.black87,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );

  // ── Section 3: Featured Products ──────────────────────────────────────────
  Widget _buildProducts() => Column(
        children: [
          _sectionHeader('Featured Products', 'Swipe to explore'),
          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: _productController,
              itemCount: _products.length,
              onPageChanged: (i) {
                setState(() => _productPage = i);
                FlutterUxcam.logEventWithProperties('carousel_product_swipe', {'index': i});
              },
              itemBuilder: (_, i) {
                final p = _products[i];
                final selected = i == _productPage;
                return AnimatedScale(
                  scale: selected ? 1.0 : 0.93,
                  duration: const Duration(milliseconds: 250),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Card(
                      elevation: selected ? 8 : 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: p.color,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Icon(p.icon,
                                        size: 72,
                                        color: Colors.white.withValues(alpha: 0.9)),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(p.category,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Icon(Icons.star,
                                              size: 13, color: Colors.amber),
                                          const SizedBox(width: 3),
                                          Text('${p.rating}',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(p.price,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: p.color)),
                                    GestureDetector(
                                      onTap: () => FlutterUxcam.logEventWithProperties(
                                          'carousel_product_add_cart',
                                          {'product': p.name}),
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: p.color,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text('Add',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _dotIndicator(_products.length, _productPage),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carousel / Slider')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanners(),
            _buildStories(),
            _buildProducts(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Data classes for carousel ─────────────────────────────────────────────────

class _BannerItem {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  const _BannerItem(this.title, this.subtitle, this.color, this.icon);
}

class _ProductItem {
  final String name;
  final String price;
  final double rating;
  final Color color;
  final IconData icon;
  final String category;
  const _ProductItem(this.name, this.price, this.rating, this.color, this.icon, this.category);
}

class _StoryItem {
  final String name;
  final IconData icon;
  final Color color;
  final bool isAdd;
  const _StoryItem(this.name, this.icon, this.color, {this.isAdd = false});
}

// ─── Map Demo ─────────────────────────────────────────────────────────────────

class _TravelCity {
  final String name;
  final double lat;
  final double lng;
  final String desc;
  final Color color;
  const _TravelCity(this.name, this.lat, this.lng, this.desc, this.color);
}

class FlutterMapDemoPage extends StatefulWidget {
  const FlutterMapDemoPage({super.key});

  @override
  State<FlutterMapDemoPage> createState() => _FlutterMapDemoPageState();
}

class _FlutterMapDemoPageState extends State<FlutterMapDemoPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // ── Delivery ──
  final _deliveryMapCtrl = MapController();
  Timer? _deliveryTimer;
  int _deliveryStep = 0;
  bool _deliveryRunning = false;

  static const _deliveryRoute = [
    LatLng(12.9716, 77.5946),
    LatLng(12.9700, 77.6010),
    LatLng(12.9660, 77.6055),
    LatLng(12.9620, 77.6090),
    LatLng(12.9550, 77.6130),
    LatLng(12.9450, 77.6165),
    LatLng(12.9341, 77.6200),
  ];

  // ── Taxi ──
  final _taxiMapCtrl = MapController();
  Timer? _taxiTimer;
  int _taxiStep = 0;
  bool _taxiRunning = false;

  static const _taxiRoute = [
    LatLng(19.0760, 72.8777),
    LatLng(19.0800, 72.8830),
    LatLng(19.0870, 72.8900),
    LatLng(19.0950, 72.8970),
    LatLng(19.1060, 72.9020),
    LatLng(19.1175, 72.9060),
  ];

  // ── Travel ──
  final _travelMapCtrl = MapController();
  int? _selectedCity;

  static const _travelCities = [
    _TravelCity('London',    51.5074, -0.1278, 'Big Ben · Tower Bridge · Hyde Park',         Color(0xFF1565C0)),
    _TravelCity('Paris',     48.8566,  2.3522, 'Eiffel Tower · Louvre · Notre-Dame',          Color(0xFFC62828)),
    _TravelCity('Brussels',  50.8503,  4.3517, 'Grand Place · Atomium · Bruges nearby',       Color(0xFF6A1B9A)),
    _TravelCity('Amsterdam', 52.3676,  4.9041, 'Rijksmuseum · Anne Frank · Canal Ring',       Color(0xFF00695C)),
    _TravelCity('Berlin',    52.5200, 13.4050, 'Brandenburg Gate · Pergamon · Tiergarten',    Color(0xFFE65100)),
  ];

  @override
  void initState() {
    super.initState();
    FlutterUxcam.tagScreenName('FlutterMapDemo');
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _deliveryTimer?.cancel();
    _taxiTimer?.cancel();
    super.dispose();
  }

  // ── Simulation helpers ────────────────────────────────────────────────────

  void _startDelivery() {
    _deliveryTimer?.cancel();
    setState(() { _deliveryRunning = true; _deliveryStep = 0; });
    FlutterUxcam.logEvent('map_delivery_start');
    _deliveryTimer = Timer.periodic(const Duration(milliseconds: 1500), (t) {
      if (!mounted) { t.cancel(); return; }
      final next = _deliveryStep + 1;
      if (next >= _deliveryRoute.length) {
        t.cancel();
        setState(() => _deliveryRunning = false);
        FlutterUxcam.logEvent('map_delivery_complete');
        return;
      }
      setState(() => _deliveryStep = next);
      _deliveryMapCtrl.move(_deliveryRoute[next], 13.5);
    });
  }

  void _startTaxi() {
    _taxiTimer?.cancel();
    setState(() { _taxiRunning = true; _taxiStep = 0; });
    FlutterUxcam.logEvent('map_taxi_start');
    _taxiTimer = Timer.periodic(const Duration(milliseconds: 1500), (t) {
      if (!mounted) { t.cancel(); return; }
      final next = _taxiStep + 1;
      if (next >= _taxiRoute.length) {
        t.cancel();
        setState(() => _taxiRunning = false);
        FlutterUxcam.logEvent('map_taxi_complete');
        return;
      }
      setState(() => _taxiStep = next);
      _taxiMapCtrl.move(_taxiRoute[next], 13.0);
    });
  }

  // ── Shared widget helpers ─────────────────────────────────────────────────

  Widget _mapBase({
    required MapController controller,
    required LatLng center,
    required double zoom,
    required List<Polyline> polylines,
    required List<Marker> markers,
  }) =>
      FlutterMap(
        mapController: controller,
        options: MapOptions(initialCenter: center, initialZoom: zoom),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.embeddedflutter',
          ),
          if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
          MarkerLayer(markers: markers),
        ],
      );

  Widget _pin(Color bg, IconData icon, {bool large = false}) => Container(
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
        ),
        child: Icon(icon, color: Colors.white, size: large ? 22 : 20),
      );

  Widget _badgePin(Color bg, String label, {bool selected = false}) => Container(
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: selected ? 3 : 2),
          boxShadow: [
            BoxShadow(color: bg.withValues(alpha: 0.5), blurRadius: selected ? 14 : 4, spreadRadius: selected ? 2 : 0),
          ],
        ),
        child: Center(
          child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        ),
      );

  Widget _bottomSheet(Widget child) => Positioned(
        bottom: 0, left: 0, right: 0,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          child: child,
        ),
      );

  Widget _dragHandle() => Center(
        child: Container(
          width: 40, height: 4,
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
        ),
      );

  Widget _iconCircle(IconData icon, Color bg, Color fg) => Container(
        width: 48, height: 48,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, color: fg, size: 26),
      );

  TextStyle get _sub => TextStyle(color: Colors.grey.shade600, fontSize: 12);

  Widget _actionButton(String label, IconData icon, Color color, VoidCallback fn) =>
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: color, foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          onPressed: fn,
          icon: Icon(icon, size: 20),
          label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      );

  Widget _progressRow(int current, int total, Color color,
      {required IconData startIcon, required Color startColor,
       required IconData endIcon, required Color endColor,
       required String startLabel, required String endLabel}) =>
      Column(children: [
        Row(children: [
          Expanded(
            child: LinearProgressIndicator(
              value: total > 0 ? current / total : 0,
              backgroundColor: Colors.grey.shade200,
              color: color,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ]),
        const SizedBox(height: 5),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [Icon(startIcon, size: 13, color: startColor), const SizedBox(width: 3),
            Text(startLabel, style: _sub)]),
          Row(children: [Text(endLabel, style: _sub), const SizedBox(width: 3),
            Icon(endIcon, size: 13, color: endColor)]),
        ]),
      ]);

  // ── Delivery Tab ──────────────────────────────────────────────────────────

  Widget _buildDeliveryTab() {
    final step = _deliveryStep.clamp(0, _deliveryRoute.length - 1);
    final driverPos = _deliveryRoute[step];
    final done = !_deliveryRunning && _deliveryStep >= _deliveryRoute.length - 1 && _deliveryStep > 0;
    final eta = done ? 'Done!' : '${(_deliveryRoute.length - 1 - step) * 2} min';

    return Stack(children: [
      _mapBase(
        controller: _deliveryMapCtrl,
        center: _deliveryRoute[3],
        zoom: 13.0,
        polylines: [
          if (step > 0)
            Polyline(
              points: _deliveryRoute.sublist(0, step + 1).toList(),
              color: Colors.green.shade400.withValues(alpha: 0.55),
              strokeWidth: 5,
            ),
          Polyline(
            points: _deliveryRoute.sublist(step).toList(),
            color: Colors.deepOrange,
            strokeWidth: 5,
          ),
        ],
        markers: [
          Marker(point: _deliveryRoute.first, width: 42, height: 42,
              child: _pin(Colors.red.shade600, Icons.restaurant)),
          Marker(point: _deliveryRoute.last, width: 42, height: 42,
              child: _pin(Colors.green.shade700, Icons.home)),
          Marker(point: driverPos, width: 48, height: 48,
              child: _pin(done ? Colors.green : Colors.deepOrange,
                  done ? Icons.check : Icons.delivery_dining, large: true)),
        ],
      ),
      _bottomSheet(Column(mainAxisSize: MainAxisSize.min, children: [
        _dragHandle(),
        Row(children: [
          _iconCircle(Icons.delivery_dining, Colors.deepOrange.shade50, Colors.deepOrange),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(done ? '✓ Order Delivered!' : 'Order is on the way',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text('Driver: Raju  ·  Bengaluru', style: _sub),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(eta, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,
                color: done ? Colors.green : Colors.deepOrange)),
            Text('ETA', style: _sub),
          ]),
        ]),
        const SizedBox(height: 14),
        if (_deliveryStep == 0 && !_deliveryRunning)
          _actionButton('Start Delivery Simulation', Icons.play_arrow, Colors.deepOrange, _startDelivery)
        else if (done)
          _actionButton('Replay', Icons.replay, Colors.grey.shade700,
              () => setState(() { _deliveryStep = 0; _deliveryRunning = false; }))
        else
          _progressRow(step, _deliveryRoute.length - 1, Colors.deepOrange,
              startIcon: Icons.restaurant, startColor: Colors.red, startLabel: 'Restaurant',
              endIcon: Icons.home, endColor: Colors.green, endLabel: 'Customer'),
      ])),
    ]);
  }

  // ── Taxi Tab ──────────────────────────────────────────────────────────────

  Widget _buildTaxiTab() {
    final step = _taxiStep.clamp(0, _taxiRoute.length - 1);
    final carPos = _taxiRoute[step];
    final done = !_taxiRunning && _taxiStep >= _taxiRoute.length - 1 && _taxiStep > 0;
    final fare = '\$${(2.5 + step * 1.8).toStringAsFixed(2)}';

    return Stack(children: [
      _mapBase(
        controller: _taxiMapCtrl,
        center: _taxiRoute[2],
        zoom: 12.5,
        polylines: [
          if (step > 0)
            Polyline(
              points: _taxiRoute.sublist(0, step + 1).toList(),
              color: Colors.amber.withValues(alpha: 0.45),
              strokeWidth: 5,
            ),
          Polyline(
            points: _taxiRoute.sublist(step).toList(),
            color: Colors.blueAccent,
            strokeWidth: 5,
          ),
        ],
        markers: [
          Marker(point: _taxiRoute.first, width: 42, height: 42,
              child: _pin(Colors.blue, Icons.person_pin_circle)),
          Marker(point: _taxiRoute.last, width: 42, height: 42,
              child: _pin(Colors.red.shade700, Icons.flag)),
          Marker(point: carPos, width: 48, height: 48,
              child: _pin(done ? Colors.green : Colors.amber.shade700,
                  done ? Icons.check : Icons.local_taxi, large: true)),
        ],
      ),
      _bottomSheet(Column(mainAxisSize: MainAxisSize.min, children: [
        _dragHandle(),
        Row(children: [
          _iconCircle(Icons.local_taxi, Colors.amber.shade50, Colors.amber.shade700),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(done ? '✓ Arrived at destination!' : 'Your cab is on the way',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text('Suresh  ·  ⭐ 4.8  ·  MH 04 AB 1234', style: _sub),
          ])),
          Text(fare, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.amber)),
        ]),
        const SizedBox(height: 14),
        if (_taxiStep == 0 && !_taxiRunning)
          _actionButton('Start Ride Simulation', Icons.directions_car, Colors.amber.shade700, _startTaxi)
        else if (done)
          _actionButton('New Ride', Icons.replay, Colors.grey.shade700,
              () => setState(() { _taxiStep = 0; _taxiRunning = false; }))
        else
          _progressRow(step, _taxiRoute.length - 1, Colors.amber,
              startIcon: Icons.person_pin_circle, startColor: Colors.blue, startLabel: 'Pickup',
              endIcon: Icons.flag, endColor: Colors.red, endLabel: 'Dropoff'),
      ])),
    ]);
  }

  // ── Travel Tab ────────────────────────────────────────────────────────────

  Widget _buildTravelTab() {
    final sel = _selectedCity;
    final cityPoints = _travelCities.map((c) => LatLng(c.lat, c.lng)).toList();

    return Stack(children: [
      _mapBase(
        controller: _travelMapCtrl,
        center: const LatLng(51.0, 5.5),
        zoom: 5.0,
        polylines: [
          Polyline(
            points: cityPoints,
            color: Colors.deepPurple.withValues(alpha: 0.55),
            strokeWidth: 3,
          ),
        ],
        markers: List.generate(_travelCities.length, (i) {
          final c = _travelCities[i];
          final isSelected = sel == i;
          return Marker(
            point: LatLng(c.lat, c.lng),
            width: isSelected ? 52 : 42,
            height: isSelected ? 52 : 42,
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedCity = sel == i ? null : i);
                if (sel != i) _travelMapCtrl.move(LatLng(c.lat, c.lng), 7.0);
                FlutterUxcam.logEventWithProperties('map_travel_city_tap', {'city': c.name});
              },
              child: _badgePin(c.color, '${i + 1}', selected: isSelected),
            ),
          );
        }),
      ),

      // Bottom sheet: selected city detail or default hint
      _bottomSheet(sel != null
          ? Column(mainAxisSize: MainAxisSize.min, children: [
              _dragHandle(),
              Row(children: [
                _badgePin(_travelCities[sel].color, '${sel + 1}', selected: true),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_travelCities[sel].name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  Text(_travelCities[sel].desc, style: _sub),
                ])),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => setState(() => _selectedCity = null),
                ),
              ]),
              const SizedBox(height: 12),
              _cityPillRow(sel),
            ])
          : Column(mainAxisSize: MainAxisSize.min, children: [
              _dragHandle(),
              const Text('European Tour', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              const SizedBox(height: 4),
              Text('5 cities · 4 countries · Tap a pin to explore', style: _sub),
              const SizedBox(height: 12),
              _cityPillRow(null),
            ])),
    ]);
  }

  Widget _cityPillRow(int? selected) => Row(
        children: List.generate(_travelCities.length, (i) {
          final c = _travelCities[i];
          final active = i == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedCity = i);
                _travelMapCtrl.move(LatLng(c.lat, c.lng), 7.0);
                FlutterUxcam.logEventWithProperties('map_travel_city_tap', {'city': c.name});
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: active ? c.color : c.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: c.color.withValues(alpha: active ? 0 : 0.3)),
                ),
                child: Column(children: [
                  Text('${i + 1}', style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14,
                      color: active ? Colors.white : c.color)),
                  const SizedBox(height: 2),
                  Text(c.name.substring(0, 3), style: TextStyle(
                      fontSize: 10, color: active ? Colors.white70 : c.color)),
                ]),
              ),
            ),
          );
        }),
      );

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Demo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.delivery_dining), text: 'Delivery'),
            Tab(icon: Icon(Icons.local_taxi), text: 'Taxi'),
            Tab(icon: Icon(Icons.travel_explore), text: 'Travel'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDeliveryTab(),
          _buildTaxiTab(),
          _buildTravelTab(),
        ],
      ),
    );
  }
}
