CREATE TABLE department
(
    dep_no   INTEGER,
    fac_no   INTEGER,
    name     VARCHAR(50),
    head     VARCHAR(50),
    building NUMERIC(2),
    fund     NUMERIC(7, 2)
);

CREATE TABLE teacher
(
    tch_no   INTEGER,
    dep_no   INTEGER,
    name     VARCHAR(50),
    post     VARCHAR(30),
    tel      CHAR(7),
    hiredate DATE
);

CREATE TABLE sgroup
(
    grp_no   INTEGER,
    dep_no   INTEGER,
    course   CHAR(1),
    num      CHAR(3),
    quantity NUMERIC(2),
    curator  INTEGER
);

CREATE TABLE subject
(
    sbj_no INTEGER,
    name   VARCHAR(50)
);

CREATE TABLE room
(
    room_no INTEGER,
    num     NUMERIC(4),
    seats   NUMERIC(3)
);

CREATE TABLE lecture
(
    tch_no  INTEGER,
    grp_no  INTEGER,
    sbj_no  INTEGER,
    room_no INTEGER,
    type    VARCHAR(25),
    day     CHAR(10),
    week    NUMERIC(1)

);

ALTER TABLE faculty
    ALTER COLUMN name TYPE VARCHAR(50);

ALTER TABLE faculty
    RENAME COLUMN chief TO dean;

ALTER TABLE faculty
    ADD fund NUMERIC(7, 2);



ALTER TABLE department
    ALTER COLUMN building TYPE CHAR(5);



ALTER TABLE teacher
    ADD salary NUMERIC(6, 2);

ALTER TABLE teacher
    ADD commission NUMERIC(6, 2);



ALTER TABLE sgroup
    ALTER COLUMN course TYPE NUMERIC(1);

ALTER TABLE sgroup
    ALTER COLUMN num TYPE NUMERIC(3);

ALTER TABLE sgroup
    ADD rating INT;



ALTER TABLE room
    ADD floor INT;

ALTER TABLE room
    ADD building CHAR(5);



ALTER TABLE lecture
    ADD lesson NUMERIC(1);


-- 3.3


DROP TABLE faculty;
DROP TABLE department;
DROP TABLE teacher;
DROP TABLE sgroup;
DROP TABLE subject;
DROP TABLE room;
DROP TABLE lecture;


-- 3.4

CREATE TABLE room
(
    rom_pk   INT PRIMARY KEY,
    num      NUMERIC(4) NOT NULL,
    seats    NUMERIC(3)          CHECK (seats BETWEEN 1 AND 300),
    floor    NUMERIC(2)          CHECK (floor BETWEEN 1 AND 16),
    building CHAR(5)    NOT NULL CHECK (building IN ('1', '2', '3', '4', '5', '6', '7', '8', '9', '10')),

    UNIQUE (num, building)
);

CREATE TABLE subject
(
    sbj_pk INT PRIMARY KEY,
    name   VARCHAR(50) NOT NULL
);

CREATE TABLE faculty
(
    fac_pk   INT PRIMARY KEY,
    name     VARCHAR(50) NOT NULL UNIQUE,
--     dean_fk  INT                          REFERENCES teacher (tch_pk) ON DELETE SET NULL,
    building CHAR(5)                      CHECK (building IN ('1', '2', '3', '4', '5', '6', '7', '8', '9', '10')),
    fund     NUMERIC(9, 2)                CHECK (fund >= 100000)
);

CREATE TABLE department
(
    dep_pk   INT PRIMARY KEY,
    fac_fk   INT                   REFERENCES faculty (fac_pk) ON DELETE RESTRICT,
    name     VARCHAR(50) NOT NULL,
--     head_fk  INT                   REFERENCES teacher (tch_pk) ON DELETE SET NULL,
    building CHAR(5)               CHECK (building IN ('1', '2', '3', '4', '5', '6', '7', '8', '9', '10')),
    fund     NUMERIC(8, 2)         CHECK (fund BETWEEN 20000.00 AND 100000.00),
    UNIQUE (fac_fk, name)
);

CREATE TABLE teacher
(
    tch_pk     INT PRIMARY KEY,
    dep_fk     INT                              REFERENCES department (dep_pk) ON DELETE SET NULL,
    name       VARCHAR(50)   NOT NULL,
    post       VARCHAR(20)                      CHECK (post IN ('assistant', 'counselor', 'assistant professor', 'professor')),
    tel        CHAR(7),
    hire_date  DATE          NOT NULL           CHECK (hire_date < '1950-01-01'),
    salary     NUMERIC(6, 2) NOT NULL           CHECK (salary > 1000),
    commission NUMERIC(6, 2)          DEFAULT 0 CHECK (commission >= 0),
    chief_fk   INT                              REFERENCES teacher (tch_pk) ON DELETE SET NULL,

    CHECK (salary - commission >= 1000),
    CHECK (salary + commission BETWEEN 1000 AND 3000),
    CHECK (chief_fk <> tch_pk)
);

CREATE TABLE sgroup
(
    grp_pk   INT PRIMARY KEY,
    dep_fk   INT        REFERENCES department (dep_pk) ON DELETE SET NULL,
    course   NUMERIC(1) CHECK (course BETWEEN 1 AND 6),
    num      NUMERIC(3) CHECK (num BETWEEN 0 AND 700),
    quantity NUMERIC(2) CHECK (quantity BETWEEN 1 AND 50),
    curator  INT        REFERENCES teacher (tch_pk) ON DELETE SET NULL,
    rating   NUMERIC(3) CHECK (rating BETWEEN 0 AND 100) DEFAULT 0,

    UNIQUE (dep_fk, num),
    UNIQUE (dep_fk, curator)
);

CREATE TABLE lecture
(
    tch_fk INT                  REFERENCES teacher (tch_pk) ON DELETE SET NULL,
    grp_fk INT                  REFERENCES sgroup (grp_pk) ON DELETE CASCADE,
    sbj_fk INT                  REFERENCES subject (sbj_pk) ON DELETE RESTRICT,
    rom_fk INT                  REFERENCES room (rom_pk) ON DELETE SET NULL,
    type   VARCHAR(25) NOT NULL CHECK (type IN ('lecture', 'lab', 'seminar', 'practice')),
    day    CHAR(3)     NOT NULL CHECK (day IN ('sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat')),
    week   NUMERIC(1)  NOT NULL CHECK (week BETWEEN 1 AND 2),
    lesson NUMERIC(1)  NOT NULL CHECK (lesson BETWEEN 1 AND 8),

    UNIQUE (grp_fk, day, week, lesson),
    UNIQUE (tch_fk, day, week, lesson)
);


ALTER TABLE faculty
    ADD dean_fk INT REFERENCES teacher (tch_pk) ON DELETE SET NULL;

ALTER TABLE department
    ADD head_fk INT REFERENCES teacher (tch_pk) ON DELETE SET NULL;