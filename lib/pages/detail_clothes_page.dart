import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailClothesPage extends StatefulWidget {
  final int id;
  final bool isFavorite;
  final Function(bool) onFavoriteChanged;

  const DetailClothesPage({
    super.key,
    required this.id,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  State<DetailClothesPage> createState() => _DetailClothesPageState();
}

class _DetailClothesPageState extends State<DetailClothesPage> {
  Map<String, dynamic>? clothesData;
  bool isLoading = true;
  String? errorMessage;
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
    fetchClothingDetail();
  }

  Future<void> fetchClothingDetail() async {
    final url = Uri.parse(
        'https://tpm-api-tugas-872136705893.us-central1.run.app/api/clothes/${widget.id}');
    try {
      final response = await http.get(url);
      if (!mounted) return;
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          clothesData = json['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = jsonDecode(response.body)['message'];
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Failed to load data 😢";
        isLoading = false;
      });
    }
  }

  String formatPrice(int price) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          clothesData?['name'] ?? 'Loading...',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              widget.onFavoriteChanged(isFavorite);
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.deepPurple[50],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                )
              : Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.checkroom,
                                size: 80, color: Colors.deepPurple),
                            const SizedBox(height: 10),
                            Text(
                              clothesData?['brand'] ?? '-',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              clothesData?['name'] ?? '-',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            _buildDetailItem(
                                "Category", clothesData?['category'] ?? '-'),
                            _buildDetailItem("Price",
                                formatPrice(clothesData?['price'] ?? 0)),
                            _buildDetailItem("Rating",
                                clothesData?['rating']?.toString() ?? '-'),
                            _buildDetailItem("Sold",
                                clothesData?['sold']?.toString() ?? '-'),
                            _buildDetailItem("Stock",
                                clothesData?['stock']?.toString() ?? '-'),
                            _buildDetailItem(
                                "Year Released",
                                clothesData?['yearReleased']?.toString() ??
                                    '-'),
                            _buildDetailItem(
                                "Material", clothesData?['material'] ?? '-'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _getIconForTitle(title),
            color: Colors.deepPurple[300],
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case "Price":
        return Icons.attach_money;
      case "Category":
        return Icons.category;
      case "Rating":
        return Icons.star_rate;
      case "Sold":
        return Icons.shopping_bag;
      case "Stock":
        return Icons.inventory;
      case "Year Released":
        return Icons.calendar_today;
      case "Material":
        return Icons.layers;
      default:
        return Icons.info_outline;
    }
  }
}
