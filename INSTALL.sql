﻿CREATE TABLE ORGANIZATIONS ( -- Cправочник "Организации"
ORG_ID NUMBER NOT NULL, -- PK
ORG_S_NAME VARCHAR2 (20CHAR) NOT NULL, -- короткое название (short)
OGR_F_NAME VARCHAR2 (100CHAR) NOT NULL, -- полноое название (full)
ORG_INN VARCHAR2 (12CHAR), -- ИНН, уникален, NULL - отсутствует
ORG_LEG_ADD VARCHAR2 (200CHAR) NOT NULL, -- юридический адрес (legal)
ORG_ACT_ADD VARCHAR2 (200CHAR) NOT NULL, -- фактический адрес (actual)
ORG_PRE VARCHAR2 (3CHAR) NOT NULL, -- префикс рорганизации для документов
CONSTRAINT PK_ORG_ID PRIMARY KEY (ORG_ID),
CONSTRAINT ORG_PRE_U UNIQUE (ORG_PRE),
CONSTRAINT ORG_INN_U UNIQUE (ORG_INN)
);
CREATE TABLE SUBDIVISIONS ( -- Справочник "Подразделения"
SUB_ID NUMBER NOT NULL, -- PK
SUB_NAME VARCHAR2 (100CHAR) NOT NULL, -- название подразделения
ORG_ID NUMBER NOT NULL, -- ссылка на справочник "Организации"
SUB_ROLE VARCHAR2 (100CHAR), -- роль подразделения
SUB_REG NUMBER NOT NULL, -- региональная надбавка (коэффициент, учитываемый при расчете зарплаты, $REG >= 0$)
SUB_PARENT_ID NUMBER, -- ссылка на родителя
CONSTRAINT PK_SUB_ID PRIMARY KEY (SUB_ID),
CONSTRAINT FK_SUB_PARENT FOREIGN KEY (SUB_PARENT_ID) REFERENCES SUBDIVISIONS (SUB_ID),
CONSTRAINT FK_SUB_to_ORG FOREIGN KEY (ORG_ID) REFERENCES ORGANIZATIONS (ORG_ID),
CONSTRAINT SUB_REG CHECK (SUB_REG >= 0)
);
CREATE TABLE POSITIONS ( -- Справочник "Должности"
POS_ID NUMBER NOT NULL, -- PK
ORG_ID NUMBER NOT NULL, -- ссылка на справочник "Организации"
POS_NAME VARCHAR2 (100CHAR) NOT NULL, -- название должности
POS_SALARY NUMBER, -- оклад - используется как значение по умолчанию при заполнении формы документа, положительный
POS_IS_GROUP NUMBER NOT NULL, -- признак группы (0 – элемент, 1 – группа)
POS_PARENT_ID NUMBER, -- ссылка на родителя
CONSTRAINT PK_POS_ID PRIMARY KEY (POS_ID),
CONSTRAINT FK_POS_PARENT FOREIGN KEY (POS_PARENT_ID) REFERENCES POSITIONS (POS_ID),
CONSTRAINT FK_POS_to_ORG FOREIGN KEY (ORG_ID) REFERENCES ORGANIZATIONS (ORG_ID),
CONSTRAINT IS_GROUP CHECK (POS_IS_GROUP IN (0,1)),
CONSTRAINT POS_SALARY CHECK (POS_SALARY > 0)
);
CREATE TABLE EMPLOYEES ( -- Справочник "Сотрудники"
EMP_ID NUMBER NOT NULL, -- PK
EMP_NAME VARCHAR2 (100CHAR) NOT NULL, -- ФИО
EMP_DATE DATE, -- дата рождения
EMP_PASS VARCHAR2 (300CHAR) NOT NULL, -- паспортные данные
EMP_INN VARCHAR2 (12CHAR), -- ИНН, уникально (NULL - ИНН отсутствует)
CONSTRAINT PK_EMP_ID PRIMARY KEY (EMP_ID),
CONSTRAINT EMP_INN UNIQUE (EMP_INN)
);
CREATE TABLE ABSENCE ( -- Справочник "Причины отсутствия"
ABS_ID NUMBER NOT NULL, -- PK
ABS_NAME VARCHAR2 (255CHAR) NOT NULL, -- название причины отсутствия (прогул, больничный, отпуск, отпуск за свой счет)
ABS_COEF NUMBER NOT NULL, -- коэффициент ставки ($COEF >= 0$;$COEF <=1$)
ABS_MAX_DAYS NUMBER NOT NULL, -- ограничение по количеству дней в году
CONSTRAINT PK_ABS_ID PRIMARY KEY (ABS_ID),
CONSTRAINT ABS_COEF CHECK (ABS_COEF >= 0 AND ABS_COEF <= 1)
);
CREATE TABLE TIMETABLE ( -- Справочник "Производственный календарь"
TIME_ID NUMBER NOT NULL, -- PK
TIME_DATE DATE NOT NULL, -- дата
TIME_HOUR NUMBER DEFAULT 8 NOT NULL, -- кол-во рабочих часов
CONSTRAINT PK_TIME_ID PRIMARY KEY (TIME_ID)
);
CREATE TABLE POSITIONS_EMPLOYEES ( -- Периодический справочник "Должности сотрудников"
PE_VALID_SINCE DATE NOT NULL, -- дата изменения
ORG_ID NUMBER NOT NULL, -- ссылка на справочник "Организации"
SUB_ID NUMBER NOT NULL, -- ссылка на справочник "Подразделения"
EMP_ID NUMBER NOT NULL, -- ссылка на справочник "Сотрудники"
POS_ID NUMBER NOT NULL, -- ссылка на справочник "Должности"
PE_RATE NUMBER NOT NULL, -- ставка (относительно нормативной)
PE_SALARY NUMBER NOT NULL, -- оклад (рублей для полной ставки), положительный
PE_STATE NUMBER NOT NULL, -- статус (0 – уволен, 1 – принят)
CONSTRAINT PK_PE_ID PRIMARY KEY (PE_VALID_SINCE, SUB_ID, EMP_ID, POS_ID),
CONSTRAINT FK_PE_to_ORG FOREIGN KEY (ORG_ID) REFERENCES ORGANIZATIONS (ORG_ID),
CONSTRAINT FK_PE_to_SUB FOREIGN KEY (SUB_ID) REFERENCES SUBDIVISIONS (SUB_ID),
CONSTRAINT FK_PE_to_EMP FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEES (EMP_ID),
CONSTRAINT FK_PE_to_POS FOREIGN KEY (POS_ID) REFERENCES POSITIONS (POS_ID),
CONSTRAINT PE_RATE_VALUE CHECK (PE_RATE > 0 AND PE_RATE <= 1),
CONSTRAINT PE_SALARY_VALUE CHECK (PE_SALARY > 0),
CONSTRAINT PE_WORK_STATE CHECK (PE_STATE IN (0,1)),
CONSTRAINT PE_SALARY CHECK (PE_SALARY > 0)
);
CREATE TABLE STAFF_ORDER_HEADER ( -- Документ "Кадровый приказ", шапка
SO_ID NUMBER NOT NULL, -- PK
SO_DATE DATE NOT NULL, -- дата создания
SO_NUMBER VARCHAR2 (30CHAR) NOT NULL, -- Номер документа
ORG_ID NUMBER NOT NULL, -- cсылка на справочник "Организации"
SO_STATE NUMBER DEFAULT 0 NOT NULL, -- cтатус документа (0 – черновой, 1 – подтверждённый)
CONSTRAINT PK_SO_ID PRIMARY KEY (SO_ID),
CONSTRAINT FK_SO_to_ORG FOREIGN KEY (ORG_ID) REFERENCES ORGANIZATIONS (ORG_ID),
CONSTRAINT SOT_STATE CHECK (SO_STATE IN (0, 1))
);
CREATE TABLE STAFF_ORDER_LINES ( -- Документ "Кадровый приказ"\ табличная часть
SOL_ID NUMBER NOT NULL,
SO_ID NUMBER NOT NULL, -- cсылка на заголовок документа
EMP_ID NUMBER NOT NULL, -- cсылка на справочник "Сотрудники"
SUB_ID NUMBER NOT NULL, -- cсылка на справочник "Подразделения"
POS_ID NUMBER NOT NULL, -- cсылка на справочник "Должности"
SOL_TYPE NUMBER NOT NULL, -- тип записи (0 – увольнение, 1 – приём, 2 – изменение)
SOL_RATE NUMBER, -- cтавка ($RATE>0$;$RATE <= 1$)
SOL_SALARY NUMBER, -- оклад ($SALARY > 0$)
CONSTRAINT PK_SOL_ID PRIMARY KEY (SOL_ID),
CONSTRAINT FK_SOL_to_SO FOREIGN KEY (SO_ID) REFERENCES STAFF_ORDER_HEADER (SO_ID),
CONSTRAINT FK_SOL_to_EMP FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEES (EMP_ID),
CONSTRAINT FK_SOL_to_SUB FOREIGN KEY (SUB_ID) REFERENCES SUBDIVISIONS (SUB_ID),
CONSTRAINT FK_SOL_to_POS FOREIGN KEY (POS_ID) REFERENCES POSITIONS (POS_ID),
CONSTRAINT SOL_TYPE_VALUE CHECK (SOL_TYPE IN (0,1,2)),
CONSTRAINT SOL_RATE_VALUE CHECK (SOL_RATE > 0 AND SOL_RATE <= 1),
CONSTRAINT SOL_SALARY_VALUE CHECK (SOL_SALARY > 0)
);
CREATE TABLE ABSENCE_EMPLOYEE ( -- Документ "Отсутствие сотрудника"
AE_ID NUMBER NOT NULL, -- PK
AE_DATE DATE NOT NULL, -- дата события
AE_NUMBER VARCHAR2 (30CHAR) NOT NULL, -- номер документа
AE_STATE NUMBER DEFAULT 0 NOT NULL, -- статус документа (0 - черновой, 1 - подтвержденный)
ORG_ID NUMBER NOT NULL, -- ссылка на справочник "Организации"
SUB_ID NUMBER NOT NULL, -- ссылка на справочник "Подразделения"
EMP_ID NUMBER NOT NULL, -- ссылка на справочник "Сотрудник"
ABS_ID NUMBER NOT NULL, -- ссылка на справочник "Причина отсутствия"
AE_START DATE NOT NULL, -- начало отсутствия
AE_END DATE NOT NULL, -- окончание отсутствия
CONSTRAINT PK_AE_ID PRIMARY KEY (AE_ID),
CONSTRAINT FK_AE_to_ORG FOREIGN KEY (ORG_ID) REFERENCES ORGANIZATIONS (ORG_ID),
CONSTRAINT FK_AE_to_SUB FOREIGN KEY (SUB_ID) REFERENCES SUBDIVISIONS (SUB_ID),
CONSTRAINT FK_AE_to_EMP FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEES (EMP_ID),
CONSTRAINT FK_AE_to_ABS FOREIGN KEY (ABS_ID) REFERENCES ABSENCE (ABS_ID),
CONSTRAINT ABS_STATE CHECK (AE_STATE IN (0,1))
);
CREATE TABLE CALCULATION_SALARY_HEADER ( -- Документ "Начисление зарплаты"\ шапка
CS_ID NUMBER NOT NULL, -- PK
CS_DATE DATE NOT NULL, -- дата события
CS_NUMBER VARCHAR2 (30CHAR) NOT NULL, -- номер документа
CS_STATE NUMBER DEFAULT 0 NOT NULL, -- статус документа (0 - черновой, 1 - подтвержденный)
SUB_ID NUMBER NOT NULL, -- ссылка на справочник "Подразделения"
CONSTRAINT PK_CS_ID PRIMARY KEY (CS_ID),
CONSTRAINT FK_CS_to_SUB FOREIGN KEY (SUB_ID) REFERENCES SUBDIVISIONS (SUB_ID),
CONSTRAINT CST_STATE CHECK (CS_STATE IN (0,1))
);
CREATE TABLE CALCULATION_SALARY_LINES ( -- Документ "Начисление зарплаты" табличная часть
CSL_ID NUMBER NOT NULL, -- PK
CS_ID NUMBER NOT NULL, -- ссылка на шапку документа
EMP_ID NUMBER NOT NULL, -- ссылка на справочник "Сотрудник"
CSL_TIME NUMBER NOT NULL, -- количество часов (фактическое)
CSL_CONSIDER NUMBER NOT NULL, -- cумма зарплаты расчетная
CSL_PRIZE NUMBER NOT NULL, -- премия
CSL_CORRECTION NUMBER NOT NULL, -- сумма зарплаты скорректированная
CONSTRAINT PK_CSL_ID PRIMARY KEY (CSL_ID),
CONSTRAINT FK_CSL_to_CS FOREIGN KEY (CS_ID) REFERENCES CALCULATION_SALARY_HEADER (CS_ID),
CONSTRAINT FK_CSL_to_EMP FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEES (EMP_ID)
);
CREATE TABLE CALCULATION_WITH_EMPLOYEES ( -- Куб "Взаиморасчёты с сотрудниками"
CWE_DOC_LINK NUMBER NOT NULL, -- ссылка на документ, создавший запись
CWE_DOC_TYPE VARCHAR2 (16CHAR) NOT NULL, -- тип документа (0-"Начисление зарплаты")
ORG_ID NUMBER NOT NULL, -- ссылка на справочник "Организации"
EMP_ID NUMBER NOT NULL, -- ссылка на справочник "Сотрудники"
CWE_DATE DATE NOT NULL, -- дата изменения
CWE_TYPE NUMBER NOT NULL, -- тип выплаты (0 - простая, 1 - целевые расходы)
CWE_SUM NUMBER NOT NULL, -- Сумма
CONSTRAINT PK_CWE_ID PRIMARY KEY (CWE_DOC_TYPE, CWE_DOC_LINK, ORG_ID, EMP_ID),
CONSTRAINT FK_CWE_to_ORG FOREIGN KEY (ORG_ID) REFERENCES ORGANIZATIONS (ORG_ID),
CONSTRAINT FK_CWE_to_EMP FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEES (EMP_ID),
CONSTRAINT CWE_DOC_TYPE CHECK (CWE_DOC_TYPE IN (0)),
CONSTRAINT CWE_TYPE CHECK (CWE_TYPE IN (0, 1))
);
CREATE TABLE DEVATION_CALCULATION ( -- Куб "Отклонения расчёта"
AE_ID NUMBER NOT NULL, -- ссылка на документ "Отсутствие сотрудника"
EMP_ID NUMBER NOT NULL, -- ссылка на справочник "Сотрудник"
ORG_ID NUMBER NOT NULL, -- ссылка на справочник "Организации"
DC_BEGIN DATE NOT NULL, -- начало периода
DC_END DATE NOT NULL, -- окончание периода
DC_TYPE NUMBER NOT NULL, -- тип отклонения (0 - коэффициент, 1 - сумма)
DC_VALUE NUMBER NOT NULL, -- отклонение
CONSTRAINT PK_DC_ID PRIMARY KEY (AE_ID, EMP_ID, DC_BEGIN, DC_END),
CONSTRAINT FK_DC_to_AE FOREIGN KEY (AE_ID) REFERENCES ABSENCE_EMPLOYEE (AE_ID),
CONSTRAINT FK_DC_to_EMP FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEES (EMP_ID),
CONSTRAINT FK_DC_to_ORG FOREIGN KEY (ORG_ID) REFERENCES ORGANIZATIONS (ORG_ID),
CONSTRAINT DC_TYPE CHECK (DC_TYPE IN (0, 1))
);
