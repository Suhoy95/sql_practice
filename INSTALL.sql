-- #############################################################################
-- ##                                                                         ##
-- ## СПРАВОЧНИКИ                                                             ##
-- ##                                                                         ##
-- #############################################################################

-- справочник "Организации"
CREATE TABLE ORGANIZATIONS (
-- fields
    ORG_ID NUMBER NOT NULL,
    ORG_S_NAME VARCHAR2(20CHAR) NOT NULL, -- short(кор.) название
    OGR_F_NAME VARCHAR2(100CHAR) NOT NULL, -- full(полн.) название
    ORG_INN VARCHAR2(12CHAR) NOT NULL, -- ИНН
    ORG_LEG_ADD VARCHAR2(200CHAR) NOT NULL, -- legal(юр.) адрес
    ORG_ACT_ADD VARCHAR2(200CHAR) NOT NULL, -- actual(факт.) фдрес
    ORG_PRE VARCHAR2(3CHAR) NOT NULL, -- префикс рорганизации для документов
-- constraints
    CONSTRAINT PK_ORG_ID PRIMARY KEY (ORG_ID),
    CONSTRAINT ORG_PRE_U UNIQUE (ORG_PRE)
);

-- справочник "Подразделения"
CREATE TABLE SUBDIVISIONS (
-- fields
    SUB_ID NUMBER NOT NULL,
    SUB_NAME VARCHAR2(100CHAR) NOT NULL, -- Название подразделения
    ORG_ID NUMBER NOT NULL, -- Ссылка на справочник "Организации"
    SUB_ROLE VARCHAR2(100CHAR), -- Роль подразделения.
    SUB_REG NUMBER NOT NULL, -- Региональная надбавка (коэффициент, учитываемый при расчете зарплаты).
    SUB_PARENT_ID NUMBER, -- Ссылка на родителя.
-- constraints
    CONSTRAINT PK_SUB_ID PRIMARY KEY (SUB_ID),
    CONSTRAINT FK_SUB_PARENT FOREIGN KEY (SUB_PARENT_ID) REFERENCES SUBDIVISIONS (SUB_ID),
    CONSTRAINT FK_SUB_to_ORG FOREIGN KEY (ORG_ID) REFERENCES ORGANIZATIONS (ORG_ID)
);

-- справочник "Должности"
CREATE TABLE POSITIONS (
-- fields
    POS_ID NUMBER NOT NULL,
    ORG_ID NUMBER NOT NULL, -- Ссылка на справочник "Организации"
    POS_NAME VARCHAR2(100CHAR) NOT NULL, -- Название должности.
    POS_SALARY NUMBER, -- Оклад - используется как значение по умолчанию при заполнении формы документа.
    POS_IS_GROUP NUMBER NOT NULL, -- 0 – элемент / 1 – группа
    POS_PARENT_ID NUMBER, -- Ссылка на родителя.
-- constraints
    CONSTRAINT PK_POS_ID PRIMARY KEY (POS_ID),
    CONSTRAINT FK_POS_PARENT FOREIGN KEY (POS_PARENT_ID) REFERENCES POSITIONS (POS_ID),
    CONSTRAINT FK_POS_to_ORG FOREIGN KEY (ORG_ID) REFERENCES ORGANIZATIONS (ORG_ID),
    CONSTRAINT IS_GROUP CHECK(POS_IS_GROUP IN (0,1))
);

-- справочник "сотрудники"
CREATE TABLE EMPLOYEES (
-- fields
    EMP_ID NUMBER NOT NULL,
    EMP_NAME VARCHAR2(100CHAR) NOT NULL, -- ФИО
    EMP_DATE DATE, -- Дата рождения.
    EMP_PASS VARCHAR2(300CHAR) NOT NULL, -- Паспортные данные.
    EMP_INN VARCHAR2(12CHAR), -- ИНН (NULL - ИНН отсутствует).
-- constraints
    CONSTRAINT PK_EMP_ID PRIMARY KEY (EMP_ID)
);

-- справочник "Причины отсутствия"
CREATE TABLE ABSENCE (
-- fields
    ABS_ID NUMBER NOT NULL,
    ABS_NAME VARCHAR2(255CHAR) NOT NULL, -- Название причины отсутствия (Прогул/больничный/очередной отпуск/отпуск за свой счет)
    ABS_COEF NUMBER NOT NULL, -- Коэффициент ставки
    ABS_MAX_DAYS NUMBER NOT NULL, -- Ограничение по количеству дней в году
-- constraints
    CONSTRAINT PK_ABS_ID PRIMARY KEY (ABS_ID)
);

-- справочник "Производственный календарь"
CREATE TABLE TIMETABLE (
-- fields
    TIME_ID NUMBER NOT NULL,
    TIME_DATE DATE NOT NULL, -- Дата 
    TIME_HOUR NUMBER DEFAULT 8 NOT NULL, -- Количество рабочих часов
-- constraints
    CONSTRAINT PK_TIME_ID PRIMARY KEY (TIME_ID),
    CONSTRAINT UNIQUE_DATE UNIQUE (TIME_DATE)
);

-- Периодический справочник "Должности сотрудников"
CREATE TABLE POSITIONS_EMPLOYEES (
-- fields
    PE_VALID_SINCE DATE NOT NULL, -- Дата изменения
    SUB_ID NUMBER NOT NULL, -- Ссылка на справочник «Подразделения».
    EMP_ID NUMBER NOT NULL, -- Ссылка на справочник «Сотрудники»
    POS_ID NUMBER NOT NULL, -- Ссылка на справочник «Должности».
    PE_RATE NUMBER NOT NULL, -- Ставка (относительно нормативной).
    PE_SALARY NUMBER NOT NULL, -- Оклад (рублей для полной ставки).
    PE_STATE NUMBER NOT NULL, -- Статус 0 – уволен / 1 – принят
-- constraints
    CONSTRAINT PK_PE_ID PRIMARY KEY (PE_VALID_SINCE, SUB_ID, EMP_ID, POS_ID),
    CONSTRAINT FK_PE_to_SUB FOREIGN KEY (SUB_ID) REFERENCES SUBDIVISIONS (SUB_ID),
    CONSTRAINT FK_PE_to_EMP FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEES (EMP_ID),
    CONSTRAINT FK_PE_to_POS FOREIGN KEY (POS_ID) REFERENCES POSITIONS (POS_ID),
    CONSTRAINT PE_RATE_VALUE CHECK (PE_RATE > 0 AND PE_RATE <= 1),
    CONSTRAINT PE_SALARY_VALUE CHECK (PE_SALARY > 0),
    CONSTRAINT PE_WORK_STATE CHECK (PE_STATE IN (0,1))
);

-- #############################################################################
-- ##                                                                         ##
-- ## ДОкументы                                                               ##
-- ##                                                                         ##
-- #############################################################################

-- документ "Кадровый приказ", шапка
CREATE TABLE STAFF_ORDER_HEADER (
-- fields
    SO_ID NUMBER NOT NULL,
    SO_DATE DATE NOT NULL, -- Дата создания.
    SO_NUMBER VARCHAR2(30CHAR) NOT NULL, -- Номер документа.
    ORG_ID NUMBER NOT NULL, -- Ссылка на справочник "Организации"
    SO_STATE NUMBER DEFAULT 0 NOT NULL, -- Статус документа 0 – черновой / 1 – подтверждённый
-- constraints
    CONSTRAINT PK_SO_ID PRIMARY KEY (SO_ID),
    CONSTRAINT FK_SO_to_ORG FOREIGN KEY (ORG_ID) REFERENCES ORGANIZATIONS (ORG_ID),
    CONSTRAINT SOT_STATE CHECK (SO_STATE IN (0, 1))
);

-- документ "Кадровый приказ", табличная часть
CREATE TABLE STAFF_ORDER_LINES (
-- fields
    SOL_ID NUMBER NOT NULL,
    SO_ID NUMBER NOT NULL, -- Ссылка на заголовок документа.
    EMP_ID NUMBER NOT NULL, -- Ссылка на справочник «Сотрудники».
    SUB_ID NUMBER NOT NULL, -- Ссылка на справочник «Подразделения».
    POS_ID NUMBER NOT NULL, -- Ссылка на справочник «Должности».
    SOL_TYPE NUMBER NOT NULL, -- 0 – увольнение, 1 – приём, 2 – изменение
    SOL_RATE NUMBER, -- Ставка (> 0 & <= 1)
    SOL_SALARY NUMBER, -- Оклад (>0)
-- constraints
    CONSTRAINT PK_SOL_ID PRIMARY KEY (SOL_ID),
    CONSTRAINT FK_SOL_to_SO FOREIGN KEY (SO_ID) REFERENCES STAFF_ORDER_HEADER (SO_ID),
    CONSTRAINT FK_SOL_to_EMP FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEES (EMP_ID),
    CONSTRAINT FK_SOL_to_SUB FOREIGN KEY (SUB_ID) REFERENCES SUBDIVISIONS (SUB_ID),
    CONSTRAINT FK_SOL_to_POS FOREIGN KEY (POS_ID) REFERENCES POSITIONS (POS_ID),
    CONSTRAINT SOL_TYPE_VALUE CHECK (SOL_TYPE IN (0,1,2)),
    CONSTRAINT SOL_RATE_VALUE CHECK (SOL_RATE > 0 AND SOL_RATE <= 1),
    CONSTRAINT SOL_SALARY_VALUE CHECK (SOL_SALARY > 0)
);

-- документ "отсутствие сотрудника"
CREATE TABLE ABSENCE_EMPLOYEE (
-- fields
    AE_ID NUMBER NOT NULL,
    AE_DATE DATE NOT NULL, -- Дата события
    AE_NUMBER VARCHAR2(30CHAR) NOT NULL, -- Номер документа
    AE_STATE NUMBER DEFAULT 0 NOT NULL, -- Статус документа 0 - черновой, 1 - подтвержденный
    SUB_ID NUMBER NOT NULL, -- Ссылка на справочник  «Подразделения»
    EMP_ID NUMBER NOT NULL, -- Ссылка на справочник  «Сотрудник»
    ABS_ID NUMBER NOT NULL, -- Ссылка на справочник "Причина отсутствия" 
    AE_START DATE NOT NULL, -- Начало отсутствия
    AE_END DATE NOT NULL, -- Окончание отсутствия 
-- constraints
    CONSTRAINT PK_AE_ID PRIMARY KEY (AE_ID),
    CONSTRAINT FK_AE_to_SUB FOREIGN KEY (SUB_ID) REFERENCES SUBDIVISIONS (SUB_ID),
    CONSTRAINT FK_AE_to_EMP FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEES (EMP_ID),
    CONSTRAINT FK_AE_to_ABS FOREIGN KEY (ABS_ID) REFERENCES ABSENCE (ABS_ID),
    CONSTRAINT ABS_STATE CHECK (AE_STATE IN (0,1))
);

-- документ "начисление зарплаты", шапка
CREATE TABLE CALCULATION_SALARY_HEADER (
-- fields
    CS_ID NUMBER NOT NULL,
    CS_DATE DATE NOT NULL, -- Дата события
    CS_NUMBER VARCHAR2(30CHAR) NOT NULL, -- Номер документа
    CS_STATE NUMBER NOT NULL, -- Статус документа  0 - черновой, 1 - подтвержденный
    SUB_ID NUMBER NOT NULL, -- Ссылка на справочник  «Подразделения»
-- constraints
    CONSTRAINT PK_CS_ID PRIMARY KEY (CS_ID),
    CONSTRAINT FK_CS_to_SUB FOREIGN KEY (SUB_ID) REFERENCES SUBDIVISIONS (SUB_ID),
    CONSTRAINT CST_STATE CHECK (CS_STATE IN (0,1))
);

-- документ "начисление зарплаты", табличная часть
CREATE TABLE CALCULATION_SALARY_LINES (
-- fields
    CSL_ID NUMBER NOT NULL,
    CS_ID NUMBER NOT NULL, -- Ссылка на шапку документа 
    EMP_ID NUMBER NOT NULL, -- Ссылка на справочник  «Сотрудник»
    CSL_TIME NUMBER NOT NULL, -- Количество часов (фактическое) 
    CSL_CONSIDER NUMBER NOT NULL, -- Сумма зарплаты   расчетная 
    CSL_PRIZE NUMBER NOT NULL, -- Премия
    CSL_CORRECTION NUMBER NOT NULL, -- Сумма зарплаты скорректированная
-- constraints
    CONSTRAINT PK_CSL_ID PRIMARY KEY (CSL_ID),
    CONSTRAINT FK_CSL_to_CS FOREIGN KEY (CS_ID) REFERENCES CALCULATION_SALARY_HEADER (CS_ID),
    CONSTRAINT FK_CSL_to_EMP FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEES (EMP_ID)
);

-- #############################################################################
-- ##                                                                         ##
-- ## Кубы                                                                    ##
-- ##                                                                         ##
-- #############################################################################

-- куб "Взаиморасчёты с сотрудниками"
CREATE TABLE CALCULATION_WITH_EMPLOYEES (
-- fields
    CSL_ID NUMBER NOT NULL, -- Ссылка на запись в документе "Начисление зарплат"
    EMP_ID NUMBER NOT NULL, -- Ссылка на справочник «Сотрудники».
    CWE_TYPE VARCHAR2(15CHAR) NOT NULL, -- Тип выплаты (простая, целевые расходы).
    CWE_SUM NUMBER NOT NULL, -- Сумма.
-- constraints
    CONSTRAINT PK_CWE_ID PRIMARY KEY (CSL_ID, EMP_ID),
    CONSTRAINT FK_CWE_to_CSL FOREIGN KEY (CSL_ID) REFERENCES CALCULATION_SALARY_LINES (CSL_ID),
    CONSTRAINT FK_CWE_to_EMP FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEES (EMP_ID)
);

-- куб "Отклонения расчёта"
CREATE TABLE DEVATION_CALCULATION (
-- fields
    AE_ID NUMBER NOT NULL, -- Ссылка на документ "Отсутствие сотрудника"
    EMP_ID NUMBER NOT NULL, -- Ссылка на справочник  «Сотрудник»
    DC_BEGIN DATE NOT NULL, -- Начало периода
    DC_END DATE NOT NULL, -- Окончание периода
    DC_TYPE VARCHAR2(20CHAR) NOT NULL, -- Тип отклонения (коэффициент / сумма)
    DC_VALUE NUMBER NOT NULL, -- Отклонение
-- constraints
    CONSTRAINT PK_DC_ID PRIMARY KEY (AE_ID, EMP_ID, DC_BEGIN, DC_END),
    CONSTRAINT FK_DC_to_AE FOREIGN KEY (AE_ID) REFERENCES ABSENCE_EMPLOYEE (AE_ID),
    CONSTRAINT FK_DC_to_EMP FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEES (EMP_ID)
);