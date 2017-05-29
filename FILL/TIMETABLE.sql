DECLARE
    TIME_DATE DATE;
    TIME_HOUR NUMBER;
    DAY_SHIFT CONSTANT NUMBER := 6; -- 2017 начинается с воскресенья
BEGIN
  FOR DAY IN 1..356 LOOP
    -- справочник "Производственный календарь"
    -- TIME_ID, TIME_DATE, TIME_HOUR;
    TIME_DATE := TO_DATE(TO_CHAR(DAY) || '.2017', 'DDD.YYYY');
    TIME_HOUR := SIGN(MOD(DAY + DAY_SHIFT, 7)) * SIGN(ABS(MOD(DAY + DAY_SHIFT, 7) - 6)) * 8;
    INSERT INTO TIMETABLE
        VALUES (DAY, TIME_DATE, TIME_HOUR);
  END LOOP;

  -- Новогодние будни-праздники
  UPDATE TIMETABLE SET TIME_HOUR=0 WHERE TIME_DATE = TO_DATE('02.01.2017','DD.MM.YYYY');
  UPDATE TIMETABLE SET TIME_HOUR=0 WHERE TIME_DATE = TO_DATE('03.01.2017','DD.MM.YYYY');
  UPDATE TIMETABLE SET TIME_HOUR=0 WHERE TIME_DATE = TO_DATE('04.01.2017','DD.MM.YYYY');
  UPDATE TIMETABLE SET TIME_HOUR=0 WHERE TIME_DATE = TO_DATE('05.01.2017','DD.MM.YYYY');
  UPDATE TIMETABLE SET TIME_HOUR=0 WHERE TIME_DATE = TO_DATE('06.01.2017','DD.MM.YYYY');
  -- 23-февраля
  UPDATE TIMETABLE SET TIME_HOUR=0 WHERE TIME_DATE = TO_DATE('23.02.2017','DD.MM.YYYY');
  UPDATE TIMETABLE SET TIME_HOUR=0 WHERE TIME_DATE = TO_DATE('24.02.2017','DD.MM.YYYY');
  -- 8-е марта
  UPDATE TIMETABLE SET TIME_HOUR=0 WHERE TIME_DATE = TO_DATE('08.03.2017','DD.MM.YYYY');
  -- 1-е мая
  UPDATE TIMETABLE SET TIME_HOUR=0 WHERE TIME_DATE = TO_DATE('01.05.2017','DD.MM.YYYY');
  -- 9-е мая
  UPDATE TIMETABLE SET TIME_HOUR=0 WHERE TIME_DATE = TO_DATE('08.05.2017','DD.MM.YYYY');
  UPDATE TIMETABLE SET TIME_HOUR=0 WHERE TIME_DATE = TO_DATE('09.05.2017','DD.MM.YYYY');
  -- 12 июня
  UPDATE TIMETABLE SET TIME_HOUR=0 WHERE TIME_DATE = TO_DATE('12.06.2017','DD.MM.YYYY');
  -- 6 нояюря
  UPDATE TIMETABLE SET TIME_HOUR=0 WHERE TIME_DATE = TO_DATE('06.11.2017','DD.MM.YYYY');
END