---první čištění - odstranění automatických emailů

create table “cista” as
select *,
case
when "subject" like 'eshop.cz - Změna stavu objednávky' then 'Yes'
when "subject" like 'Stav Vaší objednávky'then 'Yes'
when "subject" like 'eshop.cz - Změna stavu objednávky'then 'Yes'
when "subject" like 'Automaticky email - Vase baliky byly odeslany'then 'Yes'
when "subject" like 'Automaticky email (ID 423) - Prijali jsme Vas balik'then 'Yes'
when "subject" like 'eshop.cz - Objednávky byla stornována'then 'Yes'
when "subject" like 'Slovenská pošta - zásilky před ukončením odběrné lhůty'then 'Yes'
when "subject" like 'Delivery Status Notification (Failure)'then 'Yes'
when "subject" like 'eshop.cz - Objednávka je připravena k odeslání'then 'Yes'
when "subject" ilike 'eshop.cz - Potvrzení objednávky č.%' then 'Yes'
when "subject" ilike 'eshop - Potvrzení objednávky%' then 'Yes'
when "subject" ilike '%Automatická odpověď%' then 'Yes'
when "subject" like 'eshop.cz - Objednávka byla stornována'then 'Yes'
when "subject" like 'Re: Automatická odpověď'then 'Yes'
when "subject" like 'Mail delivery failed: returning message to sender'then 'Yes'
when "subject" like 'eshop - Změna stavu objednávky'then 'Yes'
when "subject" like 'eshop.cz - Objednávka je připravena'then 'Yes'
when "subject" like 'eshop - Změna stavu objednávky (vyřizuje se)'then 'Yes'
when "subject" like 'eshop - Změna stavu objednávky (stornována)'then 'Yes'
when "subject" like 'Automaticky email - zasilky neprevzaty'then 'Yes'
when "subject" like 'Dobry den'then 'Yes'
when "subject" like 'Tradeeasy – Monthly Trade Match Alert'then 'Yes'
when "subject" like 'eshop - Objednávky byla stornována'then 'Yes'
when "subject" like 'Vrácení zboží - obj. č. 218170169'then 'Yes'
when "subject" like 'eshop ...více než boty - Změna stavu objednávky'then 'Yes'
when "subject" like 'Automatická odpověď: Krásné svátky a šťastný nový rok 2017'then 'Yes'
when "subject" like 'Upozorneni - nektere zasilky nebyly odeslany'then 'Yes'
when "subject" like 'Automatická odpověď: Velký letní výprodej Rieker je tady'then 'Yes'
when "subject" like 'Automatická odpověď: Velký letní výprodej Rieker, Tamaris, Bugatti'then 'Yes'
when "subject" like 'Nedoručitelné zásilky'then 'Yes'
when "subject" like 'eshop.cz - Úhrada objednávky/neuhrazeno'then 'Yes'
when "subject" like 'Automatická odpověď: Super letní výprodej v eshop'then 'Yes'
when "subject" like 'Automatická odpověď: Velký letní výprodej Rieker, Tamaris a Bugatti'then 'Yes'
when "subject" like 'Automaticky email - baliky neprevzaty'then 'Yes'
when "subject" like 'Automatická odpověď: Novinky 2017/2018 přichází'then 'Yes'
when "subject" like 'Automatická odpověď: Novinky, které byste neměli minout'then 'Yes'
when "subject" like 'Automatická odpověď: -40 v létě?!'then 'Yes'
when "subject" like 'Undelivered Mail Returned to Sender'then 'Yes'
when "subject" like 'Změna stavu objednávky (čekající)' and "direction"= 'out' then 'Yes'
when "subject" like 'eshop.cz - Úhrada objednávky' and "direction"= 'out' then 'Yes'
when "subject" like 'Změna stavu objednávky (neuhrazena)' and "direction"= 'out' then 'Yes'
when "subject" like 'Eshop - Změna stavu objednávky (připravena)' and "direction"= 'out' then 'Yes'
else 'No'
end "Automatický"
from "email"
where "Automatický" = 'No' and "text" <> '' and "text" is not NULL;

---pro analýzu vytíženosti zákaznické podpory bylo potřeba vytvořit vhodný časový formát (timestamp)
select *, CAST("date" as timestamp) timestamp,
year(timestamp) as "YEAR",
month(timestamp) as "MONTH",
day(timestamp) as "DAY",
hour(timestamp) as "HOUR",
minute(timestamp) as "MINUTE"
from "emails" ;

--- Některé emaily obsahovaly text původní zprávy. Pro textovou analýzu bylo nutné tuto část textu odstranit.
--- Odstranění části textu za spojením'Původni email a Původní zprava'

UPDATE clean
  SET "text" = SUBSTRING("text", 1, CHARINDEX('---------- Původní e-mail', "text") - 1)
WHERE CHARINDEX('---------- Původní e-mail', "text") > 0;

---Vytvoření tabulky pro odstranění html tagů. V tabulce byl ponechaný jenom text a id emailu.

create table "superclean" as
select  "id","text" from clean;
