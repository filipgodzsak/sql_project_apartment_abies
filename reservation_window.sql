-- Top guests by revenue + ranking

WITH base AS (
  SELECT
    *,
    CASE
      WHEN lower(portal) LIKE 'book%' THEN 'booking'
      WHEN lower(portal) LIKE 'air%'  THEN 'airbnb'
      ELSE 'priamo'
    END AS portal_norm
  FROM abies_bookings_all
),
guest_rev AS (
  SELECT
    meno_priezvisko,
    SUM(cena) AS trzby,
    SUM(cena - provizia) AS ciste_trzby,
    SUM(pocet_noci) AS noci,
    COUNT(*) AS rezervacie
  FROM base
  GROUP BY meno_priezvisko
)
SELECT
  meno_priezvisko,
  trzby,
  ciste_trzby,
  noci,
  rezervacie,
  RANK() OVER (ORDER BY trzby DESC) AS rnk
FROM guest_rev
ORDER BY trzby DESC
LIMIT 10;

-- Running total sales (monthly)
-- how sales grow cumulatively over time

WITH base AS (
  SELECT
    *,
    CASE
      WHEN lower(portal) LIKE 'book%' THEN 'booking'
      WHEN lower(portal) LIKE 'air%'  THEN 'airbnb'
      ELSE 'priamo'
    END AS portal_norm
  FROM abies_bookings_all
),
monthly AS (
  SELECT
    date_trunc('month', prichod)::date AS mesiac,
    SUM(cena) AS trzby
  FROM base
  GROUP BY 1
)
SELECT
  mesiac,
  trzby,
  SUM(trzby) OVER (ORDER BY mesiac) AS running_trzby
FROM monthly
ORDER BY mesiac;

-- Cumulative share of sales (Pareto: top guests make up what %)
-- This is an "80/20" analysis

WITH base AS (
  SELECT
    *,
    CASE
      WHEN lower(portal) LIKE 'book%' THEN 'booking'
      WHEN lower(portal) LIKE 'air%'  THEN 'airbnb'
      ELSE 'priamo'
    END AS portal_norm
  FROM abies_bookings_all
),
guest_rev AS (
  SELECT
    meno_priezvisko,
    SUM(cena) AS trzby
  FROM base
  GROUP BY meno_priezvisko
),
ordered AS (
  SELECT
    meno_priezvisko,
    trzby,
    SUM(trzby) OVER () AS total_trzby,
    SUM(trzby) OVER (ORDER BY trzby DESC) AS cum_trzby
  FROM guest_rev
)
SELECT
  meno_priezvisko,
  trzby,
  total_trzby,
  cum_trzby,
  ROUND(100.0 * cum_trzby / NULLIF(total_trzby, 0), 2) AS cum_share_pct
FROM ordered
ORDER BY trzby DESC;

-- Ranking of portals over time (monthly) by net revenue
-- Shows whether the ranking of portals changes by month.

WITH base AS (
  SELECT
    *,
    CASE
      WHEN lower(portal) LIKE 'book%' THEN 'booking'
      WHEN lower(portal) LIKE 'air%'  THEN 'airbnb'
      ELSE 'priamo'
    END AS portal_norm
  FROM abies_bookings_all
),
monthly_portal AS (
  SELECT
    date_trunc('month', prichod)::date AS mesiac,
    portal_norm,
    SUM(cena - provizia) AS ciste_trzby
  FROM base
  GROUP BY 1,2
)
SELECT
  mesiac,
  portal_norm,
  ciste_trzby,
  RANK() OVER (PARTITION BY mesiac ORDER BY ciste_trzby DESC) AS rnk
FROM monthly_portal

ORDER BY mesiac, rnk;
