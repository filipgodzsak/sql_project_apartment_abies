-- Project: Reservation Analytics (Data Quality Checks)
-- DB: PostgreSQL
-- Table: abies_bookings_all

-- 1) Row counts + null checks
select
  count(*) as pocet_riadkov,
  count(*) filter (where prichod is null) as prichod_null,
  count(*) filter (where odchod is null) as odchod_null,
  count(*) filter (where pocet_noci is null) as pocet_noci_null,
  count(*) filter (where cena is null) as cena_null,
  count(*) filter (where cena_noc is null) as cena_noc_null,
  count(*) filter (where provizia is null) as provizia_null
from abies_bookings_all;

-- 2) Invalid nights (0 or negative)
select *
from abies_bookings_all
where pocet_noci <= 0;

-- 3) Invalid dates (checkout before/equals checkin)
select *
from abies_bookings_all
where odchod <= prichod;

-- 4) Price consistency check (tolerate rounding up to 0.01)
select
  *,
  (cena - (pocet_noci * cena_noc)) as rozdiel,
  abs(cena - (pocet_noci * cena_noc)) as abs_rozdiel
from abies_bookings_all
where abs(cena - (pocet_noci * cena_noc)) > 0.01
order by abs_rozdiel desc;

-- 5) Commission sanity checks
-- a) Negative commission
select *
from abies_bookings_all
where provizia < 0;

-- b) Direct channel should have zero commission (if applicable)
select *
from abies_bookings_all
where lower(portal) = 'priamo'
  and coalesce(provizia,0) <> 0;

-- 6) Duplicate detection (same guest + dates + price)
select
  meno_priezvisko,
  prichod,
  odchod,
  cena,
  count(*) as cnt
from abies_bookings_all
group by 1,2,3,4
having count(*) > 1
order by cnt desc;
