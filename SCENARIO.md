# Senaryo: Kura #42

- Öğrenci no: 202507131053 (Kura #42)
- Alan × Sistem × YZ: Perakende ve e-ticaret × Sohbet asistanı × Anomali tespiti 

## Problem : 
Bir e-ticaret firmasının müşteri hizmetlerine her gün yaklaşık 2700 talep geliyor. Taleplerin çoğu iade ve sipariş konularında.

Bazı zamanlarda talep birden artıyor ve bunu firma farkedene kadar geç oluyor.

## Ana Soru: 
Talep sayılarında normal dışı artışlar hangi konuda ve hangi saat aralığında oluşuyor?
 
## Hedef kullanıcı: 
Bu analizi müşteri hizmetleri kullanır. Amacı, artışları erken görüp önlem almak.

## Tablo adayları:

- conversations(id, topic, started_at, message_count)
  Benim verimdeki karşılığı: Unique id, category, Issue_reported at.
  Verimde mesaj sayısı yok, onun yerine cevap süresi kullanacağım.

- topic_categories(id, name)
  Benim verimdeki karşılığı: category sütunundaki 12 farklı konu.

- messages(id, conversation_id, sender, message_time)
  Verimde her satır tek bir talep, mesaj düzeyinde kayıt yok.
  Bu tablo bu veriyle kullanılamıyor .

## YZ bileşeni:

Dönem sonunda, her konu için beklenen talep sayısını hareketli ortalama ile tahmin eden ve gerçek sayı beklenenden çok yüksek olduğunda uyarı kaydı açan bir izleme tablosu yapılacak.

Dikkat: Talep artışı her zaman bir sorun demek değildir, kampanya etkisi de olabilir.

## Veri kaynağı:

Kaggle'daki "eCommerce Customer Service Satisfaction" veri setini seçtim (85.907 satır). Çünkü içinde konu, tarih-saat ve memnuniyet var.

Elediğim adaylar:
- Bitext (Hugging Face): tarih yok ve veri sentetik 
- Customer Support on Twitter (Kaggle): konu sütunu yok ve çok büyük

