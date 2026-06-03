import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ContactSection extends StatefulWidget {
  @override
  _ContactSectionState createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _validateForm() {
    setState(() {
      _isValid = _formKey.currentState?.validate() ?? false;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Aqui você faria o envio real (ex: chamar API)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mensagem enviada com sucesso!')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Entre em contato",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            onChanged: _validateForm,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: FormBuilderValidators.required(),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                TextFormField(
                  controller: _messageController,
                  decoration: const InputDecoration(labelText: 'Mensagem'),
                  maxLines: 4,
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isValid ? _submitForm : null,
                  child: const Text("Get in touch"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}