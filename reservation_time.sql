-- CTE s normalizáciou (použijeme v každom dopyte)

with base as (
  select
    *,
    case
      when lower(portal) like 'book%' then 'booking'
      when lower(portal) like 'air%' then 'airbnb'
      else 'priamo'
    end as portal_norm
  from abies_bookings_all
)

-- Mesačné tržby (trend)
with base as (
  select
    *,
    case
      when lower(portal) like 'book%' then 'booking'
      when lower(portal) like 'air%' then 'airbnb'
      else 'priamo'
    end as portal_norm
  from abies_bookings_all
)
select
  date_trunc('month', prichod)::date as mesiac,
  sum(cena) as trzby,
  sum(cena - provizia) as ciste_trzby,
  count(*) as rezervacie,
  sum(pocet_noci) as noci,
  round(sum(cena)/nullif(sum(pocet_noci),0), 2) as adr
from base
group by 1
order by 1;

--Sezónnosť podľa mesiacov (naprieč rokmi)
with base as (
  select
    *,
    case
      when lower(portal) like 'book%' then 'booking'
      when lower(portal) like 'air%' then 'airbnb'
      else 'priamo'
    end as portal_norm
  from abies_bookings_all
)
select
  extract(month from prichod) as mesiac_cislo,
  to_char(prichod, 'Mon') as mesiac_nazov,
  sum(cena) as trzby,
  round(avg(cena_noc), 2) as avg_cena_noc,
  count(*) as rezervacie
from base
group by 1,2
order by trzby desc;


-- názvy mesiacov budú podľa locale DB; poradie riešime mesiac_cislo.)

-- YoY tržby (ročne)
with base as (
  select
    *,
    case
      when lower(portal) like 'book%' then 'booking'
      when lower(portal) like 'air%' then 'airbnb'
      else 'priamo'
    end as portal_norm
  from abies_bookings_all
)
select
  extract(year from prichod) as rok,
  sum(cena) as trzby,
  sum(cena - provizia) as ciste_trzby,
  count(*) as rezervacie,
  sum(pocet_noci) as noci,
  round(sum(cena)/nullif(sum(pocet_noci),0), 2) as adr
from base
group by 1
order by 1;

-- YoY % (ročne) – pohovorový bonus
with yearly as (
  select
    extract(year from prichod) as rok,
    sum(cena) as trzby
  from abies_bookings_all
  group by 1
)
select
  rok,
  trzby,
  lag(trzby) over(order by rok) as trzby_ly,
  round(
    100.0 * (trzby - lag(trzby) over(order by rok)) / nullif(lag(trzby) over(order by rok),0),
    2
  ) as yoy_pct
from yearly
order by rok;