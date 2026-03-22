import { useContext } from 'react';
import { Outlet, NavLink } from 'react-router-dom';
import { Plus, List, BarChart3, Archive, Search } from 'lucide-react';
import { SayimContext } from '../context/SayimContext';
import SayimForm from './SayimForm';

const Layout = () => {
  const { setIsFormOpen, setEditingItem } = useContext(SayimContext);
  const currentMonth = new Date().getMonth() + 1;
  const currentYear = new Date().getFullYear();

  return (
    <div className="min-h-screen bg-autumn-bg text-autumn-text pb-28 font-sans">
      <header className="bg-autumn-rufous p-4 shadow-lg sticky top-0 z-10 flex justify-between items-center text-white border-b-2 border-white/20">
        <h1 className="text-3xl font-bold tracking-tight">
          StockFlow <span className="text-autumn-bg opacity-90">Management</span>
        </h1>
        <div className="flex items-center gap-6">
          <a href="https://tuievolution.vercel.app/" target="_blank" rel="noreferrer" className="tracking-tight hover:scale-105 transition-transform">
            <h2 className="text-3xl  font-extrabold">
              <span className="bg-clip-text text-transparent bg-linear-to-r from-accent to-yellow-400 drop-shadow-md">
                 TUIEVOLUTION
              </span>
            </h2>
          </a>
        </div>
      </header>

      <main className="p-4 max-w-7xl mx-auto mt-6">
        {/* React Router'ın sayfaları render edeceği yer (Yer Tutucu) */}
        <Outlet />
      </main>

      {/* FAB - Yeni Ekle Butonu */}
      <button onClick={() => { setEditingItem(null); setIsFormOpen(true); }} className="fixed bottom-28 right-6 bg-autumn-red text-white p-4 rounded-full shadow-2xl hover:bg-autumn-rufous transition-transform hover:scale-110 z-20">
        <Plus size={28} />
      </button>

      <SayimForm currentMonth={currentMonth} currentYear={currentYear}/>

      {/* Alt Menü - NavLink kullanıldı (Aktif olana renk verir) */}
      <nav className="fixed bottom-0 w-full bg-autumn-rufous text-white flex justify-around p-3 shadow-[0_-5px_15px_rgba(0,0,0,0.3)] z-10 pb-safe border-t-2 border-white/20">
        <NavLink to="/ara" className={({isActive}) => `flex flex-col items-center transition-colors ${isActive ? 'text-autumn-yellow scale-105' : 'text-gray-200 hover:text-white'}`}>
          <Search size={28} /> <span className="text-xs mt-1 font-medium">Ara</span>
        </NavLink>
        <NavLink to="/liste" className={({isActive}) => `flex flex-col items-center transition-colors ${isActive ? 'text-autumn-yellow scale-105' : 'text-gray-200 hover:text-white'}`}>
          <List size={28} /> <span className="text-xs mt-1 font-medium">Liste</span>
        </NavLink>
        <NavLink to="/" className={({isActive}) => `flex flex-col items-center transition-colors ${isActive ? 'text-autumn-yellow scale-105' : 'text-gray-200 hover:text-white'}`}>
          <BarChart3 size={28} /> <span className="text-xs mt-1 font-medium">Finans</span>
        </NavLink>
        <NavLink to="/arsiv" className={({isActive}) => `flex flex-col items-center transition-colors ${isActive ? 'text-autumn-yellow scale-105' : 'text-gray-200 hover:text-white'}`}>
          <Archive size={28} /> <span className="text-xs mt-1 font-medium">Arşiv</span>
        </NavLink>
      </nav>
    </div>
  );
};
export default Layout;