import 'package:flutter/material.dart';
import 'package:proyecto/screens/create_tickets_screen.dart';
import 'package:proyecto/screens/home_screen.dart';
import 'package:proyecto/screens/tickets_view_list.dart';
import 'package:proyecto/widgets/app_bar.dart';

class DownMenu extends StatefulWidget {
  const DownMenu({super.key});

  @override
  State<DownMenu> createState() => _DownMenuState();
}

class _DownMenuState extends State<DownMenu> {
  int selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lista de pantallas
    final screens = [
      const TicketListScreen(),
      const CreateTicketsScreen(),
    ];

    return Scaffold(
      appBar: const BarraApp(titulo: "Oirs Utem", showLeading: false),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            activeIcon: Icon(Icons.message_rounded),
            label: 'Crear Tickets',
            backgroundColor: Color.fromARGB(255, 128, 53, 141),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            activeIcon: Icon(Icons.list_rounded),
            label: 'Lista de Tickets',
            backgroundColor: Color.fromARGB(255, 128, 53, 141),
          ),
        ],
      ),
    );
  }
}
