CREATE OR REPLACE PACKAGE TMP_USER.PACK_APP_TABLE
IS

  PROCEDURE UPDATE_APP_DESCRIPTION
  (
    I_APP_ID IN TMP_USER.APP_TABLE.APP_ID, 
	I_APP_DESCRIPTION IN TMP_USER.APP_TABLE.APP_DESCRIPTION%TYPE
  );

END PACK_APP_TABLE;

/

CREATE OR REPLACE PACKAGE BODY TMP_USER.PACK_APP_TABLE
IS

  PROCEDURE DELETE_APP
  (
    I_APP_ID IN TMP_USER.APP_TABLE.APP_ID
  )
  AS
  BEGIN
    DELETE TMP_USER.APP_TABLE
	WHERE APP_ID = I_APP_ID;
  END;

END PACK_APP_TABLE;

/