-- CONTAINS
-- 1
select * from  ZSBD_TOOLS.cytaty



-- 2

create index CYTATY_WORD_IDX on cytaty(TEKST)
indextype is CTXSYS.CONTEXT;

select * from cytaty c where tekst like '%optymista%' or tekst like '%pesymista%'
 
 -- 3
 CREATE TABLE CYTATY AS
select * from  ZSBD_TOOLS.cytaty

-- 4

SELECT * FROM cytaty c where contains(c.tekst, 'optymista and pesymista')>0 

-- 5

SELECT * FROM cytaty c where contains(c.tekst, 'pesymista not(optymista)')>0 

-- 6

SELECT * FROM cytaty c where contains(c.tekst, 'near((optymista, pesymista),3)')>0 

-- 7

SELECT * FROM cytaty c where contains(c.tekst, 'near((optymista, pesymista),10)')>0 

-- 8

SELECT * FROM cytaty c where contains(c.tekst, 'życi%')>0 

-- 9

SELECT score(1), autor, tekst FROM cytaty c where contains(c.tekst, 'życi%',1)>0 

-- 10

SELECT score(1), autor, tekst FROM cytaty c where contains(c.tekst, 'życi%',1)>0 and rownum=1 order by score(1)   


-- 11

-- 12

INSERT INTO CYTATY (ID, AUTOR, TEKST) VALUES (39, 'Bentrand Russell', 'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości');
commit

select * from cytaty

-- 13
SELECT * FROM cytaty c where contains(c.tekst, 'glupcy')>0 

-- 14
desc DR$CYTATY_WORD_IDX$I

-- 15 
drop index CYTATY_WORD_IDX

create index CYTATY_WORD_IDX on cytaty(TEKST)
indextype is CTXSYS.CONTEXT;

-- 16
SELECT * FROM cytaty c where contains(c.tekst, 'głupcy')>0

-- 17
drop index CYTATY_WORD_IDX
drop table cytaty


--ZAAWANSOWANE INDEKSOWANIE I WYSZUKIWANIE

-- 1
select * from  ZSBD_TOOLS.quotes

 CREATE TABLE quotes AS
select * from  ZSBD_TOOLS.quotes

-- 2
create index CYTATY_quotes_IDX on quotes(TEXT)
indextype is CTXSYS.CONTEXT;

-- 3
SELECT * FROM quotes c where contains(c.text, 'work')>0 
SELECT * FROM quotes c where contains(c.text, '$work')>0 
SELECT * FROM quotes c where contains(c.text, 'working')>0 
SELECT * FROM quotes c where contains(c.text, '$working')>0 

-- 4
SELECT * FROM quotes c where contains(c.text, 'it')>0 

-- 5 

select * from CTX_STOPLISTS;

-- 6

select * from CTX_STOPWORDS WHERE SPW_STOPLIST = 'DEFAULT_STOPLIST';

-- 7

drop index CYTATY_quotes_IDX 

create index CYTATY_quotes_IDX on quotes(TEXT)
indextype is CTXSYS.CONTEXT;


-- 8


