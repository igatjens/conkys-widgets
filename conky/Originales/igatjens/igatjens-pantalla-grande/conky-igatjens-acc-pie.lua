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

-- variables persistentes
local dev_WiFi = ""
local dev_LAN = ""


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

    local updates = tonumber(conky_parse("$updates"))
    if updates < 5 then
        dev_WiFi = get_red_WiFi_dev( )
        dev_LAN = get_red_LAN_dev( )
    end

    set_fuente( cr )
    set_color_blanco( cr )
    
    local margen = 20
    local alto = conky_window.height
    local ancho = conky_window.width
    local posicion_x = 0
    local posicion_y = get_acc_pie_margen_superior( )

    mostrar_pie( cr, posicion_x, posicion_y, alto, ancho, margen, dev_WiFi, dev_LAN)

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end


function mostrar_pie( cr, posicion_x_param, posicion_y_param, alto, ancho, margen, wifi_disp, eth_disp)
    margen = margen or 10

    local escala = porcentaje( 530, ancho-(margen*2))/100
    local letra_size = get_letra_size_etiqueta( escala )
    local posicion_x = posicion_x_param + ancho/2
    local posicion_y = margen/2 + letra_size + posicion_y_param
    local separacion = 8 * escala

    local texto = conky_parse( "WiFi: ${addr "..wifi_disp.."}  -  LAN: ${addr "..eth_disp.."}  -  UTC: ${utime %H:%M:%S}" )
    mostrar_texto(cr, posicion_x, posicion_y, letra_size, texto, "centro" )

    local updates = tonumber(conky_parse("$updates"))
    if updates < 2 then
        return
    end

    posicion_y = posicion_y + letra_size + separacion

    texto = conky_parse( "${if_up "..wifi_disp.."}SSID: ${wireless_essid}  -  Signal: ${wireless_link_qual_perc "..wifi_disp.."}%${else}Load:  ${loadavg 1}  -  ${loadavg 2}  -  ${loadavg 3}${endif}" )
    mostrar_texto(cr, posicion_x, posicion_y, letra_size, texto, "centro" )
end
