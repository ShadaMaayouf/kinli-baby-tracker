import 'package:flutter/material.dart';
/*
use a Form with TextFormField, DropdownButton, and TimePicker
 */

class PumpingLogScreen extends StatefulWidget {
  const PumpingLogScreen({super.key});

  @override
  State<PumpingLogScreen> createState() => _PumpingLogScreenState();
}

class _PumpingLogScreenState extends State<PumpingLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final _leftBoobController = TextEditingController();
  final _rightBoobController = TextEditingController();
  final _noteController = TextEditingController();

  TimeOfDay? _startTime;
  bool _bothBoobs = true;

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  void _submitLog() {
    if (_formKey.currentState!.validate()) {
      final log = {
        'duration': _durationController.text,
        'left_ml': _leftBoobController.text,
        'right_ml': _rightBoobController.text,
        'start_time': _startTime?.format(context),
        'note': _noteController.text,
      };
      // TODO: Save to Firestore
      print('Pumping log: $log');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pumping session saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Pumping Session')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter duration' : null,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Pumped from both boobs?'),
                value: _bothBoobs,
                onChanged: (val) => setState(() => _bothBoobs = val),
              ),
              if (_bothBoobs || !_bothBoobs)
                TextFormField(
                  controller: _leftBoobController,
                  decoration: const InputDecoration(labelText: 'Left boob (ml)'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter amount' : null,
                ),
              if (_bothBoobs)
                TextFormField(
                  controller: _rightBoobController,
                  decoration: const InputDecoration(labelText: 'Right boob (ml)'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter amount' : null,
                ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(_startTime == null
                    ? 'Select start time'
                    : 'Start time: ${_startTime!.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: _pickStartTime,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitLog,
                child: const Text('Save Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
