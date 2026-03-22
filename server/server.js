const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const Sayim = require('./models/Sayim');
const app = express();

app.use(cors());
app.use(express.json());

mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB Bağlandı'))
  .catch(err => console.log(err));

// Hafıza Yönetimi (Memory Limit Check)
const checkMemoryLimit = async () => {
  const count = await Sayim.countDocuments();
  if (count > 10000) { // 512MB çok büyüktür, 10 bin kayıtta bir temizlik simülasyonu
    const oldestRecord = await Sayim.findOne().sort({ tarihSaat: 1 });
    if (oldestRecord) {
      const oldestMonth = oldestRecord.tarihSaat.getMonth();
      const oldestYear = oldestRecord.tarihSaat.getFullYear();
      await Sayim.deleteMany({
        tarihSaat: { 
          $gte: new Date(oldestYear, oldestMonth, 1), 
          $lt: new Date(oldestYear, oldestMonth + 1, 1) 
        }
      });
      console.log(`${oldestYear}-${oldestMonth + 1} arşivi hafıza limiti nedeniyle silindi.`);
    }
  }
};

// 1. Tüm Verileri Getir
app.get('/api/sayim', async (req, res) => {
  const veriler = await Sayim.find().sort({ tarihSaat: -1 });
  res.json(veriler);
});

// 2. Finansal Arşiv (Aggregation)
app.get('/api/archive', async (req, res) => {
  const archive = await Sayim.aggregate([
    {
      $group: {
        _id: {
          yil: { $year: "$tarihSaat" },
          ay: { $month: "$tarihSaat" }
        },
        toplamGider: { $sum: { $cond: [{ $eq: ["$islemTipi", "x"] }, "$toplamTutar", 0] } },
        toplamGelir: { $sum: { $cond: [{ $eq: ["$islemTipi", "y"] }, "$toplamTutar", 0] } }
      }
    },
    { $sort: { "_id.yil": 1, "_id.ay": 1 } }
  ]);
  
  const formatted = archive.map(a => ({
    zaman: `${a._id.yil}-${String(a._id.ay).padStart(2, '0')}`,
    gelir: a.toplamGelir,
    gider: a.toplamGider,
    kar: a.toplamGelir - a.toplamGider
  }));
  res.json(formatted);
});

// 3. Yeni Kayıt (Otomatik Barkod ve Hata Çözümü)
app.post('/api/sayim', async (req, res) => {
  try {
    await checkMemoryLimit();

    const { islemTipi } = req.body;
    const now = new Date();
    
    // Rastgele tarihler yerine en son eklenen ID'ye göre sırala
    const sonKayit = await Sayim.findOne({ islemTipi }).sort({ _id: -1 });
    let siradakiNo = 1;
    if (sonKayit && sonKayit.barkod) {
      siradakiNo = parseInt(sonKayit.barkod.replace(/[^0-9]/g, '')) + 1;
    }
    
    const barkod = `${islemTipi}${String(siradakiNo).padStart(5, '0')}`;
    const evrakNo = `EVR-${now.getFullYear()}${String(now.getMonth()+1).padStart(2,'0')}${String(now.getDate()).padStart(2,'0')}-${String(Math.floor(Math.random() * 1000)).padStart(3,'0')}`;
    const ozelKod1 = `SF-${islemTipi.toUpperCase()}-${Math.floor(Math.random() * 10000)}`;

    const yeniSayim = new Sayim({
      ...req.body,
      barkod, evrakNo, ozelKod1, tarihSaat: now
    });

    await yeniSayim.save();
    res.json(yeniSayim);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 4. Kayıt Güncelleme (Sadece izin verilen alanları güncelle ve tutarı hesapla)
app.put('/api/sayim/:id', async (req, res) => {
  try {
    const { urunAdi, miktar, birimFiyat, kaynakIsyeri, fabrika, aciklama } = req.body;

    // Miktar veya fiyat değişmiş olabileceği için toplam tutarı sunucuda yeniden hesaplıyoruz
    const yeniToplamTutar = miktar * birimFiyat;

    const guncelKayit = await Sayim.findByIdAndUpdate(
      req.params.id,
      { 
        urunAdi, 
        miktar, 
        birimFiyat, 
        kaynakIsyeri, 
        fabrika, 
        aciklama,
        toplamTutar: yeniToplamTutar 
      },
      { new: true } 
    );

    if (!guncelKayit) {
      return res.status(404).json({ error: 'Kayıt bulunamadı' });
    }

    res.json(guncelKayit);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 5. Kayıt Silme
app.delete('/api/sayim/:id', async (req, res) => {
  try {
    await Sayim.findByIdAndDelete(req.params.id);
    res.json({ mesaj: 'Silindi' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

const cron = require('node-cron');

// ... (Diğer API rotaların burada duruyor) ...

// YENİ: PORTFOLYO DEMO MODU (Her gece saat 03:00'te veritabanını otomatik sıfırlar ve güncel veri doldurur)
cron.schedule('0 3 * * *', async () => {
  console.log('Gece 03:00 Bakımı: Veritabanı sıfırlanıyor ve güncel test verileri üretiliyor...');
  
  try {
    await Sayim.deleteMany({}); // Önce kullanıcıların gün içinde bozduğu verileri tamamen sil
    
    const urunler = [
      { ad: "Zırh Delici Mühimmat", baseFiyat: 1200, maxQty: 500 },
      { ad: "Termal Kamera Lensi", baseFiyat: 45000, maxQty: 15 },
      { ad: "İHA Bataryası", baseFiyat: 15000, maxQty: 40 },
      { ad: "Taktik Telsiz", baseFiyat: 8500, maxQty: 100 },
      { ad: "Balistik Kask", baseFiyat: 3200, maxQty: 250 }
    ];
    
    const now = new Date();
    let xCount = 1; let yCount = 1;

    // Son 12 ay için döngü (Güncel aydan geriye doğru)
    for (let i = 11; i >= 0; i--) {
      const islemTarihi = new Date(now.getFullYear(), now.getMonth() - i, 1);
      const yil = islemTarihi.getFullYear();
      const ay = islemTarihi.getMonth() + 1;
      const daysInMonth = new Date(yil, ay, 0).getDate();
      
      let islemSayisi = Math.floor(Math.random() * 16) + 20; // Her aya 20-35 işlem
      
      for (let j = 0; j < islemSayisi; j++) {
        const islemTipi = Math.random() > 0.45 ? 'y' : 'x'; 
        const urun = urunler[Math.floor(Math.random() * urunler.length)];
        const miktar = Math.floor(Math.random() * urun.maxQty) + 5;
        
        let karMarji = 1 + (Math.floor(Math.random() * 40) + 20) / 100;
        let fiyat = islemTipi === 'y' ? urun.baseFiyat * karMarji : urun.baseFiyat; 
        
        const gun = Math.floor(Math.random() * daysInMonth) + 1;
        // Eğer o anki aydaysak, verileri bugünden sonrasına atma
        if (i === 0 && gun > now.getDate()) continue;

        const tarih = new Date(yil, ay - 1, gun, Math.floor(Math.random() * 8) + 9);
        
        const evrakNo = `EVR-${yil}${String(ay).padStart(2,'0')}${String(gun).padStart(2,'0')}-${String(Math.floor(Math.random() * 1000)).padStart(3,'0')}`;
        let barkod = islemTipi === 'x' ? `x${String(xCount++).padStart(5, '0')}` : `y${String(yCount++).padStart(5, '0')}`;

        await Sayim.create({
          islemTipi, barkod, urunAdi: urun.ad, miktar, birimFiyat: Math.floor(fiyat),
          toplamTutar: miktar * Math.floor(fiyat),
          kaynakIsyeri: "TUIEVOLUTION Demo",
          fabrika: "1",
          tarihSaat: tarih, evrakNo, ozelKod1: `SF-DEMO`
        });
      }
    }
    console.log('Güncel test verileri başarıyla oluşturuldu! Sistem yepyeni.');
  } catch (error) {
    console.error("Gece bakımı sırasında hata:", error);
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Sunucu ${PORT} portunda çalışıyor`));