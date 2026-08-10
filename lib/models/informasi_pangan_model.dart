/// Model representing a Kecamatan in Bojonegoro Regency for Disdag data filtering
class KecamatanOption {
  final String id;
  final String name;

  const KecamatanOption({
    required this.id,
    required this.name,
  });
}

/// Model representing a Traditional Market (Pasar Tradisional) in Bojonegoro
class PasarOption {
  final String id;
  final String name;
  final String kecamatanId;

  const PasarOption({
    required this.id,
    required this.name,
    required this.kecamatanId,
  });
}

/// Model representing a food item / staple commodity price record
class FoodPriceItem {
  final String id;
  final String category;
  final String name;
  final String unit;
  final double priceYesterday;
  final double priceToday;
  final double priceChange;
  final double percentChange;
  final String trend; // 'up', 'down', 'stable'

  const FoodPriceItem({
    required this.id,
    required this.category,
    required this.name,
    required this.unit,
    required this.priceYesterday,
    required this.priceToday,
    required this.priceChange,
    required this.percentChange,
    required this.trend,
  });

  String get formattedPriceToday => _formatRupiah(priceToday);
  String get formattedPriceYesterday => _formatRupiah(priceYesterday);
  String get formattedPriceChange => '${priceChange >= 0 ? "+" : ""}${_formatRupiah(priceChange)}';
  String get formattedPercentChange => '${percentChange >= 0 ? "+" : ""}${percentChange.toStringAsFixed(2)}%';

  static String _formatRupiah(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs().round();
    final str = absAmount.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }

    return 'Rp ${isNegative ? "-" : ""}${buffer.toString()}';
  }
}

/// Complete List of Kecamatans from Disdag Bojonegoro
const List<KecamatanOption> listKecamatanDisdag = [
  KecamatanOption(id: '', name: 'Semua Kecamatan (Rata-Rata)'),
  KecamatanOption(id: '29', name: 'Kecamatan Bojonegoro'),
  KecamatanOption(id: '28', name: 'Kecamatan Balen'),
  KecamatanOption(id: '30', name: 'Kecamatan Baureno'),
  KecamatanOption(id: '10', name: 'Kecamatan Bubulan'),
  KecamatanOption(id: '8', name: 'Kecamatan Dander'),
  KecamatanOption(id: '9', name: 'Kecamatan Gayam'),
  KecamatanOption(id: '6', name: 'Kecamatan Gondang'),
  KecamatanOption(id: '7', name: 'Kecamatan Kalitidu'),
  KecamatanOption(id: '14', name: 'Kecamatan Kanor'),
  KecamatanOption(id: '4', name: 'Kecamatan Kapas'),
  KecamatanOption(id: '15', name: 'Kecamatan Kasiman'),
  KecamatanOption(id: '11', name: 'Kecamatan Kedewan'),
  KecamatanOption(id: '31', name: 'Kecamatan Kedungadem'),
  KecamatanOption(id: '12', name: 'Kecamatan Kepohbaru'),
  KecamatanOption(id: '27', name: 'Kecamatan Malo'),
  KecamatanOption(id: '18', name: 'Kecamatan Margomulyo'),
  KecamatanOption(id: '17', name: 'Kecamatan Ngambon'),
  KecamatanOption(id: '16', name: 'Kecamatan Ngasem'),
  KecamatanOption(id: '26', name: 'Kecamatan Ngraho'),
  KecamatanOption(id: '5', name: 'Kecamatan Padangan'),
  KecamatanOption(id: '25', name: 'Kecamatan Purwosari'),
  KecamatanOption(id: '13', name: 'Kecamatan Sekar'),
  KecamatanOption(id: '20', name: 'Kecamatan Sugihwaras'),
  KecamatanOption(id: '21', name: 'Kecamatan Sukosewu'),
  KecamatanOption(id: '22', name: 'Kecamatan Sumberrejo'),
  KecamatanOption(id: '24', name: 'Kecamatan Tambakrejo'),
  KecamatanOption(id: '23', name: 'Kecamatan Temayang'),
  KecamatanOption(id: '19', name: 'Kecamatan Trucuk'),
];

/// Complete List of Markets (Pasar Tradisional) from Disdag Bojonegoro
const List<PasarOption> listPasarDisdag = [
  PasarOption(id: '', name: 'Semua Pasar Tradisional', kecamatanId: ''),
  PasarOption(id: '1', name: 'Pasar Wisata Bojonegoro', kecamatanId: '29'),
  PasarOption(id: '2', name: 'Pasar Banjarrejo', kecamatanId: '29'),
  PasarOption(id: '37', name: 'Pasar Balenrejo', kecamatanId: '28'),
  PasarOption(id: '38', name: 'Pasar Sidobandung', kecamatanId: '28'),
  PasarOption(id: '41', name: 'Pasar Pasinan', kecamatanId: '30'),
  PasarOption(id: '51', name: 'Pasar Bubulan', kecamatanId: '10'),
  PasarOption(id: '50', name: 'Pasar Ngorogunung', kecamatanId: '10'),
  PasarOption(id: '9', name: 'Pasar Dander', kecamatanId: '8'),
  PasarOption(id: '43', name: 'Pasar Sumberarum', kecamatanId: '8'),
  PasarOption(id: '45', name: 'Pasar Sendangrejo', kecamatanId: '8'),
  PasarOption(id: '46', name: 'Pasar Ngumpakdalem', kecamatanId: '8'),
  PasarOption(id: '91', name: 'Pasar Desa Gayam', kecamatanId: '9'),
  PasarOption(id: '48', name: 'Pasar Gondang', kecamatanId: '6'),
  PasarOption(id: '49', name: 'Pasar Pajeng', kecamatanId: '6'),
  PasarOption(id: '10', name: 'Pasar Kalitidu', kecamatanId: '7'),
  PasarOption(id: '56', name: 'Pasar Sumengko', kecamatanId: '7'),
  PasarOption(id: '57', name: 'Pasar Pungpungan', kecamatanId: '7'),
  PasarOption(id: '5', name: 'Pasar Kanor', kecamatanId: '14'),
  PasarOption(id: '6', name: 'Pasar Majuraya', kecamatanId: '14'),
  PasarOption(id: '35', name: 'Pasar Simorejo', kecamatanId: '14'),
  PasarOption(id: '36', name: 'Pasar Piyak', kecamatanId: '14'),
  PasarOption(id: '14', name: 'Pasar Mojodeso', kecamatanId: '4'),
  PasarOption(id: '15', name: 'Pasar Kapas', kecamatanId: '4'),
  PasarOption(id: '17', name: 'Pasar Kalianyar', kecamatanId: '4'),
  PasarOption(id: '18', name: 'Pasar Tanjungharjo', kecamatanId: '4'),
  PasarOption(id: '85', name: 'Pasar Sambeng', kecamatanId: '15'),
  PasarOption(id: '86', name: 'Pasar Sekaran', kecamatanId: '15'),
  PasarOption(id: '87', name: 'Pasar Batokan', kecamatanId: '15'),
  PasarOption(id: '88', name: 'Pasar Hargomulyo', kecamatanId: '11'),
  PasarOption(id: '89', name: 'Pasar Kedewan', kecamatanId: '11'),
  PasarOption(id: '90', name: 'Pasar Beji', kecamatanId: '11'),
  PasarOption(id: '8', name: 'Pasar Kedungadem', kecamatanId: '31'),
  PasarOption(id: '33', name: 'Pasar Kepohkidul', kecamatanId: '31'),
  PasarOption(id: '28', name: 'Pasar Kepoh', kecamatanId: '12'),
  PasarOption(id: '29', name: 'Pasar Jipo', kecamatanId: '12'),
  PasarOption(id: '30', name: 'Pasar Nglumber', kecamatanId: '12'),
  PasarOption(id: '12', name: 'Pasar Malo', kecamatanId: '27'),
  PasarOption(id: '72', name: 'Pasar Sumberrejo Malo', kecamatanId: '27'),
  PasarOption(id: '73', name: 'Pasar Kedungrejo', kecamatanId: '27'),
  PasarOption(id: '84', name: 'Pasar Margomulyo', kecamatanId: '18'),
  PasarOption(id: '13', name: 'Pasar Legi Ngambon', kecamatanId: '17'),
  PasarOption(id: '66', name: 'Pasar Ngambon', kecamatanId: '17'),
  PasarOption(id: '61', name: 'Pasar Ngasem', kecamatanId: '16'),
  PasarOption(id: '62', name: 'Pasar Trenggulunan', kecamatanId: '16'),
  PasarOption(id: '63', name: 'Pasar Ngantru', kecamatanId: '16'),
  PasarOption(id: '64', name: 'Pasar Jampet', kecamatanId: '16'),
  PasarOption(id: '74', name: 'Pasar Bancer', kecamatanId: '26'),
  PasarOption(id: '75', name: 'Pasar Blimbinggede', kecamatanId: '26'),
  PasarOption(id: '78', name: 'Pasar Tanggungan', kecamatanId: '26'),
  PasarOption(id: '11', name: 'Pasar Padangan', kecamatanId: '5'),
  PasarOption(id: '32', name: 'Pasar Banjarejo Padangan', kecamatanId: '5'),
  PasarOption(id: '69', name: 'Pasar Cendono', kecamatanId: '5'),
  PasarOption(id: '67', name: 'Pasar Purwosari', kecamatanId: '25'),
  PasarOption(id: '68', name: 'Pasar Punggur', kecamatanId: '25'),
  PasarOption(id: '58', name: 'Pasar Klino', kecamatanId: '13'),
  PasarOption(id: '59', name: 'Pasar Sekar', kecamatanId: '13'),
  PasarOption(id: '7', name: 'Pasar Sugihwaras', kecamatanId: '20'),
  PasarOption(id: '34', name: 'Pasar Bulu', kecamatanId: '20'),
  PasarOption(id: '25', name: 'Pasar Nggandu Purwoasri', kecamatanId: '21'),
  PasarOption(id: '26', name: 'Pasar Sukorame Purwoasri', kecamatanId: '21'),
  PasarOption(id: '27', name: 'Pasar Klepek', kecamatanId: '21'),
  PasarOption(id: '24', name: 'Pasar Sumberejo', kecamatanId: '22'),
  PasarOption(id: '40', name: 'Pasar Desa Tambakrejo', kecamatanId: '24'),
  PasarOption(id: '79', name: 'Pasar Napis', kecamatanId: '24'),
  PasarOption(id: '80', name: 'Pasar Malingmati', kecamatanId: '24'),
  PasarOption(id: '81', name: 'Pasar Sukorejo', kecamatanId: '24'),
  PasarOption(id: '52', name: 'Pasar Buntalan', kecamatanId: '23'),
  PasarOption(id: '53', name: 'Pasar Jono', kecamatanId: '23'),
  PasarOption(id: '54', name: 'Pasar Temayang', kecamatanId: '23'),
  PasarOption(id: '19', name: 'Pasar Kanten', kecamatanId: '19'),
  PasarOption(id: '20', name: 'Pasar Padang', kecamatanId: '19'),
  PasarOption(id: '21', name: 'Pasar Sumberejo Trucuk', kecamatanId: '19'),
  PasarOption(id: '22', name: 'Pasar Banjarejo Trucuk', kecamatanId: '19'),
];

/// Helper to parse HTML table response from Disdag Bojonegoro endpoint
List<FoodPriceItem> parseDisdagHtmlTable(String htmlContent) {
  final List<FoodPriceItem> items = [];
  if (htmlContent.isEmpty) return items;

  try {
    String currentCategory = 'Lain-Lain';
    int itemId = 1;

    final cleanHtml = htmlContent.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    final trRegex = RegExp(r'<tr[^>]*>(.*?)<\/tr>', dotAll: true, caseSensitive: false);
    final matches = trRegex.allMatches(cleanHtml);

    for (final match in matches) {
      final rowContent = match.group(1) ?? '';

      final catMatch = RegExp(r'colspan="[0-9]+"[^>]*>([^<]+)<\/td>', caseSensitive: false).firstMatch(rowContent);
      if (catMatch != null) {
        final catName = catMatch.group(1)?.trim();
        if (catName != null && catName.isNotEmpty) {
          currentCategory = catName;
        }
        continue;
      }

      final tdMatches = RegExp(r'<td[^>]*>(.*?)<\/td>', dotAll: true, caseSensitive: false)
          .allMatches(rowContent)
          .map((m) => m.group(1)?.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('&nbsp;', ' ').trim() ?? '')
          .toList();

      if (tdMatches.length >= 5) {
        final name = tdMatches.length >= 2 ? tdMatches[1] : '';
        if (name.isEmpty || name.toLowerCase().contains('nama bahan') || name.toLowerCase().contains('kategori')) {
          continue;
        }

        final unit = tdMatches.length >= 3 ? tdMatches[2] : 'Kg';
        final yesterdayStr = tdMatches.length >= 4 ? tdMatches[3] : '0';
        final todayStr = tdMatches.length >= 5 ? tdMatches[4] : '0';
        final changeStr = tdMatches.length >= 6 ? tdMatches[5] : '0';
        final percentStr = tdMatches.length >= 7 ? tdMatches[6] : '0%';

        final yesterday = _parseIndonesianNumber(yesterdayStr);
        final today = _parseIndonesianNumber(todayStr);
        final change = _parseIndonesianNumber(changeStr);
        final percent = _parseIndonesianNumber(percentStr.replaceAll('%', ''));

        String trend = 'stable';
        if (change > 0 || percent > 0) {
          trend = 'up';
        } else if (change < 0 || percent < 0) {
          trend = 'down';
        }

        items.add(FoodPriceItem(
          id: 'item_$itemId',
          category: currentCategory,
          name: name,
          unit: unit,
          priceYesterday: yesterday,
          priceToday: today,
          priceChange: change,
          percentChange: percent,
          trend: trend,
        ));
        itemId++;
      }
    }
  } catch (e) {
    // Return parsed items so far if exception happens
  }

  return items;
}

double _parseIndonesianNumber(String str) {
  if (str.isEmpty) return 0.0;
  final clean = str.replaceAll('.', '').replaceAll(',', '.').replaceAll(RegExp(r'[^0-9.-]'), '');
  return double.tryParse(clean) ?? 0.0;
}

/// Fallback / Default Real Sample Data of Bojonegoro Food Prices from Disdag Online
const List<FoodPriceItem> sampleBojonegoroFoodPrices = [
  // Beras & Gula
  FoodPriceItem(
    id: 'b1',
    category: 'Beras',
    name: 'Beras Premium (Bengawan / Mentik)',
    unit: 'Kg',
    priceYesterday: 14500.0,
    priceToday: 14500.0,
    priceChange: 0.0,
    percentChange: 0.0,
    trend: 'stable',
  ),
  FoodPriceItem(
    id: 'b2',
    category: 'Beras',
    name: 'Beras Medium / IR 64',
    unit: 'Kg',
    priceYesterday: 12500.0,
    priceToday: 12500.0,
    priceChange: 0.0,
    percentChange: 0.0,
    trend: 'stable',
  ),
  FoodPriceItem(
    id: 'g1',
    category: 'Gula Pasir',
    name: 'Gula Pasir Kristal Putih',
    unit: 'Kg',
    priceYesterday: 16800.0,
    priceToday: 17000.0,
    priceChange: 200.0,
    percentChange: 1.19,
    trend: 'up',
  ),

  // Cabai & Bawang
  FoodPriceItem(
    id: 'c1',
    category: 'Cabai',
    name: 'Cabai Rawit Merah',
    unit: 'Kg',
    priceYesterday: 42500.0,
    priceToday: 40000.0,
    priceChange: -2500.0,
    percentChange: -5.88,
    trend: 'down',
  ),
  FoodPriceItem(
    id: 'c2',
    category: 'Cabai',
    name: 'Cabai Merah Besar (Keriting)',
    unit: 'Kg',
    priceYesterday: 35000.0,
    priceToday: 36500.0,
    priceChange: 1500.0,
    percentChange: 4.28,
    trend: 'up',
  ),
  FoodPriceItem(
    id: 'bw1',
    category: 'Bawang',
    name: 'Bawang Merah Lokal',
    unit: 'Kg',
    priceYesterday: 28000.0,
    priceToday: 27500.0,
    priceChange: -500.0,
    percentChange: -1.78,
    trend: 'down',
  ),
  FoodPriceItem(
    id: 'bw2',
    category: 'Bawang',
    name: 'Bawang Putih Honan',
    unit: 'Kg',
    priceYesterday: 38000.0,
    priceToday: 38000.0,
    priceChange: 0.0,
    percentChange: 0.0,
    trend: 'stable',
  ),

  // Daging & Telur
  FoodPriceItem(
    id: 'd1',
    category: 'Daging',
    name: 'Daging Sapi Murni (Kualitas 1)',
    unit: 'Kg',
    priceYesterday: 115000.0,
    priceToday: 115000.0,
    priceChange: 0.0,
    percentChange: 0.0,
    trend: 'stable',
  ),
  FoodPriceItem(
    id: 'd2',
    category: 'Daging',
    name: 'Daging Ayam Broiler / Ras',
    unit: 'Kg',
    priceYesterday: 33500.0,
    priceToday: 34000.0,
    priceChange: 500.0,
    percentChange: 1.49,
    trend: 'up',
  ),
  FoodPriceItem(
    id: 't1',
    category: 'Telur',
    name: 'Telur Ayam Ras',
    unit: 'Kg',
    priceYesterday: 27000.0,
    priceToday: 26500.0,
    priceChange: -500.0,
    percentChange: -1.85,
    trend: 'down',
  ),

  // Minyak Goreng & Olahan
  FoodPriceItem(
    id: 'm1',
    category: 'Minyak Goreng',
    name: 'Minyak Goreng Minyakita (HET)',
    unit: 'Liter',
    priceYesterday: 15700.0,
    priceToday: 15700.0,
    priceChange: 0.0,
    percentChange: 0.0,
    trend: 'stable',
  ),
  FoodPriceItem(
    id: 'm2',
    category: 'Minyak Goreng',
    name: 'Minyak Goreng Kemasan Premium',
    unit: 'Liter',
    priceYesterday: 18500.0,
    priceToday: 18500.0,
    priceChange: 0.0,
    percentChange: 0.0,
    trend: 'stable',
  ),

  // Sayur & Ikan
  FoodPriceItem(
    id: 's1',
    category: 'Sayur Mayur',
    name: 'Kentang Super',
    unit: 'Kg',
    priceYesterday: 17380.0,
    priceToday: 18500.0,
    priceChange: 1120.0,
    percentChange: 6.44,
    trend: 'up',
  ),
  FoodPriceItem(
    id: 's2',
    category: 'Sayur Mayur',
    name: 'Tomat Merah',
    unit: 'Kg',
    priceYesterday: 8450.0,
    priceToday: 8400.0,
    priceChange: -50.0,
    percentChange: -0.59,
    trend: 'down',
  ),
  FoodPriceItem(
    id: 'i1',
    category: 'Ikan',
    name: 'Ikan Bandeng',
    unit: 'Kg',
    priceYesterday: 32200.0,
    priceToday: 30000.0,
    priceChange: -2200.0,
    percentChange: -6.83,
    trend: 'down',
  ),
  FoodPriceItem(
    id: 'i2',
    category: 'Ikan',
    name: 'Ikan Tongkol Segar',
    unit: 'Kg',
    priceYesterday: 35400.0,
    priceToday: 34500.0,
    priceChange: -900.0,
    percentChange: -2.54,
    trend: 'down',
  ),

  // Semen & Bahan Pokok Lain
  FoodPriceItem(
    id: 'sm1',
    category: 'Semen',
    name: 'Semen Gresik 40kg',
    unit: 'Zak',
    priceYesterday: 50550.0,
    priceToday: 50000.0,
    priceChange: -550.0,
    percentChange: -1.09,
    trend: 'down',
  ),
];
