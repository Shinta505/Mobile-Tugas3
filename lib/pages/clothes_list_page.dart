import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'create_clothing_page.dart';
import 'update_clothing_page.dart';
import 'detail_clothes_page.dart';

class ClothesListPage extends StatefulWidget {
  const ClothesListPage({super.key});

  @override
  State<ClothesListPage> createState() => _ClothesListPageState();
}

class _ClothesListPageState extends State<ClothesListPage> {
  List<dynamic> clothesList = [];
  bool isLoading = true;
  String? errorMessage;
  Set<int> favoriteIds = {};
  bool showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    fetchClothes();
  }

  Future<void> fetchClothes() async {
    final url = Uri.parse(
        'https://tpm-api-tugas-872136705893.us-central1.run.app/api/clothes');
    try {
      final response = await http.get(url);
      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          clothesList = data['data'];
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
        errorMessage = "Gagal memuat data 😢";
        isLoading = false;
      });
    }
  }

  Future<void> deleteClothing(int id) async {
    final url = Uri.parse(
        'https://tpm-api-tugas-872136705893.us-central1.run.app/api/clothes/$id');
    final response = await http.delete(url);
    if (!mounted) return;
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pakaian berhasil dihapus")),
      );
      fetchClothes();
    } else {
      final error = jsonDecode(response.body)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus: $error")),
      );
    }
  }

  void showDeleteConfirmation(int id, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: Text("Apakah anda yakin ingin menghapus $name?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                deleteClothing(id);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );
  }

  void showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah anda yakin ingin logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = showFavoritesOnly
        ? clothesList.where((item) => favoriteIds.contains(item['id'])).toList()
        : clothesList;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            const Text('Daftar Pakaian', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            tooltip: "Tampilkan Favorite",
            onPressed: () {
              setState(() {
                showFavoritesOnly = !showFavoritesOnly;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Logout",
            onPressed: showLogoutConfirmation,
          ),
        ],
      ),
      backgroundColor: Colors.deepPurple,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    final isFav = favoriteIds.contains(item['id']);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailClothesPage(
                                id: int.parse(item['id'].toString()),
                                isFavorite: isFav,
                                onFavoriteChanged: (fav) {
                                  setState(() {
                                    if (fav) {
                                      favoriteIds.add(item['id']);
                                    } else {
                                      favoriteIds.remove(item['id']);
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: const CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.deepPurple,
                              child: Icon(Icons.checkroom, color: Colors.white),
                            ),
                            title: Text(
                              item['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text("Harga: Rp ${item['price']}",
                                    style:
                                        const TextStyle(color: Colors.black87)),
                                Text("Kategori: ${item['category']}",
                                    style:
                                        const TextStyle(color: Colors.black87)),
                                Text("Rating: ${item['rating']}",
                                    style:
                                        const TextStyle(color: Colors.black87)),
                              ],
                            ),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (isFav) {
                                        favoriteIds.remove(item['id']);
                                      } else {
                                        favoriteIds.add(item['id']);
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => UpdateClothingPage(
                                            clothingId: item['id']),
                                      ),
                                    ).then((_) => fetchClothes());
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => showDeleteConfirmation(
                                      item['id'], item['name']),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateClothingPage()),
          ).then((_) => fetchClothes());
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.deepPurple),
      ),
    );
  }
}
