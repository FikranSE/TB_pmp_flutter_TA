import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tb_pmp/models/detail.dart';
import 'package:tb_pmp/services/api.dart';
import 'package:tb_pmp/screen/registerTA.dart'; 
import 'package:tb_pmp/screen/editRegisterTA.dart'; 

class Detail extends StatefulWidget {
  final String authToken;
  final String thesisId;

  const Detail({
    Key? key,
    required this.authToken,
    required this.thesisId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late Future<Thesis> _thesisFuture;

  @override
  void initState() {
    super.initState();
    _thesisFuture = _fetchThesis();
  }

  Future<Thesis> _fetchThesis() async {
    try {
      final thesis = await ApiService().fetchThesisDetail(widget.authToken, widget.thesisId);
      return thesis;
    } catch (e) {
      throw Exception('Error fetching thesis: $e');
    }
  }

  void _navigateToEditPendaftaranTA() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => editPendaftaranTA(
          authToken: widget.authToken,
          thesisId: widget.thesisId,
          onUpdate: _updateThesisAfterEdit,
        ),
      ),
    );
  }

  void _updateThesisAfterEdit() {
    setState(() {
      _thesisFuture = _fetchThesis(); // Memuat ulang data setelah pengeditan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Tugas Akhir'),
        centerTitle: true,
        backgroundColor: Colors.green[200],
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEditPendaftaranTA,
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Tambahkan navigasi ke halaman profil di sini jika diperlukan
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<Thesis>(
          future: _thesisFuture,
          builder: (context, AsyncSnapshot<Thesis> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final thesis = snapshot.data!;
              return ListView(
                children: [
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            thesis.status == 0 ? 'Gagal' : 'Bimbingan',
                            style: TextStyle(
                              color: thesis.status == 0 ? Colors.red : Colors.green,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            thesis.title,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue[200],
                            ),
                            child: Text(
                              thesis.topicId ?? 'Unknown',
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Abstract: ${thesis.abstract ?? 'No abstract provided'}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Dosen Pembimbing: ${thesis.supervisors.map((supervisor) => supervisor.lecturerId).join(', ')}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tanggal Mulai: ${DateFormat('dd MMMM yyyy').format(thesis.startAt)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('Data tidak tersedia'));
            }
          },
        ),
      ),
    );
  }
}
