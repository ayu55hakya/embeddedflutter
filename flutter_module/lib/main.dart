import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- UXCam Initialization (Flutter side) ---
  FlutterUxConfig config = FlutterUxConfig(
    userAppKey: "n5ctt823s8qihkk-us",
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
