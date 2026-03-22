import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Layout from './components/Layout';
import FinancePage from './pages/FinancePage';
import ListPage from './pages/ListPage';
import SearchPage from './pages/SearchPage';
import ArchivePage from './pages/ArchivePage';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Layout />}>
          {/* Outlet içine gelecek sayfalar (Index: Ana sayfa demek) */}
          <Route index element={<FinancePage />} />
          <Route path="liste" element={<ListPage />} />
          <Route path="ara" element={<SearchPage />} />
          <Route path="arsiv" element={<ArchivePage />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;