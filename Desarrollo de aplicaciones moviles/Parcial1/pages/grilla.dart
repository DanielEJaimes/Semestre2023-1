import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:parcial/exports.dart';
import 'package:parcial/services/api_service.dart';

class Grilla extends StatefulWidget {
  const Grilla({super.key});

  @override
  State<Grilla> createState() => _GrillaState();

  static count({required int crossAxisCount, required List<Center> children}) {}
}

class _GrillaState extends State<Grilla> {
  List<Product> productss = <Product>[];
  Future<List<Product>> getProducts() async {
    var register = await APIService.getProducts();
    return register;
  }

  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    getProducts().then((value) {
      setState(() {
        productss.addAll(value);
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomeFavorites()));
        break;
      case 3:
        Functions.logout(context);
        break;
    }
  }

  Widget gridElement(BuildContext context, int index) {
    return Card(
        margin: const EdgeInsets.all(3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            Image.network(productss[index].photo!,
                height: 90, fit: BoxFit.cover),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  productss[index].name!,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    productss[index].description!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w200,
                        fontFamily: 'Raleway',
                        fontSize: 12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$ ${productss[index].price}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
                      ),
                      ButtonFavorite(idOffer: productss[index].id)
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de productos'),
          backgroundColor: Colors.deepOrange,
          automaticallyImplyLeading: false,
        ),
        body: GridView.count(
          childAspectRatio: 0.8,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          crossAxisCount: 2,
          children: List.generate(productss.length, (index) {
            return gridElement(context, index);
          }),
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
      ),
    );
  }
}
