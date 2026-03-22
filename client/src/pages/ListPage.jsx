import { useContext } from 'react';
import { SayimContext } from '../context/SayimContext';
import ListItem from '../components/ListItem';

const ListPage = () => {
  const { sayimListesi, isAdmin } = useContext(SayimContext);
  const currentMonth = new Date().getMonth() + 1;

  return (
    <div className="space-y-4 animate-fade-in">
      <h2 className="text-3xl font-bold border-b-2 pb-2 border-autumn-rufous text-autumn-text">Ürün Listesi</h2>
      {sayimListesi.length === 0 ? (
        <p className="text-center font-medium mt-10">Henüz fiş eklenmedi.</p>
      ) : (
        <div className="space-y-3">
          {sayimListesi.map(item => <ListItem key={item._id} item={item} isAdmin={isAdmin} currentMonth={currentMonth}/>)}
        </div>
      )}
    </div>
  );
};
export default ListPage;