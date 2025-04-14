import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
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
  int? _selectedSayimIndex;

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

  int? get selectedSayimIndex => _selectedSayimIndex;

  set selectedSayimIndex(int? value) {
    _selectedSayimIndex = value;
    notifyListeners();
  }

  List<SayimModel> get filteredSayimListesi {
    if (_searchText.isEmpty) {
      return [];
    }
    return _sayimListesi.where((item) {
      final searchTextLower = _searchText.toLowerCase();
      switch (_searchType) {
        case 'barkod':
          return item.barkod.toLowerCase().startsWith(searchTextLower);
        case 'miktar':
          return item.miktar.toLowerCase().contains(searchTextLower);
        case 'urunAdi':
          return (item.urunAdi ?? '').toLowerCase().contains(searchTextLower);
        case 'kaynakIsyeri':
          return (item.kaynakIsyeri ?? '').toLowerCase().contains(
            searchTextLower,
          );
        case 'fabrika':
          return (item.fabrika ?? '').toLowerCase().contains(searchTextLower);
        case 'kaynakAmbar':
          return (item.kaynakAmbar ?? '').toLowerCase().contains(
            searchTextLower,
          );
        case 'evrakNo':
          return (item.evrakNo ?? '').toLowerCase().contains(searchTextLower);
        case 'ozelKod1':
          return (item.ozelKod1 ?? '').toLowerCase().contains(searchTextLower);
        case 'aciklama':
          return (item.aciklama ?? '').toLowerCase().contains(searchTextLower);
        default:
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

  void sayimGuncelle(int index, SayimModel updatedModel) {
    if (index >= 0 && index < _sayimListesi.length) {
      _sayimListesi[index] = updatedModel;
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
  final String? kaynakIsyeri;
  final String? fabrika;
  final String? kaynakAmbar;
  final String tarihSaat;
  final String? evrakNo;
  final String? ozelKod1;
  final String? aciklama;
  final String? imageUrl;

  SayimModel({
    required this.barkod,
    required this.miktar,
    this.urunAdi,
    this.kaynakIsyeri,
    this.fabrika,
    this.kaynakAmbar,
    required this.tarihSaat,
    this.evrakNo,
    this.ozelKod1,
    this.aciklama,
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
  final TextEditingController kaynakIsyeriController = TextEditingController();
  final TextEditingController fabrikaController = TextEditingController();
  final TextEditingController kaynakAmbarController = TextEditingController();
  final TextEditingController evrakNoController = TextEditingController();
  final TextEditingController ozelKod1Controller = TextEditingController();
  final TextEditingController aciklamaController = TextEditingController();
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
            Tab(icon: Icon(Icons.search, color: Colors.white), text: 'Ara'),
            Tab(icon: Icon(Icons.list, color: Colors.white), text: 'Liste'),
            Tab(
              icon: Icon(Icons.calculate, color: Colors.white),
              text: 'Toplam',
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory, size: 48, color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    'Fiş Sayım Menüsü',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_box, color: Colors.red),
              title: Text('Ürün Ekle', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ChangeNotifierProvider<SayimData>.value(
                          value: Provider.of<SayimData>(context, listen: false),
                          child: UrunEkleSayfasi(),
                        ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey),
              title: Text('Ayarlar', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings page
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.grey),
              title: Text('Hakkında', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                // Navigate to about page
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.red.shade100],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [aramaTab(context), listeTab(context), toplamTab(context)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSayimDialog(context),
        backgroundColor: Colors.red[700],
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget aramaTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 8.0,
              children: [
                _buildSearchTypeButton(context, 'barkod', 'Barkod'),
                _buildSearchTypeButton(context, 'miktar', 'Miktar'),
                _buildSearchTypeButton(context, 'urunAdi', 'Ürün Adı'),
                _buildSearchTypeButton(
                  context,
                  'kaynakIsyeri',
                  'Kaynak İşyeri',
                ),
                _buildSearchTypeButton(context, 'fabrika', 'Fabrika'),
                _buildSearchTypeButton(context, 'kaynakAmbar', 'Kaynak Ambar'),
                _buildSearchTypeButton(context, 'evrakNo', 'Evrak No'),
                _buildSearchTypeButton(context, 'ozelKod1', 'Özel Kod 1'),
                _buildSearchTypeButton(context, 'aciklama', 'Açıklama'),
              ],
            ),
          ),
          SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              labelText: 'Ara',
              hintText: 'Aranacak kelimeyi girin',
              prefixIcon: Icon(Icons.search, color: Colors.red),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
            ),
            onChanged: (value) {
              Provider.of<SayimData>(context, listen: false).searchText = value;
            },
          ),
          SizedBox(height: 16),
          Expanded(
            child: Consumer<SayimData>(
              builder: (context, sayimData, child) {
                final filteredList = sayimData.filteredSayimListesi;
                return filteredList.isNotEmpty
                    ? ListView.separated(
                      itemCount: filteredList.length,
                      separatorBuilder:
                          (context, index) =>
                              Divider(height: 1, color: Colors.grey.shade400),
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return GestureDetector(
                          onTap: () {
                            sayimData.selectedSayimIndex = index;
                            _tabController.animateTo(1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Icon(
                                Icons.shopping_cart,
                                color: Colors.red,
                              ),
                              title: Text(
                                '${item.urunAdi ?? 'Ürün'}',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Barkod: ${item.barkod}'),
                                  Text('Miktar: ${item.miktar}'),
                                  Text(
                                    'Kaynak İşyeri: ${item.kaynakIsyeri ?? '-'}',
                                  ),
                                  Text('Fabrika: ${item.fabrika ?? '-'}'),
                                  Text(
                                    'Kaynak Ambar: ${item.kaynakAmbar ?? '-'}',
                                  ),
                                  Text('Evrak No: ${item.evrakNo ?? '-'}'),
                                  Text('Özel Kod 1: ${item.ozelKod1 ?? '-'}'),
                                  Text('Açıklama: ${item.aciklama ?? '-'}'),
                                ],
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                    : Center(
                      child: Text(
                        'Ürün Bulunamadı',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTypeButton(
    BuildContext context,
    String type,
    String label,
  ) {
    final isSelected = Provider.of<SayimData>(context).searchType == type;
    return ElevatedButton(
      onPressed: () {
        Provider.of<SayimData>(context, listen: false).searchType = type;
        Provider.of<SayimData>(context, listen: false).searchText = '';
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.red[700] : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        side: BorderSide(color: Colors.red.shade200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
    );
  }

  Widget listeTab(BuildContext context) {
    return Consumer<SayimData>(
      builder: (context, sayimData, child) {
        return sayimData.sayimListesi.isNotEmpty
            ? ListView.separated(
              itemCount: sayimData.sayimListesi.length,
              separatorBuilder:
                  (context, index) =>
                      Divider(height: 1, color: Colors.grey.shade400),
              padding: EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = sayimData.sayimListesi[index];
                return Dismissible(
                  key: Key(item.barkod + index.toString()),
                  onDismissed: (_) => sayimData.sayimSil(index),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ProductListItem(
                    item: item,
                    index: index,
                    isExpanded: sayimData.selectedSayimIndex == index,
                  ),
                );
              },
            )
            : Center(
              child: Text(
                'Henüz fiş eklenmedi.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
      },
    );
  }

  Widget toplamTab(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Toplam Miktar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 12),
            Consumer<SayimData>(
              builder:
                  (context, data, _) => Text(
                    '${data.toplamMiktar.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
            ),
            SizedBox(height: 12),
            Text(
              'Toplam sayılan fiş miktarı.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSayimDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Yeni Fiş Ekle',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                    decoration: InputDecoration(
                      labelText: 'Ürün Adı (opsiyonel)',
                    ),
                  ),
                  TextField(
                    controller: kaynakIsyeriController,
                    decoration: InputDecoration(labelText: 'Kaynak İşyeri'),
                  ),
                  TextField(
                    controller: fabrikaController,
                    decoration: InputDecoration(labelText: 'Fabrika'),
                  ),
                  TextField(
                    controller: kaynakAmbarController,
                    decoration: InputDecoration(labelText: 'Kaynak Ambar'),
                  ),
                  TextField(
                    controller: evrakNoController,
                    decoration: InputDecoration(labelText: 'Evrak No'),
                  ),
                  TextField(
                    controller: ozelKod1Controller,
                    decoration: InputDecoration(labelText: 'Özel Kod 1'),
                  ),
                  TextField(
                    controller: aciklamaController,
                    decoration: InputDecoration(labelText: 'Açıklama'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _clearControllers();
                },
                child: Text(
                  'İptal',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final barkod = barkodController.text;
                  final miktar = miktarController.text;
                  if (barkod.isNotEmpty && miktar.isNotEmpty) {
                    _addSayim(context, barkod, miktar);
                    Navigator.pop(context);
                    _clearControllers();
                  }
                },
                child: Text(
                  'Ekle',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
    );
  }

  void _addSayim(BuildContext context, String barkod, String miktar) {
    Provider.of<SayimData>(context, listen: false).sayimEkle(
      SayimModel(
        barkod: barkod,
        miktar: miktar,
        urunAdi: urunAdiController.text,
        kaynakIsyeri: kaynakIsyeriController.text,
        fabrika: fabrikaController.text,
        kaynakAmbar: kaynakAmbarController.text,
        tarihSaat: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        evrakNo: evrakNoController.text,
        ozelKod1: ozelKod1Controller.text,
        aciklama: aciklamaController.text,
      ),
    );
  }

  void _clearControllers() {
    barkodController.clear();
    miktarController.clear();
    urunAdiController.clear();
    kaynakIsyeriController.clear();
    fabrikaController.clear();
    kaynakAmbarController.clear();
    evrakNoController.clear();
    ozelKod1Controller.clear();
    aciklamaController.clear();
  }
}

class UrunEkleSayfasi extends StatelessWidget {
  final TextEditingController barkodController = TextEditingController();
  final TextEditingController miktarController = TextEditingController();
  final TextEditingController urunAdiController = TextEditingController();
  final TextEditingController kaynakIsyeriController = TextEditingController();
  final TextEditingController fabrikaController = TextEditingController();
  final TextEditingController kaynakAmbarController = TextEditingController();
  final TextEditingController evrakNoController = TextEditingController();
  final TextEditingController ozelKod1Controller = TextEditingController();
  final TextEditingController aciklamaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ürün Ekle',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red[700],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.red.shade100],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: barkodController,
                decoration: InputDecoration(
                  labelText: 'Barkod',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: miktarController,
                decoration: InputDecoration(
                  labelText: 'Miktar',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: urunAdiController,
                decoration: InputDecoration(
                  labelText: 'Ürün Adı (opsiyonel)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: kaynakIsyeriController,
                decoration: InputDecoration(
                  labelText: 'Kaynak İşyeri',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: fabrikaController,
                decoration: InputDecoration(
                  labelText: 'Fabrika',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: kaynakAmbarController,
                decoration: InputDecoration(
                  labelText: 'Kaynak Ambar',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: evrakNoController,
                decoration: InputDecoration(
                  labelText: 'Evrak No',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: ozelKod1Controller,
                decoration: InputDecoration(
                  labelText: 'Özel Kod 1',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: aciklamaController,
                decoration: InputDecoration(
                  labelText: 'Açıklama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final barkod = barkodController.text;
                  final miktar = miktarController.text;
                  if (barkod.isNotEmpty && miktar.isNotEmpty) {
                    Provider.of<SayimData>(context, listen: false).sayimEkle(
                      SayimModel(
                        barkod: barkod,
                        miktar: miktar,
                        urunAdi: urunAdiController.text,
                        kaynakIsyeri: kaynakIsyeriController.text,
                        fabrika: fabrikaController.text,
                        kaynakAmbar: kaynakAmbarController.text,
                        tarihSaat: DateFormat(
                          'yyyy-MM-dd HH:mm:ss',
                        ).format(DateTime.now()),
                        evrakNo: evrakNoController.text,
                        ozelKod1: ozelKod1Controller.text,
                        aciklama: aciklamaController.text,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Ürünü Ekle',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductListItem extends StatefulWidget {
  final SayimModel item;
  final int index;
  final bool isExpanded;

  const ProductListItem({
    Key? key,
    required this.item,
    required this.index,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  _ProductListItemState createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    Color? barkodColor;
    if (widget.item.barkod.startsWith('y')) {
      barkodColor = Colors.green;
    } else if (widget.item.barkod.startsWith('x')) {
      barkodColor = Colors.red;
    } else {
      barkodColor = Colors.black;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
          if (expanded) {
            Provider.of<SayimData>(context, listen: false).selectedSayimIndex =
                widget.index;
          } else {
            Provider.of<SayimData>(context, listen: false).selectedSayimIndex =
                null;
          }
        },
        leading: Icon(Icons.assignment, color: Colors.red),
        title: RichText(
          text: TextSpan(
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
            children: [
              TextSpan(
                text: 'Ürün Adı: ${widget.item.urunAdi ?? 'Ürün'}\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'Barkod: ${widget.item.barkod}\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: barkodColor,
                ),
              ),
              TextSpan(text: 'Miktar: ${widget.item.miktar}'),
            ],
          ),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kaynak İşyeri: ${widget.item.kaynakIsyeri ?? '-'}'),
                Text('Fabrika: ${widget.item.fabrika ?? '-'}'),
                Text('Kaynak Ambar: ${widget.item.kaynakAmbar ?? '-'}'),
                Text('Tarih: ${widget.item.tarihSaat}'),
                Text('Evrak No: ${widget.item.evrakNo ?? '-'}'),
                Text('Özel Kod 1: ${widget.item.ozelKod1 ?? '-'}'),
                Text('Açıklama: ${widget.item.aciklama ?? '-'}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed:
                          () => _showEditDialog(
                            context,
                            widget.index,
                            widget.item,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    int index,
    SayimModel mevcutModel,
  ) {
    final barkodController = TextEditingController(text: mevcutModel.barkod);
    final miktarController = TextEditingController(text: mevcutModel.miktar);
    final urunAdiController = TextEditingController(text: mevcutModel.urunAdi);
    final kaynakIsyeriController = TextEditingController(
      text: mevcutModel.kaynakIsyeri,
    );
    final fabrikaController = TextEditingController(text: mevcutModel.fabrika);
    final kaynakAmbarController = TextEditingController(
      text: mevcutModel.kaynakAmbar,
    );
    final evrakNoController = TextEditingController(text: mevcutModel.evrakNo);
    final ozelKod1Controller = TextEditingController(
      text: mevcutModel.ozelKod1,
    );
    final aciklamaController = TextEditingController(
      text: mevcutModel.aciklama,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Fiş Güncelle',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                    decoration: InputDecoration(labelText: 'Ürün Adı'),
                  ),
                  TextField(
                    controller: kaynakIsyeriController,
                    decoration: InputDecoration(labelText: 'Kaynak İşyeri'),
                  ),
                  TextField(
                    controller: fabrikaController,
                    decoration: InputDecoration(labelText: 'Fabrika'),
                  ),
                  TextField(
                    controller: kaynakAmbarController,
                    decoration: InputDecoration(labelText: 'Kaynak Ambar'),
                  ),
                  TextField(
                    controller: evrakNoController,
                    decoration: InputDecoration(labelText: 'Evrak No'),
                  ),
                  TextField(
                    controller: ozelKod1Controller,
                    decoration: InputDecoration(labelText: 'Özel Kod 1'),
                  ),
                  TextField(
                    controller: aciklamaController,
                    decoration: InputDecoration(labelText: 'Açıklama'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'İptal',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
                      TextButton(
                onPressed: () {
                  Provider.of<SayimData>(
                    context,
                    listen: false,
                  ).sayimSil(index);
                  Navigator.pop(context);
                },
                child: Text(
                  'Ürünü Sil',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
                 ElevatedButton(
                onPressed: () {
                  final barkod = barkodController.text;
                  final miktar = miktarController.text;
                  if (barkod.isNotEmpty && miktar.isNotEmpty) {
                    final updatedModel = SayimModel(
                      barkod: barkod,
                      miktar: miktar,
                      urunAdi: urunAdiController.text,
                      kaynakIsyeri: kaynakIsyeriController.text,
                      fabrika: fabrikaController.text,
                      kaynakAmbar: kaynakAmbarController.text,
                      tarihSaat: mevcutModel.tarihSaat,
                      evrakNo: evrakNoController.text,
                      ozelKod1: ozelKod1Controller.text,
                      aciklama: aciklamaController.text,
                      imageUrl: mevcutModel.imageUrl,
                    );
                    Provider.of<SayimData>(
                      context,
                      listen: false,
                    ).sayimGuncelle(index, updatedModel);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Güncelle',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              ),
            ),
      );
  }
}
