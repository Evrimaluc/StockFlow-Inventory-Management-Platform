import { useContext } from 'react';
import { SayimContext } from '../context/SayimContext';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

const FinancePage = () => {
  const { sayimListesi } = useContext(SayimContext);
  
  const currentMonth = new Date().getMonth() + 1;
  const currentYear = new Date().getFullYear();
  
  const buAykiVeriler = sayimListesi.filter(item => {
    const d = new Date(item.tarihSaat);
    return d.getMonth() + 1 === currentMonth && d.getFullYear() === currentYear;
  });

  const buAyGelir = buAykiVeriler.filter(i => i.islemTipi === 'y').reduce((sum, i) => sum + (i.toplamTutar || 0), 0);
  const buAyGider = buAykiVeriler.filter(i => i.islemTipi === 'x').reduce((sum, i) => sum + (i.toplamTutar || 0), 0);
  const buAyKar = buAyGelir - buAyGider;

  const daysInMonth = new Date(currentYear, currentMonth, 0).getDate(); 
  const gunlukVeriler = Array.from({ length: daysInMonth }, (_, i) => {
    const gun = i + 1;
    const gununIslemleri = buAykiVeriler.filter(item => new Date(item.tarihSaat).getDate() === gun);
    return {
      zaman: `${gun}`,
      gelir: gununIslemleri.filter(x => x.islemTipi === 'y').reduce((sum, x) => sum + (x.toplamTutar || 0), 0),
      gider: gununIslemleri.filter(x => x.islemTipi === 'x').reduce((sum, x) => sum + (x.toplamTutar || 0), 0)
    };
  });

  const currencyFormatter = (value) => {
    if (value >= 1000000) {
      return `${(value / 1000000).toFixed(1)}M ₺`;
    } else if (value >= 1000) {
      return `${(value / 1000).toFixed(0)}K ₺`;
    }
    return `${value} ₺`;
  };

  return (
    <div className="space-y-6 animate-fade-in">
      <h2 className="text-2xl font-bold border-b-2 pb-2 border-autumn-rufous text-autumn-text">
        Anlık Finans Durumu ({currentMonth}/{currentYear})
      </h2>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        
        <div className="p-6 rounded-xl bg-autumn-card shadow-md border-l-4 border-autumn-red">
          <p className="text-sm font-bold opacity-80">Bu Ayki Gider (Alış)</p>
          <p className="text-3xl font-bold text-autumn-red">₺{buAyGider.toLocaleString()}</p>
        </div>
        
        <div className="p-6 rounded-xl bg-autumn-card shadow-md border-l-4 border-green-600">
          <p className="text-sm font-bold opacity-80">Bu Ayki Üretim (Gelir)</p>
          <p className="text-3xl font-bold text-green-700">₺{buAyGelir.toLocaleString()}</p>
        </div>
        
        <div className={`p-6 rounded-xl bg-autumn-card shadow-md border-l-4 ${buAyKar >= 0 ? 'border-[#febe35]' : 'border-autumn-red'}`}>
          <p className="text-sm font-bold opacity-80">Net Kar / Zarar</p>
          <p className={`text-3xl font-bold ${buAyKar >= 0 ? 'text-[#f4d549] drop-shadow-sm' : 'text-autumn-red'}`}>
            ₺{buAyKar.toLocaleString()}
          </p>
        </div>

      </div>
      
    <div className="bg-autumn-card p-6 rounded-xl shadow-md h-[420px] border border-autumn-rufous/20">
        <h3 className="text-lg font-bold mb-6 text-center">Ay İçi Nakit Akışı (Günlük)</h3>
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={gunlukVeriler} margin={{ top: 10, left: 20, bottom: 30 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="#7a4e39" opacity={0.2} />
            <XAxis dataKey="zaman" stroke="#3D1C02" fontWeight="bold" />
            <YAxis stroke="#3D1C02" fontWeight="bold" tickFormatter={currencyFormatter} />
            <Tooltip 
              contentStyle={{backgroundColor: '#f4e3b2', color: '#3D1C02', border: 'none', borderRadius: '8px'}}
              formatter={(value) => `${value.toLocaleString()} ₺`} 
            />
            
            {/* DEĞİŞEN KISIM: formatter eklendi */}
            <Legend 
              iconSize={20} 
              wrapperStyle={{ 
                color: '#3D1C02', 
                fontWeight: 'bold', 
                marginTop: '30px', 
                borderTop: '1px solid #7a4e3920', 
                paddingTop: '15px' 
              }}
              /* Yazının soluna (ml-2) ikonla arayı açması için, sağına (mr-10) diğer öğeyle arayı açması için boşluk verdik (mr-10 yaklaşık 1 cm yapar) */
              formatter={(value) => <span className="ml-2 mr-10">{value}</span>}
            />
            
            <Bar dataKey="gider" fill="#ed3419" name="Gider (Alış)" radius={[6, 6, 0, 0]} />
            <Bar dataKey="gelir" fill="#16a34a" name="Üretim (Gelir)" radius={[6, 6, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
};
export default FinancePage;