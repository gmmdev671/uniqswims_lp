import 'package:flutter/material.dart';

class ContactSection extends StatefulWidget {
  final Key? sectionKey;
  final Future<void> Function(Map<String, String> data)? onSubmit;

  const ContactSection({Key? key, this.sectionKey, this.onSubmit}) : super(key: key);

  @override
  _ContactSectionState createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false;
  bool _isSubmitting = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isValid = _formKey.currentState?.validate() ?? false;
    });
  }

  bool _isEmailValid(String? v) {
    if (v == null || v.trim().isEmpty) return false;
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return regex.hasMatch(v.trim());
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _validateForm();
      return;
    }

    setState(() => _isSubmitting = true);

    final payload = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'message': _messageController.text.trim(),
    };

    try {
      if (widget.onSubmit != null) {
        await widget.onSubmit!(payload);
      } else {
        // Default behavior: mostrar snackbar (substitua pela sua lógica)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mensagem enviada com sucesso!')),
        );
      }
      // limpar formulário após envio bem-sucedido
      _formKey.currentState?.reset();
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
      setState(() => _isValid = false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar: ${e.toString()}')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  InputDecoration _inputDecoration(String label, ColorScheme cs, TextStyle? labelStyle) {
    return InputDecoration(
      labelText: label,
      labelStyle: labelStyle,
      filled: true,
      fillColor: cs.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: cs.onSurface.withOpacity(0.06)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: cs.error, width: 1.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final isMobile = maxWidth < 800;

      return Container(
        key: widget.sectionKey,
        width: double.infinity,
        color: cs.background,
        padding: EdgeInsets.symmetric(vertical: isMobile ? 28 : 72, horizontal: isMobile ? 20 : 48),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // underline + title
              Align(
                alignment: Alignment.centerLeft,
                child: Container(width: 64, height: 4, color: cs.onSurface, margin: const EdgeInsets.only(bottom: 12)),
              ),
              Text(
                'Entre em contato',
                style: (tt.headlineMedium ?? const TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
                    .copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: 18),

              // Card container
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: EdgeInsets.all(isMobile ? 18 : 28),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 8))],
                  border: Border.all(color: cs.onSurface.withOpacity(0.04)),
                ),
                child: Form(
                  key: _formKey,
                  onChanged: _validateForm,
                  child: isMobile ? _buildMobileForm(cs, tt) : _buildDesktopForm(cs, tt),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMobileForm(ColorScheme cs, TextTheme tt) {
    final labelStyle = tt.labelLarge?.copyWith(color: cs.onSurface.withOpacity(0.85));
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: _inputDecoration('Nome', cs, labelStyle),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Digite seu nome' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          decoration: _inputDecoration('Email', cs, labelStyle),
          keyboardType: TextInputType.emailAddress,
          validator: (v) => _isEmailValid(v) ? null : 'Email inválido',
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _messageController,
          decoration: _inputDecoration('Mensagem', cs, labelStyle).copyWith(hintText: 'Como podemos ajudar?'),
          maxLines: 6,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Escreva uma mensagem' : null,
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: (_isValid && !_isSubmitting) ? _submitForm : null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled)) return cs.onSurface.withOpacity(0.12);
                return cs.primary;
              }),
              foregroundColor: MaterialStateProperty.all(cs.onPrimary),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
            child: _isSubmitting ? const CircularProgressIndicator.adaptive() : Text('Get in touch', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopForm(ColorScheme cs, TextTheme tt) {
    final labelStyle = tt.labelLarge?.copyWith(color: cs.onSurface.withOpacity(0.85));
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Nome', cs, labelStyle),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Digite seu nome' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _emailController,
                decoration: _inputDecoration('Email', cs, labelStyle),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => _isEmailValid(v) ? null : 'Email inválido',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _messageController,
          decoration: _inputDecoration('Mensagem', cs, labelStyle).copyWith(hintText: 'Como podemos ajudar?'),
          maxLines: 6,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Escreva uma mensagem' : null,
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: (_isValid && !_isSubmitting) ? _submitForm : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.disabled)) return cs.onSurface.withOpacity(0.12);
                      return cs.primary;
                    }),
                    foregroundColor: MaterialStateProperty.all(cs.onPrimary),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                  child: _isSubmitting ? const CircularProgressIndicator.adaptive() : Text('Get in touch', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // small helper / contact info box
            Container(
              width: 220,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: cs.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: cs.onSurface.withOpacity(0.04)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Or call us', style: tt.labelLarge?.copyWith(color: cs.onSurface.withOpacity(0.9))),
                  const SizedBox(height: 6),
                  Text('+1 (407) 555-0123', style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
                  const SizedBox(height: 8),
                  Text('support@uniqswims.com', style: tt.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.9))),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}