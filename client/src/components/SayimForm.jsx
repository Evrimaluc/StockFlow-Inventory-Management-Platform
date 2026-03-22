import { useState, useContext, useEffect } from 'react';
import { SayimContext } from '../context/SayimContext';

const SayimForm = ({ currentMonth, currentYear }) => {
  const { isFormOpen, setIsFormOpen, sayimEkle, sayimGuncelle, editingItem, setEditingItem } = useContext(SayimContext);

  const varsayilanState = { islemTipi: 'x', urunAdi: '', miktar: '', birimFiyat: '', kaynakIsyeri: '', fabrika: '', aciklama: '' };
  const [formData, setFormData] = useState(varsayilanState);

  useEffect(() => {
    if (editingItem) setFormData(editingItem);
    else setFormData(varsayilanState);
  }, [editingItem, isFormOpen]);

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!formData.urunAdi || !formData.miktar || !formData.birimFiyat) return alert("Lütfen zorunlu alanları doldurun.");
    
    if (editingItem) sayimGuncelle(editingItem._id, formData);
    else sayimEkle(formData);
    
    kapatForm();
  };

  const kapatForm = () => {
    setIsFormOpen(false);
    setEditingItem(null); 
  };

  if (!isFormOpen) return null;

  return (
    <div className="fixed inset-0 bg-black/60 z-50 flex justify-center items-center p-4">
      <form onSubmit={handleSubmit} className="bg-autumn-card p-6 rounded-xl w-full max-w-lg shadow-2xl font-sans text-autumn-text border-2 border-autumn-rufous/50">
        <h2 className="text-2xl font-bold mb-4 border-b-2 pb-2 border-autumn-rufous">
          {editingItem ? 'İşlemi Düzenle' : `Yeni İşlem Ekle (${currentMonth}/${currentYear})`}
        </h2>
        
        {!editingItem && (
          <div className="flex gap-4 mb-5 p-2 bg-autumn-bg rounded-lg shadow-inner">
            <label className="flex items-center gap-2 cursor-pointer p-2 hover:bg-autumn-red/10 rounded">
              <input type="radio" name="islemTipi" value="x" checked={formData.islemTipi === 'x'} onChange={e => setFormData({...formData, islemTipi: e.target.value})} className="accent-autumn-red w-5 h-5"/>
              <span className="text-autumn-red font-bold text-sm">Harcama/Alım (X)</span>
            </label>
            <label className="flex items-center gap-2 cursor-pointer p-2 hover:bg-green-600/10 rounded">
              <input type="radio" name="islemTipi" value="y" checked={formData.islemTipi === 'y'} onChange={e => setFormData({...formData, islemTipi: e.target.value})} className="accent-green-700 w-5 h-5"/>
              <span className="text-green-700 font-bold text-sm">Üretim/Satış (Y)</span>
            </label>
          </div>
        )}

        <div className="grid grid-cols-2 gap-4">
          <input required placeholder="Ürün Adı *" value={formData.urunAdi} className="col-span-2 p-3 rounded-lg border-2 border-autumn-rufous/30 bg-autumn-bg focus:ring-2 focus:ring-autumn-rufous outline-none font-medium placeholder-autumn-text/50" onChange={e => setFormData({...formData, urunAdi: e.target.value})} />
          <input required type="number" placeholder="Miktar *" value={formData.miktar} className="p-3 rounded-lg border-2 border-autumn-rufous/30 bg-autumn-bg focus:ring-2 focus:ring-autumn-rufous outline-none font-medium placeholder-autumn-text/50" onChange={e => setFormData({...formData, miktar: e.target.value})} />
          <input required type="number" placeholder="Birim Fiyat (₺) *" value={formData.birimFiyat} className="p-3 rounded-lg border-2 border-autumn-rufous/30 bg-autumn-bg focus:ring-2 focus:ring-autumn-rufous outline-none font-medium placeholder-autumn-text/50" onChange={e => setFormData({...formData, birimFiyat: e.target.value})} />
          <input placeholder="Kaynak İşyeri" value={formData.kaynakIsyeri} className="p-3 rounded-lg border-2 border-autumn-rufous/30 bg-autumn-bg focus:ring-2 focus:ring-autumn-rufous outline-none font-medium placeholder-autumn-text/50" onChange={e => setFormData({...formData, kaynakIsyeri: e.target.value})} />
          <input placeholder="Fabrika/Ambar" value={formData.fabrika} className="p-3 rounded-lg border-2 border-autumn-rufous/30 bg-autumn-bg focus:ring-2 focus:ring-autumn-rufous outline-none font-medium placeholder-autumn-text/50" onChange={e => setFormData({...formData, fabrika: e.target.value})} />
          <input placeholder="Açıklama" value={formData.aciklama} className="col-span-2 p-3 rounded-lg border-2 border-autumn-rufous/30 bg-autumn-bg focus:ring-2 focus:ring-autumn-rufous outline-none font-medium placeholder-autumn-text/50" onChange={e => setFormData({...formData, aciklama: e.target.value})} />
        </div>
        
        <div className="flex justify-end gap-3 mt-6 border-t-2 border-autumn-rufous/20 pt-4">
          <button type="button" onClick={kapatForm} className="px-5 py-2.5 bg-autumn-bg text-autumn-text rounded-lg hover:bg-white font-bold shadow-sm">İptal</button>
          <button type="submit" className="px-5 py-2.5 bg-autumn-rufous text-white rounded-lg hover:bg-autumn-red font-bold shadow-sm">
            {editingItem ? 'Güncelle' : 'Kaydet'}
          </button>
        </div>
      </form>
    </div>
  );
};

export default SayimForm;