                    --TRIGGERS O GATILLOS--

--CREACION DE TIGGER
create or replace TRIGGER art_audit
after update on articulos_c

declare 

v_mensaje varchar2(50);

begin
  v_mensaje := 'se a realizado un update en la tabla articulos_c';
  
  insert into log_auditoria(usuario,mensaje,fecha)
  values (user, v_mensaje,sysdate);

end;

--////////////////////////////////////////////////////////////////////////--
               --probandoo el trigger--
update articulos_c
set precio = precio*1.10

select * from log_auditoria

insert into articulos_c(idarticulo,nombre,precio,descripcion)
values(12,'art de prueba_1',16,'Este es un articulo de prueba');

delete from articulos_c
where idarticulo in (11,12)

--////////////////////////////////////////////////////////////////////////--

create or replace TRIGGER art_audit
after update or delete or insert on articulos_c

declare 

v_mensaje varchar2(50);

begin
    if inserting then
        v_mensaje := 'se a realizado un insert en la tabla articulos_c';
    elsif deleting then
         v_mensaje := 'se a realizado un delete en la tabla articulos_c';
    elsif updating then
         v_mensaje := 'se a realizado un update en la tabla articulos_c';
    end if;
    
  
  insert into log_auditoria(usuario,mensaje,fecha)
  values (user, v_mensaje,sysdate);

end;

--////////////////////////////////////////////////////////////////////////--

-- trigger con for each row--

create or replace TRIGGER art_audit
after update or delete or insert on articulos_c
for each row -- se ejecuta una vez por fila afectada, es decir que si hay diez filas afectadas 
--se ejecuta diez veces

declare 

v_mensaje varchar2(50);

begin
    if inserting then
        v_mensaje := 'se a realizado un insert en la tabla articulos_c';
    elsif deleting then
         v_mensaje := 'se a realizado un delete en la tabla articulos_c';
    elsif updating then
         v_mensaje := 'se a realizado un update en la tabla articulos_c';
    end if;
    
  
  insert into log_auditoria(usuario,mensaje,fecha)
  values (user, v_mensaje,sysdate);

end;

--////////////////////////////////////////////////////////////////////////--

                -- variables "OLD" / "NEW" --

create or replace trigger art_aud_precio
after update on articulos_c
for each row

declare
v_idarticuloaud number;

begin
  if updating('precio') then
    select nvl(max(idarticuloaud)+1,1)
      into v_idarticuloaud
      from articulos_auditoria;

    insert into articulos_auditoria (idarticuloaud,idarticulo,precioanterior,
    precionuevo,fecha,usuario)
    values (v_idarticuloaud,:old.idarticulo,:old.precio,:new.precio,sysdate,user);
  end if;
end;

--////////////////////////////////////////////////////////////////////////--

                            --BEFORE--

create or replace trigger pedidos_fecha
before insert on pedidos -- interceptar la sentencia antes de que se ejecute
for each row

declare

v_fecha date;

begin
  
  v_fecha := sysdate;
  :new.fecha := v_fecha;
end;

--////////////////////////////////////////////////////////////////////////--

--raise application error,  par que se cumplas reglas de nuestro modelo de negosio!--

create or replace trigger clientes_credito
before insert on clientes
for each row

declare
v_nuevo_limite number;

begin
  v_nuevo_limite := :new.limitecredito;

  if v_nuevo_limite >= 15000 then
    
    raise_application_error(-20000, 'el limite no puede ser mayor a 15000');
    
  end if;
end;

--////////////////////////////////////////////////////////////////////////--

                      -- Ejercicio 1 --

-- Crear un trigger que se dispare ante un INSERT en la tabla de usuarios.
-- Se debe validar que el apodo no esté siendo utilizado por un usuario existente.
-- En caso afirmativo, interrumpir la ejecución de ese INSERT.

create or replace trigger ins_usuario
before insert on usuario

declere
v_apodo varchar2(50);
v_contador number;

begin
v_apodo  := :new.apodo;
select count(*)
  into v_contador
  from usuario a
 where a.apodo = v_apodo;
    if v_contador > 0 then
      raise_application_error(-20001, 'El apodo ya esta siendo utilizado');
    end if;

end;

--////////////////////////////////////////////////////////////////////////--

    insert into usuarios (idusuario,apodo,email,password)
    values (8,'pedro456','sms@.com', 'kjsdhasdnjklwi4wu')


--////////////////////////////////////////////////////////////////////////--
                      -- Ejercicio 1 --

-- Crear un trigger que vaya guardando un histórico de las opiniones editadas y borradas.
-- Para ello, deberá crear un registro nuevo en la tabla de "opinion_historico".

-- En el campo "opinión" se debe guardar el texto de la opinión ANTES de ser borrada/editada

-- En el campo "acción" se debe indicar cuál fue la acción realizada sobre
-- la opinión ("Editado" o "Borrado")

-- En el campo "usuariomodificacion" se debe guardar el nombre del usuario
-- que realizo el update/delete. Se puede obtener mediante la variable especial "USER"

-- En el campo "fechamodificacion" se debe guardar la fecha en la que se realizó la acción. 

create or replace trigger guardar_historico_opinion
after delete or update on opinion
for each row
 
declare
 
v_opinion varchar2(140);
v_usuario_modificacion varchar2(20);
v_fecha_modificacion date;
v_accion varchar2(10);
v_id_opinion_historico number;
 
begin
 
    v_opinion := :old.opinion;
    v_usuario_modificacion := user;
    v_fecha_modificacion := sysdate;
 
    if deleting then
        v_accion := 'Borrado';
    elsif updating then
        v_accion := 'Editado';
    end if;
 
    select nvl(max(idopinionhistorico),0)+1 
    into v_id_opinion_historico
    from opinion_historico;
 
    insert into opinion_historico(idopinionhistorico,opinion,accion,usuariomodificacion,fechamodificacion)
    values (v_id_opinion_historico,v_opinion,v_accion,v_usuario_modificacion,v_fecha_modificacion);
 
end;