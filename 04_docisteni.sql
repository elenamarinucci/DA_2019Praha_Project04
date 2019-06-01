---textová analýza ukázala které slovní spojení se nacházejí v dalších automatických emailů. Díky tomu jsme je mohli odstranit.

DELETE FROM "odchozi_prichozi" 
where "text" like 'Dobrý den, mnohokrát Vám děkujeme%' //and "subject" ilike '%Potvrzení objednávky č.%'
;
DELETE FROM "odchozi_prichozi"
where "text" ilike '%Trenčín%' and "text" ilike '%Poprad%'or "text" ilike '%meridián%';

---další spamy byli odstraněny pomocí údajů v původní tabulce ve sloupci "spam_score" a "spam"
create temporary table "spamy" as
select o.*,c."spam_score",c."spam"
from "odchozi_prichozi" o
left join "cista" c on o."id" = c."id";

delete from "spamy"
  where "spam_score" >= '6'  // jsou to vsechno spamy (asi dva maily, ktere jsou fakt od zakaznika a obsahuji pouze slovo děkuji)
       or "spam" = '1' //též všechno spamy;
       
alter table "spamy"
drop column "spam_score";

alter table "spamy"
drop column "spam";

create or replace table "odchozi_prichozi" as
select * from "spamy";

--- další čištění po přezkoumání tabulky

delete from "odchozi_prichozi"  
where "subject" ilike '****SPAM****%' and "subject" <> '****SPAM**** Offline zpráva' and "subject" <> '****SPAM**** Re: Offline zpráva'
and "subject" not ilike  '****SPAM**** Nový dotaz od%' and "subject" not ilike '****SPAM**** Re: Vrácení zboží%'
or "subject" ilike '%Chcete%' or "subject" ilike '%newsletter%' 
or "subject" ilike 'Undelivered%' or "subject"  ilike 'To nej z%'
or "subject"  ilike 'STYL%' or "subject"  ilike '%spoluprác%'
or "subject"  ilike '%slev%' and "direction"='in' and not "subject"  ilike 'Re:%' and not "subject"  like 'slevový kód'
or "text"  ilike '%Copyright 2007-2018 Heureka%'
or "subject"  ilike '%Pozvanka%' or "subject"  ilike '%Pozvánka%'
or "subject"  ilike '%Pf%'
or "subject"  ilike '%out of%'
or "subject"  ilike 'Mimo%'
or "subject"  ilike 'Jak%'
or "subject"  ilike 'Děkujeme za Váš email%' 
or "subject"  ilike 'Automatisch%' or "subject"  ilike 'Autoreply%'  
or "subject"  ilike 'Automatic reply%' or "subject"  ilike 'Automatická odpove%';
