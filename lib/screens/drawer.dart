import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'clientes.dart';
import 'help.dart';

class CustomDrawer extends StatefulWidget {
  final Widget currentPage;
  final void Function(Widget page, String title) onSelectPage;

  CustomDrawer({required this.currentPage, required this.onSelectPage});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _updateSelectedIndex(widget.currentPage);
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
              decoration: BoxDecoration(
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
                  page: HomeScreen(),
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
                _buildDrawerItem(
                  index: 4,
                  icon: Icons.table_chart,
                  text: 'Tarefas',
                  page: Container(),
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
                    icon: Icon(
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
                  SizedBox(width: 4.0),
                  Text(
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
                ? LinearGradient(
                    colors: [Color(0xFF6502D4), Color(0xFF34016E)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
          ),
          child: Align(
            alignment: Alignment.center,
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 24.0),
              leading: Icon(
                icon,
                color: isSelected ? Colors.amber : Color(0xFF6502D4),
              ),
              title: Text(
                text,
                style: TextStyle(
                  fontSize: 20.0,
                  color: isSelected ? Colors.amber : Color(0xFF6502D4),
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