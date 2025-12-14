import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_admin/dto/create_service_dto.dart';
import 'package:spa_admin/screens/details/cubit/add_spa_service_cubit.dart';
import 'package:spa_admin/utils/routes.dart';
import 'package:spa_admin/utils/tokien_utils.dart';

class AddSpaServiceScreen extends StatefulWidget {
  const AddSpaServiceScreen({super.key, required this.id});
  final String id;

  @override
  State<AddSpaServiceScreen> createState() => _AddSpaServiceScreenState();
}

class _AddSpaServiceScreenState extends State<AddSpaServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _pointsController = TextEditingController(text: '0');

  bool _isActive = true;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _imageUrlController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddSpaServiceCubit()..initial(widget.id),
      child: Builder(builder: (context) => _build(context)),
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Spa Service'), elevation: 0),
      body: BlocConsumer<AddSpaServiceCubit, AddSpaServiceState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            loaded: (data) {
              _nameController.text = data.data.service.name;
              _descriptionController.text = data.data.service.description;
              _priceController.text = data.data.service.price.toString();
              _durationController.text = data.data.service.duration.toString();
              _imageUrlController.text = data.data.service.image;
              _pointsController.text = data.data.service.points.toString();
              _isActive = data.data.service.isActive;

              setState(() {});
            },
            success: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Service berhasil ditambahkan')),
              );
              Navigator.pop(context);
            },
            failure: (errorMessage) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Gagal menambahkan service: $errorMessage'),
                ),
              );
            },
            unauthorized: () async {
              await TokenUtils.deleteAllTokens();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Unauthorized. Silakan login kembali.'),
                ),
              );
              if (!mounted) return;
              context.go(AppRoutes.login);
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
              labelText: 'Nama Service *',
              hintText: 'Masukkan nama service',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.spa),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nama service harus diisi';
              }
              if (value.length > 255) {
                return 'Nama maksimal 255 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Description Field
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Deskripsi',
              hintText: 'Masukkan deskripsi service',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
              alignLabelWithHint: true,
            ),
            maxLines: 4,
            maxLength: 1000,
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
              final price = double.tryParse(value);
              if (price == null) {
                return 'Harga tidak valid';
              }
              if (price < 0) {
                return 'Harga tidak boleh negatif';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Duration Field
          TextFormField(
            controller: _durationController,
            decoration: const InputDecoration(
              labelText: 'Durasi (menit) *',
              hintText: 'Masukkan durasi dalam menit',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.access_time),
              suffixText: 'menit',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Durasi harus diisi';
              }
              final duration = int.tryParse(value);
              if (duration == null) {
                return 'Durasi tidak valid';
              }
              if (duration <= 0) {
                return 'Durasi harus lebih dari 0';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Points Field
          TextFormField(
            controller: _pointsController,
            decoration: const InputDecoration(
              labelText: 'Points',
              hintText: 'Masukkan points',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.stars),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final points = int.tryParse(value);
                if (points == null) {
                  return 'Points tidak valid';
                }
                if (points < 0) {
                  return 'Points tidak boleh negatif';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Image URL Field
          TextFormField(
            controller: _imageUrlController,
            decoration: const InputDecoration(
              labelText: 'URL Gambar',
              hintText: 'Masukkan URL gambar service',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.image),
            ),
            keyboardType: TextInputType.url,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (value.length > 255) {
                  return 'URL maksimal 255 karakter';
                }
                // Basic URL validation
                if (!value.startsWith('http://') &&
                    !value.startsWith('https://')) {
                  return 'URL harus dimulai dengan http:// atau https://';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Image Preview
          if (_imageUrlController.text.isNotEmpty)
            Container(
              height: 200,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _imageUrlController.text,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text('Tidak dapat memuat gambar'),
                        ],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),

          // Is Active Switch
          Card(
            child: SwitchListTile(
              title: const Text('Status Aktif'),
              subtitle: Text(
                _isActive ? 'Service aktif' : 'Service tidak aktif',
              ),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
              secondary: Icon(
                _isActive ? Icons.check_circle : Icons.cancel,
                color: _isActive ? Colors.green : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Save Button
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      CreateServiceDto data = CreateServiceDto(
                        name: _nameController.text,
                        description: _descriptionController.text,
                        duration: int.parse(_durationController.text),
                        price: int.parse(_priceController.text),
                        isActive: _isActive ? 1 : 0,
                        image: _imageUrlController.text,
                        point: int.parse(_pointsController.text),
                      );
                      context.read<AddSpaServiceCubit>().createData(data);
                    }
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Simpan Service', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 16),

          // Cancel Button
          OutlinedButton(
            onPressed: isLoading ? null : () => Navigator.pop(context),
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
