import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Web-only entrypoint: flutter build web -t lib/landing.dart
@JS('window.open')
external void _open(String url, String target);

// ponytail: APK copied into build/web before deploy; move to GitHub Releases if it exceeds Vercel file limits.
const _apkUrl = '/streamed.apk';
const _versionInfo = 'v1.2.0 · 47.6 MB';

const _accent = Color(0xFFCC2A26);
const _accentText = Color(0xFFFF6B61);
const _bg = Color(0xFF0A0A0A);
const _bgAlt = Color(0xFF0F0F0F);
const _card = Color(0xFF161616);
const _cardBorder = Color(0xFF262626);
const _line = Color(0xFF1F1F1F);
const _muted = Color(0xFFA8A8A8);

void _download() => _open(_apkUrl, '_self');

TextStyle _display(double size, {FontWeight w = FontWeight.w800, Color? c}) =>
    GoogleFonts.archivo(
      fontSize: size,
      fontWeight: w,
      height: 1.05,
      letterSpacing: -0.03 * size,
      color: c ?? Colors.white,
    );

const _body = TextStyle(
  fontFamily: 'Inter',
  fontSize: 16,
  height: 1.6,
  color: _muted,
);
const _h3 = TextStyle(
  fontFamily: 'Inter',
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

void main() => runApp(
  MaterialApp(
    title: 'Streamed — Nonton olahraga live',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: _bg,
      textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Inter'),
    ),
    home: const LandingPage(),
  ),
);

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _keys = {
    for (final k in ['Fitur', 'Kategori', 'Cara Mulai', 'FAQ']) k: GlobalKey(),
  };

  void _go(String k) => Scrollable.ensureVisible(
    _keys[k]!.currentContext!,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [
          _Nav(onNav: _go),
          _Hero(onKategori: () => _go('Kategori')),
          _Band(key: _keys['Kategori'], child: const _Kategori()),
          _Section(key: _keys['Fitur'], child: const _Fitur()),
          _Band(key: _keys['Cara Mulai'], child: const _Cara()),
          _Section(key: _keys['FAQ'], maxWidth: 820, child: const _Faq()),
          const _Cta(),
          const _Footer(),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------- layout

class _Section extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const _Section({super.key, required this.child, this.maxWidth = 1200});

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 88),
        child: child,
      ),
    ),
  );
}

class _Band extends StatelessWidget {
  final Widget child;
  const _Band({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      color: _bgAlt,
      border: Border.symmetric(horizontal: BorderSide(color: _line)),
    ),
    child: _Section(child: child),
  );
}

/// Grid that wraps to fewer columns on narrow screens (CSS auto-fit minmax).
class _Grid extends StatelessWidget {
  final List<Widget> children;
  final double minItem;
  final double gap;
  const _Grid({required this.children, this.minItem = 260, this.gap = 20});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final cols = ((c.maxWidth + gap) / (minItem + gap)).floor().clamp(
        1,
        children.length,
      );
      final w = (c.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [for (final ch in children) SizedBox(width: w, child: ch)],
      );
    },
  );
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      color: _card,
      border: Border.all(color: _cardBorder),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}

Widget _eyebrow(String t) => Padding(
  padding: const EdgeInsets.only(bottom: 12),
  child: Text(
    t.toUpperCase(),
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.7,
      color: _accentText,
    ),
  ),
);

double _h2Size(BuildContext c) =>
    (MediaQuery.sizeOf(c).width * 0.04).clamp(32, 48);

class _DownloadButton extends StatelessWidget {
  final Color bg;
  const _DownloadButton({this.bg = _accent});

  @override
  Widget build(BuildContext context) => FilledButton.icon(
    onPressed: _download,
    icon: const Icon(Icons.download_rounded, size: 20),
    label: const Text('Unduh untuk Android'),
    style: FilledButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

// ---------------------------------------------------------------- sections

class _Nav extends StatelessWidget {
  final void Function(String) onNav;
  const _Nav({required this.onNav});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Text('Streamed', style: _display(22)),
                const Spacer(),
                if (wide)
                  for (final l in ['Fitur', 'Kategori', 'Cara Mulai', 'FAQ'])
                    TextButton(
                      onPressed: () => onNav(l),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFC7C7C7),
                      ),
                      child: Text(l, style: const TextStyle(fontSize: 15)),
                    ),
                const SizedBox(width: 16),
                FilledButton(
                  onPressed: _download,
                  style: FilledButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Unduh Aplikasi',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final VoidCallback onKategori;
  const _Hero({required this.onKategori});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final wide = w >= 1000;
    final h1 = (w * 0.06).clamp(44.0, 76.0);

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0B0A),
            border: Border.all(color: const Color(0xFF3A1513)),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(radius: 4, backgroundColor: Color(0xFFFF5A4F)),
              SizedBox(width: 10),
              Text(
                'Siaran live setiap hari',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF8F87),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Olahraga favoritmu.\nLive, jernih,\n'),
              TextSpan(
                text: 'satu ketukan.',
                style: _display(
                  h1,
                  w: FontWeight.w900,
                  c: const Color(0xFFFF5A4F),
                ),
              ),
            ],
          ),
          style: _display(h1, w: FontWeight.w900),
        ),
        const SizedBox(height: 28),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: const Text(
            'Tonton balap, tenis, dan kriket secara langsung dalam kualitas HD. '
            'Pilih siaran, pilih stream, langsung nonton — tanpa ribet.',
            style: TextStyle(
              fontSize: 19,
              height: 1.6,
              color: Color(0xFFB5B5B5),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            const _DownloadButton(),
            OutlinedButton(
              onPressed: onKategori,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF3A3A3A)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 22,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Lihat kategori'),
            ),
          ],
        ),
        const SizedBox(height: 36),
        Wrap(
          spacing: 24,
          runSpacing: 12,
          children: [
            _perk(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('HD', style: _display(11)),
              ),
              'Kualitas tinggi',
            ),
            _perk(
              const Icon(Icons.swap_horiz, size: 18, color: _accentText),
              'Stream cadangan',
            ),
            _perk(
              const Icon(
                Icons.dark_mode_outlined,
                size: 18,
                color: _accentText,
              ),
              'Mode gelap',
            ),
          ],
        ),
      ],
    );

    final phones = SizedBox(
      height: wide ? 640 : (w * 1.2).clamp(380.0, 600.0),
      child: FittedBox(
        child: SizedBox(
          width: 500,
          height: 640,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: _phone('assets/image/screen_stream.jpg'),
              ),
              Positioned(
                left: 0,
                top: 48,
                child: _phone('assets/image/screen_matches.jpg'),
              ),
            ],
          ),
        ),
      ),
    );

    return _Section(
      child: wide
          ? Row(
              children: [
                Expanded(child: copy),
                const SizedBox(width: 64),
                Expanded(child: phones),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                copy,
                const SizedBox(height: 56),
                Center(child: phones),
              ],
            ),
    );
  }

  static Widget _perk(Widget icon, String t) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      icon,
      const SizedBox(width: 8),
      Text(t, style: const TextStyle(fontSize: 15, color: _muted)),
    ],
  );

  static Widget _phone(String asset) => Container(
    width: 270,
    decoration: BoxDecoration(
      color: Colors.black,
      border: Border.all(color: const Color(0xFF1C1C1C), width: 8),
      borderRadius: BorderRadius.circular(40),
      boxShadow: const [
        BoxShadow(
          color: Color(0x99000000),
          blurRadius: 60,
          offset: Offset(0, 30),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Image.asset(asset),
    ),
  );
}

class _Kategori extends StatelessWidget {
  const _Kategori();

  @override
  Widget build(BuildContext context) {
    Widget cat(IconData i, Color fg, Color bg, String t, String d) => _Card(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(i, color: fg, size: 28),
        ),
        const SizedBox(height: 18),
        Text(t, style: _display(26)),
        const SizedBox(height: 18),
        Text(d, style: _body),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 32,
          runSpacing: 16,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _eyebrow('Kategori'),
                Text(
                  'Dari pit lane sampai lapangan.',
                  style: _display(_h2Size(context)),
                ),
              ],
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Text(
                'Semua siaran live tersusun rapi per kategori, jadi kamu langsung menemukan yang ingin ditonton.',
                style: _body.copyWith(fontSize: 17),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        _Grid(
          children: [
            cat(
              Icons.flag_outlined,
              _accentText,
              const Color(0xFF2A0F0D),
              'Balap',
              'Latihan bebas, kualifikasi, hingga race day — ikuti setiap lap secara live.',
            ),
            cat(
              Icons.sports_tennis,
              const Color(0xFFC6E36A),
              const Color(0xFF1C2410),
              'Tenis',
              'Rally panjang dan match point menegangkan dari turnamen pilihan.',
            ),
            cat(
              Icons.sports_cricket,
              const Color(0xFFA99CF2),
              const Color(0xFF1A1430),
              'Kriket',
              'Dua channel kriket sekaligus, jadi tak ada pertandingan penting yang terlewat.',
            ),
          ],
        ),
      ],
    );
  }
}

class _Fitur extends StatelessWidget {
  const _Fitur();

  @override
  Widget build(BuildContext context) {
    Widget item(String n, String t, String d) => Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _accent, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(n, style: _display(14, c: _accentText)),
          const SizedBox(height: 14),
          Text(t, style: _h3.copyWith(fontSize: 22)),
          const SizedBox(height: 14),
          Text(d, style: _body),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _eyebrow('Kenapa Streamed'),
              Text(
                'Dibuat untuk nonton, bukan untuk bingung.',
                style: _display(_h2Size(context)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        _Grid(
          gap: 40,
          children: [
            item(
              '01',
              'Kualitas HD',
              'Setiap stream ditandai label HD, jadi kamu tahu kualitas gambar sebelum menekan play.',
            ),
            item(
              '02',
              'Stream cadangan',
              'Satu siaran tersedia di beberapa stream. Kalau satu tersendat, pindah ke yang lain dalam sekali ketuk.',
            ),
            item(
              '03',
              'Tampilan simpel & gelap',
              'Antarmuka bersih bertema gelap, nyaman di mata saat nonton pertandingan malam.',
            ),
          ],
        ),
      ],
    );
  }
}

class _Cara extends StatelessWidget {
  const _Cara();

  @override
  Widget build(BuildContext context) {
    Widget step(int n, String t, String d) => _Card(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: _accent,
          child: Text('$n', style: _display(18)),
        ),
        const SizedBox(height: 16),
        Text(t, style: _h3),
        const SizedBox(height: 16),
        Text(d, style: _body),
      ],
    );

    return Column(
      children: [
        Text(
          'Mulai nonton dalam 3 langkah',
          textAlign: TextAlign.center,
          style: _display(_h2Size(context)),
        ),
        const SizedBox(height: 48),
        _Grid(
          minItem: 240,
          children: [
            step(
              1,
              'Unduh & pasang',
              'Unduh aplikasi Streamed lewat tombol di halaman ini, lalu pasang di ponsel Android-mu.',
            ),
            step(
              2,
              'Pilih siaran live',
              'Buka daftar Live Matches dan pilih channel dari kategori balap, tenis, atau kriket.',
            ),
            step(
              3,
              'Pilih stream & tonton',
              'Tentukan Stream 1 atau Stream 2, dan pertandingan langsung diputar.',
            ),
          ],
        ),
      ],
    );
  }
}

class _Faq extends StatelessWidget {
  const _Faq();

  static const _items = [
    ('Apakah Streamed gratis?', 'Gratis untuk semua orang.'),
    ('Perangkat apa saja yang didukung?', 'Ponsel Android 7.0 ke atas.'),
    (
      'Kenapa ada Stream 1 dan Stream 2?',
      'Beberapa stream disediakan sebagai cadangan. Jika satu stream lambat di jaringanmu, cukup pindah ke stream lain.',
    ),
    (
      'Berapa kuota yang dibutuhkan?',
      'Streaming video HD memakai kuota cukup besar. Disarankan memakai Wi-Fi.',
    ),
  ];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Pertanyaan umum', style: _display(_h2Size(context))),
      const SizedBox(height: 32),
      for (final (i, (q, a)) in _items.indexed)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            border: Border(
              top: const BorderSide(color: _cardBorder),
              bottom: i == _items.length - 1
                  ? const BorderSide(color: _cardBorder)
                  : BorderSide.none,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(q, style: _h3.copyWith(fontSize: 19)),
              const SizedBox(height: 10),
              Text(a, style: _body),
            ],
          ),
        ),
    ],
  );
}

class _Cta extends StatelessWidget {
  const _Cta();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final narrow = w < 600;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 96),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1152),
          padding: EdgeInsets.symmetric(
            horizontal: narrow ? 28 : 48,
            vertical: narrow ? 48 : 72,
          ),
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 32,
            runSpacing: 32,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pertandingan berikutnya\nsudah menunggu.',
                      style: _display(
                        (w * 0.045).clamp(34, 56),
                        w: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Unduh Streamed sekarang dan jangan lewatkan satu momen pun.',
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.6,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DownloadButton(bg: _bg),
                  SizedBox(height: 12),
                  Text(
                    _versionInfo,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: _line)),
    ),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Text(
            '© ${DateTime.now().year} Streamed. Semua hak dilindungi.',
            style: const TextStyle(fontSize: 14, color: _muted),
          ),
        ),
      ),
    ),
  );
}
