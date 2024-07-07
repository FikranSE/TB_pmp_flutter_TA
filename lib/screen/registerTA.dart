import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tb_pmp/screen/ListScreen.dart';
import 'dart:convert';

import 'package:tb_pmp/services/api.dart';

class PendaftaranTA extends StatefulWidget {
  final String authToken;
  final String thesisId;
  final Function onUpdate;

  const PendaftaranTA({
    Key? key,
    required this.authToken,
    required this.thesisId,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PendaftaranTAState();
}

class _PendaftaranTAState extends State<PendaftaranTA> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _abstractController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _registerThesis() async {
    if (_formKey.currentState!.validate()) {
      try {
        final success = await ApiService().registerTA({
          'title': _titleController.text,
          'abstract': _abstractController.text,
          'topic_id': '9c483d5a-2795-4ac7-b1ad-a1b47667a384',
        }, widget.authToken);

        if (success) {
          widget.onUpdate(); // Panggil fungsi onUpdate untuk update data
          Navigator.pop(context); // Kembali ke halaman sebelumnya setelah sukses
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Thesis registered successfully'),
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
          debugPrint('Thesis registered successfully');
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Failed to register thesis'),
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
          debugPrint('Failed to register thesis');
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
        title: const Text('Pendaftaran TA'),
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
                  onPressed: () {
                    _registerThesis();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(400, 50),
                  ),
                  child: const Text(
                    'Daftar',
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