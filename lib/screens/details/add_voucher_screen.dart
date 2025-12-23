import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_admin/dto/create_voucher_dto.dart';
import 'package:spa_admin/screens/details/cubit/add_mission_cubit.dart';
import 'package:spa_admin/screens/details/cubit/add_voucher_cubit.dart';

class AddVoucherScreen extends StatefulWidget {
  final int id;
  final String? name;
  final String? price;
  final String? discountAmount;
  final String? expiryDate;
  const AddVoucherScreen({
    super.key,
    required this.id,
    this.name,
    this.price,
    this.discountAmount,
    this.expiryDate,
  });

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
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.name ?? '';
    _priceController.text = widget.price ?? '';
    _discountAmountController.text = widget.discountAmount ?? '';
    _expiryDateController.text = widget.expiryDate ?? '';
  }

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
    return BlocProvider(
      create: (context) => AddVoucherCubit(),
      child: Builder(
        builder: (context) {
          return _build(context);
        },
      ),
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Voucher'), elevation: 0),
      body: BlocConsumer<AddVoucherCubit, AddVoucherState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {},
            success: (data) {},
            failure: (errorMessage) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $errorMessage')));
            },
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => _loaded(context, false),
            loading: () => _loaded(context, true),
          );
        },
      ),
    );
  }

  Widget _loaded(BuildContext context, bool isLoading) {
    return Form(
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            onPressed: isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      await context.read<AddVoucherCubit>().save(
                        CreateVoucherDto(
                          id: widget.id,
                          name: _nameController.text,
                          price: _priceController.text,
                          discountAmount: double.parse(
                            _discountAmountController.text,
                          ),
                          expiryDate: DateTime.parse(
                            _expiryDateController.text,
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Voucher berhasil disimpan'),
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
            child: Text(
              isLoading ? 'Menyimpan...' : 'Simpan Voucher',
              style: const TextStyle(fontSize: 16),
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
    );
  }
}
