import 'package:flutter/material.dart';

import '../../models/service_model.dart';

class ServicePickerPage extends StatefulWidget {
  final List<Service> serviceList;
  final String initialPicked;

  const ServicePickerPage({
    super.key,
    required this.serviceList,
    required this.initialPicked,
  });

  @override
  State<ServicePickerPage> createState() => _ServicePickerPageState();
}

class _ServicePickerPageState extends State<ServicePickerPage> {
  late Map<int, bool> _selected; // key: serviceId, value: selected
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _selected = {
      for (final s in widget.serviceList)
        s.id: (widget.initialPicked.contains('${s.id},') ? true : false),
    };
  }

  void _toggleSelectAll(bool? value) {
    final v = value ?? false;
    setState(() {
      _selectAll = v;
      _selected.updateAll((key, old) => v);
    });
  }

  void _toggleItem(int id, bool? value) {
    setState(() {
      _selected[id] = value ?? false;
      // update state of selectAll
      _selectAll = _selected.values.every((e) => e);
    });
  }

  void _onSelectPressed() {
    final selectedIds = _selected.entries
        .where((e) => e.value)
        .map((e) => e.key.toString())
        .join(','); // "1,3,5"
    Navigator.pop(context, '$selectedIds,'); // return as String
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Services')),
      body: Column(
        children: [
          CheckboxListTile(
            title: const Text('Select all'),
            value: _selectAll,
            onChanged: _toggleSelectAll,
          ),
          const Divider(height: 0),
          Expanded(
            child: ListView.builder(
              itemCount: widget.serviceList.length,
              itemBuilder: (context, index) {
                final service = widget.serviceList[index];
                final checked = _selected[service.id] ?? false;

                return CheckboxListTile(
                  title: Text(service.name),
                  value: checked,
                  onChanged: (v) => _toggleItem(service.id, v),
                ); // [web:43][web:51]
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSelectPressed,
                  child: const Text('Select'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
