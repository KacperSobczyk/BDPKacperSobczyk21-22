--4. Wyznacz liczbę budynków (tabela: popp, atrybut: f_codedesc, reprezentowane, jako punkty) położonych w odległości mniejszej niż 1000 m od głównych rzek. 
   --Budynki spełniające to kryterium zapisz do osobnej tabeli tableB.
SELECT DISTINCT popp.gid, popp.cat, popp.f_codedesc, popp.f_code, popp.type, popp.geom INTO tableB
FROM popp, majrivers WHERE popp.f_codedesc = 'Building' AND ST_Contains(ST_Buffer(majrivers.geom,1000),popp.geom) = 'TRUE';
SELECT * FROM tableB
--5. Utwórz tabelę o nazwie airportsNew. Z tabeli airports do zaimportuj nazwy lotnisk, ich geometrię, a także atrybut elev, reprezentujący wysokość n.p.m.
SELECT name, geom, elev INTO airportsNew FROM airports;
--a) Znajdź lotnisko, które położone jest najbardziej na zachód i najbardziej na wschód.
--ZACHÓD:
SELECT * FROM airportsNew WHERE ST_Y(geom) =(SELECT MIN(ST_Y(geom)) FROM airportsNew);
--WSCHÓD:
SELECT * FROM airportsNew WHERE ST_Y(geom) =(SELECT MAX(ST_Y(geom)) FROM airportsNew);
--b) Do tabeli airportsNew VALUES ('AirportB',) dodaj nowy obiekt - lotnisko, które położone jest w punkcie środkowym drogi pomiędzy lotniskami znalezionymi w punkcie a. 
   --Lotnisko nazwij airportB. Wysokość n.p.m. przyjmij dowolną.
INSERT INTO airportsNew (name, geom, elev) VALUES ('AirportB',
							   ST_Centroid(ST_MakeLine((SELECT geom FROM airportsNew WHERE ST_Y(geom) =(SELECT MIN(ST_Y(geom)) FROM airportsNew)),(SELECT geom FROM airportsNew WHERE ST_Y(geom) =(SELECT MAX(ST_Y(geom)) FROM airportsNew)))),
							   123);
--6. Wyznacz pole powierzchni obszaru, który oddalony jest mniej niż 1000 jednostek od najkrótszej linii łączącej jezioro o nazwie ‘Iliamna Lake’ i lotnisko o nazwie „AMBLER”
SELECT ST_Area(ST_Buffer(ST_Shortestline(lakes.geom, airports.geom),1000)) FROM lakes,airports WHERE lakes.names='Iliamna Lake'AND airports.name='AMBLER'
--7. Napisz zapytanie, które zwróci sumaryczne pole powierzchni poligonów reprezentujących poszczególne typy drzew znajdujących się na obszarze tundry i bagien (swamps).
SELECT SUM(ST_Area(trees.geom)) FROM trees,tundra,swamp WHERE ST_Contains(trees.geom,tundra.geom)='TRUE' AND ST_Contains(trees.geom,swamp.geom)='TRUE';
SELECT * FROM trees