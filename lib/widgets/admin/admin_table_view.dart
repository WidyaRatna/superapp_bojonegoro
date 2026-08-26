import 'package:flutter/material.dart';

class AdminTableColumn {
  final String title;
  final double? width;
  final Alignment alignment;

  const AdminTableColumn({
    required this.title,
    this.width,
    this.alignment = Alignment.centerLeft,
  });
}

class AdminTableView<T> extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<AdminTableColumn> columns;
  final List<T> items;
  final List<Widget> Function(T item, int index) rowBuilder;
  final VoidCallback onAddNew;
  final String addNewLabel;
  final String searchHint;
  final bool Function(T item, String query)? searchFilter;
  final List<String>? filterOptions;
  final String? selectedFilter;
  final ValueChanged<String?>? onFilterChanged;

  const AdminTableView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.columns,
    required this.items,
    required this.rowBuilder,
    required this.onAddNew,
    this.addNewLabel = 'Tambah Data Baru',
    this.searchHint = 'Cari data...',
    this.searchFilter,
    this.filterOptions,
    this.selectedFilter,
    this.onFilterChanged,
  });

  @override
  State<AdminTableView<T>> createState() => _AdminTableViewState<T>();
}

class _AdminTableViewState<T> extends State<AdminTableView<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter items based on search query
    final filteredItems = widget.items.where((item) {
      if (_searchQuery.trim().isEmpty) return true;
      if (widget.searchFilter != null) {
        return widget.searchFilter!(item, _searchQuery.trim().toLowerCase());
      }
      return true;
    }).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header + Primary Action Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: widget.onAddNew,
                icon: const Icon(Icons.add_rounded, color: Colors.white, size: 19),
                label: Text(
                  widget.addNewLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D62F1),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search & Filter Toolbar Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Search Input Box
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: widget.searchHint,
                      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D62F1), size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF0D62F1), width: 1.5),
                      ),
                    ),
                  ),
                ),
                if (widget.filterOptions != null) ...[
                  const SizedBox(width: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: widget.selectedFilter ?? widget.filterOptions!.first,
                        items: widget.filterOptions!
                            .map((f) => DropdownMenuItem(
                                  value: f,
                                  child: Text(
                                    f,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF334155),
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: widget.onFilterChanged,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Total: ${filteredItems.length} Data',
                    style: const TextStyle(
                      color: Color(0xFF0D62F1),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Main Data Table Container
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: filteredItems.isEmpty
                  ? _buildEmptyState()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Table(
                            defaultColumnWidth: const IntrinsicColumnWidth(),
                            columnWidths: Map.fromEntries(
                              widget.columns.asMap().entries.map((e) => MapEntry(
                                    e.key,
                                    e.value.width != null
                                        ? FixedColumnWidth(e.value.width!)
                                        : const FlexColumnWidth(),
                                  )),
                            ),
                            children: [
                              // Table Header Row
                              TableRow(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF1F5F9),
                                  border: Border(
                                    bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                                  ),
                                ),
                                children: widget.columns.map((col) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    alignment: col.alignment,
                                    child: Text(
                                      col.title.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF475569),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                              // Table Body Rows
                              ...filteredItems.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                final rowCells = widget.rowBuilder(item, index);
                                final isEven = index % 2 == 0;

                                return TableRow(
                                  decoration: BoxDecoration(
                                    color: isEven ? Colors.white : const Color(0xFFF8FAFC),
                                    border: const Border(
                                      bottom: BorderSide(color: Color(0xFFF1F5F9)),
                                    ),
                                  ),
                                  children: rowCells.asMap().entries.map((cellEntry) {
                                    final colIndex = cellEntry.key;
                                    final cellWidget = cellEntry.value;
                                    final colAlign = widget.columns[colIndex].alignment;

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      alignment: colAlign,
                                      child: cellWidget,
                                    );
                                  }).toList(),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak ada data ditemukan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Coba kata kunci pencarian lain atau bersihkan filter.'
                  : 'Belum ada data tersimpan di menu ini.',
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
