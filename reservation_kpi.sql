--Základné KPI — jeden query blok
select
  count(*) as rezervacie,
  sum(cena) as trzby,
  sum(provizia) as provizie,
  sum(cena - provizia) as ciste_trzby,
  sum(pocet_noci) as noci,
  sum(pocet_osob) as hostia,
  avg(pocet_noci) as priemer_noci
from abies_bookings_all;

--ADR (bezpečne — ochrana proti deleniu nulou)
select
  sum(cena) / nullif(sum(pocet_noci),0) as adr
from abies_bookings_all;

--Tržby na rezerváciu
select
  sum(cena) / nullif(count(*),0) as trzby_na_rez
from abies_bookings_all;

--Provízia %
select
  sum(provizia) / nullif(sum(cena),0) as provizia_pct
from abies_bookings_all;
