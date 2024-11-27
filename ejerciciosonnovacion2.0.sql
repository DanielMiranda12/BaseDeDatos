select * from bdonnovacion.bank;
select * from bdonnovacion.city where namecit like '%Ocaña%';
select * from bdonnovacion.country;
select * from bdonnovacion.departament;
select * from bdonnovacion.management;
select * from bdonnovacion.proyect;
select * from bdonnovacion.responsible;
select * from bdonnovacion.staff;
select * from bdonnovacion.staff_task;
select * from bdonnovacion.task;

insert into bdonnovacion.city(cit_id,namecit,dpt_id)
values ('20505', 'Ocaña', '54');

--Lista de tareas asignadas a cada responsable con inner join 
SELECT r.Name1 AS Responsable_Nombre,t.Nametask AS Tarea_Nombre,t.Descripcion AS Tarea_Descripcion
FROM bdonnovacion.Responsible r INNER JOIN bdonnovacion.proyect p 
ON (r.code = p.code)
INNER JOIN bdonnovacion.Staff_Task st 
ON (p.proyect_id = st.proyect_id)
INNER JOIN bdonnovacion.Task t
ON (st.task_id = t.task_id);

--Relación entre Responsible y Staff_Task:
SELECT r.Name1 AS Responsable_Nombre,t.Nametask AS Tarea_Nombre,t.Descripcion AS Tarea_Descripcion
FROM bdonnovacion.Responsible r INNER JOIN bdonnovacion.Proyect p
ON (r.Code = p.Code)  -- Relacionamos Responsible con Proyect
INNER JOIN bdonnovacion.Staff_Task st
ON (p.Proyect_ID = st.Proyect_ID)  -- Relacionamos Proyect con Staff_Task
INNER JOIN bdonnovacion.Task t
ON (st.Task_ID = t.Task_ID);  -- Relacionamos Staff_Task con Task


--Relación entre Staff_Task y Task
SELECT st.staff_id, t.Nametask, t.Descripcion 
FROM bdonnovacion.Staff_Task st 
INNER JOIN bdonnovacion.Task t 
ON st.task_id = t.task_id;


--Ver responsables sin tareas asignadas:
SELECT r.code, r.Name1
FROM bdonnovacion.Responsible r
LEFT JOIN bdonnovacion.Staff_Task st
ON r.code = st.staff_id
WHERE st.staff_id IS NULL;

--Ver tareas sin equipo asignados:
SELECT st.staff_id, st.task_id
FROM bdonnovacion.Staff_Task st
LEFT JOIN bdonnovacion.Responsible r
ON st.staff_id = r.code
WHERE r.code IS NULL;

-- proyectos que se trabajaron en el departamento de Cundinamarca
SELECT p.proyect_id,p.descripcion,c.namecit AS ciudad
FROM bdonnovacion.proyect p
inner JOIN bdonnovacion.bank b
ON p.bank_id = b.bank_id
JOIN bdonnovacion.city c
ON b.cit_id = c.cit_id 
join bdonnovacion.departament d
on c.dpt_id = d.dpt_id
WHERE d.namedpto = 'Cundinamarca';

--saber qué proyectos se están trabajando en cada departamento
SELECT d.Namedpto AS Departamento, p.proyect_id AS Proyecto, p.Descripcion AS Descripcion_Proyecto
FROM bdonnovacion.Departament d INNER JOIN bdonnovacion.City c 
ON d.dpt_ID = c.dpt_ID
INNER JOIN bdonnovacion.Bank b 
ON c.cit_ID = b.cit_ID
INNER JOIN bdonnovacion.Proyect p 
ON b.Bank_ID = p.Bank_ID;

--¿Cuántos proyectos se están trabajando en cada departamento?
select count(p.proyect_id) as total_proyectos,d.namedpto
from bdonnovacion.proyect p inner join bdonnovacion.bank b
on (p.bank_id = b.bank_id)
inner join bdonnovacion.city c
on (b.cit_id = c.cit_id) 
inner join bdonnovacion.departament d
on (c.dpt_id = d.dpt_id)
group by d.namedpto
order by total_proyectos desc;

--Promedio de duración de proyectos 
SELECT p.proyect_id AS Proyecto, p.Descripcion AS Descripcion_Proyecto, ROUND(AVG(st.EndDate - st.StartDate), 2) AS Promedio_Duracion_Tareas
FROM bdonnovacion.Proyect p INNER JOIN bdonnovacion.Staff_Task st 
ON p.Proyect_ID = st.Proyect_ID
GROUP BY p.proyect_id, p.Descripcion
ORDER BY Promedio_Duracion_Tareas DESC;

-- Cantidad de tareas por proyecto
SELECT p.Proyect_ID AS Proyecto, COUNT(st.Task_ID) AS Total_Tareas
FROM bdonnovacion.Proyect p INNER JOIN bdonnovacion.Staff_Task st 
ON p.Proyect_ID = st.Proyect_ID
GROUP BY p.Proyect_ID
ORDER BY Total_Tareas DESC;

--Responsable con más tareas asignadas
SELECT r.Name1 AS Responsable, COUNT(st.Task_ID) AS Total_Tareas
FROM bdonnovacion.Responsible r INNER JOIN bdonnovacion.Proyect p 
ON r.Code = p.Code
INNER JOIN bdonnovacion.Staff_Task st 
ON p.Proyect_ID = st.Proyect_ID
GROUP BY r.Name1
ORDER BY Total_Tareas DESC;

--Porcentaje de proyectos por departamento
SELECT d.Namedpto AS Departamento, round(COUNT(p.Proyect_ID) * 100.0 / (SELECT COUNT(*) FROM bdonnovacion.Proyect),1) AS Porcentaje_Proyectos
FROM bdonnovacion.Departament d INNER JOIN bdonnovacion.City c 
ON d.dpt_ID = c.dpt_ID
INNER JOIN bdonnovacion.Bank b 
ON c.cit_ID = b.cit_ID
INNER JOIN bdonnovacion.Proyect p 
ON b.Bank_ID = p.Bank_ID
GROUP BY d.Namedpto
ORDER BY Porcentaje_Proyectos desc;

--suma de proyectos
select count(p.proyect_id) as suma_proyectos 
from bdonnovacion.proyect p;

--Fecha más reciente de inicio de proyecto por responsable
SELECT concat(r.Name1,' ',r.lastname1) AS Responsable, MAX(p.StartDate) AS Fecha_Reciente_Inicio
FROM bdonnovacion.Responsible r INNER JOIN bdonnovacion.Proyect p 
ON r.Code = p.Code
GROUP BY r.Name1,r.lastname1
ORDER BY Fecha_Reciente_Inicio DESC;

--Cantidad de bancos en cada departamento
select count(b.bank_id) as total_bancos,d.namedpto
from bdonnovacion.bank b inner join bdonnovacion.city c
on (b.cit_id = c.cit_id)
inner join bdonnovacion.departament d
on (c.dpt_id = d.dpt_id)
group by d.namedpto
order by 1 desc;

--Duración total de las tareas por proyecto
SELECT p.Proyect_ID AS Proyecto, SUM(st.Enddate - st.StartDate) AS Duracion_Total_Tareas
FROM bdonnovacion.Proyect p INNER JOIN bdonnovacion.Staff_Task st 
ON p.Proyect_ID = st.Proyect_ID
GROUP BY p.Proyect_ID
ORDER BY Duracion_Total_Tareas DESC;

--Listar los responsables y su 
--ubicación que no han participado en ningún proyecto entre junio y septiembre
select r.Name1 AS Responsable, r.Locationr AS Ubicacion
from bdonnovacion.responsible r left join bdonnovacion.proyect p
on (r.code = p.code)
where p.startdate is null 
or p.startdate not between '2024-06-01' and '2024-09-30';

select * from bdonnovacion.proyect;

--Listar las tareas completadas (que tienen fecha de finalización), 
--junto con el responsable asignado y el departamento donde trabajó
SELECT t.Nametask AS Tarea, r.Name1 AS Responsable, d.Namedpto AS Departamento, st.EndDate AS Fecha_Finalizacion
FROM bdonnovacion.Task t INNER JOIN bdonnovacion.Staff_Task st 
ON t.Task_ID = st.Task_ID
INNER JOIN bdonnovacion.Proyect p 
ON st.Proyect_ID = p.Proyect_ID
INNER JOIN bdonnovacion.Responsible r 
ON p.Code = r.Code
INNER JOIN bdonnovacion.Bank b 
ON p.Bank_ID = b.Bank_ID
INNER JOIN bdonnovacion.City c 
ON b.Cit_ID = c.Cit_ID
INNER JOIN bdonnovacion.Departament d 
ON c.dpt_ID = d.Dpt_ID
WHERE 
    st.EndDate IS NOT NULL
ORDER BY 
    st.EndDate DESC;

--Listar los bancos y sus ciudades que han financiado más de 5 proyectos Consulta:
SELECT b.Namebank AS Banco, c.Namecit AS Ciudad, COUNT(p.Proyect_ID) AS Numero_Proyectos
FROM bdonnovacion.Bank b INNER JOIN bdonnovacion.City c 
ON b.Cit_ID = c.Cit_ID
INNER JOIN bdonnovacion.Proyect p 
ON b.Bank_ID = p.Bank_ID
GROUP BY b.Namebank, c.Namecit
HAVING COUNT(p.Proyect_ID) > 5
ORDER BY Numero_Proyectos DESC;



