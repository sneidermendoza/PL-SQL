---------------->>> Funciones <<<------------------

create or replace function pedidos_pendientes return varchar2 
is
v_cantidad number;

begin
  select count(*)
    into v_cantidad
    from pedidos
   where fechaentregado is null;

   return v_cantidad;
end;

--para llamar a esa funcion se abre otra hoja de trabajo y colocamos:
select pedidos_pendientes()
from dual

--////////////////////////////////////////////////////////////////////////////--

                  --FUNCIONES CON PARAMETROS--


create or replace function calcular_valor_pedido(p_idpedido number)  
return number is

cursor articulos(v_idpedido number) is
  select pa.cantidad, a.precio
  from pedidos_articulos pa
  inner join articulos a on a.idarticulo = pa.idarticulo
  where pa.idpedido =  v_idpedido;

  v_total number := 0;
  v_porcentaje_costo_entrega number;
  v_costo_entrega number;

  begin
    
  select c.costoentrega
    into v_porcentaje_costo_entrega
    from canales_venta c
    inner join pedidos p on c.idcanalventa = p.idcanalventa
   where p.idpedido = p_idpedido;

  for art in articulos(p_idpedido)  loop
    v_total := v_total+(art.precio*art.cantidad);
  end loop;

  v_costo_entrega := (v_porcentaje_costo_entrega*v_total)/100;
  v_total := v_total+v_costo_entrega;
  return v_total;

  exception
    when others then
    dbms_output.put_line('Hubo un error');
  end;

--llamamientos de la funcion anterior

select calcular_valor_pedido(2)
from dual

select p.*, calcular_valor_pedido(p.idpedido)
from pedidos p


--////////////////////////////////////////////////////////////////////////////--


                         --procedimientos--

create or replace procedure ordenar_a_fabrica is

cursor articulos is
select a.idarticulo, a.stock, a.idsucursal
  from articulos_sucursales a;

v_mejor_precio number;
v_idfabricante number;
v_siguiente_id number;

begin
  
  for art in articulos loop
    
    if art.stock = 0 then
      
      select min(precio)
        into v_mejor_precio
        from articulos_fabricantes af
       where af.idarticulo = art.idarticulo
       group by idarticulo;

       select idfabricante
         into v_idfabricante
         from articulos_fabricantes af
        where af.idarticulo = art.idarticulo and af.precio = v_mejor_precio;

        select max(idpedidofabrica) + 1
          into v_siguiente_id
          from pedido_fabrica;

      insert into pedido_fabrica(idpedidofabrica,idsucursal,idarticulo,idfabricante,
      fechapedido,cantidad)
      values (v_siguiente_id, art.idsucursal, art.idarticulo,v_idfabricante,sysdate,10);
      
    end if;
  end loop;
end;

-- los procedimientos se tienen que llamar desde otro bloque de codigo pl/sql:

BEGIN
ordenar_a_fabrica();-- llamamiento del procedimiento
end;

select * from pedido_fabrica --miramos las tablas que se afectaron en el procedimiento


--////////////////////////////////////////////////////////////////////////////--

                      --procedimientos con parametros--


create or replace procedure agregar_articulo(p_idarticulo in number,p_idpedido in number,
p_cantidad in number, p_mensaje out varchar2 )
is

v_idsucursal number;
v_stock number;
v_idpedidosarticulos number;

begin
  select p.idsucursal
    into v_idsucursal
    from pedidos p
   where p.idpedido = p_idpedido;

   select a.stock
     into v_stock
     from articulos_sucursal a
    where a.idarticulo = p_idarticulo end a.idsucursal = v_idsucursal;

    if v_stock >= p_cantidad then
    select max(idpedidosarticulos + 1)
      into v_idpedidosarticulos
      from pedidos_articulos;

    insert into pedidos_articulos (idpedido,idarticulo,cantidad,idpedidosarticulos)
    values (p_idpedido,p_idarticulo,p_cantidad, v_idpedidosarticulos);
    v_mensaje := 'articulo agregado al pedido';

    else 
      v_mensaje := 'no hay stock suficiente';

    end if;


end;

--////////////////////////////////////////////////////////////////////////////--

                        --ejercicio de practica-- 


create or replace procedure imprimir_pedido(p_idpedido in number,p_resumen_pedido out clob) is

v_res_pedido clob;
br varchar2(1) := chr(10);
sep VARCHAR2(35) := br||'---------------------------------'||br;
v_datos_cliente VARCHAR2(140);
v_direccion_cliente VARCHAR2(140);
v_precio_final number;

cursor pedidos_articulo(id_pedido number) is
select p.cantidad, a.nombre, a.precio
from pedidos_articulos p
inner join articulos a on p.idarticulo = a.idarticulo
where p.idpedido = id_pedido;

BEGIN
v_res_pedido := sep;
v_res_pedido := v_res_pedido||'PEDIDO Nº: '||p_idpedido;
v_res_pedido := v_res_pedido||sep;

select c.apellido||'. '||c.nombre||'. DOC: '||c.documento,d.calle||'  '||d.numero||' - piso: '||d.piso||' '||d.departamento
into v_datos_cliente, v_direccion_cliente
from pedidos p
inner join clientes c on p.idcliente = c.idcliente
inner join direcciones d on d.idcliente = p.iddireccion
where p.idpedido = p_idpedido;

v_res_pedido := v_res_pedido||'CLIENTE: '||v_datos_cliente||br||'DIRECCION: '||v_direccion_cliente||sep;
v_res_pedido := v_res_pedido||sep||'A R T I C U L O S'||sep;

for art in pedidos_articulo(p_idpedido) loop
  
  v_res_pedido := v_res_pedido||art.nombre||'(x'||art.cantidad||')........$'||art.precio||br;
end loop;



v_precio_final := calcular_valor_pedido(p_idpedido);
v_res_pedido := v_res_pedido||sep||'TOTAL: $'||v_precio_final||sep;

p_resumen_pedido := v_res_pedido;

end;

--////////////////////////////////////////////////////////////////////////////--

                      --ejercicio 1-- 

-- Crear una function que reciba por parámetro un id de película.
-- Se debe retornar nombre de la película, la calificación promedio numérica y calificación
-- en texto (Entre 1 y 2: Mala - entre 3 y 4: Buena - Mayor a 4: Excelente) y el número
-- de calificaciones, todo en un mismo texto.
-- Ejemplo: "Power Rangers - Calificación: Buena (3,2) - Basada en 7 puntuaciónes".  

create or replace function puntuacion_pelicula(p_id_pelicula number) return varchar2 is
 
v_titulo_pelicula varchar2(50);
v_puntuacion_promedio number(10,2);
v_calificacion varchar2 (10);
v_cantidad_puntuaciones number(10);
v_texto_respuesta varchar2(255);
 
begin
 
    select p.titulo
    into v_titulo_pelicula
    from pelicula p
    where p.idpelicula = p_id_pelicula;
 
    select avg(o.puntuacion)
    into v_puntuacion_promedio
    from opinion o
    where o.idpelicula = p_id_pelicula;
 
    if v_puntuacion_promedio between 1 and 2 then
        v_calificacion := 'Mala';
    elsif v_puntuacion_promedio between 3 and 4 then
        v_calificacion := 'Buena';
    elsif v_puntuacion_promedio > 4 then
        v_calificacion := 'Excelente';
    end if;
    
    select count(*)
    into v_cantidad_puntuaciones
    from opinion o
    where o.idpelicula = p_id_pelicula;
    
    v_texto_respuesta := v_titulo_pelicula||' - Calificación: '||v_calificacion||' ('||v_puntuacion_promedio||') - Basada en '||v_cantidad_puntuaciones||' puntuaciónes';
        
    return v_texto_respuesta;
    
    exception when NO_DATA_FOUND then
        v_texto_respuesta := 'No existe la pelicula';
    return v_texto_respuesta;
 
end;
--Para probar el funcionamiento con una sola película:

select puntuacion_pelicula(2)
from dual
--Para probar el funcionamiento con todas las películas de la tabla:

select puntuacion_pelicula(p.idpelicula), p.titulo
from pelicula p







--////////////////////////////////////////////////////////////////////////////--
                      
                      --ejercicio 2--

-- Crear un procedure para el login de usuario.

-- Se deben recibir 2 parámetros: p_apodo y p_password.
-- Se debe chequear que el nombre de usuario existe y que la password sea válida.

-- En caso de ser datos válidos, se deben devolver datos en
-- 4 variables OUT: v_mensaje(con el mensaje "Login correcto"), v_id_usuario, v_apodo,v_email.

-- En caso de ser datos inválidos, se deben devolver las 4 mismas
-- variables OUT: v_mensaje (con el mensaje "Usuario no existente" o "Password incorrecta",
-- según corresponda). El resto de las variables deben ser "null".

-- Passwords de usuarios para probar:
-- -Usuario: JuanPerez123 - Password: abc123
-- -Usuario: Pedro456 - Password: def456
-- -Usuario: Maria789 - Password: ghi789

-- /*Nota: para chequear si un password es correcto, se debe primero convertir el password recibido por parametro a hash MD5.
-- Para ello utilizamos la función de oracle "standard_hash", de la siguiente manera:*/
   
-- select standard_hash(p_password_recibido_por_parametro, 'MD5')
-- into v_password_hasheado
-- from dual;
    
-- /*Luego se compara el password hasheado con el guardado en el campo "password" de la tabla usuario.*/


Passwords de usuarios para probar:
-Usuario: JuanPerez123 - Password: abc123
-Usuario: Pedro456 - Password: def456
-Usuario: Maria789 - Password: ghi789


create or replace procedure login_usuario(p_apodo IN varchar2, p_password IN varchar2, v_mensaje OUT varchar2, v_id_usuario OUT number, v_apodo OUT varchar2, v_email OUT varchar2) is
 
v_password_hasheado varchar2(255);
v_datos_validos number(10);
 
begin
 
    select u.idusuario
    into v_id_usuario
    from usuario u
    where u.apodo = p_apodo;
    
    select standard_hash(p_password, 'MD5')
    into  v_password_hasheado
    from dual;
    
    select count (*)
    into v_datos_validos
    from usuario u
    where u.idusuario = v_id_usuario and v_password_hasheado = u.password;
    
    if v_datos_validos > 0 then
    
        select u.idusuario,u.apodo,u.email
        into v_id_usuario, v_apodo, v_email
        from usuario u
        where u.idusuario = v_id_usuario;
        
        v_mensaje := 'Login correcto';
        
    else
 
        v_mensaje := 'Password incorrecta';
        v_id_usuario := null;
        v_apodo := null;
        v_email := null;
        
    end if;
  
exception when no_data_found then
 
    v_mensaje := 'Usuario no existente';
    v_id_usuario := null;
    v_apodo := null;
    v_email := null;
        
end;
--Bloque anonimo para probar el Procedure:

declare
 
v_apodo_parametro varchar2(20);
v_password_parametro varchar2(100);
 
v_mensaje varchar2(255);
v_id_usuario number(10);
v_apodo varchar2(20);
v_email varchar2(320);
 
begin
 
    v_apodo_parametro := 'Maria789';
    v_password_parametro := 'ghi789';
 
    login_usuario(v_apodo_parametro,v_password_parametro,v_mensaje,v_id_usuario,v_apodo,v_email);
    
    dbms_output.put_line('Mensaje: '||v_mensaje);
    dbms_output.put_line('Id Usuario: '||v_id_usuario);
    dbms_output.put_line('Apodo: '||v_apodo);
    dbms_output.put_line('Email: '||v_email);
    
end;