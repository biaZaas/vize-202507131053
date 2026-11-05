# Yapay Zeka Kullanım Beyanı

Bu çalışmada Claude (Anthropic) kullandım.

| Aşama | Claude'a ne sordum / ne yaptı | Ben ne yaptım | Nasıl doğruladım |
|---|---|---|---|
| Veri seçimi | Bulduğum 3 veri setini senaryo kurallarına göre karşılaştırdı | Veri setlerini Hugging Face ve Kaggle'da kendim aradım ve indirdim | Kaggle sayfasındaki satır/sütun sayısını ve açıklamayı kendim okudum |
| Ham veri inceleme | Veriyi inceleyip boş sütunları, tarih formatlarını ve 3.128 tutarsız satırı buldu | — | Bulguları Kaggle'daki sütun bilgileriyle karşılaştırdım |
| SCENARIO.md | Başlıkları ve doldurmam için cümle kalıplarını verdi | Boşlukları doldurup metni kendim yazdım | Kura #42 senaryo metniyle karşılaştırdım |
| data/README.md | Şablonu ve veri bilgilerini verdi | Dosyayı kendim yazdım, bağlantıyı ve lisansı Kaggle'dan kendim aldım | Kaggle sayfasıyla karşılaştırdım |
| Git / GitHub | Komutları verdi | Repo, dal ve commit'leri kendim oluşturdum | GitHub'da dosyaların göründüğünü kontrol ettim |

Yapay zekanın ürettiği hiçbir veri satırı yoktur.

| scripts/temizle.py | Betiği Claude yazdı | Okudum ve kendi bilgisayarımda çalıştırdım | Çıktıda 85.907 satır okunduğunu gördüm |
| sql/hafta-04.sql | Yükleme ve dönüşüm sorgularını Claude yazdı | Bölümlerini okudum ve kendi PostgreSQL'imde çalıştırdım | Tutarsız kayıt sayısının (3.128) ve satır sayısının doğru olduğunu kontrol ettim |

| AI_BEYAN.md ve PR açıklaması | Metni Claude hazırladı | Okudum ve yaptıklarımla karşılaştırdım | Her satırın gerçekte yaptığım işle uyuştuğunu kontrol ettim |