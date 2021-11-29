# BCRM Oracle 初始資料

## 匯出注意事項
* 將 object 屬於系統的 schema 移除
* 匯入到 OCP 環境不使用 SYSTEM,SYS，將 "SYSTEM".  SYSTEM.  "SYS."  SYS. 內容移除
* ORACLE 系統所使用的view , table 也需要移除
* 整理好的sql需要使用dos2unix去除windows特殊字元
* 整理好的SQL要先在自己的環境，建立新的oracle user去進行檢查。是否有遺漏修改的。
* create table statement need to modify:
```sql
CREATE TABLE "ACCOUNT" 
   (	"ID" NUMBER(10,0), 
	"EMAIL" VARCHAR2(255 CHAR), 
	"EMPLOYEETYPE" NUMBER(1,0), 
	"FAX" VARCHAR2(255 CHAR), 
	"INVALID_REASON" VARCHAR2(255 CHAR), 
	"LAST_LOGIN_IDENTITY" NUMBER(10,0), 
	"LAST_LOGIN_IP" VARCHAR2(255 CHAR), 
	"LAST_LOGIN_TIME" TIMESTAMP (6), 
	"LDAP_ID" VARCHAR2(255 CHAR), 
	"MOBILE" VARCHAR2(255 CHAR), 
	"NAME" VARCHAR2(255 CHAR), 
	"NOTIFY_STATUS" NUMBER(10,0), 
	"EMPNO" VARCHAR2(255 CHAR), 
	"TELO" VARCHAR2(255 CHAR), 
	"VALID" NUMBER(1,0)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
```
Need To modify as the bellow:
```sql
CREATE TABLE "ACCOUNT" 
   (	"ID" NUMBER(10,0), 
	"EMAIL" VARCHAR2(255 CHAR), 
	"EMPLOYEETYPE" NUMBER(1,0), 
	"FAX" VARCHAR2(255 CHAR), 
	"INVALID_REASON" VARCHAR2(255 CHAR), 
	"LAST_LOGIN_IDENTITY" NUMBER(10,0), 
	"LAST_LOGIN_IP" VARCHAR2(255 CHAR), 
	"LAST_LOGIN_TIME" TIMESTAMP (6), 
	"LDAP_ID" VARCHAR2(255 CHAR), 
	"MOBILE" VARCHAR2(255 CHAR), 
	"NAME" VARCHAR2(255 CHAR), 
	"NOTIFY_STATUS" NUMBER(10,0), 
	"EMPNO" VARCHAR2(255 CHAR), 
	"TELO" VARCHAR2(255 CHAR), 
	"VALID" NUMBER(1,0)
   )   ;
``` 
* alter table statement need to modify:
```sql
  ALTER TABLE "ROLE" ADD CONSTRAINT "UK_C36SAY97XYDPMGIGG38QV5L2P" UNIQUE ("CODE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;
``` 
Need To modify as the bellow: 
```sql
  ALTER TABLE "ROLE" ADD CONSTRAINT "UK_C36SAY97XYDPMGIGG38QV5L2P" UNIQUE ("CODE") ;
``` 

## 匯出的Table,Sequence,View
資料清單如下，整理檢核用。
不然會有以下錯誤訊息

## Oracle DB專用Table
MVIEW_EVALUATIONS

```sql
警告: 建立的視觀表含有編譯錯誤.

   COMMENT ON TABLE "MVIEW_EVALUATIONS"  IS 'This view gives DBA access to summary evaluation output'
                    *
 ERROR 在行 1:
ORA-00942: 表格或視觀表不存在



警告: 建立的視觀表含有編譯錯誤.

   COMMENT ON TABLE "MVIEW_EXCEPTIONS"  IS 'This view gives DBA access to dimension validation results'
                    *
 ERROR 在行 1:
ORA-00942: 表格或視觀表不存在



警告: 建立的視觀表含有編譯錯誤.

   COMMENT ON TABLE "MVIEW_FILTER"  IS 'Workload filter records'
                    *
 ERROR 在行 1:
ORA-00942: 表格或視觀表不存在



警告: 建立的視觀表含有編譯錯誤.

   COMMENT ON TABLE "MVIEW_FILTERINSTANCE"  IS 'Workload filter instance records'
                    *
 ERROR 在行 1:
ORA-00942: 表格或視觀表不存在



警告: 建立的視觀表含有編譯錯誤.

   COMMENT ON TABLE "MVIEW_LOG"  IS 'Advisor session log'
                    *
 ERROR 在行 1:
ORA-00942: 表格或視觀表不存在



警告: 建立的視觀表含有編譯錯誤.

   COMMENT ON TABLE "MVIEW_RECOMMENDATIONS"  IS 'This view gives DBA access to summary recommendations'
                    *
 ERROR 在行 1:
ORA-00942: 表格或視觀表不存在



警告: 建立的視觀表含有編譯錯誤.

   COMMENT ON TABLE "MVIEW_WORKLOAD"  IS 'This view gives DBA access to shared workload'
                    *
 ERROR 在行 1:
ORA-00942: 表格或視觀表不存在



警告: 建立的視觀表含有編譯錯誤.

  GRANT READ ON "PRODUCT_PRIVS" TO PUBLIC
                *
 ERROR 在行 1:
ORA-00942: 表格或視觀表不存在


  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SCHEDULER_JOB_ARGS" ("OWNER", "JOB_NAME", "ARGUMENT_NAME", "ARGUMENT_POSITION", "ARGUMENT_TYPE", "VALUE", "ANYDATA_VALUE", "OUT_ARGUMENT") AS
                                              *
 ERROR 在行 1:
ORA-01031: 權限不足


  GRANT SELECT ON "SCHEDULER_JOB_ARGS" TO "SELECT_CATALOG_ROLE"
                  *
 ERROR 在行 1:
ORA-00942: 表格或視觀表不存在


  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SCHEDULER_PROGRAM_ARGS" ("OWNER", "PROGRAM_NAME", "ARGUMENT_NAME", "ARGUMENT_POSITION", "ARGUMENT_TYPE", "METADATA_ATTRIBUTE", "DEFAULT_VALUE", "DEFAULT_ANYDATA_VALUE", "OUT_ARGUMENT") AS
                                              *
 ERROR 在行 1:
ORA-01031: 權限不足

```