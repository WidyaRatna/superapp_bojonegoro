import 'package:flutter/material.dart';

class AdminFormField {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool isMultiLine;
  final bool isRequired;
  final List<String>? options; // If set, renders as Dropdown

  const AdminFormField({
    required this.label,
    required this.controller,
    this.hint = '',
    this.isMultiLine = false,
    this.isRequired = true,
    this.options,
  });
}

class AdminFormDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<AdminFormField> fields;
  final String? initialPdfName;
  final String? initialImageName;
  final VoidCallback onSave;
  final bool isEditing;

  const AdminFormDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fields,
    this.initialPdfName,
    this.initialImageName,
    required this.onSave,
    this.isEditing = false,
  });

  @override
  State<AdminFormDialog> createState() => _AdminFormDialogState();
}

class _AdminFormDialogState extends State<AdminFormDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _attachedPdfName;
  String? _attachedImageName;

  @override
  void initState() {
    super.initState();
    _attachedPdfName = widget.initialPdfName;
    _attachedImageName = widget.initialImageName;
  }

  void _simulatePickPdf() {
    setState(() {
      _attachedPdfName = 'Dokumen_Persyaratan_${DateTime.now().millisecondsSinceEpoch}.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File PDF berhasil diunggah: $_attachedPdfName'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  void _simulatePickImage() {
    setState(() {
      _attachedImageName = 'Brosur_Banner_${DateTime.now().millisecondsSinceEpoch}.png';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gambar/Brosur berhasil diunggah: $_attachedImageName'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1),

              // Form Scroll Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...widget.fields.map((field) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      field.label,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF334155),
                                      ),
                                    ),
                                    if (field.isRequired)
                                      const Text(
                                        ' *',
                                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                if (field.options != null && field.options!.isNotEmpty)
                                  DropdownButtonFormField<String>(
                                    initialValue: field.options!.contains(field.controller.text)
                                        ? field.controller.text
                                        : field.options!.first,
                                    decoration: _inputDecoration(field.hint),
                                    items: field.options!
                                        .map((opt) => DropdownMenuItem(
                                              value: opt,
                                              child: Text(opt, style: const TextStyle(fontSize: 13.5)),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) field.controller.text = val;
                                    },
                                  )
                                else
                                  TextFormField(
                                    controller: field.controller,
                                    maxLines: field.isMultiLine ? 3 : 1,
                                    validator: (val) {
                                      if (field.isRequired && (val == null || val.trim().isEmpty)) {
                                        return '${field.label} wajib diisi';
                                      }
                                      return null;
                                    },
                                    decoration: _inputDecoration(field.hint),
                                  ),
                              ],
                            ),
                          );
                        }),

                        // File Upload Component (PDF)
                        if (widget.initialPdfName != null || _attachedPdfName != null) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Unggah Dokumen Persyaratan (PDF)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _attachedPdfName ?? 'Belum ada file PDF',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Text(
                                        'Format: PDF (Max 10 MB)',
                                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: _simulatePickPdf,
                                  icon: const Icon(Icons.upload_file_rounded, size: 16),
                                  label: Text(_attachedPdfName != null ? 'Ganti PDF' : 'Upload'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Image Upload Component
                        if (widget.initialImageName != null || _attachedImageName != null) ...[
                          const SizedBox(height: 14),
                          const Text(
                            'Unggah Foto / Gambar Banner',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.image_rounded, color: Color(0xFF0D62F1), size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _attachedImageName ?? 'Belum ada gambar',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Text(
                                        'Format: PNG/JPG (Max 5 MB)',
                                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: _simulatePickImage,
                                  icon: const Icon(Icons.photo_camera_rounded, size: 16),
                                  label: Text(_attachedImageName != null ? 'Ganti Foto' : 'Upload'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSave();
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.save_rounded, color: Colors.white, size: 18),
                      label: Text(
                        widget.isEditing ? 'Simpan Perubahan' : 'Tambah Data',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D62F1),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF0D62F1), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
