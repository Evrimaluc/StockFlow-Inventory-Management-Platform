import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<SayimData>(
      create: (_) => SayimData(),
      builder: (context, child) => FisSayimApp(),
    ),
  );
}

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
      ),
      home: FisSayimEkrani(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SayimData extends ChangeNotifier {
  List<SayimModel> _sayimListesi = [];
  String _searchText = '';
  String _searchType = 'barkod';

  List<SayimModel> get sayimListesi => _sayimListesi;

  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  String get searchType => _searchType;

  set searchType(String value) {
    _searchType = value;
    notifyListeners();
  }

  List<SayimModel> get filteredSayimListesi {
    if (_searchText.isEmpty) {
      return [];
    }
    return _sayimListesi.where((item) {
      if (_searchType == 'barkod') {
        return item.barkod.toLowerCase().startsWith(_searchText.toLowerCase());
      } else if (_searchType == 'miktar') {
        return item.miktar.toLowerCase().contains(_searchText.toLowerCase());
      } else if (_searchType == 'urunAdi') {
        return (item.urunAdi ?? '').toLowerCase().contains(_searchText.toLowerCase());
      } else {
        return false;
      }
    }).toList();
  }

  void sayimEkle(SayimModel model) {
    _sayimListesi.add(model);
    notifyListeners();
  }

  void sayimSil(int index) {
    _sayimListesi.removeAt(index);
    notifyListeners();
  }

  void sayimGuncelle(int index, String yeniMiktar) {
    if (index >= 0 && index < _sayimListesi.length) {
      _sayimListesi[index] = SayimModel(
        barkod: _sayimListesi[index].barkod,
        miktar: yeniMiktar,
        urunAdi: _sayimListesi[index].urunAdi,
        imageUrl: _sayimListesi[index].imageUrl,
      );
      notifyListeners();
    }
  }

  double get toplamMiktar {
    return _sayimListesi.fold(
      0,
      (sum, item) => sum + (double.tryParse(item.miktar) ?? 0),
    );
  }
}

class SayimModel {
  final String barkod;
  final String miktar;
  final String? urunAdi;
  final String? imageUrl;

  SayimModel({
    required this.barkod,
    required this.miktar,
    this.urunAdi,
    this.imageUrl,
  });
}

class FisSayimEkrani extends StatefulWidget {
  @override
  _FisSayimEkraniState createState() => _FisSayimEkraniState();
}

class _FisSayimEkraniState extends State<FisSayimEkrani>
    with TickerProviderStateMixin {
  final TextEditingController barkodController = TextEditingController();
  final TextEditingController miktarController = TextEditingController();
  final TextEditingController urunAdiController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fiş Sayım'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.search), text: 'Ara'),
            Tab(icon: Icon(Icons.list), text: 'Liste'),
            Tab(icon: Icon(Icons.calculate), text: 'Toplam'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: Text(
                'Menü',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Ürün Ekle'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider<SayimData>.value(
                      value: Provider.of<SayimData>(context, listen: false),
                      child: UrunEkleSayfasi(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          aramaTab(context),
          listeTab(context),
          toplamTab(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSayimDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget aramaTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Arama Tipi',
              border: OutlineInputBorder(),
            ),
            value: Provider.of<SayimData>(context).searchType,
            items: [
              DropdownMenuItem(value: 'barkod', child: Text('Barkod')),
              DropdownMenuItem(value: 'miktar', child: Text('Miktar')),
              DropdownMenuItem(value: 'urunAdi', child: Text('Ürün Adı')),
            ],
            onChanged: (String? value) {
              if (value != null) {
                Provider.of<SayimData>(context, listen: false).searchType = value;
                Provider.of<SayimData>(context, listen: false).searchText = '';
              }
            },
          ),
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              labelText: 'Ara',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              Provider.of<SayimData>(context, listen: false).searchText = value;
            },
          ),
          SizedBox(height: 8),
          Expanded(
            child: Consumer<SayimData>(
              builder: (context, sayimData, child) {
                final filteredList = sayimData.filteredSayimListesi;
                return filteredList.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          return Card(
                            child: ListTile(
                              title: Text('${item.urunAdi ?? 'Ürün'} (${item.barkod})'),
                              subtitle: Text('Miktar: ${item.miktar}'),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text('Ürün Bulunamadı'),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget listeTab(BuildContext context) {
    return Consumer<SayimData>(
      builder: (context, sayimData, child) {
        return ListView.builder(
          itemCount: sayimData.sayimListesi.length,
          itemBuilder: (context, index) {
            final item = sayimData.sayimListesi[index];
            return Dismissible(
              key: Key(item.barkod + index.toString()),
              onDismissed: (_) => sayimData.sayimSil(index),
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text('${item.urunAdi ?? 'Ürün'} (${item.barkod})'),
                subtitle: Text('Miktar: ${item.miktar}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showEditDialog(context, index, item.miktar),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget toplamTab(BuildContext context) {
    return Center(
      child: Consumer<SayimData>(
        builder: (context, data, _) => Text(
          'Toplam: ${data.toplamMiktar.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showAddSayimDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Yeni Fiş Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: barkodController,
              decoration: InputDecoration(hintText: 'Barkod'),
            ),
            TextField(
              controller: miktarController,
              decoration: InputDecoration(hintText: 'Miktar'),
            ),
            TextField(
              controller: urunAdiController,
              decoration: InputDecoration(hintText: 'Ürün Adı (opsiyonel)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              barkodController.clear();
              miktarController.clear();
              urunAdiController.clear();
              Navigator.pop(context);
            },
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              final barkod = barkodController.text;
              final miktar = miktarController.text;
              final urunAdi = urunAdiController.text;
              if (barkod.isNotEmpty && miktar.isNotEmpty) {
                Provider.of<SayimData>(context, listen: false).sayimEkle(
                  SayimModel(
                    barkod: barkod,
                    miktar: miktar,
                    urunAdi: urunAdi,
                  ),
                );
                barkodController.clear();
                miktarController.clear();
                urunAdiController.clear();
                Navigator.pop(context);
              }
            },
            child: Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index, String mevcutMiktar) {
    TextEditingController editController = TextEditingController(text: mevcutMiktar);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Miktar Güncelle'),
        content: TextField(
          controller: editController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'Yeni Miktar'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              if (editController.text.isNotEmpty) {
                Provider.of<SayimData>(context, listen: false).sayimGuncelle(index, editController.text);
                Navigator.pop(context);
              }
            },
            child: Text('Güncelle'),
          ),
        ],
      ),
    );
  }
}

class UrunEkleSayfasi extends StatelessWidget {
  final TextEditingController barkodController = TextEditingController();
  final TextEditingController miktarController = TextEditingController();
  final TextEditingController urunAdiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ürün Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: barkodController,
              decoration: InputDecoration(labelText: 'Barkod'),
            ),
            TextField(
              controller: miktarController,
              decoration: InputDecoration(labelText: 'Miktar'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: urunAdiController,
              decoration: InputDecoration(labelText: 'Ürün Adı (opsiyonel)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final barkod = barkodController.text;
                final miktar = miktarController.text;
                final urunAdi = urunAdiController.text;

                if (barkod.isNotEmpty && miktar.isNotEmpty) {
                  Provider.of<SayimData>(context, listen: false).sayimEkle(
                    SayimModel(
                      barkod: barkod,
                      miktar: miktar,
                      urunAdi: urunAdi,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
