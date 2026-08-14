import 'package:flutter/material.dart';
import '../models/service_model.dart';

class PopularServicesWidget extends StatelessWidget {
  final List<ServiceCategory> services;
  final Function(ServiceCategory) onServiceTap;
  final VoidCallback onViewAllTap;
  final bool isDarkMode;

  const PopularServicesWidget({
    super.key,
    required this.services,
    required this.onServiceTap,
    required this.onViewAllTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure only 4 items are displayed on home grid
    final displayServices = services.take(4).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Layanan Populer',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              InkWell(
                onTap: onViewAllTap,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Semua layanan',
                        style: TextStyle(
                          color: isDarkMode ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: isDarkMode ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2 x 2 Grid Layout (Consistent 4 Primary Service Cards)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayServices.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.3,
            ),
            itemBuilder: (context, index) {
              final service = displayServices[index];
              return InkWell(
                onTap: () => onServiceTap(service),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Soft Tint Colored Icon Box
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: service.color.withAlpha(isDarkMode ? 35 : 20),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(
                            service.icon,
                            color: service.color,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Service Title Label
                      Expanded(
                        child: Text(
                          service.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
