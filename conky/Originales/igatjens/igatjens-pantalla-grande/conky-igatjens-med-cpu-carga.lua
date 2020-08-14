--this is a lua script for use in conky



--==============================================================================
--                            conky-igatjens.lua
--
--  author  : Isaías Gatjens M - Twitter @igatjens
--  version : v2.0 for Conky Manager
--  license : Distributed under the terms of GNU GPL version 2 or later
--
--
--  notes   : uses conky conf newer >v1.10
--==============================================================================





require 'cairo'
require "conky-igatjens-lib-medidor-circulo"
require "conky-igatjens-lib-tools"
require "conky-igatjens-lib-texto"
require "conky-igatjens-lib-colores"
require "conky-igatjens-000-ajustes"

function conky_main()
    if conky_window == nil then
        return
    end
    local cs = cairo_xlib_surface_create(conky_window.display,
                                         conky_window.drawable,
                                         conky_window.visual,
                                         conky_window.width,
                                         conky_window.height)
    cr = cairo_create(cs)

    -- Establecer tipo de fuente
    set_fuente(cr)


    local radio = calcular_radio_medidor(conky_window.height)
    local posicion_x = calcular_posicion_x_medidor( radio ) + get_med_disk_margen_izquierdo( )
    local posicion_y = calcular_posicion_y_medidor( radio )

    
    -- CPU --
    medidor_cpu_carga(cr, posicion_x, posicion_y, radio, get_num_nucleos( ))

    


    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end


function medidor_cpu_carga(cr, centro_x, centro_y, radio, num_nucleos)
   
    local loadavg1=conky_parse("${loadavg 1}")
    local loadavg2=conky_parse("${loadavg 2}")
    local loadavg3=conky_parse("${loadavg 3}")

    local carga_max = num_nucleos

    local porcentaje_reduccion = get_medidor_relacion_arco_interno( )/100

    -- mostrar medidor
    set_color_fusia(cr)
    hacer_arco_medidor(cr,centro_x,centro_y,radio,0,carga_max,loadavg1,true)



    -- Medidor particion2
    local radio_interno1=radio*porcentaje_reduccion
    set_color_azul(cr)
    hacer_arco_medidor(cr,centro_x,centro_y,radio_interno1,0,carga_max,loadavg2,false)



    local escala = calcular_escala_respecto_radio(radio)


    -- Medidor particion3
    set_color_verde(cr)
    local separacion = 12

    if escala > 1 then
    	separacion = separacion * escala
    end

    local radio_interno2=radio_interno1-(separacion)
    hacer_arco_medidor(cr,centro_x,centro_y,radio_interno2,0,carga_max,loadavg3,false)




    -- mostrar texto
    set_color_blanco(cr)

    local texto=loadavg1
    local texto_posicion_x = centro_x+10
    local texto_posicion_y = centro_y+(get_letra_size_grande(escala)/2)

    -- ajustar alieacion izquierda del texto
    if escala < 1 then texto_posicion_x = centro_x + (10*escala)/2 end

    mostrar_texto_grande(cr,texto_posicion_x,texto_posicion_y, texto, escala)


    --texto="last 1 min"
    --texto_posicion_y = texto_posicion_y + get_letra_size_pequenna( escala ) + 1
    --mostrar_texto_pequenno(cr,texto_posicion_x,texto_posicion_y, texto, escala)

    
    texto = loadavg3
    texto_posicion_y = centro_y + radio_interno2 + get_letra_size_pequenna( escala )/3
    mostrar_texto_pequenno(cr,texto_posicion_x,texto_posicion_y, texto, escala)


    texto = loadavg2
    texto_posicion_y = centro_y + radio_interno1 + get_letra_size_pequenna( escala )/3
    mostrar_texto_pequenno(cr,texto_posicion_x,texto_posicion_y, texto, escala)

    texto = "LOAD"
    texto_posicion_y = centro_y + radio + get_letra_size_median( escala )/3
    mostrar_texto_mediano(cr,texto_posicion_x,texto_posicion_y, texto, escala)

end