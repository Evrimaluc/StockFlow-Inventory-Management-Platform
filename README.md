**birinci vers:**
Bugün, Flutter ile bir envanter yönetim uygulamasının bir parçası olan ürün ekleme, düzenleme, görüntüleme ve silme işlevlerini içeren bir sayfa üzerinde çalıştım. Uygulama, kullanıcıların ürün bilgilerini girmesini sağlayan form alanlarıyla başlıyor. Formda barkod, miktar, ürün adı, kaynak işyeri gibi bilgilerin her biri için bir TextFormField kullanılıyor. Kullanıcı formu doldurduktan sonra veriler, Provider ile merkezi bir veri kaynağına (SayimData) ekleniyor.

Bir ürün ekledikten sonra, bu ürünler listeleniyor ve her bir ürün için genişletilebilir bir başlık (ExpansionTile) gösteriliyor. Burada kullanıcı ürünün detaylarını görebilir ve düzenleyebilir. Ürün düzenleme için bir diyalog penceresi açılıyor, burada kullanıcı bilgileri güncelleyebiliyor veya ürünü silebiliyor.

Tarih ve saat bilgisi de her ürün ekleme işleminde otomatik olarak kaydediliyor. Bu sayfa genel olarak kullanıcı dostu ve işlevsel bir ürün ekleme ve yönetme arayüzü sunuyor.

Veri yönetimi için Provider kullanarak ürün ekleme, güncelleme ve silme işlemleri merkezileştirilmiş şekilde gerçekleştiriliyor. Bu, uygulamanın tüm bileşenlerinin güncel veriye hızlı bir şekilde erişmesini sağlıyor.


**ikinci vers:**
Bugün Flutter ile bir envanter yönetimi uygulamasında ürün ekleme, düzenleme, listeleme ve silme işlemlerini içeren bir sayfa geliştirdim.

Sayfanın üst kısmında, kullanıcıların ürün bilgilerini girebileceği bir form yer alıyor. Bu formda barkod, miktar, ürün adı, kaynak işyeri, fabrika, ambar, evrak numarası, özel kod ve açıklama gibi birçok alan bulunuyor. Her biri için TextFormField kullanarak kullanıcıdan giriş alınıyor.

Kullanıcı formu doldurduğunda, bilgiler Provider yapısıyla SayimData adlı veri yöneticisine gönderiliyor. Burada SayimModel modeliyle birlikte yeni ürünler sisteme ekleniyor. Bu sayede veriler uygulama genelinde kullanılabilir oluyor.

Eklenen ürünler listeleniyor ve her ürün bir ExpansionTile ile gösteriliyor. Bu yapı sayesinde kullanıcı ürünün detaylarını görmek için kutuyu genişletebiliyor. Ürünlerin başlık kısmında barkoda göre farklı renklerde görsel vurgular yapılıyor (örneğin, "y" ile başlayan barkodlar yeşil, "x" ile başlayanlar kırmızı renkte gösteriliyor).

Her ürünün detay kısmında, düzenleme veya silme seçenekleri bulunuyor. Kullanıcı "düzenle" ikonuna bastığında, mevcut bilgilerle dolu bir diyalog (AlertDialog) açılıyor. Burada kullanıcı verileri güncelleyebiliyor ya da ürünü tamamen silebiliyor.

Ayrıca, ürün eklenirken güncel tarih ve saat bilgisi de otomatik olarak kayıt altına alınıyor.

Bu sayfa sayesinde kullanıcılar, ürünleri hem manuel olarak ekleyebiliyor hem de daha sonra bu ürünleri düzenleyip silebiliyor. Uygulama genelinde Provider ile veri yönetimi yapıldığı için, işlemler tüm bileşenler arasında anlık olarak senkronize bir şekilde çalışıyor.


![image](https://github.com/user-attachments/assets/fb544a0c-1853-473f-894b-12b149f7b4ea)
![image](https://github.com/user-attachments/assets/8fe39016-f9f5-4c9f-837d-a62e7383ac0b)
![image](https://github.com/user-attachments/assets/8d81c6b9-2a90-4ad2-a735-3b162a21ba5e)







**1. Gün: Uygulamanın Temelleri ve Ürün Ekleme Sayfası**





Bugün, uygulamanın temel yapı taşlarını anlamaya ve ilk adım olarak Ürün Ekleme Sayfası üzerine çalışmaya başladım. Bu sayfa, kullanıcının ürün bilgilerini girmesi için bir formdan oluşuyor. Formda, Barkod, Miktar, Ürün Adı, Kaynak İşyeri, Fabrika, Kaynak Ambar, Evrak No, Özel Kod 1 ve Açıklama gibi bilgiler alınmakta. Bu verilerin her biri, bir TextEditingController ile kontrol ediliyor, böylece kullanıcıların girdiği veriler programda saklanabiliyor.

Bu formu, her bir input alanına OutlineInputBorder ekleyerek görsel olarak daha çekici ve kullanıcı dostu hale getirdim. Bunun dışında, ElevatedButton kullanarak bir "Ürünü Ekle" butonu oluşturdum. Bu buton tıklandığında, formdaki tüm veriler alınarak bir SayimModel objesine dönüştürülüyor. Kullanıcı, formu doldurduktan sonra bu objeyi, uygulamanın genel veri yönetimi için kullanılan Provider yapısına ekliyoruz. Bu sayede, sayım verileri her yerde erişilebilir oluyor.

Ayrıca, formun kullanıcı dostu olabilmesi için, her alanın düzenli ve erişilebilir olmasına dikkat ettim. SizedBox kullanarak her input arasında yeterli boşluk bırakarak, formun daha temiz ve düzenli görünmesini sağladım.







**2. Gün: Verilerin Eklenmesi ve Temizlenmesi**





Bugün, ürünlerin eklenmesi ve form temizliği işlemleri üzerine yoğunlaştım. Kullanıcı “Ürünü Ekle” butonuna tıkladığında, formdaki veriler, SayimModel olarak bir araya getirilip, Provider aracılığıyla sayım listesine ekleniyor. sayimEkle() fonksiyonu, bu yeni verileri veritabanına eklememizi sağlıyor.

Formdaki her bir alanı TextEditingController aracılığıyla topladım ve bir SayimModel objesi oluşturup, bunu SayimData sınıfına gönderdim. Sayım verileri, kullanıcı veritabanına kaydedildiğinde, sayfa yenileniyor ve kullanıcı eklediği ürünü görmeye devam edebiliyor.

Ayrıca, formun daha verimli çalışabilmesi için _clearControllers() fonksiyonunu ekledim. Bu fonksiyon, kullanıcı yeni bir ürün girişi yaptıktan sonra formdaki tüm TextEditingController nesnelerini temizliyor. Bu, aynı sayfada birden fazla ürün girişi yapılmasını sağlıyor ve kullanıcıyı bir sonraki veri girişi için rahatlatıyor.





**3. Gün: Ürün Detaylarının Görüntülenmesi ve Düzenlenmesi**




Bugün, kullanıcıların ekledikleri ürünlerin detaylarını görüp düzenleyebileceği bir ProductListItem widget'ı oluşturdum. Bu widget, her ürünü ExpansionTile içinde görüntülüyor. Kullanıcı, ürün ismine tıkladığında, ürünle ilgili detaylı bilgiler açılır bir panelde görünüyor. Ürün adı, barkod, miktar gibi bilgilerin yanı sıra, Kaynak İşyeri, Fabrika, Kaynak Ambar gibi ek bilgiler de burada yer alıyor.

Eklediğim barkod renk düzeni sayesinde, ürünler barkod bilgilerine göre renklerle ayrılıyor. Eğer bir ürünün barkodu "y" harfi ile başlıyorsa, bu ürün yeşil renkte gösteriliyor. Eğer barkod "x" ile başlıyorsa, bu ürün kırmızı renkte görünüyor. Bu görsel ayrım, kullanıcıların ürünleri daha hızlı ve kolay bir şekilde tanımlamalarına olanak sağlıyor.

Ayrıca, kullanıcılara ürünlerini düzenleyebilme imkanı sundum. Her ürünün sağ köşesinde bir düzenleme ikonu bulunuyor. Kullanıcı bu ikona tıkladığında, düzenleme penceresi açılıyor ve mevcut ürün bilgileriyle bir form dolduruluyor. Kullanıcı, sadece değiştirmek istediği alanları güncelleyerek, mevcut ürünü düzenleyebiliyor. Bu özellik, sayimGuncelle() fonksiyonu ile sağlanıyor.







**4. Gün: Ürün Silme ve Görsel Düzenlemeler**





Bugün, kullanıcıların mevcut ürünleri silme özelliklerini ekledim. Her düzenleme penceresinde, bir “Ürünü Sil” butonu bulunuyor. Kullanıcı bu butona tıkladığında, sayimSil() fonksiyonu devreye giriyor ve seçilen ürün sayım listesinden kaldırılıyor. Bu, özellikle yanlış girilen ürünlerin veya artık ihtiyaç duyulmayan ürünlerin sistemden silinmesine olanak tanıyor.

Ayrıca, ürünlerin görsel düzenlemeleri üzerinde çalıştım. Ürünlerin barkod renkleri daha da belirgin hale getirildi. Eğer barkod bilgisi "y" harfi ile başlıyorsa, o ürün yeşil renkte görünüyor, "x" ile başlıyorsa kırmızı renkte gösteriliyor. Bu renk kodları, kullanıcıya anında bir bilgi sunuyor ve ürünün durumunu hızlıca anlamalarına yardımcı oluyor. Bu özellik görsel olarak kullanıcı deneyimini zenginleştiriyor.






**5. Gün: Tarih ve Saat Ekleme, Performans İyileştirmeleri**




Bugün, ürünlerin eklenme tarih ve saat bilgisini kaydeden bir özellik ekledim. Kullanıcı ürün eklediğinde, sistem otomatik olarak DateFormat sınıfı ile ürünün eklenme tarih ve saatini kaydediyor. Bu bilgi, ürünle birlikte tarihSaat alanında saklanıyor ve kullanıcılara ürünlerin eklenme zamanını gösteriyor. Bu özellik, özellikle en son eklenen ürünleri takip etmek isteyen kullanıcılar için faydalı.

Ayrıca, uygulamanın performansını artırmak için küçük iyileştirmeler yaptım. Özellikle listeleme sırasında, ListView.builder kullanarak sadece ekranda görünen ürünlerin yüklenmesini sağladım. Bu yöntem, daha büyük veri kümeleri ile çalışırken uygulamanın daha hızlı çalışmasına yardımcı oluyor ve belleği daha verimli kullanıyor.

Son olarak, uygulamanın genel stabilitesini sağlamak adına bazı küçük hata düzeltmeleri ve optimizasyonlar gerçekleştirdim. Bu adımlar sayesinde, uygulamanın veri yönetimi çok daha verimli hale geldi ve kullanıcı deneyimi iyileştirildi.






