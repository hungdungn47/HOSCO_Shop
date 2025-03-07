import 'package:flutter/material.dart';

class CustomerDialog extends StatefulWidget {
  final Function(String name, String phone, String email, String address) onSubmit;
  final String? initialName, initialPhone, initialEmail, initialAddress;

  const CustomerDialog({
    Key? key,
    required this.onSubmit,
    this.initialName,
    this.initialPhone,
    this.initialEmail,
    this.initialAddress,
  }) : super(key: key);

  @override
  _CustomerDialogState createState() => _CustomerDialogState();
}

class _CustomerDialogState extends State<CustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName ?? "";
    _phoneController.text = widget.initialPhone ?? "";
    _emailController.text = widget.initialEmail ?? "";
    _addressController.text = widget.initialAddress ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add / Edit Customer"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField("Name", _nameController, (value) {
              if (value == null || value.isEmpty) return "Name is required";
              return null;
            }),
            _buildTextField("Phone", _phoneController, (value) {
              if (value == null || value.isEmpty) return "Phone is required";
              if (!RegExp(r'^\d{10,11}$').hasMatch(value)) return "Invalid phone number";
              return null;
            }),
            _buildTextField("Email", _emailController, (value) {
              if (value == null || value.isEmpty) return "Email is required";
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Invalid email";
              return null;
            }),
            _buildTextField("Address", _addressController, (value) {
              if (value == null || value.isEmpty) return "Address is required";
              return null;
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(
                _nameController.text,
                _phoneController.text,
                _emailController.text,
                _addressController.text,
              );
              Navigator.of(context).pop();
            }
          },
          child: Text("Save"),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String? Function(String?) validator) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
