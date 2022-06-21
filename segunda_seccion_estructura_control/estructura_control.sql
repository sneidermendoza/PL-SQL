--->>>>>>> IF / ELSE <<<<<----

declare
v_edad number;
begin
v_edad := 25;
if v_edad > 18 then 
    dbms_output.put_line('Eres mayor de edad');
else
    dbms_output.put_line('Eres menor de edad');
end if;
end;

--////////////////////////////////////////////////////////////////////////////--

declare
v_salary number;
begin
select e.salary
  into v_salary
  from EMPLOYEES e
 where e.employee_id = 200;

-- if v_salary > 1000 and v_salary < 5000 
--     then dbms_output.put_line('Empleado de categoria C');
--     elsif v_salary > 5000 and v_salary <= 10000 then
--         dbms_output.put_line('Empleado de categoria B');
--     elsif v_salary > 10000 then
--         dbms_output.put_line('Empleado de categoria A');
-- end if; 

if v_salary between 1000 and 5000 -- el between: sirve para comparar entre rangos
    then dbms_output.put_line('Empleado de categoria C');
    elsif v_salary between 5000 and  10000 then
        dbms_output.put_line('Empleado de categoria B');
    elsif v_salary > 10000 then
        dbms_output.put_line('Empleado de categoria A');
end if;
end;

--////////////////////////////////////////////////////////////////////////////--

declare
v_departamento departments.department_name%type;
begin
  select d.department_name
    into v_departamento
    from departments d
   where d.department_id = 200;

case v_departamento --- case: es un condicional al igual que el if
  when 'Operations' then dbms_output.put_line('El departamento se encuenra en el piso 4');
  when 'IT Support' then dbms_output.put_line('El departamento se encuenra en el piso 3');
  when 'NOC' then dbms_output.put_line('El departamento se encuenra en el piso 3');
  when 'IT Helpdesk' then dbms_output.put_line('El departamento se encuenra en el piso 3');
  when 'Government Sale' then dbms_output.put_line('El departamento se encuenra en el piso 2');
  else dbms_output.put_line('El departamento se encuenra en el piso 1');

end case;
end;


--////////////////////////////////////////////////////////////////////////////--

declare
v_departamento departments.department_name%type;
begin
  select d.department_name
    into v_departamento
    from departments d
   where d.department_id = 200;

case  --- case: otra manera de utilizar el condicional case

  when v_departamento = 'Operations' 
    then dbms_output.put_line('El departamento se encuenra en el piso 4');
  when v_departamento in('IT Support','NOC','IT Helpdesk') 
    then dbms_output.put_line('El departamento se encuenra en el piso 3');
  when v_departamento = 'Government Sale' 
    then dbms_output.put_line('El departamento se encuenra en el piso 2');
  else dbms_output.put_line('El departamento se encuenra en el piso 1');

end case;
end;

--////////////////////////////////////////////////////////////////////////////--



declare
v_contador number := 0;
begin
loop-- bucle infinito
v_contador := v_contador + 1;
    continue when = 3; -- continue: para seguir a otro bloque de codigo
    dbms_output.put_line('el numero es : '|| v_contador);
    exit when v_contador = 7;--exit: para cortar cualquier bucle
end loop;  
end;

--////////////////////////////////////////////////////////////////////////////--

declare
v_contador number := 0;
begin
while v_contador < 7 loop -- while: va a repetirse mientra la condicion siguiente hasta que la condicion sea False
  v_contador := v_contador + 1;
  dbms_output.put_line('el numero es : '|| v_contador);
end loop;
end;

--////////////////////////////////////////////////////////////////////////////--


declare
v_texto varchar(25) := 'El valor del numero es: ';
begin
  for numero in 1..8  loop --for: ciclo que permite iterar hasta un tope que debemos declarar nosotros
    dbms_output.put_line(v_texto || numero);
  end loop;
end;

--////////////////////////////////////////////////////////////////////////////--

----EJERCICIOS DEL CURSO-----

        -->>> 1 <<<--
    
--Dada una determinada opinión,
--si esta fue de 1 o 2 puntos llenar una variable con el valor "Mala".
--Si fue de 3 o 4 puntos "Buena" y si fue de 5 puntos "Excelente".
--Luego imprimir el resultado junto al título de la película.

declare
puntuacion number;
id_pelicula number;
t_pelicula varchar(20);

begin
select e.puntuacion, e.IDPELICULA  
  into puntuacion,id_pelicula
  from OPINION e
  where e.idopinion = 5;
  

select p.titulo
  into t_pelicula
  from PELICULA p
 where p.idpelicula = id_pelicula;

if puntuacion between 1 and 2 
    then dbms_output.put_line('La pelicula '||t_pelicula||', tuvo una de puntacion '||puntuacion
    ||' y su critica es Mala' );
    
    elsif puntuacion between 3 and 4 
    then dbms_output.put_line('La pelicula '||t_pelicula||', tuvo una de puntacion '||puntuacion
    ||' y su critica es Buena' );

    elsif puntuacion = 5 
    then dbms_output.put_line('La pelicula '||t_pelicula||', tuvo una de puntacion '||puntuacion
    ||' y su critica es Excelente' );
      
end if;

end;

--////////////////////////////////////////////////////////////////////////////--


        -->>> 2 <<<--

--Calcular la potencia de un número cualquiera e imprimir el resultado. Ejemplo: 2^4 = 16.

declare
numero_1 number := 5;
numero_2 number := 4;
numero_3 number;
begin
numero_3 := numero_1;
for numero in 1..(numero_2 - 1)  loop
    numero_3 := numero_3 * numero_1;

end loop;
dbms_output.put_line(numero_3);
end;