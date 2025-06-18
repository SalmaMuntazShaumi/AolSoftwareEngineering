import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controller.dart'; // Make sure this import is correct

class InputProduct extends StatefulWidget {
  final String token;
  const InputProduct({super.key, required this.token});

  @override
  State<InputProduct> createState() => _InputProductState();
}

class _InputProductState extends State<InputProduct> {
  String _category = "layak";
  int _step = 0;
  List<String> kategoriList = ['roti', 'lemak', 'nasi', 'daging', 'buah dan sayur', 'tulang'];
  String selectedKategori = 'tulang';

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController totalBarangController = TextEditingController();
  TextEditingController optionalReferenceController = TextEditingController();

  String selectedUnit = "Kg";
  File? _selectedImage;

  DateTime? _produksiDate;
  DateTime? _kadaluarsaDate;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _pickDate(BuildContext context, bool isProduksi) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        if (isProduksi) {
          _produksiDate = picked;
        } else {
          _kadaluarsaDate = picked;
        }
      });
    }
  }

  Future<void> _onSave() async {
    if (_selectedImage == null || _produksiDate == null || _kadaluarsaDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields and pick an image.')),
      );
      return;
    }
    try {
      await createProduct(
        token: widget.token,
        nama: nameController.text,
        kategori: selectedKategori, // <-- use the selected value
        deskripsi: descController.text,
        foto: _selectedImage,
        hargaBerat: double.tryParse(priceController.text) ?? 0.0,
        berat: double.tryParse(weightController.text) ?? 0.0,
        totalBarang: int.tryParse(totalBarangController.text) ?? 0,
        totalBerat: double.tryParse(weightController.text) ?? 0.0,
        tanggalProduksi: _produksiDate!.toIso8601String().split('T').first,
        tanggalKadaluarsa: _kadaluarsaDate!.toIso8601String().split('T').first,
        kondisi: _category == "layak" ? "layak" : "tidak",
        syaratKetentuan: 'asdasdadasdasdasdasasd',
        catatanTambahan: 'adsasdasdasdadasasdad',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambah produk: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Menambahkan Produk Baru', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              if (_step == 0) ...[
                _buildSection(
                  title: "Informasi Umum",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField("Nama Produk", controller: nameController, height: 48),
                      const SizedBox(height: 16),
                      const Text("Kategori Produk", style: TextStyle(fontWeight: FontWeight.w600)),
                      Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: selectedKategori,
                            items: kategoriList
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (val) => setState(() => selectedKategori = val!),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text("Deskripsi Produk", style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: descController,
                        maxLines: 4,
                        maxLength: 2000,
                        decoration: InputDecoration(
                          hintText: "Tulis deskripsi di sini...",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text("Upload Foto Produk", style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      _selectedImage != null
                          ? Image.file(_selectedImage!, height: 100)
                          : SizedBox.shrink(),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text("Tambah Image"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[100],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildSection(
                  title: "Harga",
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildTextField("Harga Dasar", controller: priceController, height: 48)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildTextField("Berat", controller: weightController, height: 48)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField("Persentase Diskon", controller: discountController, height: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _step = 1;
                    });
                  },
                  child: const Text("Next"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Colors.deepPurple[100],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
              if (_step == 1) ...[
                _buildSection(
                  title: "Jumlah Barang",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                controller: totalBarangController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  isDense: true,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: DropdownButtonFormField<String>(
                                value: selectedUnit,
                                items: ["Kg", "Gram", "Ton"]
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (val) => setState(() => selectedUnit = val!),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  isDense: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                _buildSection(
                  title: "Waktu dan Tanggal",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Produksi", style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _pickDate(context, true),
                              child: Text(_produksiDate == null
                                  ? "Pilih Tanggal"
                                  : "${_produksiDate!.day}/${_produksiDate!.month}/${_produksiDate!.year}"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text("Kadaluwarsa", style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _pickDate(context, false),
                              child: Text(_kadaluarsaDate == null
                                  ? "Pilih Tanggal"
                                  : "${_kadaluarsaDate!.day}/${_kadaluarsaDate!.month}/${_kadaluarsaDate!.year}"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildSection(
                  title: "Detail Pengambilan",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.location_on_outlined),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "BINUS Anggrek\nJl. Raya Kb. Jeruk No.27, Kb. Jeruk, Jakarta Barat",
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildTextField("Tambahkan Referensi (opsional)", controller: optionalReferenceController, height: 48),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _step = 0;
                          });
                        },
                        child: const Text("← Previous"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[100],
                        ),
                        child: const Text("Save"),
                      ),
                    ),
                  ],
                )
              ],
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, {required TextEditingController controller, required double height}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SizedBox(
          height: height,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              isDense: false,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRadio(String label, String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _category,
          onChanged: (val) => setState(() => _category = val!),
        ),
        Text(label),
      ],
    );
  }
}