import { useContext } from 'react';
import { SayimContext } from '../context/SayimContext';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, ReferenceLine } from 'recharts';

const ArchivePage = () => {
  const { arsivVerileri } = useContext(SayimContext);

  // Akıllı Rakam Formatlayıcı (Eksi değerler ve M/K harfleri)
  const currencyFormatter = (value) => {
    if (value === 0) return "0 ₺"; // Sıfır noktası için net format
    const isaret = value < 0 ? '-' : '';
    const mutlakDeger = Math.abs(value);
    
    if (mutlakDeger >= 1000000) {
      return `${isaret}${(mutlakDeger / 1000000).toFixed(1)}M ₺`;
    } else if (mutlakDeger >= 1000) {
      return `${isaret}${(mutlakDeger / 1000).toFixed(0)}K ₺`;
    }
    return `${isaret}${mutlakDeger} ₺`;
  };

  // Son 12 ayın verisini al
  const twelveMonthsData = arsivVerileri.slice(-12);

  const maxAbs = twelveMonthsData.length > 0
    ? Math.max(...twelveMonthsData.map(d => Math.abs(d.kar)))
    : 10000;

  const limit = maxAbs * 1.15;
  
  const yTicks = [-limit, -limit / 2, 0, limit / 2, limit];

  return (
    <div className="space-y-6 animate-fade-in">
      <h2 className="text-2xl font-bold border-b-2 pb-2 border-autumn-rufous text-autumn-text">
        Yıllık Analiz
      </h2>
      
      <div className="bg-autumn-card p-6 rounded-xl shadow-md h-[450px] border border-autumn-rufous/20">
        <h3 className="text-lg font-bold mb-4 text-center">Net Kar / Zarar Eğilimi (Son 12 Ay)</h3>
        {arsivVerileri.length === 0 ? (
          <div className="h-full flex items-center justify-center font-medium">Arşiv için veri yok.</div>
        ) : (
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={twelveMonthsData} margin={{ top: 20, left: 10, right: 30, bottom: 40 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#7a4e39" opacity={0.2} />
              
              <XAxis 
                dataKey="zaman" 
                stroke="#3D1C02" 
                fontWeight="bold" 
                padding={{ left: 40, right: 40 }} 
              />
              <YAxis 
                stroke="#3D1C02" 
                fontWeight="bold" 
                width={85} 
                tickFormatter={currencyFormatter}
                domain={[-limit, limit]}
                ticks={yTicks}
              />
              
              <Tooltip 
                contentStyle={{backgroundColor: '#f4e3b2', color: '#3D1C02', border: 'none', borderRadius: '8px', boxShadow: '0 4px 15px rgba(0,0,0,0.2)'}}
                formatter={(value) => `${value.toLocaleString()} ₺`} 
              />
              
              <Legend 
                iconSize={20}
                wrapperStyle={{ color: '#3D1C02', fontWeight: 'bold', paddingTop: '20px' }}
                formatter={(value) => <span className="ml-2">{value}</span>}
              />

              {/* Tam '0' noktasına çizilen referans çizgisi */}
              <ReferenceLine y={0} stroke="#3D1C02" strokeWidth={2} strokeOpacity={0.4} />
              
              <Line 
                type="monotone" 
                dataKey="kar" 
                stroke="#F97316" 
                strokeWidth={4}  
                name="Net Kar" 
                dot={{ fill: '#F97316', r: 6, strokeWidth: 2, stroke: '#e5a96a' }} 
                activeDot={{ r: 9, strokeWidth: 0 }}
              />
            </LineChart>
          </ResponsiveContainer>
        )}
      </div>
      
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {arsivVerileri.length === 0 ? (
          <p className="col-span-3 text-center font-medium mt-10">Henüz arşiv verisi yok.</p>
        ) : (
          [...twelveMonthsData].reverse().map((aylik, idx) => (
            <div key={idx} className="bg-autumn-card p-4 rounded-lg shadow-sm border border-autumn-rufous/30 hover:border-autumn-rufous transition-colors">
              <h3 className="font-bold text-lg mb-2">{aylik.zaman} Finans Özeti</h3>
              <p className="text-green-700 font-bold">Gelir: ₺{aylik.gelir.toLocaleString()}</p>
              <p className="text-autumn-red font-bold">Gider: ₺{aylik.gider.toLocaleString()}</p>
              <p className={`font-extrabold mt-2 border-t border-autumn-rufous/20 pt-2 ${aylik.kar < 0 ? 'text-autumn-red' : 'text-autumn-text'}`}>
                {aylik.kar >= 0 ? 'Kar' : 'Zarar'}: ₺{Math.abs(aylik.kar).toLocaleString()}
              </p>
            </div>
          ))
        )}
      </div>
    </div>
  );
};
export default ArchivePage;