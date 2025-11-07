import 'package:express/data/models/user_model.dart';
import 'package:express/logic/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/screens/login_page.dart';

class DashboardPage extends StatelessWidget {
  final UserModel user;

  const DashboardPage({super.key, required this.user});
  String capitalize(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  void _showProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.95,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  height: 5,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 20),
                const Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 10),
                Text(
                  "${capitalize(user.firstName)} ${capitalize(user.lastName)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(user.email, style: const TextStyle(color: Colors.grey)),
                const Divider(height: 40, thickness: 4),
                Expanded(
                  child: ListView(
                    children: [
                      _buildProfileRow(
                        "First Name",
                        capitalize(user.firstName),
                      ),
                      _buildProfileRow("Last Name", capitalize(user.lastName)),
                      _buildProfileRow("Role", capitalize(user.role)),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<AuthCubit>().logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text("Logout"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Welcome, ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: capitalize(user.firstName),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () => _showProfileSheet(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to Kuza Dashboard',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
