
// Adit Astro - Flutter (Material 3)
// Notes:
// - This is a demo app with simplified astrology logic.
// - Real Kundli calculations require ephemeris/astro SDKs. Integrate a service later.
// - Hindi is the default language; English included. You can extend languages in `Strings`.
//
// How to run:
// 1) flutter create adit_astro
// 2) Replace lib/main.dart + pubspec.yaml with these files
// 3) flutter pub get
// 4) flutter run  (or) flutter build apk

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final langCode = prefs.getString('lang') ?? 'hi';
  runApp(MyApp(initialLang: langCode));
}

class MyApp extends StatelessWidget {
  final String initialLang;
  const MyApp({super.key, required this.initialLang});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(initialLang),
      child: Consumer<AppState>(
        builder: (_, state, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Adit Astro',
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.deepPurple,
              textTheme: GoogleFonts.interTextTheme(),
            ),
            home: const HomePage(),
            locale: Locale(state.langCode),
          );
        },
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  String langCode = 'hi';
  AppState(this.langCode);
  Future<void> setLang(String code) async {
    langCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', code);
    notifyListeners();
  }
}

class Strings {
  // Hindi-first, English fallback
  static Map<String, Map<String, String>> _map = {
    'hi': {
      'app_title': 'Adit Astro',
      'new_kundli': 'कुंडली बनाएं',
      'kundli_milan': 'कुंडली मिलान',
      'feedback': 'फीडबैक',
      'settings': 'सेटिंग्स',
      'name': 'नाम',
      'male_name': 'पुरुष का नाम',
      'female_name': 'महिला का नाम',
      'dob': 'जन्म तिथि',
      'time': 'जन्म समय',
      'place': 'जन्म स्थान',
      'generate': 'जेनरेट करें',
      'result': 'परिणाम',
      'compatibility_score': 'अनुकूलता स्कोर',
      'submit': 'सबमिट करें',
      'issue_hint': 'एप से जुड़ी किसी भी समस्या का विवरण लिखें...',
      'thank_you': 'धन्यवाद! आपका फीडबैक दर्ज हो गया है।',
      'language': 'भाषा',
      'hindi': 'हिंदी',
      'english': 'English',
      'upay_title': 'उपाय व विधि (डेमो)',
      'disclaimer': 'अस्वीकरण: यह एक डेमो ऐप है। वास्तविक वैदिक गणना के लिए ज्योतिषीय डेटा/एपीआई जोड़ें।',
      'basic_chart': 'मूल चार्ट (डेमो)',
    },
    'en': {
      'app_title': 'Adit Astro',
      'new_kundli': 'Create Kundli',
      'kundli_milan': 'Kundali Milan',
      'feedback': 'Feedback',
      'settings': 'Settings',
      'name': 'Name',
      'male_name': 'Male Name',
      'female_name': 'Female Name',
      'dob': 'Date of Birth',
      'time': 'Time of Birth',
      'place': 'Birth Place',
      'generate': 'Generate',
      'result': 'Result',
      'compatibility_score': 'Compatibility Score',
      'submit': 'Submit',
      'issue_hint': 'Describe any app issue you are facing...',
      'thank_you': 'Thank you! Your feedback has been recorded.',
      'language': 'Language',
      'hindi': 'Hindi',
      'english': 'English',
      'upay_title': 'Upay & Vidhi (Demo)',
      'disclaimer': 'Disclaimer: This is a demo. For real Vedic calculations add an astrology SDK/API.',
      'basic_chart': 'Basic Chart (Demo)',
    }
  };

  static String t(BuildContext context, String key) {
    final lang = Provider.of<AppState>(context, listen: false).langCode;
    return _map[lang]?[key] ?? _map['en']![key] ?? key;
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.t(context, 'app_title')),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HomeCard(
              icon: Icons.auto_awesome,
              title: Strings.t(context, 'new_kundli'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const KundliFormPage()),
              ),
            ),
            _HomeCard(
              icon: Icons.favorite_border,
              title: Strings.t(context, 'kundli_milan'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MilanPage()),
              ),
            ),
            _HomeCard(
              icon: Icons.feedback_outlined,
              title: Strings.t(context, 'feedback'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FeedbackPage()),
              ),
            ),
            _HomeCard(
              icon: Icons.settings,
              title: Strings.t(context, 'settings'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              ),
            ),
            const Spacer(),
            Text(
              Strings.t(context, 'disclaimer'),
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _HomeCard({required this.icon, required this.title, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 16),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class KundliFormPage extends StatefulWidget {
  const KundliFormPage({super.key});
  @override
  State<KundliFormPage> createState() => _KundliFormPageState();
}

class _KundliFormPageState extends State<KundliFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _place = TextEditingController();
  DateTime? _dob;
  TimeOfDay? _tob;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.t(context, 'new_kundli'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: Strings.t(context, 'name')),
                validator: (v) => (v==null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _place,
                decoration: InputDecoration(labelText: Strings.t(context, 'place')),
                validator: (v) => (v==null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(Strings.t(context, 'dob')),
                subtitle: Text(_dob == null
                    ? '--'
                    : DateFormat('dd MMM yyyy').format(_dob!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(now.year, now.month, now.day),
                    initialDate: DateTime(now.year - 25),
                  );
                  if (picked != null) setState(() => _dob = picked);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(Strings.t(context, 'time')),
                subtitle: Text(_tob == null ? '--' : _tob!.format(context)),
                trailing: const Icon(Icons.schedule),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 12, minute: 0),
                  );
                  if (picked != null) setState(() => _tob = picked);
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _dob != null && _tob != null) {
                    final basic = BasicKundli.fromInputs(
                      name: _name.text.trim(),
                      dob: _dob!,
                      tob: _tob!,
                      place: _place.text.trim(),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => KundliResultPage(k: basic)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please complete all fields')),
                    );
                  }
                },
                child: Text(Strings.t(context, 'generate')),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BasicKundli {
  final String name;
  final DateTime dob;
  final TimeOfDay tob;
  final String place;
  final String sunSign; // Approx by date only (Western style – demo)
  final List<String> upay; // Demo remedies

  BasicKundli({
    required this.name,
    required this.dob,
    required this.tob,
    required this.place,
    required this.sunSign,
    required this.upay,
  });

  static String _sunSignFor(DateTime dob) {
    // Western zodiac by date ranges (demo only)
    final m = dob.month;
    final d = dob.day;
    if ((m==3 && d>=21) || (m==4 && d<=19)) return 'Mesh (Aries)';
    if ((m==4 && d>=20) || (m==5 && d<=20)) return 'Vrishabh (Taurus)';
    if ((m==5 && d>=21) || (m==6 && d<=20)) return 'Mithun (Gemini)';
    if ((m==6 && d>=21) || (m==7 && d<=22)) return 'Kark (Cancer)';
    if ((m==7 && d>=23) || (m==8 && d<=22)) return 'Singh (Leo)';
    if ((m==8 && d>=23) || (m==9 && d<=22)) return 'Kanya (Virgo)';
    if ((m==9 && d>=23) || (m==10 && d<=22)) return 'Tula (Libra)';
    if ((m==10 && d>=23) || (m==11 && d<=21)) return 'Vrishchik (Scorpio)';
    if ((m==11 && d>=22) || (m==12 && d<=21)) return 'Dhanu (Sagittarius)';
    if ((m==12 && d>=22) || (m==1 && d<=19)) return 'Makar (Capricorn)';
    if ((m==1 && d>=20) || (m==2 && d<=18)) return 'Kumbh (Aquarius)';
    return 'Meen (Pisces)';
  }

  static List<String> _upayFor(String sunSign) {
    // Demo upay with simple vidhi
    final m = {
      'Mesh (Aries)': [
        'मंगलवार को हनुमान चालीसा का पाठ करें।',
        'मसूर दाल का दान करें।'
      ],
      'Vrishabh (Taurus)': [
        'शुक्रवार को माता लक्ष्मी की आराधना करें।',
        'सफेद वस्त्र/चावल का दान करें।'
      ],
      'Mithun (Gemini)': [
        'बुधवार को गणेश जी को दूर्वा अर्पित करें।',
        'हरि ओम् नमः का जप करें।'
      ],
      'Kark (Cancer)': [
        'सोमवार को शिवजी को जल चढ़ाएं।',
        'दूध का दान करें।'
      ],
      'Singh (Leo)': [
        'रविवार को सूर्य अर्घ्य दें।',
        'गुड़ और गेहूं का दान करें।'
      ],
      'Kanya (Virgo)': [
        'बुधवार को गाय को हरा चारा खिलाएं।',
        'विद्या दान/किताबें दें।'
      ],
      'Tula (Libra)': [
        'शुक्रवार को कन्याओं को खीर खिलाएं।',
        'सफेद चंदन लगाएं।'
      ],
      'Vrishchik (Scorpio)': [
        'मंगलवार को भैरव आराधना करें।',
        'तिल तेल का दान करें।'
      ],
      'Dhanu (Sagittarius)': [
        'गुरुवार को विष्णु सहस्त्रनाम पठें।',
        'पीली दाल/हल्दी का दान करें।'
      ],
      'Makar (Capricorn)': [
        'शनिवार को शनि आराधना/दीपदान करें।',
        'काला तिल दान करें।'
      ],
      'Kumbh (Aquarius)': [
        'शनिवार को जरूरतमंदों को वस्त्र दें।',
        'पिप्पल के वृक्ष में जल दें।'
      ],
      'Meen (Pisces)': [
        'गुरुवार को केसर/पीले फूल अर्पित करें।',
        'गायत्री मंत्र का जप करें।'
      ],
    };
    return m[sunSign] ?? ['सामान्य दान-पुण्य करें।', 'प्रतिदिन प्रार्थना/ध्यान करें।'];
  }

  factory BasicKundli.fromInputs({required String name, required DateTime dob, required TimeOfDay tob, required String place}) {
    final sign = _sunSignFor(dob);
    final upay = _upayFor(sign);
    return BasicKundli(name: name, dob: dob, tob: tob, place: place, sunSign: sign, upay: upay);
    }
}

class KundliResultPage extends StatelessWidget {
  final BasicKundli k;
  const KundliResultPage({super.key, required this.k});

  @override
  Widget build(BuildContext context) {
    final dt = DateFormat('dd MMM yyyy').format(k.dob);
    final t = k.tob.format(context);
    return Scaffold(
      appBar: AppBar(title: Text(Strings.t(context, 'result'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${k.name} • ${k.place}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('$dt • $t'),
                    const SizedBox(height: 8),
                    Chip(label: Text('Rashi (approx): ${k.sunSign}')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(Strings.t(context, 'basic_chart'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _DemoChart(),
            const SizedBox(height: 16),
            Text(Strings.t(context, 'upay_title'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            ...k.upay.map((u) => ListTile(leading: const Icon(Icons.star_border), title: Text(u))).toList(),
          ],
        ),
      ),
    );
  }
}

class _DemoChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Just a 3x3 grid to represent a North Indian chart placeholder.
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(12),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: 9,
          itemBuilder: (_, i) => Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
            ),
            child: Center(child: Text('H${i+1}')),
          ),
          shrinkWrap: true,
        ),
      ),
    );
  }
}

class MilanPage extends StatefulWidget {
  const MilanPage({super.key});
  @override
  State<MilanPage> createState() => _MilanPageState();
}

class _MilanPageState extends State<MilanPage> {
  final _formKey = GlobalKey<FormState>();
  final _male = TextEditingController();
  final _female = TextEditingController();
  int? _score;

  int _compatFromNames(String a, String b) {
    // Simple numerology-esque demo: sum of char codes modulo 36 -> scale to 36 "gunas"
    int sumA = a.toLowerCase().runes.fold(0, (p, c) => p + (c % 96));
    int sumB = b.toLowerCase().runes.fold(0, (p, c) => p + (c % 96));
    int raw = ((sumA - sumB).abs() % 36);
    return 36 - raw; // higher is better
  }

  String _verdict(int s) {
    if (s >= 30) return 'उत्तम / Excellent';
    if (s >= 24) return 'अच्छा / Good';
    if (s >= 18) return 'औसत / Average';
    return 'कमजोर / Weak';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.t(context, 'kundli_milan'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _male,
                decoration: InputDecoration(labelText: Strings.t(context, 'male_name')),
                validator: (v) => (v==null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _female,
                decoration: InputDecoration(labelText: Strings.t(context, 'female_name')),
                validator: (v) => (v==null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final s = _compatFromNames(_male.text.trim(), _female.text.trim());
                    setState(() => _score = s);
                  }
                },
                child: Text(Strings.t(context, 'generate')),
              ),
              const SizedBox(height: 16),
              if (_score != null)
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('${Strings.t(context, 'compatibility_score')}: $_score / 36',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(_verdict(_score!)),
                        const SizedBox(height: 8),
                        const Text('नोट: यह नाम-आधारित डेमो स्कोर है; वास्तविक गुण मिलान हेतु जन्म विवरण/नक्षत्र आवश्यक हैं।'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});
  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _issue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.t(context, 'feedback'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: Strings.t(context, 'name')),
                validator: (v) => (v==null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _issue,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: Strings.t(context, 'feedback'),
                  hintText: Strings.t(context, 'issue_hint'),
                ),
                validator: (v) => (v==null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final prefs = await SharedPreferences.getInstance();
                    final history = prefs.getStringList('feedbacks') ?? [];
                    history.add('${DateTime.now().toIso8601String()}|${_name.text.trim()}|${_issue.text.trim()}');
                    await prefs.setStringList('feedbacks', history);
                    _issue.clear();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Strings.t(context, 'thank_you'))));
                  }
                },
                child: Text(Strings.t(context, 'submit')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(title: Text(Strings.t(context, 'settings'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(Strings.t(context, 'language'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'hi', label: Text(Strings.t(context, 'hindi'))),
              ButtonSegment(value: 'en', label: Text(Strings.t(context, 'english'))),
            ],
            selected: {state.langCode},
            onSelectionChanged: (s) => state.setLang(s.first),
          ),
        ],
      ),
    );
  }
}
