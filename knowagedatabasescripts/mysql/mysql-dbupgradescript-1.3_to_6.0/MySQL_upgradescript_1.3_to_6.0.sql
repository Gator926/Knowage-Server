ALTER TABLE SBI_META_TABLE_BC
	DROP FOREIGN KEY FK_SBI_META_TABLE_BC_2;
ALTER TABLE SBI_META_TABLE_BC
	ADD CONSTRAINT FK_SBI_META_TABLE_BC_2 FOREIGN KEY (BC_ID) REFERENCES SBI_META_BC (BC_ID) ON DELETE CASCADE;

ALTER TABLE SBI_META_BC
	DROP FOREIGN KEY FK_SBI_META_BC_1;
ALTER TABLE SBI_META_BC
	ADD CONSTRAINT FK_SBI_META_BC_1 FOREIGN KEY (MODEL_ID) REFERENCES SBI_META_MODELS (ID) ON DELETE CASCADE;
	
ALTER TABLE SBI_META_BC_ATTRIBUTE
	DROP FOREIGN KEY FK_SBI_META_BC_ATTRIBUTE_1;
ALTER TABLE SBI_META_BC_ATTRIBUTE
	ADD CONSTRAINT FK_SBI_META_BC_ATTRIBUTE_1 FOREIGN KEY (BC_ID) REFERENCES SBI_META_BC (BC_ID) ON DELETE CASCADE;	
	
ALTER TABLE SBI_META_BC_ATTRIBUTE
	DROP FOREIGN KEY FK_SBI_META_BC_ATTRIBUTE_2;
ALTER TABLE SBI_META_BC_ATTRIBUTE
	ADD CONSTRAINT FK_SBI_META_BC_ATTRIBUTE_2 FOREIGN KEY (COLUMN_ID) REFERENCES SBI_META_TABLE_COLUMN (COLUMN_ID) ON DELETE CASCADE;	
	
ALTER TABLE SBI_META_DS_BC
	DROP FOREIGN KEY FK_SBI_META_DS_BC_2;
ALTER TABLE SBI_META_DS_BC
	ADD CONSTRAINT FK_SBI_META_DS_BC_2 FOREIGN KEY (BC_ID) REFERENCES SBI_META_BC (BC_ID) ON DELETE CASCADE;
	

update SBI_ENGINES set MAIN_URL='/knowagewhatifengine/restful-services/olap/startolap' where LABEL = 'knowageolapengine';
update SBI_ENGINES set MAIN_URL='/knowagewhatifengine/restful-services/olap/startwhatif' where LABEL = 'knowagewhatifengine';

ALTER TABLE SBI_CATALOG_FUNCTION ADD COLUMN REMOTE TINYINT(1) DEFAULT 0;
ALTER TABLE SBI_CATALOG_FUNCTION ADD COLUMN URL VARCHAR(100);
ALTER TABLE SBI_CATALOG_FUNCTION CHANGE COLUMN SCRIPT SCRIPT TEXT NULL;


CREATE TABLE SBI_FUNCTION_INPUT_FILE (
	FUNCTION_ID INTEGER(11)	NOT NULL,
	FILE_NAME VARCHAR(100)	NOT NULL, 
	FILE_CONTENT MEDIUMBLOB	DEFAULT NULL,
	ALIAS VARCHAR(45)		DEFAULT NULL,
	USER_IN 				VARCHAR(100) NOT NULL,
  	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
  	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
  	TIME_IN 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
  	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
  	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
  	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
  	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
  	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	PRIMARY KEY (FUNCTION_ID, FILE_NAME)
) ENGINE=InnoDB;
  
ALTER TABLE SBI_FUNCTION_INPUT_FILE ADD CONSTRAINT FK_FUNCTION_INPUT_FILES_2 FOREIGN KEY (FUNCTION_ID) REFERENCES SBI_CATALOG_FUNCTION(FUNCTION_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
  
ALTER TABLE SBI_OUTPUT_PARAMETER ADD COLUMN IS_USER_DEFINED BOOLEAN NULL DEFAULT FALSE;

CREATE TABLE SBI_ACCESSIBILITY_PREFERENCES (
	 ID INT(11) UNSIGNED NOT NULL,
	 USER_ID INT(11) NOT NULL,
	 ENABLE_UIO TINYINT(1) NOT NULL,
	 ENABLE_RROBOBRAILLE TINYINT(1) NULL DEFAULT NULL,
	 ENABLE_GRAPH_SONIFICATION TINYINT(1) NULL DEFAULT NULL,
	 ENABLE_VOICE TINYINT(1) NULL DEFAULT NULL,
	 PREFERENCES TEXT NULL,
	 USER_IN VARCHAR(100) NULL DEFAULT NULL,
	 USER_UP VARCHAR(100) NULL DEFAULT NULL,
	 USER_DE VARCHAR(100) NULL DEFAULT NULL,
	 TIME_IN TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
	 TIME_UP TIMESTAMP NULL ,
	 TIME_DE TIMESTAMP NULL ,
	 SBI_VERSION_IN VARCHAR(10) NULL DEFAULT NULL,
	 SBI_VERSION_UP VARCHAR(10) NULL DEFAULT NULL,
	 SBI_VERSION_DE VARCHAR(10) NULL DEFAULT NULL,
	 ORGANIZATION VARCHAR(20) NULL DEFAULT NULL,
	 PRIMARY KEY (ID)
) ENGINE=InnoDB;

ALTER TABLE SBI_SNAPSHOTS ADD COLUMN SCHEDULATION VARCHAR(100);
ALTER TABLE SBI_SNAPSHOTS ADD COLUMN SCHEDULER VARCHAR(100);
ALTER TABLE SBI_SNAPSHOTS ADD COLUMN SCHEDULATION_START INT(11);
ALTER TABLE SBI_SNAPSHOTS ADD COLUMN SEQUENCE INT(11);

ALTER TABLE SBI_IMAGES
DROP INDEX NAME_UNIQUE,
ADD UNIQUE INDEX NAME_UNIQUE (NAME, ORGANIZATION);

-- 02.03.2017 Dragan Pirkovic 
-- changed path for chart document execution
update SBI_ENGINES set MAIN_URL='/knowagecockpitengine/api/1.0/chart/pages/execute' where LABEL = 'knowagechartengine';

ALTER TABLE SBI_CROSS_NAVIGATION
ADD COLUMN TYPE INT(10) NOT NULL AFTER NAME;