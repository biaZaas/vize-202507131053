"""
Ham veriyi temizleyip ayri bir dosyaya yazar. Ham dosyaya dokunmaz.

Calistirma (repo ana klasorunden):
    python scripts/temizle.py

Neden gerekli?
  PostgreSQL'in \\copy komutu ham CSV'yi yuklerken su hatayi verdi:
      ERROR: extra data after last expected column
  Sebep: Bazi "Customer Remarks" metinlerinde tirnak icinde olmayan \\" karakterleri var.
  Python'un csv modulu bu satirlari dogru okuyor; bu betik veriyi standart,
  her alani tirnakli bir CSV olarak yeniden yaziyor.

Yapilanlar:
  1. Kisisel / kimlik alanlari cikarildi: Agent_name, Supervisor, Manager,
     Customer_City, Order_id ve serbest metin Customer Remarks.
  2. Customer Remarks yerine sadece "yorum_var" (1/0) bayragi tutuldu.
  3. Sutun adlari kucuk harf ve alt cizgi ile yazildi.
  Tarih ve sayi donusumleri SQL tarafinda (sql/hafta-04.sql) yapiliyor.
"""
import csv

HAM = "data/raw/Customer_support_data.csv"
TEMIZ = "data/clean/destek_temiz.csv"

# Ham sutun adi -> temiz sutun adi (listede olmayanlar cikarilir)
TUTULACAK = {
    "Unique id": "unique_id",
    "channel_name": "channel_name",
    "category": "category",
    "Sub-category": "sub_category",
    "order_date_time": "order_date_time",
    "Issue_reported at": "issue_reported_at",
    "issue_responded": "issue_responded",
    "Survey_response_Date": "survey_response_date",
    "Product_category": "product_category",
    "Item_price": "item_price",
    "connected_handling_time": "connected_handling_time",
    "Tenure Bucket": "tenure_bucket",
    "Agent Shift": "agent_shift",
    "CSAT Score": "csat_score",
}

okunan = 0
with open(HAM, encoding="utf-8", newline="") as giris, \
     open(TEMIZ, "w", encoding="utf-8", newline="") as cikis:
    okuyucu = csv.DictReader(giris)
    yazici = csv.writer(cikis, quoting=csv.QUOTE_ALL)
    yazici.writerow(list(TUTULACAK.values()) + ["yorum_var"])
    for satir in okuyucu:
        okunan += 1
        degerler = [satir[eski].strip() for eski in TUTULACAK]
        yorum_var = 1 if satir["Customer Remarks"].strip() else 0
        yazici.writerow(degerler + [yorum_var])

print(f"Okunan satir: {okunan}")
print(f"Temiz dosya yazildi: {TEMIZ}")
