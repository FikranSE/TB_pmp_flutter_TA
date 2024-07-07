import 'package:flutter/material.dart';
import 'package:tb_pmp/services/api.dart';

class AjukanSuratPage extends StatefulWidget {
  final String authToken;

  const AjukanSuratPage({Key? key, required this.authToken}) : super(key: key);

  @override
  _AjukanSuratPageState createState() => _AjukanSuratPageState();
}

class _AjukanSuratPageState extends State<AjukanSuratPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _requestDataController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final to = _toController.text;
      final position = _positionController.text;
      final organization = _organizationController.text;
      final address = _addressController.text;
      final requestData = _requestDataController.text;

      // Call the API
      final success = await ApiService().sendDataRequest(
        'your-thesis-id', // Replace with actual thesisId
        widget.authToken,
        to,
        position,
        organization,
        address,
        requestData,
      );

      if (success) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Data request sent successfully'),
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
              content: const Text('Failed to send data request'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Surat'),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _toController,
                decoration: InputDecoration(
                  labelText: 'To',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a recipient';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _positionController,
                decoration: InputDecoration(
                  labelText: 'Position',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a position';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _organizationController,
                decoration: InputDecoration(
                  labelText: 'Organization',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an organization';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _requestDataController,
                decoration: InputDecoration(
                  labelText: 'Request Data',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the request data';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(400, 50),
                  ),
                  child: const Text(
                    'Submit',
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
