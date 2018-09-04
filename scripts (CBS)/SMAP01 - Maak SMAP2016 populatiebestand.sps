*****************************************************************************************************************************************************************.
* SMAP2016 populatie
* Samenstellen benodigde kenmerken SMAP2016 populatie, peildatum 01-09-2016.
* Grotendeels gebaseerd op script van Caroline Amerling voor de SMAP populatie 2012.
* Maarten Mulder, februari 2018.
*****************************************************************************************************************************************************************.

TITLE SELECTEREN POPULATIE OP PEILDATUM UIT GBAADRESOBJECTBUS.

* de populatie op 01-09-2016 uit de GBAADRESOBJECTBUS halen en wegschrijven.

GET FILE = 'G:\1_MicroData\GBAADRESOBJECTBUS\2016\GBAADRESOBJECT2016BUSV1.sav'.
CACHE.
    *FREQUENCIES rinpersoons.
SELECT IF (GBADATUMAANVANGADRESHOUDING <='20160901' & GBADATUMEINDEADRESHOUDING >='20160901').
   *FREQUENCIES rinpersoons.
SORT CASES BY RINPERSOONS RINPERSOON.

SAVE OUTFILE='H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPers.sav'
   /KEEP RINPERSOONS RINPERSOON SOORTOBJECTNUMMER RINOBJECTNUMMER 
   /COMPRESSED.


TITLE TOEVOEGEN VARIABELEN UIT GBAPERSOONSTAB.

* Informatie uit GBAPERSOONSTAB toevoegen.
* Eerst sorteren op de sleutelvariabelen.

GET FILE =  'G:\1_MicroData\GBAPERSOONTAB\2016\GBAPERSOONTAB 2016V1.sav'.
CACHE.
   *FREQUENCIES rinpersoons gbageboorteland gbageslacht gbaherkomstgroepering gbageneratie gbageboortejaar gbageboortemaand gbageboortedag.
SORT CASES BY RINPERSOONS RINPERSOON.

MATCH FILES file = 'G:\1_MicroData\GBAPERSOONTAB\2016\GBAPERSOONTAB 2016V1.sav'
   /file =  'H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPers.sav'
   /in = indin
   /by RINPERSOONS RINPERSOON.
   *FREQUENCIES indin.
SELECT IF indin = 1.
   *FREQUENCIES indin.
   *FREQUENCIES rinpersoons gbageboorteland gbageslacht gbaherkomstgroepering gbageneratie gbageboortejaar gbageboortemaand.
 
* Hernoemen GBAHERKOMSTGROEPERING voor de koppeling met het SSB referentiebestand "LANDAKTUEELREF" om de etniciteit te verkrijgen.
* Sorteren om de koppeling goed te krijgen.
 
RENAME VARIABLES GBAHERKOMSTGROEPERING = LAND.
SORT CASES BY LAND.
  
* Tussendoor opslaan.

SAVE OUTFILE='H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPers.sav'
   /KEEP RINPERSOONS RINPERSOON SOORTOBJECTNUMMER RINOBJECTNUMMER 
GBAGESLACHT GBAGEBOORTEJAAR GBAGEBOORTEMAAND GBAGEBOORTELAND LAND GBAGENERATIE
  /COMPRESSED.

* Koppeling

GET FILE =  'G:\8_Utilities\Code_Listings\SSBreferentiebestanden\LANDAKTUEELREFV4.sav'.
CACHE.
   *FREQUENCIES LAND ETNGRP.
SORT CASES BY LAND.

MATCH FILES table= 'G:\8_Utilities\Code_Listings\SSBreferentiebestanden\LANDAKTUEELREFV4.sav'
   /file = 'H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPers.sav'
   /in = indin
   /by LAND.
   *FREQUENCIES indin.
SELECT IF indin = 1.
   *FREQUENCIES indin.

* gbaherkomstgroepering oorspronkelijke naam uit cbs bestand teruggeven.

RENAME VARIABLES LAND = GBAHERKOMSTGROEPERING.

   *FREQUENCIES rinpersoons gbageboorteland gbageslacht gbaherkomstgroepering etngrp gbageneratie gbageboortejaar gbageboortemaand.
SORT CASES BY RINPERSOONS RINPERSOON.

SAVE OUTFILE='H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtn.sav'
   /KEEP RINPERSOONS RINPERSOON SOORTOBJECTNUMMER RINOBJECTNUMMER 
GBAGESLACHT GBAGEBOORTEJAAR GBAGEBOORTEMAAND GBAGEBOORTELAND GBAHERKOMSTGROEPERING GBAGENERATIE 
ETNGRP
   /COMPRESSED.


TITLE INFORMATIE UIT GBABURGERLIJKESTAATBUS TOEVOEGEN.

* informatie uit GBABURGERLIJKESTAATBUS er aan toevoegen. 

 * Eerst de burgerlijke staat op 01-09-2016 uit de GBABURGERLIJKESTAATBUS halen en wegschrijven. Dan koppelen.

GET FILE = 'G:\1_MicroData\GBABURGERLIJKESTAATBUS\2016\GBABURGERLIJKESTAAT2016BUSV1.sav'.
CACHE.
   *FREQUENCIES RINPERSOONS.
SELECT IF (GBAAANVANGBURGERLIJKESTAAT <='20160901' & GBAEINDEBURGERLIJKESTAAT >='20160901').
   *FREQUENCIES RINPERSOONS GBABURGERLIJKESTAATNW.
SORT CASES BY RINPERSOONS RINPERSOON.

SAVE OUTFILE='H:\SMAP2016\data\populatie\SMAP2016_populatie_x_BurgSt.sav'
   /KEEP RINPERSOONS RINPERSOON GBABURGERLIJKESTAATNW
   /COMPRESSED.

MATCH FILES file = 'H:\SMAP2016\data\populatie\SMAP2016_populatie_x_BurgSt.sav'
   /file =  'H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtn.sav'
   /in = indin
   /by RINPERSOONS RINPERSOON.
EXECUTE.

   *FREQUENCIES indin.
SELECT IF indin = 1.
   *FREQUENCIES in1din.
   *FREQUENCIES rinpersoons gbageslacht etngrp gbageneratie gbageboortejaar gbageboortemaand gbaburgerlijkestaatnw.
SAVE OUTFILE = 'H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurg.sav' 
   /KEEP RINPERSOONS RINPERSOON SOORTOBJECTNUMMER RINOBJECTNUMMER 
GBAGESLACHT GBAGEBOORTEJAAR GBAGEBOORTEMAAND GBAGEBOORTELAND GBAHERKOMSTGROEPERING GBAGENERATIE 
ETNGRP
GBABURGERLIJKESTAATNW
   /COMPRESSED.

* Controleren welke kenmerken de groep heeft zonder burgerlijke staat. (LET OP: ik weet niet wat Caroline Amerling hier mee gedaan heeft verder!).

USE ALL.
COMPUTE filter_$=(GBABURGERLIJKESTAATNW = ' ').
VARIABLE LABELS filter_$ "GBABURGERLIJKESTAATNW = ' ' (FILTER)".
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
   FREQUENCIES rinpersoons gbageslacht etngrp gbageneratie gbageboortejaar gbaburgerlijkestaatnw.


TITLE INFORMATIE UIT GBAHUISHOUDENSBUS TOEVOEGEN.

* informatie uit GBAHUISHOUDENSBUS er aan toevoegen.

 * eerst de huishouding op 01-09-2016 uit de GBAHUISHOUDENSBUS halen en wegschrijven. Dan koppelen.

GET FILE = 'G:\1_MicroData\GBAHUISHOUDENSBUS\2016\GBAHUISHOUDENS2016BUSV1.sav'.
CACHE.
   *FREQUENCIES RINPERSOONS.
SELECT IF (DATUMAANVANGHH <='20160901' & DATUMEINDEHH >='20160901').
EXECUTE.  
   *FREQUENCIES rinpersoons typhh aantalpershh imputatiecodehh.
SORT CASES BY RINPERSOONS RINPERSOON.

SAVE OUTFILE = ' H:\SMAP2016\data\populatie\SMAP2016_populatie_x_Hh.sav'
   /KEEP RINPERSOONS RINPERSOON HUISHOUDNR TYPHH AANTALPERSHH IMPUTATIECODEHH
   /COMPRESSED.

MATCH FILES file = 'H:\SMAP2016\data\populatie\SMAP2016_populatie_x_Hh.sav'
   /file =  'H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurg.sav'
   /in = indin
   /by RINPERSOONS RINPERSOON.
   *FREQUENCIES indin.
SELECT IF indin = 1.
   *FREQUENCIES indin.
   *FREQUENCIES  rinpersoons gbageslacht etngrp gbageneratie gbageboortejaar gbageboortemaand gbaburgerlijkestaatnw typhh aantalpershh imputatiecodehh.
SAVE OUTFILE = 'H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHh.sav' 
   /KEEP RINPERSOONS RINPERSOON SOORTOBJECTNUMMER RINOBJECTNUMMER 
GBAGESLACHT GBAGEBOORTEJAAR GBAGEBOORTEMAAND GBAGEBOORTELAND GBAHERKOMSTGROEPERING GBAGENERATIE 
ETNGRP
GBABURGERLIJKESTAATNW
HUISHOUDNR TYPHH AANTALPERSHH IMPUTATIECODEHH
   /COMPRESSED.


TITLE INFORMATIE UIT HOOGSTEOPLTAB TOEVOEGEN. 

GET FILE = 'G:\1_MicroData\HOOGSTEOPLTAB\2015\HOOGSTEOPL2015TABV2.sav'.
CACHE.

MATCH FILES file = 'G:\1_MicroData\HOOGSTEOPLTAB\2015\HOOGSTEOPL2015TABV2.sav'
   /file =  'H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHh.sav'
   /in = indin
   /by RINPERSOONS RINPERSOON.
  *FREQUENCIES indin.
SELECT IF indin = 1.

SAVE OUTFILE='H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHhOpl.sav'
   /KEEP RINPERSOONS RINPERSOON SOORTOBJECTNUMMER RINOBJECTNUMMER 
GBAGESLACHT GBAGEBOORTEJAAR GBAGEBOORTEMAAND GBAGEBOORTELAND GBAHERKOMSTGROEPERING GBAGENERATIE 
ETNGRP
GBABURGERLIJKESTAATNW
HUISHOUDNR TYPHH AANTALPERSHH IMPUTATIECODEHH
OPLNIVSOI2016AGG4HBMETNIRWO OPLNIVSOI2016AGG4HGMETNIRWO
  /COMPRESSED.


TITLE INFORMATIE UIT INHATAB & VEHTAB TOEVOEGEN, VIA INPATAB

* Dit zijn de nieuwe inkomensbestanden, vervangers van IPI, IHI en IVB.
* Altijd eerst INPATAB omdat hierin de RINPERSOONSHKW en RINPERSOONHKW zit (hoofdkostwinner huishouden), 
* Dit zijn de koppelvariabelen voor INHATAB & VEHTAB, waaruit we enkele variabelen nodig hebben.

GET FILE = 'G:\1_MicroData\INPATAB\INPA2016TABV1.sav'.
CACHE.

 MATCH FILES file = 'G:\1_MicroData\INPATAB\INPA2016TABV1.sav'
   /file =  'H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHhOpl.sav'
   /in = indin
   /by RINPERSOONS RINPERSOON.
  *FREQUENCIES indin.
SELECT IF indin = 1.
   *FREQUENCIES RINPERSOONS RINPERSOONSHKW. 
SORT CASES BY RINPERSOONSHKW RINPERSOONHKW.

SAVE OUTFILE='H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHhOplInk.sav'
   /KEEP RINPERSOONS RINPERSOON SOORTOBJECTNUMMER RINOBJECTNUMMER 
GBAGESLACHT GBAGEBOORTEJAAR GBAGEBOORTEMAAND GBAGEBOORTELAND GBAHERKOMSTGROEPERING GBAGENERATIE 
ETNGRP
GBABURGERLIJKESTAATNW
HUISHOUDNR TYPHH AANTALPERSHH IMPUTATIECODEHH
OPLNIVSOI2016AGG4HBMETNIRWO OPLNIVSOI2016AGG4HGMETNIRWO
RINPERSOONSHKW RINPERSOONHKW
  /COMPRESSED.


TITLE INHATAB

* Via de hoofdkostwinner koppelen met INHATAB. Is one-to-many omdat de HKW geldt voor alle huishoudenleden. In dat geval /TABLE gebruiken ipv /FILE bij de "one"  kant.
* Dat is hier dus de IHI tabel

GET FILE = 'G:\1_MicroData\INHATAB\INHA2016TABV1.sav'.
CACHE.

MATCH FILES TABLE = 'G:\1_MicroData\INHATAB\INHA2016TABV1.sav'
   /file =  'H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHhOplInk.sav'
   /in = indin
   /by RINPERSOONSHKW RINPERSOONHKW.
  *FREQUENCIES indin.
SELECT IF indin = 1.

SAVE OUTFILE='H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHhOplInk.sav'
   /KEEP RINPERSOONS RINPERSOON SOORTOBJECTNUMMER RINOBJECTNUMMER 
GBAGESLACHT GBAGEBOORTEJAAR GBAGEBOORTEMAAND GBAGEBOORTELAND GBAHERKOMSTGROEPERING GBAGENERATIE 
ETNGRP
GBABURGERLIJKESTAATNW
HUISHOUDNR TYPHH AANTALPERSHH IMPUTATIECODEHH
OPLNIVSOI2016AGG4HBMETNIRWO OPLNIVSOI2016AGG4HGMETNIRWO
RINPERSOONSHKW RINPERSOONHKW
INHBBIHJ INHEHALGR INHP100HBEST
  /COMPRESSED.


TITLE VEHTAB.

* Via de hoofdkostwinner koppelen met VEHTAB. Is one-to-many omdat de HKW geldt voor alle huishoudenleden. In dat geval /TABLE gebruiken ipv /FILE bij de "one"  kant.
* Dat is hier dus de VEH tabel

GET FILE = 'G:\1_MicroData\VEHTAB\VEH2016TABV1.sav'.
CACHE.

MATCH FILES TABLE = 'G:\1_MicroData\VEHTAB\VEH2016TABV1.sav'
   /file =  'H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHhOplInk.sav'
   /in = indin
   /by RINPERSOONSHKW RINPERSOONHKW.
  *FREQUENCIES indin.
SELECT IF indin = 1.

SAVE OUTFILE='H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHhOplInk.sav'
   /KEEP RINPERSOONS RINPERSOON SOORTOBJECTNUMMER RINOBJECTNUMMER 
GBAGESLACHT GBAGEBOORTEJAAR GBAGEBOORTEMAAND GBAGEBOORTELAND GBAHERKOMSTGROEPERING GBAGENERATIE 
ETNGRP
GBABURGERLIJKESTAATNW
HUISHOUDNR TYPHH AANTALPERSHH IMPUTATIECODEHH
OPLNIVSOI2016AGG4HBMETNIRWO OPLNIVSOI2016AGG4HGMETNIRWO
RINPERSOONSHKW RINPERSOONHKW
INHBBIHJ INHEHALGR INHP100HBEST
VEHP100HVERM
  /COMPRESSED.

* Van bijna 270.000 personen ontbreekt informatie over het huishoudensinkomen en -vermogen.
* Checken kenmerken
* Lijkt vooral te gaan om pasgeborenen (tussen 1 jan waarop de inkomensstatistiek is gebaseerd en 1 sep peildatum) en vermoedelijk immigranten.

COMPUTE filter_$=(RINPERSOONSHKW = '').
VARIABLE LABELS filter_$ "RINPERSOONSHKW = '' (FILTER)".
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
   FREQUENCIES rinpersoons gbageslacht etngrp gbageneratie gbageboortejaar gbaburgerlijkestaatnw.


TITLE GEO componenten toevoegen: gemeente/wijk/buurt & coordinaat.

* Koppelen via objectnummer met VSLGWBTAB. Indelingen van 2016 en 2017 houden.
* Twee microdatabestanden om objecten te koppelen met geo: voor objecten wel in de BAG en voor niet in de BAG. 
* Beide bestanden onder elkaar zetten en daarna koppelen met de SMAP populatie.

* Eerst het SMAP bestand sorteren op object ipv person

GET FILE = 'H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHhOplInk.sav'.
   CACHE.
SORT CASES BY SOORTOBJECTNUMMER RINOBJECTNUMMER.
SAVE OUTFILE = 'H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHhOplInkGeo.sav'
   /COMPRESSED.

* Gemeente/wijk/buurt.

GET FILE = 'G:\1_MicroData\VSLGWBTAB\VSLGWBTAB2017091V1.sav'.
   CACHE.

ADD FILES /FILE=*
  /FILE='G:\1_MicroData\NIETVSLGWBTAB\NIETVSLGWBTAB2017V2.sav'.
EXECUTE.
SORT CASES BY SOORTOBJECTNUMMER RINOBJECTNUMMER.

SAVE OUTFILE = 'H:\SMAP2016\data\populatie\SMAP2016_populatie_x_GeoGWB.sav'
  /KEEP SOORTOBJECTNUMMER RINOBJECTNUMMER 
gem2016 wc2016 bc2016 gem2017 wc2017 bc2017
  /COMPRESSED.

MATCH FILES TABLE = 'H:\SMAP2016\data\populatie\SMAP2016_populatie_x_GeoGWB.sav'
   /file =  'H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHhOplInkGeo.sav'
   /in = indin
   /by SOORTOBJECTNUMMER RINOBJECTNUMMER.
  *FREQUENCIES indin.
SELECT IF indin = 1.

SAVE OUTFILE='H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHhOplInkGeo.sav'
   /KEEP RINPERSOONS RINPERSOON SOORTOBJECTNUMMER RINOBJECTNUMMER 
GBAGESLACHT GBAGEBOORTEJAAR GBAGEBOORTEMAAND GBAGEBOORTELAND GBAHERKOMSTGROEPERING GBAGENERATIE 
ETNGRP
GBABURGERLIJKESTAATNW
HUISHOUDNR TYPHH AANTALPERSHH IMPUTATIECODEHH
OPLNIVSOI2016AGG4HBMETNIRWO OPLNIVSOI2016AGG4HGMETNIRWO
RINPERSOONSHKW RINPERSOONHKW
INHBBIHJ INHEHALGR INHP100HBEST
VEHP100HVERM
gem2016 wc2016 bc2016 gem2017 wc2017 bc2017
  /COMPRESSED.

* Coordinaten.

GET FILE = 'G:\1_MicroData\VSLCOORDTAB\2016\VSLCOORDTABV2016V1.sav'.
   CACHE.
SORT CASES BY SOORTOBJECTNUMMER RINOBJECTNUMMER.
SAVE OUTFILE = 'H:\SMAP2016\data\populatie\SMAP2016_populatie_x_GeoXY.sav'
   /COMPRESSED.

MATCH FILES TABLE = 'H:\SMAP2016\data\populatie\SMAP2016_populatie_x_GeoXY.sav'
   /file =  'H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHhOplInkGeo.sav'
   /in = indin
   /by SOORTOBJECTNUMMER RINOBJECTNUMMER.
  *FREQUENCIES indin.
SELECT IF indin = 1.

SAVE OUTFILE='H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHhOplInkGeo.sav'
   /KEEP RINPERSOONS RINPERSOON SOORTOBJECTNUMMER RINOBJECTNUMMER 
GBAGESLACHT GBAGEBOORTEJAAR GBAGEBOORTEMAAND GBAGEBOORTELAND GBAHERKOMSTGROEPERING GBAGENERATIE 
ETNGRP
GBABURGERLIJKESTAATNW
HUISHOUDNR TYPHH AANTALPERSHH IMPUTATIECODEHH
OPLNIVSOI2016AGG4HBMETNIRWO OPLNIVSOI2016AGG4HGMETNIRWO
RINPERSOONSHKW RINPERSOONHKW
INHBBIHJ INHEHALGR INHP100HBEST
VEHP100HVERM
gem2016 wc2016 bc2016 gem2017 wc2017 bc2017
XCOORDADRES YCOORDADRES
  /COMPRESSED.


TITLE Checken aantallen (variabelen uit de verschillende bestanden, behalve coordinaat)

FREQUENCIES VARIABLES=RINPERSOONS SOORTOBJECTNUMMER GBAGESLACHT ETNGRP GBABURGERLIJKESTAATNW 
    IMPUTATIECODEHH OPLNIVSOI2016AGG4HBMETNIRWO RINPERSOONSHKW INHP100HBEST VEHP100HVERM gem2017 
  /ORDER=ANALYSIS.


TITLE Selectiebestand SMAP2016 voor Jan van de Kassteele

* Niet alle variabelen nodig. De huidige volledige selectie is oorspronkelijk bedoeld voor Dedipop 2012.

GET FILE='H:\SMAP2016\data\populatie\SMAP2016_populatie_AdresPersEtnBurgHhOplInkGeo.sav'.
   CACHE.

SAVE OUTFILE='H:\SMAP2016\data\populatie\SMAP2016_populatie.sav'
   /KEEP RINPERSOON
GBAGESLACHT GBAGEBOORTEJAAR GBAGEBOORTEMAAND 
ETNGRP
GBABURGERLIJKESTAATNW
TYPHH AANTALPERSHH
OPLNIVSOI2016AGG4HBMETNIRWO
INHBBIHJ INHEHALGR INHP100HBEST
VEHP100HVERM
gem2016 wc2016 bc2016
XCOORDADRES YCOORDADRES
  /COMPRESSED.

* Save tab-delimited .dat file

GET FILE='H:\SMAP2016\data\populatie\SMAP2016_populatie.sav'.
   CACHE.

SAVE TRANSLATE OUTFILE='H:\SMAP2016\data\populatie\SMAP2016_populatie.dat'
  /TYPE=TAB
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.
