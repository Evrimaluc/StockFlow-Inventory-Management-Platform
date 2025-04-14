import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(FisSayimApp());

class FisSayimApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fiş Sayım',
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red[700],
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
      ),
      home: ChangeNotifierProvider<SayimData>(
        create: (context) => SayimData(),
        child: FisSayimEkrani(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SayimData extends ChangeNotifier {
  List<SayimModel> _sayimListesi = [];
  String _searchText = '';

  List<SayimModel> get sayimListesi => _sayimListesi;

  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  List<SayimModel> get filteredSayimListesi {
    if (_searchText.isEmpty) {
      return _sayimListesi;
    } else {
      return _sayimListesi
          .where(
            (item) =>
                item.barkod.toLowerCase().contains(_searchText.toLowerCase()) ||
                item.miktar.toLowerCase().contains(_searchText.toLowerCase()),
          )
          .toList();
    }
  }

  void sayimEkle(SayimModel sayim) {
    _sayimListesi.add(sayim);
    notifyListeners();
  }

  void sayimSil(int index) {
    _sayimListesi.removeAt(index);
    notifyListeners();
  }
}

class SayimModel {
  String barkod;
  String miktar;

  SayimModel({required this.barkod, required this.miktar});
}

class FisSayimEkrani extends StatefulWidget {
  @override
  _FisSayimEkraniState createState() => _FisSayimEkraniState();
}

class _FisSayimEkraniState extends State<FisSayimEkrani> {
  final TextEditingController barkodController = TextEditingController();
  final TextEditingController miktarController = TextEditingController();

  @override
  void dispose() {
    barkodController.dispose();
    miktarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fiş Sayım Ekranı')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Ara',
                hintText: 'Barkod veya miktar ile ara',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              onChanged: (value) {
                Provider.of<SayimData>(context, listen: false).searchText =
                    value;
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: barkodController,
                    decoration: InputDecoration(labelText: 'Barkod'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: miktarController,
                    decoration: InputDecoration(labelText: 'Miktar'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final barkod = barkodController.text;
                final miktar = miktarController.text;

                if (barkod.isNotEmpty && miktar.isNotEmpty) {
                  Provider.of<SayimData>(
                    context,
                    listen: false,
                  ).sayimEkle(SayimModel(barkod: barkod, miktar: miktar));
                  barkodController.clear();
                  miktarController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lütfen barkod ve miktar girin.')),
                  );
                }
              },
              child: Text('Ekle'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<SayimData>(
                builder: (context, sayimData, child) {
                  return ListView.builder(
                    itemCount: sayimData.filteredSayimListesi.length,
                    itemBuilder: (context, index) {
                      final item = sayimData.filteredSayimListesi[index];
                      return Dismissible(
                        key: Key(item.barkod),
                        onDismissed: (direction) {
                          sayimData.sayimSil(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Fiş silindi.')),
                          );
                        },
                        background: Container(color: Colors.red),
                        child: Card(
                          child: ListTile(
                            title: Text('Barkod: ${item.barkod}'),
                            subtitle: Text('Miktar: ${item.miktar}'),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
