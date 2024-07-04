import 'package:flutter/material.dart';
import 'crypto_model.dart';
import 'api_service.dart';

void main() {
  runApp(CryptoPriceApp());
}

class CryptoPriceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Prices',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CryptoListScreen(),
    );
  }
}

class CryptoListScreen extends StatefulWidget {
  @override
  _CryptoListScreenState createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  late Future<List<Crypto>> futureCryptoPrices;

  @override
  void initState() {
    super.initState();
    futureCryptoPrices = ApiService().fetchCryptoPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRYPTO PRICES'),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: FutureBuilder<List<Crypto>>(
        future: futureCryptoPrices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load crypto prices'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final crypto = snapshot.data![index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.blueAccent,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.yellow,
                      child: Text(
                        crypto.symbol,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    title: Text(
                      crypto.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      '\$${crypto.priceUsd.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.lightGreenAccent),
                    ),
                    trailing: Icon(Icons.trending_up, color: Colors.green),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
