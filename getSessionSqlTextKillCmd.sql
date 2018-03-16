/* ---------- Active Sessions ---------- */
SET LINES 195 PAGES 9999 LONG 10000
COL USERNAME FOR A18
COL OSUSER FOR A20
COL EVENT FOR a35
COL STATUS FOR A8
COL PROGRAM FOR A35
COL MODULE FOR A50
COL MACHINE FOR A18
COL SPID FOR A8
col MIN for '99999.99'

SELECT DISTINCT S.INST_ID, 
  S.USERNAME, 
  S.STATUS, S.MODULE,
  S.SID, S.SERIAL#, S.SQL_ID, V.EVENT,
  S.LAST_CALL_ET/60 as min
FROM GV$SESSION S, GV$PROCESS P, GV$SESSION_WAIT V
WHERE P.ADDR = S.PADDR AND S.SID = V.SID AND S.USERNAME IS NOT NULL
AND S.STATUS = 'ACTIVE'
ORDER BY 1, 2
;

/* ---------- Sql Text from Sql ID ---------- */
COL SQL_TEXT FOR A130

SELECT SQL_ID, SQL_TEXT
  FROM GV$SQLTEXT
 WHERE SQL_ID in ('gdrxxp9q9q1a8')
 ORDER BY INST_ID, SQL_ID, PIECE
;

/* ---------- Sql Text of All the Active Sessions of a Specific User ---------- */
SELECT SQL_ID, 
       SQL_TEXT 
  FROM GV$SQLTEXT
 WHERE SQL_ID IN ( SELECT DISTINCT SQL_ID
                     FROM GV$SESSION
                    WHERE USERNAME IN ('&USERNAME')
                      AND STATUS = 'ACTIVE'
           )
ORDER BY INST_ID, SQL_ID, PIECE
;

/* ---------- Get Kill Session Cmd for All Active Sessions of a Specific User  ---------- */
SELECT 'ALTER SYSTEM KILL SESSION ''' || S.SID || ',' || S.SERIAL# || ''' IMMEDIATE;', S.INST_ID
FROM GV$SESSION S
WHERE S.USERNAME IN ('&USERNAMEKILL')
AND S.STATUS = 'ACTIVE'
;