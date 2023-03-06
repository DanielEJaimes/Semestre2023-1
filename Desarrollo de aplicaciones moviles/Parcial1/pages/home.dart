import 'dart:convert';
import 'package:parcial/exports.dart';
import 'package:parcial/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  /* ==================Functions================= */

  @override
  void initState() {
    super.initState();
    setProducts();
  }

  void setProducts() {
    getProducts().then((value) {
      setState(() {
        productss.addAll(value);
      });
    });
  }

  List<Product> productss = <Product>[];
  Future<List<Product>> getProducts() async {
    var register = await APIService.getProducts();
    return register;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Grilla()));
        break;
      case 2:
        setState(() {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomeFavorites()));
        });
        break;
      case 3:
        Functions.logout(context);
        break;
    }
  }

  /* ==============WIDGET LISTA===================== */

  Widget buildLista(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: productss.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Card(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Image.network(productss[index].photo!,
                                height: 120, width: 150, fit: BoxFit.cover),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productss[index].name!,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Raleway'),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                productss[index].description!,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Raleway'),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "\$ ${productss[index].price}",
                                style: const TextStyle(fontFamily: 'Raleway'),
                              ),
                              const SizedBox(height: 8),
                              ButtonFavorite(idOffer: productss[index].id)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de productos'),
        backgroundColor: Colors.deepOrange,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: buildLista(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.deepOrange),
            label: 'Lista',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_4x4, color: Colors.deepOrange),
            label: 'Grilla',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.deepOrange),
            label: 'Favoritos',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.logout, color: Colors.deepOrange),
            label: 'Salir',
          ),
        ],
        selectedLabelStyle: const TextStyle(color: Colors.red),
      ),
    );
  }
}
