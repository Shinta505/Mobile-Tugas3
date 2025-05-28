import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateClothingPage extends StatefulWidget {
  const CreateClothingPage({super.key});

  @override
  State<CreateClothingPage> createState() => _CreateClothingPageState();
}

class _CreateClothingPageState extends State<CreateClothingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _soldController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _yearReleasedController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();

  String _message = '';

  Future<void> _createClothing() async {
    final url = Uri.parse(
        'https://tpm-api-tugas-872136705893.us-central1.run.app/api/clothes');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': _nameController.text,
        'price': int.tryParse(_priceController.text),
        'category': _categoryController.text,
        'brand': _brandController.text,
        'sold': int.tryParse(_soldController.text),
        'rating': double.tryParse(_ratingController.text),
        'stock': int.tryParse(_stockController.text),
        'yearReleased': int.tryParse(_yearReleasedController.text),
        'material': _materialController.text,
      }),
    );

    final responseBody = jsonDecode(response.body);
    setState(() {
      _message = responseBody['message'] ?? 'Unexpected error';
    });

    if (response.statusCode == 201) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Clothing added successfully!')),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $_message')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50], // Latar belakang lembut
      appBar: AppBar(
        title: const Text('Tambah Daftar Pakaian',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nameController, 'Name'),
              _buildTextField(_priceController, 'Price', isNumber: true),
              _buildTextField(_categoryController, 'Category'),
              _buildTextField(_brandController, 'Brand'),
              _buildTextField(_soldController, 'Sold', isNumber: true),
              _buildTextField(_ratingController, 'Rating (0-5)',
                  isDecimal: true),
              _buildTextField(_stockController, 'Stock', isNumber: true),
              _buildTextField(_yearReleasedController, 'Year Released',
                  isNumber: true),
              _buildTextField(_materialController, 'Material'),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createClothing();
                  }
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 10),
              Text(_message, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false, bool isDecimal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber
            ? TextInputType.number
            : isDecimal
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return '$label cannot be empty';
          if (isNumber && int.tryParse(value) == null) {
            return '$label must be a valid number';
          }
          if (isDecimal && double.tryParse(value) == null) {
            return '$label must be a valid decimal';
          }
          return null;
        },
      ),
    );
  }
}
