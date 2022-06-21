-------->>>>>>>>>>>>> EXEPCIONES <<<<<<<<<<<<<<------------

--exepciones implicitas: las genera oracle

declare
v_busqueda employees.first_name%type;
v_telefono employees.phone_number%type;
v_cantidad number;
begin
  
  v_busqueda := 'luis';
  select e.phone_number
    into v_telefono
    from employees e
   where e.first_name = v_busqueda;

   dbms_output.put_line('El telefono de : '||v_busqueda||' es: '||v_telefono);

   exception
     when too_many_rows then

    select count(*)
      into v_cantidad
      from employees e
     where e.first_name = v_busqueda;
    
    dbms_output.put_line('Hay '||v_cantidad||' empleados con ese nombre');
    
    when no_data_found then
    
    dbms_output.put_line('No hay empleados con ese nombre');
end;


--////////////////////////////////////////////////////////////--

declare

v_job_id varchar(25);
v_afectadas number;
job_no_encontrado exception;

begin
  v_job_id := 'IT_PROG';

  update employees
     set salary=salary*1.5
   where job_id = v_job_id;

   v_afectadas := sql%rowcount;

   if v_afectadas = 0 then
        raise job_no_encontrado;
     
   end if;
   dbms_output.put_line('Afectadas: '||v_afectadas);


   exception
     when job_no_encontrado then
     dbms_output.put_line('ese job no existe');
end;

--////////////////////////////////////////////////////////////////////////////--


                ----EJERCICIOS DEL CURSO-----


                          -->>> 1 <<<--
-- * Utilizando el email, buscar e imprimir ID y apodo de un usuario.
-- Lanzar una exception e imprimir un mensaje si no se encuentra ningún usuario con ese email.

declare
id_usuario number;
apodo_usuario varchar(15);
email_usuario varchar(50);

begin
email_usuario := 'josefina@mailejemplo.com';
  select e.idusuario, e.apodo
    into id_usuario, apodo_usuario
    from usuario e
   where e.email = email_usuario;

   dbms_output.put_line(id_usuario||' '||apodo_usuario);
     
    exception
    when no_data_found then
    
    dbms_output.put_line('No hay usuarios con ese email');
end;


--////////////////////////////////////////////////////////////////////////////--

                        -->>> 2 <<<--
-- Continuando con el punto anterior, lanzar una exception e imprimir un mensaje si
-- hay más de un usuario con el mismo email.

declare
id_usuario number;
apodo_usuario varchar(15);
email_usuario varchar(50);
v_cantidad number;

begin
email_usuario := 'josefina@mailejemplo.com';
  select e.idusuario, e.apodo
    into id_usuario, apodo_usuario
    from usuario e
   where e.email = email_usuario;

   dbms_output.put_line(id_usuario||' '||apodo_usuario);
     
    exception
    when no_data_found then
    
    dbms_output.put_line('No hay usuarios con ese email');

    when too_many_rows then

    select count(*)
      into v_cantidad
      from usuario e
     where e.email = email_usuario;
    
    dbms_output.put_line('ERROR:-> Hay '||v_cantidad||' usuarios con ese email');
end;

--////////////////////////////////////////////////////////////////////////////--

                               -->>> 2 <<<--  

-- Continuando con el punto anterior, crear una exception personalizada
-- e imprimir un mensaje en caso de que el mail ingresado no tenga un "@"
-- en alguna parte del texto.

declare
id_usuario number;
apodo_usuario varchar(15);
email_usuario varchar(50);
v_cantidad number;
email_sin_arroba exception;

begin
email_usuario := 'josefinamailejemplo.com';

    if email_usuario not like '%@%' then
        raise email_sin_arroba;
    end if;
  select e.idusuario, e.apodo
    into id_usuario, apodo_usuario
    from usuario e
   where e.email = email_usuario;

   dbms_output.put_line(id_usuario||' '||apodo_usuario);
     
    exception
    when no_data_found then
    dbms_output.put_line('No hay usuarios con ese email');

    when too_many_rows then
    select count(*)
      into v_cantidad
      from usuario e
     where e.email = email_usuario;
    dbms_output.put_line('ERROR:-> Hay '||v_cantidad||' usuarios con ese email');
    
    when email_sin_arroba then
     dbms_output.put_line('El email tiene un formato invalido');
end;