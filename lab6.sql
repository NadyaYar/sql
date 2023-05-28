SELECT sg.num, sg.course
FROM sgroup sg
JOIN subject s ON sg.sbj_fk = s.sbj_pk
WHERE s.name = 'DBMS'
AND sg.rating IN (
  SELECT sg.rating
  FROM sgroup sg
  JOIN department d ON sg.dep_fk = d.dep_pk
  JOIN faculty f ON d.fac_fk = f.fac_pk
  WHERE f.name IN ('IPAS', 'KIT')
)

SELECT t.name
FROM teacher t
JOIN department d ON t.dep_fk = d.dep_pk
WHERE d.head_fk = (
  SELECT tch_pk
  FROM teacher
  WHERE name = 'Ivanov'
)
AND t.post = 'associate professor'
AND (
  SELECT COUNT(*)
  FROM lecture l
  WHERE l.tch_fk = t.tch_pk
  AND l.week = 1
) < 4

SELECT d.name
FROM department d
JOIN faculty f ON d.fac_fk = f.fac_pk
WHERE f.dean_fk = (
  SELECT tch_pk
  FROM teacher
  WHERE name = 'Ivanov'
)
AND EXISTS (
  SELECT *
  FROM teacher t
  WHERE t.dep_fk = d.dep_pk
  AND t.post = 'associate professor'
  AND t.salary + COALESCE(t.commission, 0) BETWEEN 1000 AND 12000
)

SELECT d.name
FROM department d
JOIN faculty f ON d.fac_fk = f.fac_pk
WHERE f.name = 'Computer Science'
AND d.building IN (
  SELECT DISTINCT r.building
  FROM lecture l
  JOIN room r ON l.rom_fk = r.rom_pk
  JOIN teacher t ON l.tch_fk = t.tch_pk
  JOIN department d2 ON t.dep_fk = d2.dep_pk
  WHERE d2.name = 'IPAS'
)

SELECT t.name
FROM teacher t
JOIN lecture l1 ON t.tch_pk = l1.tch_fk AND l1.type = 'lecture'
JOIN (
  SELECT COUNT(DISTINCT l2.grp_fk) AS num_groups
  FROM lecture l2
  JOIN teacher t2 ON l2.tch_fk = t2.tch_pk AND t2.dep_fk = (
    SELECT dep_pk
    FROM department
    WHERE name = 'IPAS'
  )
  WHERE l2.type = 'lab'
) subquery ON subquery.num_groups = (
  SELECT COUNT(DISTINCT l3.grp_fk)
  FROM lecture l3
  WHERE l3.tch_fk = t.tch_pk AND l3.type = 'lecture'
)
WHERE t.salary + COALESCE(t.commission, 0) BETWEEN 1000 AND 3000

SELECT
  (SELECT SUM(fund) FROM faculty) AS total_faculty_funding,
  (SELECT SUM(fund) FROM department) AS total_department_funding,
  (SELECT SUM(salary + COALESCE(commission, 0)) FROM teacher) AS total_teacher_salary

SELECT
  d.name AS department_name,
  COUNT(DISTINCT l1.lesson) AS num_lectures,
  COUNT(DISTINCT l1.grp_fk) AS num_groups
FROM department d
JOIN teacher t ON d.dep_pk = t.dep_fk
JOIN lecture l1 ON t.tch_pk = l1.tch_fk AND l1.sbj_fk = (
  SELECT sbj_pk
  FROM subject
  WHERE name = 'DBMS'
)
WHERE (
  SELECT COUNT(DISTINCT t2.tch_pk)
  FROM teacher t2
  JOIN lecture l2 ON t2.tch_pk = l2.tch_fk AND l2.sbj_fk = (
    SELECT sbj_pk
    FROM subject
    WHERE name = 'DBMS'
  )
  WHERE t2.dep_fk = d.dep_pk
) <= 2
GROUP BY d.name