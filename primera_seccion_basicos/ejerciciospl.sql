--haciendo la primeras variables con pl/sql
declare

mi_texto varchar(20);--variable

begin
  
mi_texto := 'hola mundo';-- valor de la variable

dbms_output.put_line(mi_texto); -- para imprimir por pantalla

end;
--///////////////////////
--para imprimir en pantalla hay que utilizar en una nueva hoja de trabajo este comando :

set serveroutput on

----///////////////////////////////////////////////////////////////////

--tipos de variables en pl/sql
declare 

nombre varchar(15)  := 'juan'; --una manera de inicializar una variable
edad number not null := 16; --cuando se coloca not null, no puede estar vacia y se inicializa con valor 
f_nacimiento constant date; -- constant para que no sea variable
acpta_terminos boolean;

begin

--nombre := 'juan'; --otramanera de inicializar una variable
nombre := &nombre;-- & -> este simbolo es para pedir que ingresen el valor de la variable
edad := 25;
f_nacimiento := date '1975-03-10';
acpta_terminos := true;

dbms_output.put_line('Nombre: '|| nombre);
dbms_output.put_line('Edad: '|| edad);
dbms_output.put_line('f_nacimiento: '|| f_nacimiento);

end;

--//////////////////////////////////////////////////////////////////////////


-- primera consulta a una tabla, trayendonos unos datos
declare

v_last_name varchar(15);
v_frits_name varchar(15);
v_salario number;

begin

select e.last_name, e.first_name, e.salary-- podemos hacer mas de una consulta
  into v_frits_name, v_last_name, v_salario--y guardarlas en variables correspondientes 
  from employees e
 where e.employee_id = 100;

 dbms_output.put_line(v_frits_name);
 dbms_output.put_line( v_last_name);
 dbms_output.put_line( v_salario);

end;

--//////////////////////////////////////////////////////////////////////////////

declare
v_salario_max number;

begin

select max(salary)
  into v_salario_max
  from employees;
 
dbms_output.put_line(v_salario_max);

update employees -- funcion para actualizar un dato de una tabla
   set salary = 22500
 where salary = 23500
end;

-- ///////////////////

declare
v_region_id number;
v_country_name varchar(15);

begin
  
  select region_id
    into v_region_id
    from regions
   where region_name = 'Asia';

  v_country_name = 'Korea';

  insert into countries (country_id,country_name,region_id)-- funcion para insertar datos en una tabla
  values ('KR',v_country_name,v_region_id);

end;

--////////////////////////////////////////////////////

declare

v_country_id varchar(15);

begin
  
select country_id
  into v_country_id
  from countries
 where country_name = 'Korea';

delete from countries -- funcion para eliminar un dato de la tabla
 where country_id = v_country_id;

end;

--////////////////////////////////////////////////////////


declare

v_last_name varchar(10);
begin
-- funciones(upper,lower,substr,replace)
  select lower(e.last_name) -- convierte a minuscula
  select upper(e.last_name)-- convierte a mayusculas 
  select substr(e.last_name,2,4)-- toma 2 parametros para tomar esos valores
  select replace(e.last_name,'in','an')-- toma 2 parametros el primero describes un patron y el segundo escribes por que lo va a remplazar 
    into v_last_name
    from employees e
   where employee_id = 100;

dbms_output.put_line(v_last_name);
end;

--/////////////////////////////////////////////

declare

v_fecha date;
v_fecha_2 date;
v_fecha_3 date;
v_diferencia number;
v_fecha_texto varchar(25);
v_fecha_convertida date;
v_fecha_recortada varchar(25);
v_numero_decimal number;
v_truncate number;
v_redondear number;

v_commission varchar(15);

begin
v_fecha := sysdate; -- trae la fecha de cuando se esta escribiendo el query
v_fecha_2 := last_day(v_fecha);-- trae el ultimo dia del mes de la fecha que se le pase
v_fecha_3 := date'2022-04-13';
v_diferencia := months_between(v_fecha,v_fecha_3); --devuelve la diferencia entre dos fechas en meses
v_fecha_texto := '10/12/2000';
v_fecha_convertida := to_date(v_fecha_texto,'dd/mm/yyyy');-- convertir una fecha en string a tipo date
v_fecha_recortada := to_char(v_fecha_convertida,'dd-mm');-- convertir de tipo date a string

v_numero_decimal := 10.202020;
v_truncate := trunc(v_numero_decimal);-- quita los decimales
v_redondear := ROUND(v_numero_decimal); -- redondea al numero mas proximo 



dbms_output.put_line(v_fecha-2);
dbms_output.put_line(v_diferencia);
dbms_output.put_line(v_fecha_texto);
dbms_output.put_line(v_fecha_convertida);
dbms_output.put_line(v_fecha_recortada);
dbms_output.put_line(v_numero_decimal);
dbms_output.put_line(v_truncate);
dbms_output.put_line(v_redondear);


select nvl(e.commission_pct, '0')--[nvl]-> nos permite imprimir algo si el resultado es null  
  into v_commission
  from employees e
 where e.employee_id = 129;

dbms_output.put_line(v_commission);

end;

--////////////////////////////////////////////////////////////////

declare

v_job_id employees.job_id%type;-- por si no sabemos que tipo de dato es el que vamos a traer
-- colocamos %type para evitar el error

begin
  
select e.job_id
  into v_job_id
  from employees e
 where e.employee_id = 134;

dbms_output.put_line(v_job_id);
end;

--/////////////////////////////////////////////////////


declare

v_job jobs%rowtype; -- nos permite declarar una variable que podra contener los datos de una fila entera
--entera de una tabla
v_desc jobs.job_title%type;
v_min_salary jobs.min_salary%type;

begin
  select j.*
    into v_job
    from jobs j
   where j.job_id = 'IT_PROG';

v_desc := v_job.job_title;
v_min_salary := v_job.min_salary;

dbms_output.put_line('Para el trabajo con salario '||v_desc||' el salario minimo es '||v_min_salary);

end;

--/////////////////////////////////////////////////////////////////////////
declare

v_new_job jobs%rowtype;

begin
  v_new_job.job_id := 'DBA';
  v_new_job.job_tilte := 'Database Administrator';
  v_new_job.min_salary := 5000;
  v_new_job.max_salary := 11000;

--insert into jobs -- para registrar en bloque
  --values v_new_job; 

update jobs -- para actualizar en bloque
   set row = v_new_job
 where job_id = 'DBA';

end;

--///////////////////////////////////////////////////////

----EJERCICIOS DEL CURSO-----

          -->>> 1 <<<-- 

--Traer e imprimir el año de estreno más alto.--

declare
año_extreno_mas_alto number;
begin
select max(A�O)
  into año_extreno_mas_alto
  from PELICULA;

dbms_output.put_line('El año de estreno mas alto de esta base de datos es: '||año_extreno_mas_alto);
  
end;

        -->>> 2 <<<--
--Traer la descripción de la película "Coco". Si es nula, reemplazarlo por "-Sin descripción-"--

declare
v_descripcion varchar(20);

begin
select nvl(E.DESCRIPCION,'Sin descripcion')
  into v_descripcion
  from PELICULA E
 where e.titulo = 'Coco';

 dbms_output.put_line(v_descripcion);
end;

         -->>> 3 <<<--
---Armar e imprimir una descripción corta de cualquier película con el siguiente formato:
---(año de estreno) - Primeros 40 caracteres de la descripción...

declare
año_extreno number;
descripcion varchar(40);
titulo_pelicula varchar(15);
begin
select e.A�O, substr(e.DESCRIPCION,1,40), e.titulo
  into año_extreno, descripcion, titulo_pelicula
  from PELICULA e
  where e.IDPELICULA = 4;

  dbms_output.put_line('La pelicula '||titulo_pelicula|| ' se estreno el año '||año_extreno||'. '
  || descripcion);

end;