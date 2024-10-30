import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:proyecto/screens/create_tickets.dart';
import 'package:proyecto/screens/home_screen.dart';
import 'package:proyecto/screens/login_screen.dart';
import 'package:proyecto/screens/tickets_view_list.dart';
import 'package:proyecto/services/storage_service.dart';

class MenuApp extends StatelessWidget {
  const MenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepOrange),
            accountName: FutureBuilder(
              future: StorageService.getValue('name'), // Corregido
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final String name = snapshot.data ?? '';
                  return Text(name);
                } else {
                  return const Text('...');
                }
              },
            ),
            accountEmail: FutureBuilder(
              future: StorageService.getValue('email'), // Corregido
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final String email = snapshot.data ?? '';
                  return Text(email);
                } else {
                  return const Text('usuario@gmail.com');
                }
              },
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: FutureBuilder(
                  future: StorageService.getValue('image'), // Corregido
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && snapshot.data != null) {
                        final String photoUrl = snapshot.data!;
                        if (photoUrl.isNotEmpty) {
                          return CachedNetworkImage(
                            imageUrl: photoUrl,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          );
                        }
                      }
                      return const Icon(Icons
                          .person); // Mostrar un ícono de usuario por defecto si no hay imagen.
                    } else if (snapshot.hasError) {
                      return const Icon(Icons
                          .error); // Cambia a un ícono de error si hay un problema con el `Future`.
                    } else {
                      return const CircularProgressIndicator(); // Muestra un indicador de progreso mientras se carga la imagen.
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Inicio'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_circle_rounded),
                  title: const Text('Crear Ticket'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateTickets()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Lista'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TicketsViewList()));
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.output),
            title: const Text('Login'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class ViewList {
  const ViewList();
}
