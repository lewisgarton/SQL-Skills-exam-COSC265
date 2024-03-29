set autocommit on;


-- 1a
CREATE TABLE JobSkill (
  Jobname VARCHAR(15) NOT NULL ,
  Skillcode CHAR(1) NOT NULL,
  Rank integer CONSTRAINT Chk_rank CHECK(RANK <= 3 and rank >= 1),
  CONSTRAINT Pk_jobskill PRIMARY KEY(Jobname, Skillcode)
  );
  
-- 1b.
INSERT INTO JobSkill VALUES ('SWDeveloper', 'C', 2);
INSERT INTO JobSkill VALUES ('SWDeveloper', 'D', 3);
INSERT INTO JobSkill VALUES ('SWDeveloper', 'T', 1);
INSERT INTO JobSkill VALUES ('Lifeguard', 'F', 2);
INSERT INTO JobSkill VALUES ('Lifeguard', 'S', 1);
  
  -- check
  SELECT COUNT(*)
  FROM JobSkill;
  
  

-- 1d 

UPDATE Creature
SET C_NAME = 'Smeagol'
WHERE LOWER(C_NAME) = 'gollum';

--CHECK

SELECT *
FROM CREATURE;



-- 2a
-- I KNOW I DO NOT NEED TO SPECIFY THE JOIN CONDITION, BUT I LIKE TO BE CONSISTANT
SELECT DISTINCT C_NAME
FROM CREATURE
JOIN ACHIEVEMENT ON CREATURE.C_ID = ACHIEVEMENT.C_ID
JOIN SKILL ON SKILL.S_CODE = ACHIEVEMENT.S_CODE
WHERE S_WEIGHT <= 0.5
ORDER BY C_NAME ASC;



--2b
SELECT C_NAME
FROM CREATURE
WHERE C_ID IN (SELECT C_ID
               FROM ACHIEVEMENT
               WHERE ACHIEVEMENT.S_CODE IN (SELECT S_CODE
                                            FROM SKILL
                                            WHERE S_WEIGHT <= 0.5))
ORDER BY C_NAME ASC;



-- 2C

SELECT CREATURE.C_TYPE, COUNT(*) AS NUM_ACHIEVED,AVG(SCORE)
FROM CREATURE
JOIN ACHIEVEMENT ON CREATURE.C_ID = ACHIEVEMENT.C_ID
GROUP BY CREATURE.C_TYPE;




-- 2d
SELECT S1.S_CODE, S2.S_CODE
FROM SKILL S1, SKILL S2
WHERE S1.SCORE = 2 AND S2.SCORE = 2;





-- 2e
SELECT CREATURE.C_ID AS CREATURE_ID, COUNT(SCORE) AS ACHIEVEMENTS
FROM CREATURE
JOIN ACHIEVEMENT ON CREATURE.C_ID = ACHIEVEMENT.C_ID
GROUP BY CREATURE.C_ID
ORDER BY CREATURE.C_ID;

SELECT *
FROM CREATURE;




--3a
CREATE VIEW ACH_VIEW AS
SELECT CREATURE.C_ID, CREATURE.C_NAME, CREATURE.C_TYPE, ACHIEVEMENT.S_CODE, ACHIEVEMENT.SCORE, SKILL.S_DESC
FROM CREATURE
JOIN ACHIEVEMENT ON CREATURE.C_ID = ACHIEVEMENT.C_ID
JOIN SKILL ON SKILL.S_CODE = ACHIEVEMENT.S_CODE;



--3b
SELECT * 
FROM ACH_VIEW
WHERE C_ID BETWEEN 1 AND 4;


--3c



CREATE OR REPLACE TRIGGER trg_ach_view
INSTEAD OF INSERT ON ACH_VIEW
FOR EACH ROW
BEGIN
  INSERT INTO CREATURE(C_ID, C_NAME, C_TYPE)
  VALUES(:new.C_ID, :new.C_NAME, :new.C_TYPE);
  INSERT INTO ACHIEVEMENT(C_ID, SCORE, S_CODE)
  VALUES(:new.C_ID, :new.SCORE, :new.S_CODE);
END;


INSERT INTO Ach_View (C_id, C_Name, C_Type, S_Code, Score) 
VALUES (9, 'Fanghorn', 'Ent', 'W', 3);
