import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateClothingPage extends StatefulWidget {
  final int clothingId;

  const UpdateClothingPage({super.key, required this.clothingId});

  @override
  State<UpdateClothingPage> createState() => _UpdateClothingPageState();
}

class _UpdateClothingPageState extends State<UpdateClothingPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _brandController = TextEditingController();
  final _soldController = TextEditingController();
  final _ratingController = TextEditingController();
  final _stockController = TextEditingController();
  final _yearReleasedController = TextEditingController();
  final _materialController = TextEditingController();

  final String baseUrl =
      'https://tpm-api-tugas-872136705893.us-central1.run.app';

  @override
  void initState() {
    super.initState();
    fetchClothingData();
  }

  Future<void> fetchClothingData() async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/clothes/${widget.clothingId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      setState(() {
        _nameController.text = data['name'];
        _priceController.text = data['price'].toString();
        _categoryController.text = data['category'];
        _brandController.text = data['brand'];
        _soldController.text = data['sold'].toString();
        _ratingController.text = data['rating'].toString();
        _stockController.text = data['stock'].toString();
        _yearReleasedController.text = data['yearReleased'].toString();
        _materialController.text = data['material'];
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil data pakaian')),
      );
    }
  }

  Future<void> updateClothing() async {
    if (!_formKey.currentState!.validate()) return;

    final body = jsonEncode({
      "name": _nameController.text,
      "price": int.parse(_priceController.text),
      "category": _categoryController.text,
      "brand": _brandController.text,
      "sold": int.parse(_soldController.text),
      "rating": double.parse(_ratingController.text),
      "stock": int.parse(_stockController.text),
      "yearReleased": int.parse(_yearReleasedController.text),
      "material": _materialController.text,
    });

    final response = await http.put(
      Uri.parse('$baseUrl/api/clothes/${widget.clothingId}'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    final resBody = json.decode(response.body);

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resBody['message'])),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resBody['message'])),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        validator: (value) =>
            value == null || value.isEmpty ? '$label tidak boleh kosong' : null,
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
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _brandController.dispose();
    _soldController.dispose();
    _ratingController.dispose();
    _stockController.dispose();
    _yearReleasedController.dispose();
    _materialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Perbarui Data Pakaian',
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
              _buildTextField('Name', _nameController),
              _buildTextField('Price', _priceController,
                  keyboardType: TextInputType.number),
              _buildTextField('Category', _categoryController),
              _buildTextField('Brand', _brandController),
              _buildTextField('Sold', _soldController,
                  keyboardType: TextInputType.number),
              _buildTextField('Rating', _ratingController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true)),
              _buildTextField('Stock', _stockController,
                  keyboardType: TextInputType.number),
              _buildTextField('Year Released', _yearReleasedController,
                  keyboardType: TextInputType.number),
              _buildTextField('Material', _materialController),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: updateClothing,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
