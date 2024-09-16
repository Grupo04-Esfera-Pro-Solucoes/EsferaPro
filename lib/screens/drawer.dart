import 'package:esferapro/screens/dashbord.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'clientes.dart';
import 'help.dart';
import 'tasks.dart';

class CustomDrawer extends StatefulWidget {
  final Widget currentPage;
  final void Function(Widget page, String title) onSelectPage;

  const CustomDrawer({required this.currentPage, required this.onSelectPage});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int _selectedIndex = 0;
  int? userId;

  @override
  void initState() {
    super.initState();
    _updateSelectedIndex(widget.currentPage);
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  void _updateSelectedIndex(Widget page) {
    if (page is HomeScreen) {
      setState(() {
        _selectedIndex = 0;
      });
    } else if (page is ClientPage) {
      setState(() {
        _selectedIndex = 1;
      });
    } else if (page is TasksPage) {
      setState(() {
        _selectedIndex = 4;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 150.0,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6502D4), Color(0xFF34016E)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                ),
              ),
              child: Container(),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _buildDrawerItem(
                  index: 0,
                  icon: Icons.dashboard_outlined,
                  text: 'Dashboard',
                  page: Dashboard(),
                  title: 'Dashboard',
                  context: context,
                ),
                _buildDrawerItem(
                  index: 1,
                  icon: Icons.person_add,
                  text: 'Clientes',
                  page: ClientPage(),
                  title: 'Clientes',
                  context: context,
                ),
                _buildDrawerItem(
                  index: 2,
                  icon: Icons.phone,
                  text: 'Ligações',
                  page: Container(),
                  title: 'Ligações',
                  context: context,
                ),
                _buildDrawerItem(
                  index: 3,
                  icon: Icons.description_outlined,
                  text: 'Propostas',
                  page: Container(),
                  title: 'Propostas',
                  context: context,
                ),
                if (userId != null)
                  _buildDrawerItem(
                    index: 4,
                    icon: Icons.table_chart,
                    text: 'Tarefas',
                    page: const TasksPage(),
                    title: 'Tarefas',
                    context: context,
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 6;
                });
                widget.onSelectPage(HelpPage(), 'Ajuda');
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.help_outline,
                      color: Color(0xFF98A2B3),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 6;
                      });
                      widget.onSelectPage(HelpPage(), 'Ajuda');
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 4.0),
                  const Text(
                    'Ajuda',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF98A2B3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required int index,
    required IconData icon,
    required String text,
    required Widget page,
    required String title,
    required BuildContext context,
  }) {
    bool isSelected = _selectedIndex == index;

    return Column(
      children: [
        Container(
          height: 70.0,
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF6502D4), Color(0xFF34016E)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
          ),
          child: Align(
            alignment: Alignment.center,
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 24.0),
              leading: Icon(
                icon,
                color: isSelected ? Colors.amber : const Color(0xFF6502D4),
              ),
              title: Text(
                text,
                style: TextStyle(
                  fontSize: 20.0,
                  color: isSelected ? Colors.amber : const Color(0xFF6502D4),
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onSelectPage(page, title);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }
}