-- CHANNEL SQL ANALYSIS (with portal normalization)
-- PostgreSQL

-- Common base with normalized portal
WITH base AS (
  SELECT
    *,
    CASE
      WHEN lower(portal) LIKE 'book%' THEN 'booking'
      WHEN lower(portal) LIKE 'air%'  THEN 'airbnb'
      ELSE 'priamo'
    END AS portal_norm
  FROM abies_bookings_all
)

-- 1) KPI podľa portálu (normalized)
SELECT
  portal_norm,
  COUNT(*) AS rezervacie,
  SUM(cena) AS trzby,
  SUM(provizia) AS provizie,
  SUM(cena - provizia) AS ciste_trzby,
  SUM(pocet_noci) AS noci,
  ROUND(SUM(cena) / NULLIF(SUM(pocet_noci), 0), 2) AS adr
FROM base
GROUP BY portal_norm
ORDER BY trzby DESC;

-- 2) Podiel na tržbách (% share) podľa portálu (normalized)
WITH base AS (
  SELECT
    *,
    CASE
      WHEN lower(portal) LIKE 'book%' THEN 'booking'
      WHEN lower(portal) LIKE 'air%'  THEN 'airbnb'
      ELSE 'priamo'
    END AS portal_norm
  FROM abies_bookings_all
)
SELECT
  portal_norm,
  SUM(cena) AS trzby,
  ROUND(
    100.0 * SUM(cena) / NULLIF(SUM(SUM(cena)) OVER (), 0),
    2
  ) AS trzby_share_pct
FROM base
GROUP BY portal_norm
ORDER BY trzby DESC;

-- 3) Provízia % podľa portálu (normalized)
WITH base AS (
  SELECT
    *,
    CASE
      WHEN lower(portal) LIKE 'book%' THEN 'booking'
      WHEN lower(portal) LIKE 'air%'  THEN 'airbnb'
      ELSE 'priamo'
    END AS portal_norm
  FROM abies_bookings_all
)
SELECT
  portal_norm,
  SUM(provizia) AS provizie,
  SUM(cena) AS trzby,
  ROUND(
    100.0 * SUM(provizia) / NULLIF(SUM(cena), 0),
    2
  ) AS provizia_pct
FROM base
GROUP BY portal_norm
ORDER BY provizia_pct DESC;

-- 4) Ranking portálov podľa čistých tržieb (normalized)
WITH base AS (
  SELECT
    *,
    CASE
      WHEN lower(portal) LIKE 'book%' THEN 'booking'
      WHEN lower(portal) LIKE 'air%'  THEN 'airbnb'
      ELSE 'priamo'
    END AS portal_norm
  FROM abies_bookings_all
)
SELECT
  portal_norm,
  SUM(cena - provizia) AS ciste_trzby,
  RANK() OVER (ORDER BY SUM(cena - provizia) DESC) AS rnk
FROM base
GROUP BY portal_norm
ORDER BY rnk;