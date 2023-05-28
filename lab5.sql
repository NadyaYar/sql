 SELECT COUNT(*) AS "К-ть груп", SUM(quantity) AS "К-ть студентів"
FROM sgroup
WHERE course = 3;

SELECT 'Інфо про факт компютерних наук:' AS "Що виводиться?",
       COUNT(*) AS "Кількість викладачів",
       COUNT(DISTINCT sbj_fk) AS "Кількість дисциплін",
       COUNT(DISTINCT grp_fk) AS "Кількість груп",
       COUNT(DISTINCT rom_fk) AS "Кількість аудиторій"
FROM teacher
WHERE dep_fk IN (SELECT dep_pk FROM department WHERE fac_fk = (SELECT fac_pk FROM faculty WHERE name = 'компютерні науки'))
  AND post IN ('професор', 'доцент', 'асистент');
  
  SELECT DISTINCT post
FROM teacher
WHERE chief_fk = (SELECT tch_pk FROM teacher WHERE name = 'Іванов');

SELECT g.num AS "Номер групи",
       g.course AS "Курс",
       g.rating AS "Рейтинг",
       s.name AS "Дисципліна",
       COUNT(l.lesson) AS "Кількість лекцій",
       COUNT(DISTINCT l.tch_fk) AS "Кількість викладачів",
       COUNT(DISTINCT l.rom_fk) AS "Кількість аудиторій"
FROM sgroup g
JOIN subject s ON g.dep_fk = s.dep_fk
JOIN lecture l ON g.grp_pk = l.grp_fk AND s.sbj_pk = l.sbj_fk
WHERE g.rating IN (10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 30, 45, 55, 56, 57, 58, 59, 60, NULL)
GROUP BY g.grp_pk, g.num, g.course, g.rating, s.name;

SELECT TO_CHAR(hire_date, 'Month') AS "Місяць",
       COUNT(*) AS "К-ть викладачів",
       AVG(salary + COALESCE(commission, 0)) AS "Середн. Зарплата за роботу цього місяця",
       MAX(salary + COALESCE(commission, 0)) - MIN(salary + COALESCE(commission, 0)) AS "МАКС(зарп.)-МІН(зарп.) викладачів, прийнятих на роботу цього місяця"
FROM teacher
WHERE salary + COALESCE(commission, 0) BETWEEN 0 AND 3000
GROUP BY TO_CHAR(hire_date, 'Month');

SELECT s.name AS "Назва дисципліни",
       COUNT(DISTINCT g.grp_pk) AS "Кількість груп",
       COUNT(DISTINCT l.tch_fk) AS "Кількість викладачів"
FROM department d
JOIN sgroup g ON d.dep_pk = g.dep_fk
JOIN subject s ON g.dep_fk = s.dep_fk
JOIN lecture l ON g.grp_pk = l.grp_fk AND s.sbj_pk = l.sbj_fk
WHERE d.head_fk = (SELECT tch_pk FROM teacher WHERE name = 'Іванов')
  AND COUNT(DISTINCT l.rom_fk) <= 4
  AND COUNT(l.lesson) <= 5
GROUP BY s.name;

SELECT name AS "Імя викладача", hire_date AS "Дата надходження на роботу"
FROM teacher
WHERE dep_fk = (SELECT dep_pk FROM department WHERE name = 'ІПО')
ORDER BY hire_date DESC;