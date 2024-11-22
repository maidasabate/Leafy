import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leafy_app/components/appbar.dart';
import 'package:leafy_app/components/formulario.dart';
import 'package:leafy_app/components/tabs.dart';

class Mantenedor extends StatefulWidget {
  const Mantenedor({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MantenedorState createState() => _MantenedorState();
}

class _MantenedorState extends State<Mantenedor> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const BlogScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar Plantas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Mis Plantas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Comunidad',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Buscar Plantas'),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay registros disponibles.'));
          }

          final usuarios = snapshot.data!.docs;

          return ListView.separated(
            itemCount: usuarios.length,
            separatorBuilder: (context, index) => const Divider(
              color: Color.fromARGB(255, 235, 235, 235), // Color del divisor
              thickness: 1, // Grosor del divisor
            ),
            itemBuilder: (context, index) {
              final usuario = usuarios[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(
                  '${usuario['nombre']}',
                  style: const TextStyle(fontWeight: FontWeight.bold), // Título en negrita
                ),
                subtitle: Text('${usuario['telefono']}'), // Muestra el teléfono
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => FractionallySizedBox(
              heightFactor: 0.9,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: FormularioScreen(),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: buildAppBar(context, 'Mis Plantas'),
    
        body: Padding(
  padding: const EdgeInsets.all(12.0),
  child: GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, 
      crossAxisSpacing: 12.0, 
      mainAxisSpacing: 12.0, 
    ),
    itemCount: 6, 
    itemBuilder: (context, index) {
      return SizedBox(
        width: 80, 
        height: 40, 
        child: Card(
          elevation: 4.0,
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              Container(
                height: 130, 
                width: double.infinity, 
                child: Image.asset(
                  'lib/assets/images/Arapanto.jpeg', 
                  fit: BoxFit.cover, 
                ),
              ),
              Expanded(
                child: Container(
                padding: const EdgeInsets.all(4.0),
                width: double.infinity, 
                alignment: Alignment.centerLeft, 
                child: Text(
                  'Arapanto ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
    ),
  ),
),

              ),
            ],
          ),
        ),
      );
    },
  ),
),

      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (kDebugMode) {
            print('Botón presionado');
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Comunidad'),
      body: const Center(
        child: Text('Pantalla de comunidad'),
      ),
    );
  }
}