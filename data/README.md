# Veri Kartı

## Kaynak
- Veri seti: eCommerce Customer Service Satisfaction (Kaggle, Dhruv D)
- Bağlantı: https://www.kaggle.com/datasets/ddosad/ecommerce-customer-service-satisfaction
- Lisans: Kaggle sayfasında "Other (specified in description)" yazıyor, açıklamada ayrı bir lisans metni bulamadım. Veri sadece ders/eğitim amacıyla kullanıldı. 
- İndirme tarihi: 05.11.2026
- Gerçek mi: Kaggle "Real World Data" diyor. Kimlik bilgileri (isimler) Faker ile değiştirilmiş. Ben hiçbir satır üretmedim.

## Boyut
- 85.907 satır, 20 sütun
- Tarih aralığı: 28 Temmuz – 31 Ağustos 2023

## Verideki sorunlar
1. Bazı sütunların yarısından fazlası boş
2. Tarih formatı her yerde aynı değil
3. 3.128 satırda yanıt zamanı, şikayet zamanından önce görünüyor
4. Kişisel bilgiler her ne kadar gizlenmiş olsada yönetici ve suoervizör isimleri duruyor

## Temizleme adımları
1. İsim sütunlarını kaldırmak
2. tarihleri aynı tip e çevirmek 
3. tutarsız  satırları işaretlemek ve silmek 