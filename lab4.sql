INSERT INTO faculty (fac_pk, name, building, fund)
VALUES (1, 'informatics', 5, 573980.00),
       (2, 'economy', 3, 100000),
       (3, 'linguistics', 4, 500000);

INSERT INTO department (dep_pk, fac_fk, name, building, fund)
VALUES (1, 1, 'SE', 5, 99800.00),
       (2, 1, 'CAD', 5, 99000.00),
       (3, 1, 'DBMS', 4, 22000.00),
       (4, 2, 'Accounts', 3, 99000);

INSERT INTO teacher (tch_pk, dep_fk, name, post, tel, hire_date, salary, commission)
VALUES (0, 2, 'Sidorov', 'assistant', '2281319', TO_DATE('01.02.1948', 'dd.MM.yyyy'), 2500, 80),
       (2, 1, 'Perov', 'professor', '2281550', TO_DATE('01.07.1948', 'dd.MM.yyyy'), 1500, 150),
       (3, 2, 'Ivanov', 'assistant', NULL, TO_DATE('17.11.1948', 'dd.MM.yyyy'), 2400, 80),
       (4, 2, 'John', 'assistant', NULL, TO_DATE('11.11.1948', 'dd.MM.yyyy'), 2600, 100),
       (5, 2, 'Popov', 'assistant', NULL, TO_DATE('11.11.1948', 'dd.MM.yyyy'), 2600, 100);

UPDATE faculty
   SET dean_fk = (SELECT tch_pk FROM teacher WHERE name = 'Sidorov')
 WHERE fac_pk = 1;

UPDATE faculty
   SET dean_fk = (SELECT tch_pk FROM teacher WHERE name = 'Perov')
 WHERE fac_pk = 2;

UPDATE faculty
   SET dean_fk = (SELECT tch_pk FROM teacher WHERE name = 'Ivanov')
 WHERE fac_pk = 3;

UPDATE department
   SET head_fk = (SELECT tch_pk FROM teacher WHERE name = 'Sidorov')
 WHERE dep_pk = 1;

UPDATE department
   SET head_fk = (SELECT tch_pk FROM teacher WHERE name = 'Perov')
 WHERE dep_pk = 2;

UPDATE department
   SET head_fk = (SELECT tch_pk FROM teacher WHERE name = 'Popov')
 WHERE dep_pk = 3;


INSERT INTO sgroup (grp_pk, dep_fk, course, num, quantity, curator, rating)
VALUES (1, 1, 1, 101, 33, 4, 20),
       (2, 1, 1, 102, 35, 5, 22),
       (3, 3, 2, 205, 20, 1, 15),
       (4, 3, 3, 305, 25, NULL, 40),
       (5, 3, 4, 405, 25, 2, 37);

INSERT INTO subject (sbj_pk, name)
VALUES (1, 'pascal'),
       (2, 'C'),
       (3, 'OS'),
       (4, 'inernet'),
       (5, 'dbms');

INSERT INTO room (rom_pk, num, seats, floor, building)
VALUES (1, 101, 20, 1, 5),
       (2, 316, 150, 3, 5),
       (3, 201, 150, 2, 2),
       (4, 202, 30, 2, 5);

INSERT INTO lecture (tch_fk, grp_fk, sbj_fk, rom_fk, type, day, week, lesson)
VALUES (1, 1, 1, 1, 'lecture', 'mon', 1, 1),
       (1, 2, 2, 1, 'lab', 'mon', 1, 2),
       (2, 3, 3, 1, 'lecture', 'tue', 1, 3),
       (2, 4, 4, 2, 'practice', 'wed', 1, 5),
       (4, 4, 5, 2, 'practice', 'thu', 2, 4),
       (4, 4, 5, 3, 'lab', 'fri', 2, 1);


INSERT INTO faculty (fac_pk, name, building, fund, dean_fk)
VALUES (99, '126', 1, 102102, NULL);

INSERT INTO department (dep_pk, fac_fk, name, building, fund, head_fk)
VALUES (99, 99, 'ipzas', 1, 20102, NULL);


INSERT INTO teacher (tch_pk, dep_fk, name, post, tel, hire_date, salary, chief_fk)
VALUES (99, 99, 'Ivanov', 'assistant', '2281319', TO_DATE('01.02.1948', 'dd.MM.yyyy'), 1800, 100),
       (100, 99, 'Petrov', 'professor', '2281550', TO_DATE('01.07.1948', 'dd.MM.yyyy'), 1800, NULL),
       (101, 99, 'Sidorov', 'assistant', NULL, TO_DATE('17.11.1948', 'dd.MM.yyyy'), 1800, 100),
       (102, 99, 'Perov', 'assistant', NULL, TO_DATE('11.11.1948', 'dd.MM.yyyy'), 1800, 100);
--     ...

UPDATE faculty
   SET dean_fk = 100
 WHERE fac_pk = 99;

UPDATE department
   SET head_fk = 100
 WHERE dep_pk = 99;

INSERT INTO sgroup (grp_pk, dep_fk, course, num, quantity, curator)
VALUES (99, 99, 2, 23, 27, NULL);

INSERT INTO subject (sbj_pk, name)
VALUES (99, 'kmi');

INSERT INTO lecture (tch_fk, grp_fk, sbj_fk, rom_fk, type, day, week, lesson)
VALUES (99, 99, 99, 1, 'lecture', 'mon', 1, 1);

UPDATE faculty
   SET dean_fk = (SELECT tch_pk FROM teacher WHERE name = 'Bob'),
       fund = 3467.00
 WHERE name = 'economy';

UPDATE department
   SET head_fk = (SELECT tch_pk FROM teacher WHERE name = 'Frank'),
       building = 3
 WHERE dep_pk = 3;

UPDATE teacher
   SET commission = 25
 WHERE post = 'assistant';

UPDATE sgroup
   SET rating = 0
 WHERE course = 1;

UPDATE subject
   SET name = 'html'
 WHERE name = 'internet';
 
 SELECT post || ' ' || name || ' був прийнятий на роботу ' || hire_date || ' і має зарплату ' || (salary + commission) AS "Інформація про викладачів"
FROM teacher;
 
 SELECT post as посада,name as викладач, hire_date as дата ,
 sum(salary+commission) as зарплата 
 FROM TEACHER 
 GROUP BY post, name, hire_date;

SELECT DISTINCT t.name
FROM teacher t
JOIN lecture l ON t.tch_pk = l.tch_fk
JOIN sgroup g ON l.grp_fk = g.grp_pk
JOIN department d ON g.dep_fk = d.dep_pk
JOIN faculty f ON d.fac_fk = f.fac_pk
WHERE t.post = 'docent' AND f.name = 'informatics' AND l.type = 'lecture';

SELECT f.name
FROM faculty f
JOIN department d ON f.fac_pk = d.fac_fk
JOIN sgroup g ON d.dep_pk = g.dep_fk
JOIN teacher t ON g.curator = t.tch_pk
JOIN department d_curator ON t.dep_fk = d_curator.dep_pk
JOIN faculty f_curator ON d_curator.fac_fk = f_curator.fac_pk
WHERE f_curator.name = 'informatics';

SELECT DISTINCT f.name
FROM faculty f
JOIN department d ON f.fac_pk = d.fac_fk
JOIN teacher t ON d.dep_pk = t.dep_fk
JOIN lecture l ON t.tch_pk = l.tch_fk
WHERE t.post = 'professor' AND l.lesson BETWEEN 2 AND 6;

SELECT DISTINCT t.name
FROM teacher t
JOIN lecture l ON t.tch_pk = l.tch_fk
JOIN room r ON l.rom_fk = r.rom_pk
WHERE t.post = 'professor' AND l.type = 'lecture' AND r.building = 6 AND r.num IN (309, 311, 313, 315, 327);

SELECT g1.num, g2.num
FROM sgroup g1
JOIN faculty f1 ON g1.dep_fk = f1.dean_fk
JOIN sgroup g2 ON g1.course = g2.course AND g1.num <> g2.num
JOIN faculty f2 ON g2.dep_fk = f2.dean_fk
WHERE f1.fac_pk = g1.fac_fk AND f2.fac_pk = g2.fac_fk AND (f1.salary + f1.commission) > (f2.salary + f2.commission);

SELECT t.name, t.hire_date
FROM teacher t
JOIN department d ON t.dep_fk = d.dep_pk
JOIN teacher t_head ON d.head_fk = t_head.tch_pk
JOIN faculty f ON d.fac_fk = f.fac_pk
JOIN teacher t_dean ON f.dean_fk = t_dean.tch_pk
WHERE (t.salary + t.commission) > 1000 OR t.hire_date > TO_DATE('01.01.2001', 'dd.MM.yyyy')
    AND ((t_head.salary + t_head.commission) > 3000 OR (t_head.salary + t_head.commission) < 2500)
    AND (t_dean.post = 'professor' OR t_dean.post = 'docent');
