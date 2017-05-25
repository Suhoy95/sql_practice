DECLARE
    TIME_DATE DATE;
    TIME_HOUR NUMBER;
BEGIN
  FOR DAY IN 1..356 LOOP
    -- справочник "Производственный календарь"
    -- TIME_ID, TIME_DATE, TIME_HOUR;
    TIME_DATE := TO_DATE(TO_CHAR(DAY) || '.2016', 'DDD.YYYY');
    TIME_HOUR := SIGN(MOD(DAY, 7)) * SIGN(ABS(MOD(DAY, 7) - 6)) * 8;
    INSERT INTO TIMETABLE
        VALUES (DAY, TIME_DATE, TIME_HOUR);
  END LOOP;

-- справочник "Организации"
    -- ORG_ID, ORG_S_NAME, OGR_F_NAME, ORG_INN, ORG_LEG_ADD, ORG_ACT_ADD, ORG_PRE
INSERT INTO ORGANIZATIONS
    (ORG_ID, ORG_S_NAME, OGR_F_NAME, ORG_INN, ORG_LEG_ADD, ORG_ACT_ADD, ORG_PRE) VALUES
    (0, 'Мего код', 'ООО "МЕГА КОД"', '6669996660', 'Ижевск, Инд. р., ул. Л. Толстого, 11', 'Ижевск, Инд. р., ул. Л. Толстого, 11', 'SPC');
INSERT INTO ORGANIZATIONS
    (ORG_ID, ORG_S_NAME, OGR_F_NAME, ORG_INN, ORG_LEG_ADD, ORG_ACT_ADD, ORG_PRE) VALUES
    (1, 'Ижтрейдинг', 'ООО "ИЖТРЕЙДИНГ"', '1833036726', '426039, г Ижевск, Воткинское шоссе,178а', '426039, г Ижевск, Воткинское шоссе,178а', 'IZT');
INSERT INTO ORGANIZATIONS
    (ORG_ID, ORG_S_NAME, OGR_F_NAME, ORG_INN, ORG_LEG_ADD, ORG_ACT_ADD, ORG_PRE) VALUES
    (2, 'Вкусный дом', 'ООО "ВКУСНЫЙ ДОМ"', '1831133410', '426000, г Ижевск, Воткинское шоссе,17','426000, г Ижевск, Воткинское шоссе,17', 'VKD');
INSERT INTO ORGANIZATIONS
    (ORG_ID, ORG_S_NAME, OGR_F_NAME, ORG_INN, ORG_LEG_ADD, ORG_ACT_ADD, ORG_PRE) VALUES
    (3, 'Пятерочка', 'ООО "ПЯТЕРОЧКА РЕГИОНЫ"', '7811339968', '192019, Г САНКТ-ПЕТЕРБУРГ, УЛ ГЛАЗУРНАЯ, 10 ЛИТЕР А','192019, Г САНКТ-ПЕТЕРБУРГ, УЛ ГЛАЗУРНАЯ, 10 ЛИТЕР А', 'PTR');
INSERT INTO ORGANIZATIONS
    (ORG_ID, ORG_S_NAME, OGR_F_NAME, ORG_INN, ORG_LEG_ADD, ORG_ACT_ADD, ORG_PRE) VALUES
    (4, 'Магнит', 'ООО "МАГНИТ"', '1831086930', '426052, г Ижевск, ул Лесозаводская,23/164','Г ИЖЕВСК,УЛ 30 ЛЕТ ПОБЕДЫ,68', 'MGT');

-- справочник "Подразделения"
    -- SUB_ID, SUB_NAME, ORG_ID, SUB_ROLE, SUB_REG, SUB_PARENT_ID
    -- + 1. Администрация
    -- | - 5. Совет директоров
    -- | - 6. Отдел топ менеджмента
    -- + 2. Маркетинг
    -- | - 7. Маркетологи
    -- | - 8. Отдел продаж
    -- + 3. Разработчики
    -- | - 9. Проектировщики баз данных
    -- | - 10. Разработчки ПО
    -- - 4. Отдел тестирования
INSERT INTO SUBDIVISIONS (SUB_ID, SUB_NAME, ORG_ID, SUB_ROLE, SUB_REG, SUB_PARENT_ID) VALUES
    (1, 'Администрация',                0, 'Управление',                         1, NULL);
INSERT INTO SUBDIVISIONS (SUB_ID, SUB_NAME, ORG_ID, SUB_ROLE, SUB_REG, SUB_PARENT_ID) VALUES
    (2, 'Маркетинг',                    0, 'Продажа услуг приложения',           1, NULL);
INSERT INTO SUBDIVISIONS (SUB_ID, SUB_NAME, ORG_ID, SUB_ROLE, SUB_REG, SUB_PARENT_ID) VALUES
    (3, 'Разработчики',                 0, 'Создание и поддержка приложений',    1, NULL);
INSERT INTO SUBDIVISIONS (SUB_ID, SUB_NAME, ORG_ID, SUB_ROLE, SUB_REG, SUB_PARENT_ID) VALUES
    (4, 'Отдел тестирования',           0, 'Контроль качества приложения',       1, NULL);
INSERT INTO SUBDIVISIONS (SUB_ID, SUB_NAME, ORG_ID, SUB_ROLE, SUB_REG, SUB_PARENT_ID) VALUES
    (5, 'Совет директоров',             0, 'Политика компании',                  1, 1);
INSERT INTO SUBDIVISIONS (SUB_ID, SUB_NAME, ORG_ID, SUB_ROLE, SUB_REG, SUB_PARENT_ID) VALUES
    (6, 'Отдел топ менеджмента',        0, 'Исполнители',                        1, 1);
INSERT INTO SUBDIVISIONS (SUB_ID, SUB_NAME, ORG_ID, SUB_ROLE, SUB_REG, SUB_PARENT_ID) VALUES
    (7, 'Маркетологи',                  0, 'Разработка и поддержка брэнда',    1, 2);
INSERT INTO SUBDIVISIONS (SUB_ID, SUB_NAME, ORG_ID, SUB_ROLE, SUB_REG, SUB_PARENT_ID) VALUES
    (8, 'Отдел продаж',                 0, 'Предоставление услуг клиентам',    1, 2);
INSERT INTO SUBDIVISIONS (SUB_ID, SUB_NAME, ORG_ID, SUB_ROLE, SUB_REG, SUB_PARENT_ID) VALUES
    (9, 'Проектировщики баз данных',    0, 'Управление базами данных',          1, 3);
INSERT INTO SUBDIVISIONS (SUB_ID, SUB_NAME, ORG_ID, SUB_ROLE, SUB_REG, SUB_PARENT_ID) VALUES
    (10, 'Разработчки ПО',              0, 'Разработка приложения',            1, 3);


-- справочник "Должности"
    -- POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID
    --    + 1. Дизайнер
    --    |     - 10. Дизайнер по персонажам
    --    |     - 11. Дазайнер ландшафтов
    --    + 2. Программист
    --    |    - 12. Разработчик
    --    |    - 13. Разработчик сюжета
    --    |    - 14. Разработчик навыков
    --    + 3. Маркетолог
    --    |    - 15. Аналитик
    --    |    - 16. SEO-специалист
    --    |    - 17. SMM-специалист
    --    |    - 18. Специалист по рекламе
    --    - 4. Тестировщик
    --    - 5. Системный администратор
    --    - 6. Менеджер проекта
    --    - 7. Менеджер по работе с персоналом
    --    - 8. Бухгалтер
    --    - 9. Директор
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (1, 0, 'Дизайнер',                            20000, 1, NULL);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (2, 0, 'Программист',                        20000, 1, NULL);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (3, 0, 'Маркетолог',                        18000, 1, NULL);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (4, 0, 'Тестировщик',                        25000, 0, NULL);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (5, 0, 'Системный администратор',            20000, 0, NULL);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (6, 0, 'Менеджер проекта',                    25800, 0, NULL);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (7, 0, 'Менеджер по работе с персоналом',    17600, 0, NULL);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (8, 0, 'Бухгалтер',                            21500, 0, NULL);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (9, 0, 'Директор',                            50000, 0, NULL);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (10,0, 'Дизайнер по персонажам',            22000, 0, 1);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (11,0, 'Дазайнер ландшафтов',                35000, 0, 1);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (12,0, 'Разработчик',                        20000, 0, 2);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (13,0, 'Разработчик сюжета',                32000, 0, 2);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (14,0, 'Разработчик навыков',                32000, 0, 2);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (15,0, 'Аналитик',                            25000, 0, 3);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (16,0, 'SEO-специалист',                    20000, 0, 3);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (17,0, 'SMM-специалист',                    20000, 0, 3);
INSERT INTO POSITIONS (POS_ID, ORG_ID, POS_NAME, POS_SALARY, POS_IS_GROUP, POS_PARENT_ID) VALUES
    (18,0, 'Специалист по рекламе',                18000, 0, 3);


-- справочник "сотрудники"
    -- EMP_ID, EMP_NAME, EMP_DATE, EMP_PASS, EMP_INN
INSERT INTO EMPLOYEES VALUES (1,'Иванов Аркадий Акакиевич',TO_DATE('30.03.1991','DD.MM.YYYY'),
'9410 1234 выдан отделом УФМС России по УР в Октябрьском р-не гор. Ижевска 17.02.2010',183454321234);
INSERT INTO EMPLOYEES VALUES (2,'Абрикосов Алексей Алексеевич',TO_DATE('15.09.1975','DD.MM.YYYY'),
'9415 9839 выдан отделом УФМС России по УР в Ленинском р-не гор. Ижевска 30.05.2005',185678769876);
INSERT INTO EMPLOYEES VALUES (3,'Алферов Жорес Иванович',TO_DATE('18.10.1934','DD.MM.YYYY'),
'9440 9843 выдан Индустриальным РОВД гор. Ижевска 15.12.2015',189064783652);
INSERT INTO EMPLOYEES VALUES (4,'Никогдаев Марат Ашанович',TO_DATE('22.05.1976','DD.MM.YYYY'),
'9432 8315 выдан Устиновским РОВД гор. Ижевска 16.07.2000',186479382035);
INSERT INTO EMPLOYEES VALUES (5,'Миловашкин Никита Любовин',TO_DATE('26.08.1968','DD.MM.YYYY'),
'9400 8314 выдан Индустриальным РОВД гор. Ижевска 15.09.2013',182345983765);
INSERT INTO EMPLOYEES VALUES (6,'Мимишкина Анастасия Арсеньевна',TO_DATE('26.07.1980','DD.MM.YYYY'),
'9430 4731 выдан отделом УФМС России по УР в Ленинском р-не гор. Ижевска 23.03.2010',182091850392);
INSERT INTO EMPLOYEES VALUES (7,'Улюлюкина Мирана Дьяволовна',TO_DATE('07.01.1972','DD.MM.YYYY'),
'9411 4542 выдан Индустриальным РОВД гор. Ижевска 23.01.1992',182345678765);
INSERT INTO EMPLOYEES VALUES (8,'Ненавистина Мария Предметовна',NULL,
'9413 3913 выдан Ленинским РОВД гор. Ижевска 31.01.2008',189098765432);


-- справочник "Причины отсутствия"
    -- ABS_ID, ABS_NAME, ABS_COEF, ABS_MAX_DAYS
INSERT INTO ABSENCE (ABS_ID, ABS_NAME, ABS_COEF, ABS_MAX_DAYS) VALUES
    (1,'Прогул',                0,    1);
INSERT INTO ABSENCE (ABS_ID, ABS_NAME, ABS_COEF, ABS_MAX_DAYS) VALUES
    (2,'Больничный',            1,    366);
INSERT INTO ABSENCE (ABS_ID, ABS_NAME, ABS_COEF, ABS_MAX_DAYS) VALUES
    (3,'Очередной отпуск',        1,    28);
INSERT INTO ABSENCE (ABS_ID, ABS_NAME, ABS_COEF, ABS_MAX_DAYS) VALUES
    (4,'Отпуск за свой счёт',    0,    56);

-- Периодический справочник "Должности сотрудников"
    -- PE_VALID_SINCE, SUB_ID, EMP_ID, POS_ID, PE_RATE, PE_SALARY, PE_STATE
INSERT INTO POSITIONS_EMPLOYEES
    (PE_VALID_SINCE, ORG_ID, SUB_ID, EMP_ID, POS_ID, PE_RATE, PE_SALARY, PE_STATE) VALUES
    (TO_DATE('21.09.2016','DD.MM.YYYY'), 1, 4, 1, 18, 1, 50000, 1);
INSERT INTO POSITIONS_EMPLOYEES
    (PE_VALID_SINCE, ORG_ID, SUB_ID, EMP_ID, POS_ID, PE_RATE, PE_SALARY, PE_STATE) VALUES
    (TO_DATE('21.09.2016','DD.MM.YYYY'), 1, 5, 4, 4,        1, 20000, 1);
INSERT INTO POSITIONS_EMPLOYEES
    (PE_VALID_SINCE, ORG_ID, SUB_ID, EMP_ID, POS_ID, PE_RATE, PE_SALARY, PE_STATE) VALUES
    (TO_DATE('21.09.2016','DD.MM.YYYY'), 1, 4, 5, 17,    1, 21500, 1);
INSERT INTO POSITIONS_EMPLOYEES
    (PE_VALID_SINCE, ORG_ID, SUB_ID, EMP_ID, POS_ID, PE_RATE, PE_SALARY, PE_STATE) VALUES
    (TO_DATE('21.09.2016','DD.MM.YYYY'), 1, 6, 3, 7,        1, 32000, 1);
INSERT INTO POSITIONS_EMPLOYEES
    (PE_VALID_SINCE, ORG_ID, SUB_ID, EMP_ID, POS_ID, PE_RATE, PE_SALARY, PE_STATE) VALUES
    (TO_DATE('21.09.2016','DD.MM.YYYY'), 1, 4, 7, 16,    1, 17600, 1);
INSERT INTO POSITIONS_EMPLOYEES
    (PE_VALID_SINCE, ORG_ID, SUB_ID, EMP_ID, POS_ID, PE_RATE, PE_SALARY, PE_STATE) VALUES
    (TO_DATE('21.09.2016','DD.MM.YYYY'), 1, 3, 6, 12,    1, 18000, 1);
INSERT INTO POSITIONS_EMPLOYEES
    (PE_VALID_SINCE, ORG_ID, SUB_ID, EMP_ID, POS_ID, PE_RATE, PE_SALARY, PE_STATE) VALUES
    (TO_DATE('21.10.2016','DD.MM.YYYY'), 1, 5, 4, 4,        1, 20000, 0);
INSERT INTO POSITIONS_EMPLOYEES
    (PE_VALID_SINCE, ORG_ID, SUB_ID, EMP_ID, POS_ID, PE_RATE, PE_SALARY, PE_STATE) VALUES
    (TO_DATE('21.10.2016','DD.MM.YYYY'), 1, 5, 2, 4,        1, 20000, 1);
INSERT INTO POSITIONS_EMPLOYEES
    (PE_VALID_SINCE, ORG_ID, SUB_ID, EMP_ID, POS_ID, PE_RATE, PE_SALARY, PE_STATE) VALUES
    (TO_DATE('21.10.2016','DD.MM.YYYY'), 1, 6, 4, 6,        1, 35000, 1);
INSERT INTO POSITIONS_EMPLOYEES
    (PE_VALID_SINCE, ORG_ID, SUB_ID, EMP_ID, POS_ID, PE_RATE, PE_SALARY, PE_STATE) VALUES
    (TO_DATE('24.10.2016','DD.MM.YYYY'), 1, 1, 8, 15,    1, 25800, 1);
END;