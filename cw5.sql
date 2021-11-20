--1.  Utwórz tabelę obiekty. W tabeli umieść nazwy i geometrie obiektów przedstawionych poniżej. 
--Układ odniesienia ustal jako niezdefiniowany.
CREATE TABLE obiekty
(
	nazwa VARCHAR(16),
	geom geometry
);
INSERT INTO obiekty VALUES
	('obiekt1',ST_CollectionExtract(ST_CurveToLine(ST_Collect(Array['LINESTRING(0 1, 1 1)', 'CIRCULARSTRING(1 1, 2 0, 3 1)',
							   'CIRCULARSTRING(3 1, 4 2, 5 1)', 'LINESTRING(5 1, 6 1)'])))),
	('obiekt2',ST_Difference(ST_MakePolygon(ST_LineMerge(ST_Collect(Array['LINESTRING(10 2, 10 6, 14 6)', 'CIRCULARSTRING(14 6, 16 4, 14 2)',
							   'CIRCULARSTRING(14 2, 12 0, 10 2)']))),ST_MakePolygon(ST_LineMerge('CIRCULARSTRING(11 2, 13 2, 11 2)')))),				   
	('obiekt3','POLYGON((7 15, 10 17, 12 13, 7 15))'),
	('obiekt4','LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)'),
	('obiekt5',ST_Collect(Array['POINT(30 30 59)','POINT(38 32 234)'])),
	('obiekt6',ST_Collect(Array['LINESTRING(1 1, 3 2)', 'POINT(4 2)']));

--1. Wyznacz pole powierzchni bufora o wielkości 5 jednostek, który został utworzony wokół najkrótszej linii łączącej obiekt 3 i 4.
SELECT ST_Area(ST_Buffer(ST_ShortestLine((SELECT geom FROM obiekty WHERE nazwa='obiekt3'),(SELECT geom FROM obiekty WHERE nazwa='obiekt4')),5));
--2. Zamień obiekt4 na poligon. Jaki warunek musi być spełniony, abymożna było wykonać to zadanie? Zapewnij te warunki.
--Obiekt 4 nie jest poligonem, ponieważ poligon jest zamknięty, tzn. pierwsza i ostatnia współrzędna przy tworzeniu poligonu jest taka sama.
UPDATE obiekty SET geom=ST_MakePolygon(ST_SetPoint(geom, 6, 'POINT(20 20)')) WHERE nazwa='obiekt4';
SELECT nazwa,ST_GeometryType(geom),geom FROM obiekty;
--3. W tabeli obiekty, jako obiekt7 zapisz obiekt złożony z obiektu 3 i obiektu 4.
INSERT INTO obiekty VALUES ('obiekt7', ST_Union((SELECT geom FROM obiekty WHERE nazwa='obiekt3'),(SELECT geom FROM obiekty WHERE nazwa='obiekt4')));
SELECT * FROM obiekty WHERE nazwa='obiekt7';
--4.  Wyznacz pole powierzchni wszystkich buforów o wielkości 5 jednostek, które zostały utworzone wokół obiektów nie zawierających łuków.
SELECT SUM(ST_Area(ST_Buffer(geom,5))) FROM obiekty WHERE ST_HasArc(geom) = 'FALSE';

