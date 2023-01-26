-- CONTAINS
-- 1
select * from  ZSBD_TOOLS.cytaty

CREATE TABLE CYTATY AS
select * from  ZSBD_TOOLS.cytaty
-- 2
select * from cytaty c where lower(tekst) like '%optymista%' and lower(tekst) like '%pesymista%'

--3
create index CYTATY_WORD_IDX on cytaty(TEKST)
indextype is CTXSYS.CONTEXT;


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

select * FROM cytaty c where contains(tekst, 'fuzzy(probelm)')>0

-- 12

INSERT INTO CYTATY (ID, AUTOR, TEKST) VALUES (39, 'Bentrand Russell', 'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości');
commit

select * from cytaty

-- 13
SELECT * FROM cytaty c where contains(c.tekst, 'glupcy')>0 

-- 14
select token_text from DR$CYTATY_WORD_IDX$I

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
-- Slowo it znajduje sie w stopliscie

-- 5 

select * from CTX_STOPLISTS;

-- 6

select * from CTX_STOPWORDS WHERE SPW_STOPLIST = 'DEFAULT_STOPLIST';

-- 7

drop index CYTATY_quotes_IDX 

create index CYTATY_quotes_IDX on quotes(TEXT)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST')


-- 8

SELECT * FROM quotes c where contains(c.text, 'it')>0 

-- 9

SELECT * FROM quotes c where contains(c.text, 'fool AND humans')>0 

-- 10

SELECT * FROM quotes c where contains(c.text, 'fool AND computer')>0 

-- 11

SELECT * FROM quotes c where contains(c.text, '(fool AND humans) within sentence')>0 

-- 12 

drop index CYTATY_quotes_IDX 

-- 13

begin 
    ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
    ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
end;

-- 14

create index CYTATY_quotes_IDX on quotes(TEXT)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST section group nullgroup')

-- 15

SELECT * FROM quotes c where contains(c.text, 'fool AND humans')>0 
SELECT * FROM quotes c where contains(c.text, 'fool AND computer')>0 

-- 16

SELECT * FROM quotes c where contains(c.text, 'humans')>0 

-- 17

drop index CYTATY_quotes_IDX 

begin 
    ctx_ddl.create_preference('lex_z_m', 'BASIC_LEXER');
    ctx_ddl.set_attribute('lex_z_m', 'printjoins', '_-');
    ctx_ddl.set_attribute('lex_z_m', 'index_text', 'YES');
end;

create index CYTATY_quotes_IDX on quotes(TEXT)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST section group nullgroup LEXER lex_z_m')

-- 18

SELECT * FROM quotes c where contains(c.text, 'humans')>0 
-- nie

-- 19

SELECT * FROM quotes c where contains(c.text, 'non\-humans')>0

-- 20

drop table quotes;

begin 
    ctx_ddl.drop_preference('lex_z_m');
end;
