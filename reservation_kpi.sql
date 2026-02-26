--Basic KPI — 
select
  count(*) as rezervacie,
  sum(cena) as trzby,
  sum(provizia) as provizie,
  sum(cena - provizia) as ciste_trzby,
  sum(pocet_noci) as noci,
  sum(pocet_osob) as hostia,
  avg(pocet_noci) as priemer_noci
from abies_bookings_all;

--ADR (safely – division by zero protection)
select
  sum(cena) / nullif(sum(pocet_noci),0) as adr
from abies_bookings_all;

--Revenue per reservation
select
  sum(cena) / nullif(count(*),0) as trzby_na_rez
from abies_bookings_all;

--Commission %
select
  sum(provizia) / nullif(sum(cena),0) as provizia_pct
from abies_bookings_all;

