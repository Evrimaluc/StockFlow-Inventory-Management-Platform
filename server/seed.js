const mongoose = require('mongoose');
require('dotenv').config();
const Sayim = require('./models/Sayim');

// Mevcut Ürün Fiyat ve Adet Aralıkları
const urunler = [
  { ad: "Zırh Delici Mühimmat", aciklama: "Tungsten çekirdekli", baseFiyat: 1200, maxQty: 500 },
  { ad: "Termal Kamera Lensi", aciklama: "Kızılötesi görüş", baseFiyat: 45000, maxQty: 15 },
  { ad: "İHA Bataryası", aciklama: "Lityum polimer", baseFiyat: 15000, maxQty: 40 },
  { ad: "Taktik Telsiz", aciklama: "Kriptolu haberleşme", baseFiyat: 8500, maxQty: 100 },
  { ad: "Balistik Kask", aciklama: "Kevlar kompozit", baseFiyat: 3200, maxQty: 250 }
];
const cicekler = ["Gül", "Lale", "Zambak", "Orkide", "Papatya"];

mongoose.connect(process.env.MONGO_URI).then(async () => {
  console.log('Veritabanına bağlanıldı, test verileri üretiliyor...');
  await Sayim.deleteMany({}); // Eski verileri sil

  let xCount = 1; let yCount = 1;

  for (let yil = 2025; yil <= 2026; yil++) {
    let bitisAyi = yil === 2026 ? 3 : 12; // Mart 2026'ya kadar
    
    for (let ay = 1; ay <= bitisAyi; ay++) {
      // Aylık işlem sayısını artırdık ki 30 günlük grafikte boşluk kalmasın (aylık 20-35 işlem)
      let islemSayisi = Math.floor(Math.random() * 16) + 20; 
      
      for (let i = 0; i < islemSayisi; i++) {
        const islemTipi = Math.random() > 0.45 ? 'y' : 'x'; // %55 Satış, %45 Alış
        const urun = urunler[Math.floor(Math.random() * urunler.length)];
        
        // Ürünün kapasitesine göre mantıklı miktar
        const miktar = Math.floor(Math.random() * urun.maxQty) + 5;
        
        // Kar Marjı: %20 ile %60 arası
        let karMarji = 1 + (Math.floor(Math.random() * 40) + 20) / 100;
        let fiyat = islemTipi === 'y' ? urun.baseFiyat * karMarji : urun.baseFiyat; 
        
        // 2026 Enflasyon Simülasyonu
        if(yil === 2026) fiyat = fiyat * 1.45;

        // O ayın kaç çektiğini bul ve rastgele bir gün seç (Günlük grafik için önemli)
        const maxGun = new Date(yil, ay, 0).getDate();
        const gun = Math.floor(Math.random() * maxGun) + 1;
        const tarih = new Date(yil, ay - 1, gun, Math.floor(Math.random() * 8) + 9, Math.floor(Math.random() * 60)); // 09:00 - 17:00 arası
        
        const evrakNo = `EVR-${yil}${String(ay).padStart(2,'0')}${String(gun).padStart(2,'0')}-${String(Math.floor(Math.random() * 1000)).padStart(3,'0')}`;
        let barkod = islemTipi === 'x' ? `x${String(xCount++).padStart(5, '0')}` : `y${String(yCount++).padStart(5, '0')}`;

        await Sayim.create({
          islemTipi, barkod, urunAdi: urun.ad, miktar, birimFiyat: Math.floor(fiyat),
          kaynakIsyeri: cicekler[Math.floor(Math.random() * cicekler.length)],
          fabrika: String(Math.floor(Math.random() * 10) + 1),
          kaynakAmbar: String(Math.floor(Math.random() * 10) + 1),
          tarihSaat: tarih, evrakNo, ozelKod1: `SF-${islemTipi.toUpperCase()}-${Math.floor(Math.random() * 10000)}`,
          aciklama: urun.aciklama
        });
      }
    }
  }
  console.log('Test verileri oluşturuldu.');
  process.exit();
});