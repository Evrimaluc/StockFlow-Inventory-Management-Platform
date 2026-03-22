import { createContext, useState, useEffect } from 'react';
import axios from 'axios';

export const SayimContext = createContext();

export const SayimProvider = ({ children }) => {
  const [sayimListesi, setSayimListesi] = useState([]);
  const [arsivVerileri, setArsivVerileri] = useState([]);
  const [isAdmin, setIsAdmin] = useState(true); 
  
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [editingItem, setEditingItem] = useState(null);

  const fetchVeriler = async () => {
    try {
      const res = await axios.get('http://localhost:5000/api/sayim');
      const arsivRes = await axios.get('http://localhost:5000/api/archive');
      setSayimListesi(res.data);
      setArsivVerileri(arsivRes.data);
    } catch (error) { console.error("Veri çekme hatası:", error); }
  };

  useEffect(() => { fetchVeriler(); }, []);

  const sayimEkle = async (yeniVeri) => {
    try {
      await axios.post('http://localhost:5000/api/sayim', yeniVeri);
      await fetchVeriler(); // YENİ: UI güncellenmesi için bekleniyor
      return true;
    } catch (error) { 
      console.error("Veri ekleme hatası:", error);
      alert("Hata oluştu: " + (error.response?.data?.error || "Sunucu hatası"));
      return false;
    }
  };

  const sayimSil = async (id) => {
    try {
      await axios.delete(`http://localhost:5000/api/sayim/${id}`);
      await fetchVeriler(); // YENİ: Anında tüm sayfalardan silinmesi için bekleniyor
    } catch (error) { console.error("Veri silme hatası:", error); }
  };

  const sayimGuncelle = async (id, guncelVeri) => {
    try {
      await axios.put(`http://localhost:5000/api/sayim/${id}`, guncelVeri);
      await fetchVeriler(); // YENİ: Bekleniyor
      return true;
    } catch (error) { 
      console.error("Güncelleme hatası:", error); 
      alert("Hata oluştu: " + (error.response?.data?.error || "Sunucu hatası"));
      return false;
    }
  };

  return (
    <SayimContext.Provider value={{
      sayimListesi, arsivVerileri, sayimEkle, sayimSil, sayimGuncelle, fetchVeriler,
      isAdmin, isFormOpen, setIsFormOpen, editingItem, setEditingItem
    }}>
      {children}
    </SayimContext.Provider>
  );
};