CREATE OR REPLACE PROCEDURE C##TMP_USER.PROC_INSERT_APP (
	I_APP_ID IN C##TMP_USER.APP_TABLE.APP_ID, 
	I_APP_DESCRIPTION IN C##TMP_USER.APP_TABLE.APP_DESCRIPTION%TYPE
)
IS
BEGIN
	
	INSERT INTO C##TMP_USER.APP_TABLE (APP_ID, APP_DESCRIPTION)
	VALUES (I_APP_ID, I_APP_DESCRIPTION);

END PROC_INSERT_APP;