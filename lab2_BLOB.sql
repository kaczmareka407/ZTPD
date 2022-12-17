--1
drop table movies
CREATE TABLE MOVIES(
    ID NUMBER(12),
    TITLE VARCHAR2(400) NOT NULL,
    CATEGORY VARCHAR2(50),
    YEAR CHAR(4),
    CAST VARCHAR2(4000),
    DIRECTOR VARCHAR2(4000),
    STORY VARCHAR2(4000),
    PRICE NUMBER(5,2),
    COVER BLOB,
    MIME_TYPE VARCHAR2(50),
    PRIMARY KEY(ID)
)
select * from DESCRIPTIONS;
select * from covers;

--2
INSERT INTO MOVIES  
SELECT DESCRIPTIONS.ID,
DESCRIPTIONS.TITLE,
DESCRIPTIONS.CATEGORY,
TRIM(DESCRIPTIONS.YEAR),
DESCRIPTIONS.CAST,
DESCRIPTIONS.DIRECTOR,
DESCRIPTIONS.STORY,
DESCRIPTIONS.PRICE,
COVERS.IMAGE,
COVERS.MIME_TYPE
FROM DESCRIPTIONS
FULL OUTER JOIN COVERS
ON DESCRIPTIONS.ID = COVERS.MOVIE_ID
WHERE DESCRIPTIONS.ID <67;

Select * from movies;

--3
Select ID, TITLE from movies where movies.cover is null;

--4
Select ID, TITLE , length(movies.cover) as "FILESIZE"  from movies where movies.cover is not null;

--5
Select ID, TITLE , length(movies.cover) as "FILESIZE"  from movies where movies.cover is  null;

--6
select DIRECTORY_NAME, DIRECTORY_PATH FROM ALL_DIRECTORIES

--7
UPDATE MOVIES
SET COVER = EMPTY_BLOB(),
MIME_TYPE='image/jpeg'
where MOVIES.ID=66;

--8
Select ID, TITLE , length(movies.cover) as "FILESIZE"  from movies where MOVIES.ID>64;

--9
DECLARE
lobd blob;
fils BFILE := BFILENAME('ZSBD_DIR','escape.jpg');

BEGIN
SELECT cover INTO lobd
FROM movies
where id like 66

FOR UPDATE;
DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
DBMS_LOB.FILECLOSE(fils);
COMMIT;
END;

--10
DROP TABLE TEMP_COVERS
CREATE TABLE TEMP_COVERS(
movie_id NUMBER(12),
image BFILE,
mime_type VARCHAR2(50)
)

--11
DECLARE
lobd blob;
fils BFILE := BFILENAME('ZSBD_DIR','eagles.jpg');
BEGIN
INSERT INTO TEMP_COVERS(movie_id, image, mime_type)
VALUES (65, fils, 'image/jpeg');
COMMIT;
END;


--12
select movie_id, DBMS_LOB.GETLENGTH(image) as "FILESIZE" from TEMP_COVERS where movie_id=65;


--13--
DECLARE

fils BFILE;
mimeType VARCHAR2(50);
lobs BLOB;

BEGIN

SELECT IMAGE, MIME_TYPE
INTO fils, mimeType
FROM TEMP_COVERS
WHERE MOVIE_ID=65;

DBMS_LOB.CREATETEMPORARY(lobs, true, dbms_lob.session);
DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
DBMS_LOB.LOADFROMFILE(lobs,fils,DBMS_LOB.GETLENGTH(fils));
DBMS_LOB.FILECLOSE(fils);

UPDATE MOVIES
SET COVER=lobs,
    MIME_TYPE=mimeType
    WHERE ID=65;

DBMS_LOB.FREETEMPORARY(LOBS);
COMMIT;
END;

--14
Select ID, TITLE , length(movies.cover) as "FILESIZE"  from movies where MOVIES.ID>64;

--15
DROP TABLE MOVIES;
DROP TABLE TEMP_COVERS;


