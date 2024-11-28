import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_smarcerti/app/modules/sertifikasi/controllers/sertifikasi_controller.dart';
import 'package:mobile_smarcerti/app/modules/sertifikasi/views/add_sertifikasi_page.dart';
import 'package:mobile_smarcerti/app/modules/sertifikasi/views/detail_sertifikasi_page.dart';

class ListSertifikasi extends StatelessWidget {
  ListSertifikasi({super.key});
  final SertifikasiController controller = Get.put(SertifikasiController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Row untuk Search bar dan Filter button
            Row(
              children: [
                // Search bar
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari Sertifikasi',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fillColor: const Color.fromARGB(145, 255, 249, 249),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Spasi antara search dan tombol filter

                // Tombol Filter
                Container(
                  height: 54,
                  width: 48,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(145, 255, 249, 249),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    color: Colors.grey[700],
                    onPressed: () {
                      // Aksi tombol Filter
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Opsi Filter"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: const Text("Filter Berdasarkan Tanggal"),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  title: const Text("Filter Berdasarkan Lokasi"),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Daftar Sertifikasi
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.sertifikasis.isEmpty) {
                  return const Center(
                    child: Text("Tidak ada sertifikasi tersedia."),
                  );
                }

                // Gabungkan semua data sertifikasi
                var allData = controller.sertifikasis.toList();

                return ListView.builder(
                  itemCount: allData.length,
                  itemBuilder: (context, index) {
                    final sertifikasi = allData[index];

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(
                          Icons.verified,
                          size: 35.0,
                          color: Color.fromARGB(255, 55, 94, 151),
                        ),
                        title: Text(
                          sertifikasi.namaSertifikasi,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 55, 94, 151), // Warna title diperbarui
                          ),
                        ),
                        subtitle: Text(
                          "Tanggal: ${sertifikasi.tanggal.toLocal()}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 55, 94, 151),
                            ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailSertifikasiPage(
                                idSertifikasi: sertifikasi.idSertifikasi,
                              ),
                            ),
                          );
                        },

                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20.0,
                          color: Color.fromARGB(255, 55, 94, 151),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi ketika tombol "Upload" ditekan
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  AddSertifikasiPage(),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 239, 84, 40),
        foregroundColor: Colors.white, // Mengubah warna ikon menjadi putih
        child: const Icon(Icons.add),
      ),
    );
  }
}