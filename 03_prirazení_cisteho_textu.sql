create table "odchozi_prichozi" as
select c."id", c."subject",c."direction", cft."text"
from "cista" c
left join "Cleaned_from_tags" cft on c."id" = cft."id"
order by "direction" asc; 
