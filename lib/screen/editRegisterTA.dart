import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tb_pmp/services/api.dart'; // Sesuaikan dengan lokasi ApiService Anda
import 'dart:convert';

class editPendaftaranTA extends StatefulWidget {
  final String authToken;
  final String thesisId;
  final Function onUpdate; // Callback untuk memperbarui data setelah edit

  const editPendaftaranTA({
    Key? key,
    required this.authToken,
    required this.thesisId,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PendaftaranTAState();
}

class _PendaftaranTAState extends State<editPendaftaranTA> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _abstractController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchThesisDetails();
  }

  void _fetchThesisDetails() async {
  try {
    final thesis = await ApiService().fetchThesisDetail(widget.authToken, widget.thesisId);
    _titleController.text = thesis.title ?? '';
    _abstractController.text = thesis.abstract  ?? ''; // Ensure correct property name
  } catch (e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to fetch thesis details: $e'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


  void _updateThesis() async {
    if (_formKey.currentState!.validate()) {
      try {
        final success = await ApiService().updateThesis({
          'title': _titleController.text,
          'abstract': _abstractController.text,
          'topic_id': '9c483d5a-2795-4ac7-b1ad-a1b47667a384', // Ganti dengan topicId yang sesuai
        }, widget.authToken, widget.thesisId);

        if (success) {
          // Panggil callback untuk memperbarui data di halaman Detail
          widget.onUpdate();
          Navigator.pop(context); // Kembali ke halaman Detail setelah berhasil update
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Thesis updated successfully'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Failed to update thesis'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Exception occurred: $e'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        debugPrint('Exception occurred: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pendaftaran TA'),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _abstractController,
                decoration: InputDecoration(
                  labelText: 'Abstract',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Abstract tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _updateThesis,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(400, 50),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}