import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final SupabaseClient supabase = Supabase.instance.client;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        debugPrint('[UserProfile] No user is logged in.');
        return;
      }

      final userId = user.id;
      final response =
          await supabase
              .from('Users')
              .select()
              .eq('user_id', userId)
              .maybeSingle();

      if (response == null) return;

      if (!mounted) return;
      setState(() => userData = response);

      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString('driver_name', response['driver_name'] ?? 'Unknown'),
        prefs.setString('email', response['email'] ?? 'Unknown'),
        prefs.setString('profile_image', response['profile_image'] ?? ''),
        prefs.setString('phone', response['phone'] ?? 'Unknown'),
        prefs.setString('vehicle_name', response['vehicle_name'] ?? 'Unknown'),
      ]);
    } catch (e) {
      debugPrint('[UserProfile] Error: $e');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await supabase.auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed("home");
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(154, 0, 220, 168),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("home");
            },
          ),
        ),
        backgroundColor: const Color(0xFF0C1515),
        body:
            userData == null
                ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF01D5A2)),
                )
                : ListView(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(
                        '${userData?['driver_name']} - ${userData?['vehicle_name']}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      accountEmail: Text(
                        userData?['email'] ?? 'email@example.com',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                        child: ClipOval(
                          child:
                              (userData?['profile_image']?.isNotEmpty ?? false)
                                  ? FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/images/default-user-icon-23.jpg',
                                    image: userData!['profile_image'],
                                    fit: BoxFit.cover,
                                    width: 80,
                                    height: 80,
                                    imageErrorBuilder: (_, __, ___) {
                                      return Image.asset(
                                        'assets/images/default-user-icon-23.jpg',
                                        fit: BoxFit.cover,
                                        width: 80,
                                        height: 80,
                                      );
                                    },
                                  )
                                  : Image.asset(
                                    'assets/images/default-user-icon-23.jpg',
                                    fit: BoxFit.cover,
                                    width: 80,
                                    height: 80,
                                  ),
                        ),
                      ),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(154, 0, 220, 168),
                      ),
                    ),
                    const Divider(color: Colors.white24),
                    _buildListTile(
                      Icons.favorite_border_outlined,
                      'Suggestions',
                      () {},
                    ),
                    _buildListTile(Icons.feedback_outlined, 'Feedback', () {}),
                    _buildListTile(
                      Icons.support_agent_rounded,
                      'Support',
                      () {},
                    ),
                    _buildListTile(Icons.settings, 'Settings', () {}),
                    _buildListTile(Icons.logout, 'Logout', _logout),
                  ],
                ),
      ),
    );
  }

  ListTile _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color.from(
          alpha: 102,
          red: 0.004,
          green: 0.835,
          blue: 0.635,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }
}
