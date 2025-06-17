import 'package:flutter/material.dart';

class InputProduct extends StatefulWidget {
  const InputProduct({super.key});

  @override
  State<InputProduct> createState() => _InputProductState();
}

class _InputProductState extends State<InputProduct> {
  String _category = "layak";
  int _step = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController totalBarangController = TextEditingController();
  TextEditingController optionalReferenceController = TextEditingController();

  String selectedUnit = "Kg";

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
                          _buildRadio("Layak Konsumsi", "layak"),
                          _buildRadio("Tidak Layak Konsumsi", "tidak"),
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
                      ElevatedButton(
                        onPressed: () {},
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
                          _buildDateDropdown("Hari", List.generate(31, (i) => "${i + 1}")),
                          const SizedBox(width: 8),
                          _buildDateDropdown("Bulan", ["April", "Mei", "Juni"]),
                          const SizedBox(width: 8),
                          _buildDateDropdown("Tahun", ["2025", "2026"]),
                        ],
                      ),
                      const Text("Kadaluwarsa", style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildDateDropdown("Hari", List.generate(31, (i) => "${i + 1}")),
                          const SizedBox(width: 8),
                          _buildDateDropdown("Bulan", ["April", "Mei", "Juni"]),
                          const SizedBox(width: 8),
                          _buildDateDropdown("Tahun", ["2025", "2026"]),
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
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Produk Disimpan"),
                              content: const Text("Produk berhasil ditambahkan."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Close"),
                                ),
                              ],
                            ),
                          );
                        },
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
          height: height, // or your desired height
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: EdgeInsets.symmetric(horizontal: 8), // adjust vertical
              isDense: false, // set to false for more space
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

  Widget _buildDateDropdown(String hint, List<String> items) {
    return Expanded(
      child: SizedBox(
        height: 48,
        child: DropdownButtonFormField<String>(
          value: items.first,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (_) {},
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            isDense: true,
          ),
        ),
      ),
    );
  }
}