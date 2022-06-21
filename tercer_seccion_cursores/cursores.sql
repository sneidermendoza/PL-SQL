--------------- cursores: implicito/explicito --------------

   -->> IMPLICITO <<--

-- SQL%FOUND: ATRIBUTO BOOLEANO, DEVUELVE 'TRUE' 
--SI LA  SENTENCIA DML MAS RECIENTE DEVOLVIO (SELECT) O AFECTÓ (INSERT, UPDATE, DELETE)
--ALMENOS UNA FILA


--SQL%NOTFOUND: ATRIBUTO BOOLEANO, DEVUELVE 'TRUE'
--SI LA SENTENCIA DML MAS RECIENTE NO AFECTO (INSERT,UPDATE,DELETE)
--AL MENOS UNA FILA. EN CASO DE SELECT SE GENERA UNA EXEPCION


--SQL%ROWCOUNT: ATRIBUTO NUMERICO, DEVUELVE EL NUMERO DE FILADEVUELTO (SELECT)
--O AFECTO (INSERT,UPDATE,DELETE) POR LA ULTIMASENTENCIA

declare
v_cantidad number;
v_afecto boolean;
v_afecto_txt varchar(25);
v_salario employees.salary%type;
begin

update EMPLOYEES E
   set E.SALARY = E.SALARY *1.5
 where E.DEPARTMENT_ID = 9990;

v_cantidad := sql%ROWCOUNT--<<--
v_afecto := sql%FOUND;--<<--

case v_afecto
  when true  then v_afecto_txt := 'Si';
  when false  then v_afecto_txt := 'No';
end case;

dbms_output.put_line('se afectaron fila? : '||v_afecto_txt);
dbms_output.put_line('cantidad de fila afectadas: '||v_cantidad);

select E.SALARY
into v_salario
from EMPLOYEES E
where E.EMPLOYEE_ID = 201;

v_cantidad := sql%ROWCOUNT;--<<--
v_afecto := sql%FOUND;--<<--

case v_afecto
  when true  then v_afecto_txt := 'Si';
  when false  then v_afecto_txt := 'No';
end case;

dbms_output.put_line('se encontraron filas? : '||v_afecto_txt);
dbms_output.put_line('cantidad de fila encontradas: '||v_cantidad);
dbms_output.put_line('SALARIO: ' ||v_cantidad);
end;

--////////////////////////////////////////////////////////////////////////////--

       -->> IMPLICITO <<--

-- A diferencia de los implicitos, los cursores explicitos no son creados
-- automaticamente por oracle, si no que los define explicitamenete el programador

-- Nos permite tener mas control sobre el 'context area'

-- Se utilizan cuando nececitamos recuperar varias filas de una tabla
-- de la base de datos, y en este caso, los cursores nos permiten apuntar a cada 
-- una de las filas que se recuperaron e irlas trabajando de una en una

-- los paso para la creacion y manipulacion de un cursor explicito son los siguienetes:
-- * Declaracion: se debe declarar el cursor en el declare, alli definimos la estructura
--   de la consulta asociada a el cursor.

-- * apertura: Se realiza mediante la sentencia open. en este momento se ejecuta la consulta,
-- las filas retornadas por la consulta se denominan "JUEGOS ACTIVOS" y ya pueden ser consultadas

-- * Se realiza la recuperacion de las filas del cursor mediante la sentencia "FETCH",
--   las cuales las recupera de una en una 

-- * Despues de cada recuperacion, el cursor avanza hacia la siguiente
--   del juego activo, la cual podra ser recuperada en una siguiente  "FETCH"

-- *  Utilizando el atributo "%NOTFOUND" podemos saber si quedan filas por recuperar


declare
cursor empleados is select e.first_name, e.last_name,e.hire_date
  from employees e
 where e.hire_date between date'2002-01-01' and date'2002-12-31';

v_nombre varchar(25);
v_apellido varchar(25);
v_contratacion date;

begin
  open empleados;
  loop
    FETCH empleados into v_nombre,v_apellido,v_contratacion;
    exit when empleados%notfound;

    dbms_output.put_line('Nombre: ' ||v_nombre||': Apellido: ' ||v_apellido||': Fecha de contratacion: ' ||v_contratacion);


  end loop;

  close empleados;
end;

--////////////////////////////////////////////////////////////////////////////--

--manera mas facil de hacerlo con el ciclo for

declare

cursor empleados is select e.first_name, e.last_name,e.hire_date
  from employees e
 where e.hire_date between date'2002-01-01' and date'2002-12-31';

begin
  for registro in empleados  loop

dbms_output.put_line('Nombre: ->' ||registro.first_name||
'.  Apellido: ->' ||registro.last_name||'.  Fecha de contratacion: ->' ||registro.hire_date);
    
    end loop;
end;

--////////////////////////////////////////////////////////////////////////////--

--- parametros en los cursores---------
declare

cursor empleados (p_desde date, p_hasta date) is 
select e.first_name, e.last_name,e.hire_date
  from employees e
 where e.hire_date between date'2002-01-01' and date'2002-12-31';

v_desde date;
v_hasta date;

begin
  v_desde := date'2003-01-01';
  select max(hire_date)
    into v_hasta
    from employees
   where department_id = 100;

   for registro in empleados(v_desde,v_hasta)  loop

dbms_output.put_line('Nombre: ->' ||registro.first_name||
'.  Apellido: ->' ||registro.last_name||'.  Fecha de contratacion: ->' ||registro.hire_date);
    
    end loop;
end;


--////////////////////////////////////////////////////////////////////////////--

--<< clausula for update >>--

declare

cursor empleados is
select e.*
  from EMPLOYEES e
 where e.COMMISSION_PCT is null and e.HIRE_DATE <= date'2005-12-31'
 for update;

v_porcentage_comision number;

begin
  
for emp in empleados  loop
  v_porcentage_comision := 0

  if emp.SALARY between 1000 and 5000 
    then v_porcentage_comision := 0.1;
  elsif emp.SALARY  between 5001 and 10000 
    then v_porcentage_comision := 0.2;
  elsif emp.SALARY > 10001
    then v_porcentage_comision := 0.3;  
  end if;

dbms_output.put_line('Emplead: '||emp.last_name||' '||emp.first_name||
'. con ID: '||emp.employee_id||' califica para recibir un porcentaje de comision:');

dbms_output.put_line('Porcentage asignado: '||v_porcentage_comision||'%');

update EMPLOYEES
   set COMMISSION_PCT = v_porcentage_comision
 where current of empleados;

end loop;
end;


--////////////////////////////////////////////////////////////////////////////--

       ----EJERCICIOS DEL CURSO-----

               -->>> 1 <<<--



--** Obtener e imprimir todas las opiniones para la película con ID 5. **--

declare
c_idpelicula number := 5;
cursor opiniones is
select e.idpelicula,e.opinion
  from OPINION e
 where e.IDPELICULA = c_idpelicula;

v_opinion varchar(50);


begin
loop
  FETCH opiniones into v_opinion,c_idpelicula;
  exit when opiniones%notfound;

dbms_output.put_line('Pelicula con ID: '||c_idpelicula||' tuvo estas opiniones -> '||v_opinion );
end loop;  

end;


--otra manera es:
declare

cursor opiniones is 
select e.*, o.titulo
  from opinion e, pelicula o
 where e.idpelicula = 5 and e.idpelicula = o.idpelicula; 

begin
  for opin in opiniones  loop
    dbms_output.put_line('ID: '||opin.idpelicula||'. Pelicula -> '||opin.titulo||
    '. Su opiniones fueron: '||opin.opinion);
  end loop;

end;


 --////////////////////////////////////////////////////////////////////////////--

                    -->>> 2 <<<--

-- Obtener e imprimir todas las opiniones de un usuario
-- (enviar id de usuario por parámetro al cursor),
-- imprimiendo primero el nombre de la película en mayúsculas y luego la opinión.

declare

cursor opiniones(v_id number) is
select u.apodo, o.*, p.titulo
  from usuario u, opinion o, pelicula p
 where o.idusuario = v_id and o.idusuario = u.idusuario and o.idpelicula = p.idpelicula ;

v_id number := &id;
v_nombre varchar(20);
v_opinion varchar(20);

begin

for obt in opiniones(v_id)  loop
  dbms_output.put_line('Pelicula-> '||upper(obt.titulo||' Opinion: '||obt.opinion||
  ' ID: '||v_id||' Nombre: '||obt.apodo));
end loop;  
end;

--////////////////////////////////////////////////////////////////////////////--

                      -->>> 3 <<<--

-- Cambiar todos los textos de opiniones para la película con ID 4.
-- Modificar concatenando el nombre del usuario delante del texto.
-- Ej: "Juan: Aquí iría la opinión del usuario".
-- Imprimir cuantas filas fueron afectadas utilizando cursor implícito.  


declare

cursor opiniones is
select o.*, u.apodo, p.titulo
  from OPINION o, USUARIO u, PELICULA p
 where o.idpelicula = 4 and o.idusuario = u.idusuario and p.idpelicula = o.idpelicula
 for update;

nueva_opinion varchar(50);
begin
  
for op in opiniones  loop
  nueva_opinion := 'Me encanto, volveria a repeti mil veces';


update OPINION
   set opinion = nueva_opinion
 where idopinion = op.idopinion;
 
dbms_output.put_line('Usuario: '||op.apodo||' Nueva opinion -> '||nueva_opinion||
' ID Pelicula: '||op.idpelicula||' Nombre de pelicula: '||op.titulo);

end loop;

 commit;
end;