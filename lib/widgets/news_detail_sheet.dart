import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_model.dart';

class NewsDetailSheet extends StatefulWidget {
  final NewsItem news;

  const NewsDetailSheet({
    super.key,
    required this.news,
  });

  @override
  State<NewsDetailSheet> createState() => _NewsDetailSheetState();
}

class _NewsDetailSheetState extends State<NewsDetailSheet> {
  late int _likeCount;
  bool _isLiked = false;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.news.likes;
  }

  Future<void> _openWebUrl() async {
    final uri = Uri.parse(widget.news.webUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka ${widget.news.webUrl}')),
        );
      }
    }
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likeCount++;
      } else {
        _likeCount--;
      }
    });
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked ? 'Berita disimpan ke favorit' : 'Berita dihapus dari favorit'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareArticle() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tautan disalin: ${widget.news.webUrl}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle bar
          const SizedBox(height: 12),
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Header Bar Actions (Close, Bookmark, Share)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF0F172A)),
                  onPressed: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: _isBookmarked ? const Color(0xFF0D62F1) : const Color(0xFF64748B),
                      ),
                      onPressed: _toggleBookmark,
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: Color(0xFF64748B)),
                      onPressed: _shareArticle,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Main Article Scroll View
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Date Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D62F1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.news.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${widget.news.date}  •  ${widget.news.readTime}',
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Article Title
                  Text(
                    widget.news.title,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Featured Image Banner
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      widget.news.imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: const Color(0xFFE2E8F0),
                        child: const Center(
                          child: Icon(Icons.image_not_supported_rounded, color: Color(0xFF94A3B8)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Article Text Content
                  Text(
                    widget.news.content,
                    style: const TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 15,
                      height: 1.65,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Button to Open Full Article on Official Web Portal
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _openWebUrl,
                      icon: const Icon(Icons.open_in_browser_rounded, color: Color(0xFF0284C7)),
                      label: const Text(
                        'Baca Artikel Lengkap di bojonegorokab.go.id ↗',
                        style: TextStyle(
                          color: Color(0xFF0284C7),
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        side: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Author / Publisher Footer Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0D62F1),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.verified_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Humas Pemkab Bojonegoro',
                                style: TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Sumber Informasi Resmi Pemerintah Daerah',
                                style: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Interactive Bottom Like Bar inside Detail
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _toggleLike,
                        icon: Icon(
                          _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: _isLiked ? Colors.white : const Color(0xFF0D62F1),
                          size: 20,
                        ),
                        label: Text(
                          'Sukai Berita ($_likeCount)',
                          style: TextStyle(
                            color: _isLiked ? Colors.white : const Color(0xFF0D62F1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isLiked ? const Color(0xFF0D62F1) : const Color(0xFFEFF6FF),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

