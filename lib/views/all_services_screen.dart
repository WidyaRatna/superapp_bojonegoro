import 'package:flutter/material.dart';
import '../widgets/superapp_header.dart';
import '../models/service_model.dart';

class AllServicesScreen extends StatefulWidget {
  final List<ServiceCategory> allServices;
  final Function(ServiceCategory) onServiceTap;
  final bool isDarkMode;
  final VoidCallback? onToggleDarkMode;

  const AllServicesScreen({
    super.key,
    required this.allServices,
    required this.onServiceTap,
    required this.isDarkMode,
    this.onToggleDarkMode,
  });

  @override
  State<AllServicesScreen> createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends State<AllServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceCategory> get _filteredServices {
    final list = widget.allServices.where((service) => service.id != 'lainnya');
    if (_searchQuery.trim().isEmpty) return list.toList();
    final query = _searchQuery.toLowerCase();
    return list.where((service) {
      final titleMatches = service.title.toLowerCase().contains(query);
      final subMatches =
          service.subServices.any((sub) => sub.toLowerCase().contains(query));
      return titleMatches || subMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || widget.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          SuperAppHeader(
            title: 'Kategori Layanan',
            subtitle: 'SuperApp Kabupaten Bojonegoro',
            isDarkMode: isDark,
            onToggleDarkMode: widget.onToggleDarkMode,
          ),
          const SizedBox(height: 12),

                // Floating Search Bar ("Telusuri kategori layanan..")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: isDark
                          ? Border.all(color: const Color(0xFF334155))
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 13.5,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Telusuri kategori layanan..',
                        hintStyle: TextStyle(
                          color: isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8),
                          fontSize: 13.5,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                ),

          // Full Screen Grid View of All Categories
          Expanded(
            child: _filteredServices.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 54,
                          color: isDark ? Colors.white38 : Colors.black26,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Kategori layanan tidak ditemukan',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seluruh Kategori Layanan (${_filteredServices.length})',
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 4-Column Grid View
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredServices.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.72,
                          ),
                          itemBuilder: (context, index) {
                            final service = _filteredServices[index];
                            return InkWell(
                              onTap: () {
                                widget.onServiceTap(service);
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Circular Icon Badge Button
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1E293B)
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? const Color(0xFF334155)
                                            : const Color(0xFFF1F5F9),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(12),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        service.icon,
                                        color: service.color,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Category Label Title
                                  Text(
                                    service.title,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFFF1F5F9)
                                          : const Color(0xFF1E293B),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      height: 1.15,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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
