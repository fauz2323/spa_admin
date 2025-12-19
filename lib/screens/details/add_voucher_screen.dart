import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddVoucherScreen extends StatefulWidget {
  final int id;
  const AddVoucherScreen({super.key, required this.id});

  @override
  State<AddVoucherScreen> createState() => _AddVoucherScreenState();
}

class _AddVoucherScreenState extends State<AddVoucherScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountAmountController = TextEditingController();
  final _expiryDateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _discountAmountController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _expiryDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Voucher'), elevation: 0),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Voucher *',
                hintText: 'Masukkan nama voucher',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.card_giftcard),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama voucher harus diisi';
                }
                if (value.length > 255) {
                  return 'Nama maksimal 255 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Price Field
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Harga *',
                hintText: 'Masukkan harga',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                prefixText: 'Rp ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harga harus diisi';
                }
                if (value.length > 255) {
                  return 'Harga maksimal 255 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Discount Amount Field
            TextFormField(
              controller: _discountAmountController,
              decoration: const InputDecoration(
                labelText: 'Jumlah Diskon *',
                hintText: 'Masukkan jumlah diskon',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.discount),
                prefixText: 'Rp ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah diskon harus diisi';
                }
                final discount = double.tryParse(value);
                if (discount == null) {
                  return 'Jumlah diskon tidak valid';
                }
                if (discount < 0) {
                  return 'Jumlah diskon tidak boleh negatif';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Expiry Date Field
            TextFormField(
              controller: _expiryDateController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Kadaluarsa *',
                hintText: 'Pilih tanggal kadaluarsa',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tanggal kadaluarsa harus diisi';
                }
                if (value.length > 255) {
                  return 'Tanggal maksimal 255 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Form valid! (Static screen - no action)'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Simpan Voucher',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Cancel Button
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Batal', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
