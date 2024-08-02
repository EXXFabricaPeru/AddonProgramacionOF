DROP PROCEDURE "EXX_ValidarStage";
CREATE PROCEDURE "EXX_ValidarStage"
	(IN DOCENTRY INT,
	IN SEQNUM INT,
	IN CODE NVARCHAR(50))
AS
BEGIN
	DECLARE SEQANT INT;
	DECLARE RECURSOS INT;
	DECLARE RECURSOSPROG INT;
	DECLARE RECURSOSPROG2 INT;
	IF :SEQNUM=1 THEN
		SELECT 0 FROM DUMMY;
	ELSE
		
		SELECT max("StageId") INTO SEQANT FROM WOR4 WHERE "DocEntry"=:DOCENTRY and "SeqNum"<:SEQNUM;
		SELECT COUNT(0) INTO RECURSOS FROM WOR1 WHERE "DocEntry"=:DOCENTRY AND "StageId"=:SEQANT AND "ItemType"=290;
		IF :RECURSOS>0 THEN
			SELECT COUNT(0) INTO RECURSOSPROG FROM WOR1 WHERE "DocEntry"=:DOCENTRY AND "StageId"=:SEQANT AND "U_EXC_Programado"='Y';
			SELECT COUNT(0) INTO RECURSOSPROG2 FROM "@EXX_PROGOF" T0 WHERE T0.U_PROGCODE=:CODE AND T0.U_DOCENTRY=:DOCENTRY AND T0.U_STAGEID=:SEQANT;
			IF :RECURSOSPROG=0 AND :RECURSOSPROG2=0 THEN
				SELECT -1 FROM DUMMY;
			ELSE
				IF :RECURSOSPROG>0 THEN
					SELECT MAX("U_EXC_HoraFin") FROM WOR1 WHERE "DocEntry"=:DOCENTRY AND "StageId"=:SEQANT AND "U_EXC_Programado"='Y';
				ELSE
					SELECT MAX(T0.U_FINISHTIME) FROM "@EXX_PROGOF" T0 WHERE T0.U_PROGCODE=:CODE AND T0.U_DOCENTRY=:DOCENTRY AND T0.U_STAGEID=:SEQANT;
				END IF;
			END IF;
		ELSE
			SELECT 0 FROM DUMMY;
		END IF;
	END IF;
END;