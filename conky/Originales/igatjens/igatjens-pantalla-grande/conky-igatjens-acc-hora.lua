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
    local alto = conky_window.height - get_acc_hora_margen_superior( )
    local posicion_x = get_acc_hora_margen_izquierdo( )
    local posicion_y = get_acc_hora_margen_superior( )

    mostrar_fecha_hora( cr, posicion_x, posicion_y, alto, margen)



    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end

function mostrar_fecha_hora( cr, posicion_x_param, posicion_y_param, alto, margen )
    margen = margen or 10
    local escala = porcentaje( 83, alto-(margen*2))/100
    local letra_size_grande = 64 * escala
    local letra_size_fecha = 24 * escala
    local posicion_x = margen + posicion_x_param
    local posicion_y = margen + letra_size_grande - 15*escala + posicion_y_param
    local separacion = 4 * escala

    local texto = conky_parse( "${time %H:%M}" )
    mostrar_texto(cr, posicion_x-3*escala, posicion_y, letra_size_grande, texto )

    texto = conky_parse( "${time :%S}" )
    mostrar_texto(cr, posicion_x+160*escala, posicion_y - letra_size_grande*0.375, letra_size_grande/2, texto )

    texto = conky_parse( "${time %a %d %B %Y}" )
    mostrar_texto(cr, posicion_x, posicion_y + letra_size_fecha + separacion, letra_size_fecha, texto )
end