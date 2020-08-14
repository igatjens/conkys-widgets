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
    set_fuente( cr )
    set_color_blanco( cr )

    local margen = 10
    local alto = conky_window.height - get_acc_maquina_margen_superior( )
    local posicion_x = conky_window.width - get_acc_maquina_margen_derecho( )
    local posicion_y = get_acc_maquina_margen_superior( )
    
    mostrar_fecha_maquina( cr, posicion_x, posicion_y, alto, margen )


    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end

function mostrar_fecha_maquina( cr, posicion_x_param, posicion_y_param, alto, margen )
    margen = margen or 10
    local escala = porcentaje( 83, alto-(margen*2))/100
    local letra_size_grande = 34 * escala
    local letra_size_mediana = 18 * escala
    local posicion_x = posicion_x_param - margen
    local posicion_y = margen + letra_size_grande - 7.8*escala + posicion_y_param
    local separacion = 13 * escala

    local texto = conky_parse( "$nodename" )
    mostrar_texto(cr, posicion_x, posicion_y, letra_size_grande, texto, "derecha" )

    texto = conky_parse( "${execi 600 lsb_release -si} ${execi 600 lsb_release -sr}" )
    posicion_y = posicion_y + letra_size_mediana + 2*escala
    mostrar_texto(cr, posicion_x, posicion_y, letra_size_mediana, texto, "derecha"  )

    texto = conky_parse( "Uptime: $uptime_short" )
    posicion_y = posicion_y + letra_size_mediana  + separacion
    mostrar_texto(cr, posicion_x, posicion_y, letra_size_mediana, texto, "derecha"  )
end