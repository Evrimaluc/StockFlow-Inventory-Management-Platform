import { useState, useContext } from 'react';
import { SayimContext } from '../context/SayimContext';
import { FaTrash, FaEdit, FaChevronDown, FaChevronUp, FaExclamationTriangle } from 'react-icons/fa';

const ListItem = ({ item, isAdmin, currentMonth }) => {
  const { sayimSil, setIsFormOpen, setEditingItem } = useContext(SayimContext);
  
  const [isExpanded, setIsExpanded] = useState(false);
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false); // YENİ: Silme onay penceresi için state

  const isEski = new Date(item.tarihSaat).getMonth() + 1 !== currentMonth;
  const borderClass = item.islemTipi === 'x' ? 'border-autumn-red' : 'border-green-600';

  const handleEdit = (e) => {
    e.stopPropagation();
    setEditingItem(item);
    setIsFormOpen(true);
  };

  // Sil butonuna basıldığında sadece özel pencereyi aç
  const handleDeleteClick = (e) => {
    e.stopPropagation(); 
    setIsDeleteModalOpen(true);
  };

  // Pencerde "Evet, Sil" e basılırsa
  const confirmDelete = (e) => {
    e.stopPropagation();
    sayimSil(item._id);
    setIsDeleteModalOpen(false);
  };

  // Pencerde "İptal" e basılırsa
  const cancelDelete = (e) => {
    e.stopPropagation();
    setIsDeleteModalOpen(false);
  };

  return (
    <>
      <div className={`bg-autumn-card rounded-xl shadow-sm border-l-4 transition-colors hover:shadow-md mb-3 overflow-hidden ${borderClass}`}>
        <div className="flex justify-between items-center p-4 cursor-pointer" onClick={() => setIsExpanded(!isExpanded)}>
          <div>
            <h3 className="font-bold text-autumn-text">
              {item.urunAdi} <span className="text-xs opacity-70">({item.barkod})</span>
            </h3>
            <p className="text-sm font-medium text-autumn-text mt-1">
              Tutar: <span className="font-bold">₺{item.toplamTutar?.toLocaleString() || 0}</span> | Tarih: {new Date(item.tarihSaat).toLocaleDateString()}
            </p>
          </div>

          <div className="flex items-center gap-4">
            {(!isEski || isAdmin) && (
              <>
                <button onClick={handleEdit} className="text-white hover:text-autumn-rufous transition-colors" title="Düzenle">
                  <FaEdit size={18} />
                </button>
                {/* Olay handleDeleteClick'e bağlandı */}
                <button onClick={handleDeleteClick} className="text-autumn-red hover:text-red-900 transition-colors" title="Sil">
                  <FaTrash size={18} />
                </button>
              </>
            )}
            {isExpanded ? <FaChevronUp className="text-autumn-rufous" /> : <FaChevronDown className="text-autumn-rufous" />}
          </div>
        </div>

        {isExpanded && (
          <div className="p-4 bg-autumn-bg/50 border-t border-autumn-rufous/20 text-sm flex flex-col gap-1 text-autumn-text font-medium">
            <p><strong>Miktar:</strong> {item.miktar}</p>
            <p><strong>Birim Fiyat:</strong> ₺{item.birimFiyat?.toLocaleString() || 0}</p>
            <p><strong>Kaynak İşyeri:</strong> {item.kaynakIsyeri || '-'}</p>
            <p><strong>Fabrika:</strong> {item.fabrika || '-'}</p>
            <p><strong>Evrak No:</strong> {item.evrakNo || '-'}</p>
            <p><strong>Özel Kod:</strong> {item.ozelKod1 || '-'}</p>
            <p><strong>Açıklama:</strong> {item.aciklama || '-'}</p>
          </div>
        )}
      </div>

      {/* YENİ: ÖZEL SİLME ONAY PENCERESİ (MODAL) */}
      {isDeleteModalOpen && (
        <div 
          className="fixed inset-0 bg-black/60 z-[60] flex justify-center items-center p-4 animate-fade-in" 
          onClick={cancelDelete} // Arka plana tıklayınca kapat
        >
          <div 
            className="bg-autumn-bg p-6 rounded-xl w-full max-w-sm shadow-2xl text-autumn-text border-2 border-autumn-rufous/50 flex flex-col items-center text-center"
            onClick={(e) => e.stopPropagation()} // İçeri tıklayınca kapanmasını engelle
          >
            {/* Uyarı İkonu */}
            <div className="bg-autumn-red/10 p-4 rounded-full mb-4">
              <FaExclamationTriangle size={36} className="text-autumn-red" />
            </div>
            
            <h3 className="text-xl font-bold mb-2">Silme Onayı</h3>
            
            <p className="mb-6 font-medium">
              <span className="font-bold text-autumn-rufous">"{item.urunAdi}"</span> isimli işlemi silmek istediğinize emin misiniz?<br/>
              <span className="text-sm text-autumn-red font-bold mt-2 inline-block">Bu işlem kalıcıdır.</span>
            </p>
            
            <div className="flex gap-3 w-full">
              <button 
                onClick={cancelDelete} 
                className="flex-1 py-2.5 bg-autumn-card text-autumn-text rounded-lg hover:bg-white font-bold shadow-sm transition-colors border border-autumn-rufous/20"
              >
                İptal
              </button>
              <button 
                onClick={confirmDelete} 
                className="flex-1 py-2.5 bg-autumn-red text-white rounded-lg hover:bg-red-800 font-bold shadow-sm transition-colors"
              >
                Evet
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default ListItem;