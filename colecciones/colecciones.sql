-- Variables "record" personalizadas --

declare

type datos_empleados is record
(apellido varchar(50),
nombre varchar(50),
pais varchar(50));

empleado datos_empleados;

begin

select e.last_name, e.first_name, c.country_name
  into empleado
  from employees e
  inner join departments d on e.department_id = d.department_id
  inner join locations l on d.location_id = l.location_id
  inner join countries c on country_id = c.country_id
  where employee_id = 100;  

  dbms_output.put_line(empleado.apellido);
  dbms_output.put_line(empleado.nombre);
  dbms_output.put_line(empleado.pais);
end;

--///////////////////////////////////////////////////////////////--

                -- Colecciones parte 1--

declare



type l_empleados is table of varchar2(50);
c_empleados l_empleados := l_empleados('juan','pedro','carlos');
v_size number;
v_primer_elemento number;
v_ultimo_elemento number;

begin

  c_empleados.extend;-- para agregar mas espacio a la coleccion "lista"
  c_empleados (4) := 'marcelo'; 
  c_empleados.extend;
  c_empleados (5) := 'fernando';--asi se agrega otro elemento a la lista
  
  v_size := c_empleados.count();-- para contar cuantos elementos hay
  dbms_output.put_line('Tamaño de la coleccion: '||v_size);
  
    v_primer_elemento := c_empleados.first();
    v_ultimo_elemento := c_empleados.last();
    dbms_output.put_line('Primer elemento: '||c_empleados(v_primer_elemento));
    dbms_output.put_line('Ultimo elemento: '||c_empleados(v_ultimo_elemento));

for i in 1..v_size loop
dbms_output.put_line(c_empleados(i));
end loop;
end;

--///////////////////////////////////////////////////////////////--


declare

type l_empleados is table of varchar2(50);

v_empleados l_empleados := l_empleados();
v_size number;
v_primer_elemento number;
v_ultimo_elemento number;

begin
  
  for i in 1..10  loop
    v_empleados.extend;
    
    select e.first_name
      into v_empleados(i)
      from employees e
     where e.employee_id = (100+i);
    end loop;

   for i in 1..10 loop
     dbms_output.put_line(v_empleados(i));
   end loop;
end;

--///////////////////////////////////////////////////////////////--

declare

type datos_empleado is record
(apellido varchar(50),
nombre varchar(50),
pais varchar(50));

type e_list is table of datos_empleado;
v_empleado datos_empleado;
lista e_list := e_list();

begin
  
    for i  in 1..4  loop
      select e.last_name, e.first_name, c.country_name
      into v_empleado
      from employees e
      inner join departments d on e.department_id = d.department_id
      inner join locations l on d.location_id = l.location_id
      inner join countries c on l.country_id = c.country_id
      where employee_id = (i+100);

    lista.extend;
    lista(i) := v_empleado;
    end loop;
    dbms_output.put_line(lista(1).apellido||' '||lista(1).nombre||' '||lista(1).pais);
    dbms_output.put_line(lista(2).apellido||' '||lista(2).nombre||' '||lista(2).pais);
    dbms_output.put_line(lista(3).apellido||' '||lista(3).nombre||' '||lista(3).pais);
    dbms_output.put_line(lista(4).apellido||' '||lista(4).nombre||' '||lista(4).pais);

end;