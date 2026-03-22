const mongoose = require('mongoose');

const SayimSchema = new mongoose.Schema({
  islemTipi: { type: String, enum: ['x', 'y'], required: true }, // x: Harcama/Alış, y: Üretim/Satış
  barkod: { type: String, unique: true }, // Otomatik: x00001, y00002
  urunAdi: { type: String, required: true },
  miktar: { type: Number, required: true },
  birimFiyat: { type: Number, required: true }, // Alış veya Satış fiyatı
  toplamTutar: { type: Number }, // miktar * birimFiyat
  kaynakIsyeri: { type: String }, // Çiçek isimleri (Gül, Lale vb.)
  fabrika: { type: String }, // 1-10
  kaynakAmbar: { type: String }, // 1-10
  tarihSaat: { type: Date, default: Date.now },
  evrakNo: { type: String }, // Otomatik: EVR-YYYYMMDD-XXXX
  ozelKod1: { type: String }, // Otomatik: SF-X-YYYY veya SF-Y-YYYY
  aciklama: { type: String }, // Savunma sanayi 2 kelime
});

// Kaydetmeden önce toplam tutarı hesapla (Modern Async Yöntem)
SayimSchema.pre('save', async function() {
  this.toplamTutar = this.miktar * this.birimFiyat;
});

module.exports = mongoose.model('Sayim', SayimSchema);