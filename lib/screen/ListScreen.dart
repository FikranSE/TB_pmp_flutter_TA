import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tb_pmp/models/profile.dart';
import 'package:tb_pmp/models/theses.dart';
import 'package:tb_pmp/screen/detail.dart';
import 'package:tb_pmp/screen/ajukansurat.dart';
import 'package:tb_pmp/screen/registerTA.dart';
import 'package:tb_pmp/screen/profile.dart'; // Import ProfileScreen
import 'package:tb_pmp/services/api.dart';

class ListScreen extends StatefulWidget {
  final String authToken;

  const ListScreen({Key? key, required this.authToken}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List<Theses>> _thesesList;
  late Future<DateTime> _currentDate;
  late Future<Profile?> _profileFuture; // Future to fetch profile data

  @override
  void initState() {
    super.initState();
    _fetchThesesAndCurrentDate();
    _fetchProfile(); // Fetch profile data when screen initializes
  }

  void _fetchThesesAndCurrentDate() {
    _thesesList = ApiService().fetchTheses(widget.authToken);
    _currentDate = Future.value(DateTime.now());
  }

  void _fetchProfile() {
    _profileFuture = ApiService().fetchProfile(widget.authToken);
  }

  void updateThesesList() {
    setState(() {
      _fetchThesesAndCurrentDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          FutureBuilder<Profile?>(
            future: _profileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                final profile = snapshot.data!;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          profile: profile,
                          authToken: widget.authToken,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: profile.photo != null
                              ? NetworkImage(profile.photo)
                              : AssetImage('profile.jpg') as ImageProvider,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'No Profile',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Tampilan untuk layar lebar (tablet/desktop)
            return _buildListView(true);
          } else {
            // Tampilan untuk layar sempit (mobile)
            return _buildListView(false);
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF49454F),
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PendaftaranTA(
                          authToken: widget.authToken,
                          onUpdate: updateThesesList,
                          thesisId: '',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.note_add,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AjukanSuratPage(
                          authToken: widget.authToken,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.mail,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    // Tindakan ketika tombol List TA ditekan
                  },
                  icon: const Icon(
                    Icons.list,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(bool isWideScreen) {
    return FutureBuilder<List<Theses>>(
      future: _thesesList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final thesis = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: const Color(0xFF49454F),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            thesis.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Tanggal Pendaftaran: ${thesis.startAt != null ? DateFormat('dd MMMM yyyy').format(thesis.startAt!) : DateFormat('dd MMMM yyyy').format(DateTime.now())}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isWideScreen)
                      Container(
                        width: double.infinity,
                        color: const Color.fromARGB(255, 199, 198, 198),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Detail(
                                      authToken: widget.authToken,
                                      thesisId: thesis.id,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Detail',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
