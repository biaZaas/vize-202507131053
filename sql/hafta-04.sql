-- =====================================================================
-- Hafta 4: Veriyi PostgreSQL'e yükleme, tip dönüşümü ve ilk SELECT'ler
--
-- Çalıştırma sırası (repo ana klasöründen, PowerShell):
--   1) python scripts/temizle.py
--   2) psql -U postgres -d vize -f sql/hafta-04.sql
--
-- Ham dosya (data/raw/) hiç değiştirilmez. Kişisel alanları çıkarılmış
-- ara dosya data/clean/destek_temiz.csv'dir.
-- =====================================================================

-- 1) YÜKLEME TABLOSU
-- Bütün sütunlar TEXT olarak alınır. Böylece boş ya da bozuk değerler
-- yüklemede hata vermez; sorunları SQL ile görebiliriz.
DROP TABLE IF EXISTS destek_yukleme;
CREATE TABLE destek_yukleme (
    unique_id               TEXT,
    channel_name            TEXT,
    category                TEXT,
    sub_category            TEXT,
    order_date_time         TEXT,
    issue_reported_at       TEXT,
    issue_responded         TEXT,
    survey_response_date    TEXT,
    product_category        TEXT,
    item_price              TEXT,
    connected_handling_time TEXT,
    tenure_bucket           TEXT,
    agent_shift             TEXT,
    csat_score              TEXT,
    yorum_var               TEXT
);

\copy destek_yukleme FROM 'data/clean/destek_temiz.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')

-- Kaç satır yüklendi? (Beklenen: 85907)
SELECT COUNT(*) AS yuklenen_satir FROM destek_yukleme;


-- 2) VERİDEKİ SORUNLARI GÖRMEK
-- Boş alanlar CSV'den '' (boş metin) olarak gelir. Sütun başına kaç boş var?
SELECT
    COUNT(*) FILTER (WHERE order_date_time = '')         AS bos_siparis_tarihi,
    COUNT(*) FILTER (WHERE product_category = '')        AS bos_urun_kategorisi,
    COUNT(*) FILTER (WHERE item_price = '')              AS bos_fiyat,
    COUNT(*) FILTER (WHERE connected_handling_time = '') AS bos_islem_suresi
FROM destek_yukleme;

-- İki farklı tarih formatı var: '01/08/2023 11:13' ve '01-Aug-23'.
SELECT issue_reported_at, issue_responded, survey_response_date
FROM destek_yukleme
LIMIT 5;


-- 3) ANALİZ TABLOSU: conversations
--  * Metin tarihler TIMESTAMP / DATE tipine çevrildi.
--  * Boş metinler NULLIF ile NULL yapıldı, sonra sayıya çevrildi.
--  * Hesaplanan sütun: yanit_suresi_dk = yanıt zamanı - bildirim zamanı (dakika).
--  * zaman_tutarsiz: yanıt zamanı bildirimden ÖNCE görünüyorsa TRUE.
--    Bu satırlar silinmedi, işaretlendi.
DROP TABLE IF EXISTS conversations;
CREATE TABLE conversations AS
SELECT
    unique_id                                                         AS id,
    channel_name                                                      AS kanal,
    category                                                          AS topic,
    sub_category                                                      AS alt_konu,
    TO_TIMESTAMP(issue_reported_at, 'DD/MM/YYYY HH24:MI')::timestamp  AS started_at,
    TO_TIMESTAMP(issue_responded,   'DD/MM/YYYY HH24:MI')::timestamp  AS responded_at,
    TO_DATE(survey_response_date, 'DD-Mon-YY')                         AS anket_tarihi,
    NULLIF(item_price, '')::numeric                                   AS urun_fiyati,
    NULLIF(connected_handling_time, '')::numeric                      AS islem_suresi,
    csat_score::int                                                   AS csat,
    tenure_bucket                                                     AS kidem_grubu,
    agent_shift                                                       AS vardiya,
    (yorum_var = '1')                                                 AS yorum_var
FROM destek_yukleme;

ALTER TABLE conversations ADD COLUMN yanit_suresi_dk INTEGER;
ALTER TABLE conversations ADD COLUMN zaman_tutarsiz  BOOLEAN;

UPDATE conversations
SET yanit_suresi_dk = ROUND(EXTRACT(EPOCH FROM (responded_at - started_at)) / 60),
    zaman_tutarsiz  = (responded_at < started_at);


-- 4) İLK SELECT SORGULARI (kontrol)
-- Satır sayısı ve tarih aralığı
SELECT COUNT(*) AS satir, MIN(started_at) AS ilk_kayit, MAX(started_at) AS son_kayit
FROM conversations;

-- İlk 10 kayıt
SELECT id, kanal, topic, started_at, yanit_suresi_dk, csat
FROM conversations
ORDER BY started_at
LIMIT 10;

-- Yanıt zamanı bildirimden önce görünen (tutarsız) kaç kayıt var?
SELECT COUNT(*) AS tutarsiz_kayit
FROM conversations
WHERE zaman_tutarsiz;

-- 'Returns' konusunda CSAT puanı 1 olan talepler
SELECT id, started_at, alt_konu, csat
FROM conversations
WHERE topic = 'Returns' AND csat = 1
ORDER BY started_at
LIMIT 10;
