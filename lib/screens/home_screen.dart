import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Estado para simular si se abrió el menú de búsqueda / mapa de destinos
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fondo oscuro estilo Uber
      body: SafeArea(
        child: Stack(
          children: [
            // Contenido principal de la pasarela de inicio
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Barra de búsqueda superior tipo "¿A dónde vas?"
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSearching = true; // Activa la vista de mapa/destino
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF212121),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey.shade800),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.white70),
                          SizedBox(width: 12),
                          Text(
                            "¿A dónde vas?",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Chip(
                            label: Text("Más tarde", style: TextStyle(color: Colors.white)),
                            backgroundColor: Color(0xFF333333),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Historial de direcciones recientes (Ej: Quesada 2150)
                  _buildRecentDestinationTile("Quesada 2150", "Cdad. Autónoma de Buenos Aires"),
                  const SizedBox(height: 10),
                  _buildRecentDestinationTile("Blanco Encalada 1011", "DCE Cdad. Autónoma de Buenos Aires"),
                  const SizedBox(height: 24),

                  // 3. Botones circulares de categorías ("Para ti" / Servicios)
                  const Text("Para ti", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildServiceCategory(Icons.local_taxi, "Viaje"),
                        _buildServiceCategory(Icons.delivery_dining, "Moto"),
                        _buildServiceCategory(Icons.calendar_today, "Reserva"),
                        _buildServiceCategory(Icons.inventory_2, "Enviar"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Banner interactivo de promociones (Carrusel)
                  const Text("Promociones y novedades", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 160,
                    child: PageView(
                      controller: PageController(viewportFraction: 0.85),
                      children: [
                        _buildPromoBanner("Transportá artículos importantes", "Enviá un paquete con seguridad", Colors.blue.shade800),
                        _buildPromoBanner("Viajá con descuentos", "Conocé las promos de la semana", Colors.deepPurple.shade700),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Vista superpuesta (Menú aparte de mapa / Origen y Destino) al hacer click en "¿A dónde vas?"
            if (_isSearching)
              Container(
                color: const Color(0xFF121212),
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _isSearching = false; // Cierra la vista de mapa
                          });
                        },
                      ),
                      title: const Text("Elegí tu destino", style: TextStyle(color: Colors.white)),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Campo de Origen
                            TextField(
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.my_location, color: Colors.blueAccent),
                                hintText: "Ubicación actual",
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: const Color(0xFF212121),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Campo de Destino
                            TextField(
                              style: const TextStyle(color: Colors.white),
                              autofocus: true,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.location_on, color: Colors.redAccent),
                                hintText: "¿A dónde vamos?",
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: const Color(0xFF212121),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              ),
                            ),
                            const Spacer(),
                            // Simulación del mapa o botón de confirmación
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF212121),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  "🗺️ [Vista previa del mapa interactivo de rutas]",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
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
  }

  // Widget auxiliar para direcciones recientes
  Widget _buildRecentDestinationTile(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF333333),
            child: Icon(Icons.access_time, color: Colors.white70, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  // Widget auxiliar para categorías circulares
  Widget _buildServiceCategory(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: const Color(0xFF212121),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  // Widget auxiliar para banners promocionales
  Widget _buildPromoBanner(String title, String subtitle, Color bgColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }
}