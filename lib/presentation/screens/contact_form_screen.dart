// lib/presentation/screens/contact_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/contact.dart';
import '../blocs/contacts_form/contact_form_cubit.dart';

class ContactFormScreen extends StatefulWidget {
  final Contact? existing;
  const ContactFormScreen({super.key, this.existing});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late final _name = TextEditingController(text: widget.existing?.name);
  late final _email = TextEditingController(text: widget.existing?.email);
  late final _phone = TextEditingController(text: widget.existing?.phone);
  late final _company = TextEditingController(text: widget.existing?.company);

  bool _offline = false;

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit contact' : 'Create contact')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SwitchListTile(
                title: const Text('Work offline (queue sync)'),
                value: _offline,
                onChanged: (v) => setState(() => _offline = v),
              ),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name *'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  final ok = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$').hasMatch(v);
                  return ok ? null : 'Invalid email';
                },
              ),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  final ok = RegExp(r'^[0-9+]+$').hasMatch(v);
                  return ok ? null : 'Digits/+ only';
                },
              ),
              TextFormField(
                controller: _company,
                decoration: const InputDecoration(labelText: 'Company'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final now = DateTime.now();
                  final c = (widget.existing ??
                      Contact(id: _uuid.v4(), name: '', updatedAt: now))
                      .copyWith(
                    name: _name.text.trim(),
                    email: _email.text.trim().isEmpty ? null : _email.text.trim(),
                    phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
                    company: _company.text.trim().isEmpty ? null : _company.text.trim(),
                  );
                  await context.read<ContactFormCubit>().save(c, offline: _offline);
                  if (mounted) Navigator.pop(context);
                },
                child: Text(isEdit ? 'Save' : 'Create'),
              ),
              if (isEdit)
                TextButton(
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete contact?'),
                        content: const Text('This will tombstone locally and sync later.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await context.read<ContactFormCubit>().delete(widget.existing!, offline: _offline);
                      if (mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
