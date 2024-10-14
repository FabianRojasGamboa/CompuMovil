import 'package:flutter/material.dart';
import 'package:proyecto/screens/create_tickets.dart';
import 'package:proyecto/screens/home_screen.dart';
import 'package:proyecto/screens/view_list.dart';

class DownMenu extends StatefulWidget {
  const DownMenu({super.key});

  @override
  State<DownMenu> createState() => _DownMenuState();
}

class _DownMenuState extends State<DownMenu> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Lista de pantallas
    final screens = [
      const HomeScreen(),
      const CreateTickets(),
      const ViewList()
    ];

    // Lista de títulos correspondientes
    final titulos = ['OIRS UTEM', 'Crear Tickets', 'Lista de Tickets'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titulos[
            selectedIndex]), // Cambia el título según el índice seleccionado
        centerTitle: true,
        backgroundColor:
            Colors.cyan, // Personaliza el color de la AppBar si lo deseas
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home_filled),
            label: 'Inicio',
            backgroundColor:
                Colors.cyan, // Puedes ajustar los colores si es necesario
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            activeIcon: Icon(Icons.message_rounded),
            label: 'Crear Tickets',
            backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            activeIcon: Icon(Icons.list_rounded),
            label: 'Lista de Tickets',
            backgroundColor: Colors.cyan,
          ),
        ],
      ),
    );
  }
}
