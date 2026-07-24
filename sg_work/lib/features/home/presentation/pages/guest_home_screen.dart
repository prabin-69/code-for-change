import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchService() {
    final query = searchController.text.trim();

    if (query.isEmpty) return;

    context.push(
      '/search',
      extra: query,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SewaGhar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Connecting Skills\nWith People",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: searchController,
                    onSubmitted: (_) => searchService(),
                    decoration: InputDecoration(
                      hintText: "Search services...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: searchService,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _sectionTitle("Popular Services"),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _serviceCard("🔧 Plumbing"),
                _serviceCard("⚡ Electrician"),
                _serviceCard("🧹 Cleaning"),
                _serviceCard("❄️ AC Repair"),
              ],
            ),

            const SizedBox(height: 30),

            _sectionTitle("Top Professionals"),

            _professionalCard(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
            //Home
              break;

            case 1:
            //Search
              searchService();
              break;

            case 2:
            //Booking 
            _showLogin();
            break;

            case 3:
            //Chat
            _showLogin();
            break;

            case 4:
            //Profile
            _showLogin();
            break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
           BottomNavigationBarItem(
           icon: Icon(Icons.calendar_month),
           label: "Booking",
          ),
          BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),

        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _serviceCard(String name) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(name),
      ),
    );
  }

  Widget _professionalCard() {
    return Card(
      margin: const EdgeInsets.all(15),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const ListTile(
              leading: CircleAvatar(
                radius: 28,
                child: Icon(Icons.person),
              ),
              title: Text(
                "Ram Bahadur",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Plumber\n⭐ 4.9",
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.visibility),
                    label: const Text("View"),
                    onPressed: () {
                      context.push(
                        '/professional-preview',
                        extra: {
                          'name': 'Ram Bahadur',
                          'profession': 'Plumber',
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogin() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const  Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.orange),
            SizedBox(width: 8),
            Text("Login Required"),
          ],
        ),

        content: const Text("Please login to continue."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          SizedBox(
            width: 120,
            child: ElevatedButton(
            onPressed:(){
              Navigator.pop(context);
              context.push('/phone-login');
            },
            child: const Text("Login"),
          ),
          ),
        ],
      ),
    );
  }
}