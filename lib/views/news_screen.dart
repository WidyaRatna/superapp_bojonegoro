import 'package:flutter/material.dart';
import '../widgets/superapp_header.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_model.dart';
import '../services/admin_data_service.dart';
import '../widgets/news_detail_sheet.dart';

class NewsScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const NewsScreen({
    super.key,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final String _officialNewsWebUrl = 'https://bojonegorokab.go.id/berita';

  Future<void> _openOfficialWeb([String? url]) async {
    final targetUrl = Uri.parse(url ?? _officialNewsWebUrl);
    if (await canLaunchUrl(targetUrl)) {
      await launchUrl(targetUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka $targetUrl')),
        );
      }
    }
  }

  void _openNewsDetail(NewsItem news) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewsDetailSheet(news: news),
    );
  }

  void _shareArticle(NewsItem news) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tautan berita disalin: ${news.webUrl}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Berita Terkini',
            subtitle: 'Pemerintah Kabupaten Bojonegoro',
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
            actions: [
              IconButton(
                tooltip: 'Buka Web Resmi Pemkab Bojonegoro',
                icon: const Icon(Icons.language_rounded, color: Colors.white),
                onPressed: () => _openOfficialWeb(),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            // Top Banner Button directing to official news site
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withAlpha(64),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.public_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Portal Berita Resmi Pemkab',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'bojonegorokab.go.id/berita',
                          style: TextStyle(
                            color: Color(0xFFE0F2FE),
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _openOfficialWeb(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0369A1),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Buka Web',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.open_in_new_rounded, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // News Feed List matching user image design & synchronized with Admin Data
            ListenableBuilder(
              listenable: AdminDataService(),
              builder: (context, child) {
                final adminService = AdminDataService();
                final publishedItems = adminService.publishedBeritaList;

                if (publishedItems.isEmpty) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sampleNews.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      final news = sampleNews[index];
                      return _buildNewsCard(news, textColor, subtitleColor);
                    },
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: publishedItems.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    final item = publishedItems[index];
                    final news = NewsItem(
                      id: item.id,
                      title: item.title,
                      category: item.category,
                      snippet: item.content,
                      content: item.content,
                      imageUrl: item.imageUrl,
                      date: item.date,
                      readTime: '3 mnt baca',
                      likes: 120,
                      views: 950,
                      webUrl: 'https://bojonegorokab.go.id/berita',
                    );
                    return _buildNewsCard(news, textColor, subtitleColor);
                  },
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    ),
  ],
),
    );
  }

  Widget _buildNewsCard(NewsItem news, Color textColor, Color subtitleColor) {
    return InkWell(
      onTap: () => _openNewsDetail(news),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full-width Image with Rounded Corners
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: news.imageUrl.startsWith('assets/')
                  ? Image.asset(
                      news.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFE2E8F0),
                        child: const Center(
                          child: Icon(Icons.image_not_supported_rounded, color: Color(0xFF94A3B8), size: 40),
                        ),
                      ),
                    )
                  : Image.network(
                      news.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFE2E8F0),
                        child: const Center(
                          child: Icon(Icons.image_not_supported_rounded, color: Color(0xFF94A3B8), size: 40),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),

          // Bold Title Text below image
          Text(
            news.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),

          // Date & Share Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${news.date} • ${news.category}',
                style: TextStyle(
                  fontSize: 13,
                  color: subtitleColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.open_in_new_rounded,
                      size: 20,
                      color: subtitleColor,
                    ),
                    tooltip: 'Buka di bojonegorokab.go.id',
                    onPressed: () => _openOfficialWeb(news.webUrl),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      size: 20,
                      color: subtitleColor,
                    ),
                    tooltip: 'Bagikan Berita',
                    onPressed: () => _shareArticle(news),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
