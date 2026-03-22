import { useContext, useState } from 'react';
import { SayimContext } from '../context/SayimContext';
import ListItem from '../components/ListItem';

const SearchPage = () => {
  const { sayimListesi, isAdmin } = useContext(SayimContext);
  const [searchText, setSearchText] = useState('');
  const [searchType, setSearchType] = useState('barkod');
  const currentMonth = new Date().getMonth() + 1;

  const aramaTipleri = [
    { id: 'barkod', label: 'Barkod' }, { id: 'miktar', label: 'Miktar' },
    { id: 'urunAdi', label: 'Ürün Adı' }, { id: 'kaynakIsyeri', label: 'Kaynak İşyeri' },
    { id: 'fabrika', label: 'Fabrika' }, { id: 'evrakNo', label: 'Evrak No' }
  ];

  const filteredSayimListesi = sayimListesi.filter(item => {
    if (!searchText) return true;
    const val = item[searchType] ? String(item[searchType]).toLowerCase() : '';
    return searchType === 'barkod' ? val.startsWith(searchText.toLowerCase()) : val.includes(searchText.toLowerCase());
  });

  return (
    <div className="flex flex-col gap-4 animate-fade-in">
      <div className="flex overflow-x-auto gap-2 pb-2">
        {aramaTipleri.map(type => (
          <button key={type.id} onClick={() => setSearchType(type.id)}
            className={`px-4 py-2 rounded-full whitespace-nowrap text-sm font-bold border transition-colors ${
              searchType === type.id ? 'bg-autumn-rufous text-white border-autumn-rufous' : 'bg-autumn-card text-autumn-text border-autumn-rufous/30 hover:bg-autumn-card/80'
            }`}
          >
            {type.label}
          </button>
        ))}
      </div>
      <input type="text" placeholder={`${aramaTipleri.find(t => t.id === searchType)?.label} ara...`} onChange={(e) => setSearchText(e.target.value)}
        className="w-full p-3 border border-autumn-rufous/30 rounded-lg focus:outline-none focus:ring-2 focus:ring-autumn-rufous shadow-sm bg-autumn-card text-autumn-text"
      />
      <div className="mt-4 space-y-3">
        {filteredSayimListesi.length === 0 ? (
          <p className="text-center font-medium mt-10">Aranan kriterde fiş bulunamadı.</p>
        ) : (
          filteredSayimListesi.map(item => <ListItem key={item._id} item={item} isAdmin={isAdmin} currentMonth={currentMonth}/>)
        )}
      </div>
    </div>
  );
};
export default SearchPage;