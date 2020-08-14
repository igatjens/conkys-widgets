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

-- variables persistentes
local esta_hecho = false

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
    set_color_blanco( cr )

   
    local posicion_x = conky_window.width/2
    local posicion_y = conky_window.height/3
    local texto = "Hola mundo"
    local texto_size = get_letra_size_etiqueta( 1 )

    if not esta_hecho then
        conky_parse("${exec sed -i 's/own_window_transparent *yes/own_window_transparent no/' *.conf}")
        conky_parse("${exec sed -i 's/own_window_colour *....../own_window_colour 222222/' *.conf}")
        conky_parse("${exec sed -i 's/own_window_argb_value *.*/own_window_argb_value 199/' *.conf}")
        --own_window_transparent no
        esta_hecho = true
    end

    print(esta_hecho)

    texto = "¡Listo! Fondo por defecto aplicado."
    mostrar_texto(cr, posicion_x, posicion_y, texto_size, texto, "centro" )

    posicion_y = posicion_y + texto_size*2
    texto = "Si los widgets no se muestran, por favor vuelva a activarlos."
    mostrar_texto(cr, posicion_x, posicion_y, texto_size, texto, "centro" )
    

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end
