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

local wifi_nombre_dispositivo = ""
local eth_nombre_dispositivo = ""

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
    local posicion_x = calcular_posicion_x_medidor( radio ) + get_med_internet_margen_izquierdo( )
    local posicion_y = calcular_posicion_y_medidor( radio )


    local ancho_banda_bajada_internet_Mbps = get_med_red_ancho_banda_descarga( )        --ancho banda bajada Internet - down speed Internet
    local ancho_banda_subida_internet_Mbps = get_med_red_ancho_banda_subida( )    --ancho banda subida Internet - up speed Internet

    local updates = tonumber(conky_parse("$updates"))
    if updates < 5 then
        wifi_nombre_dispositivo = get_red_WiFi_dev( )
        eth_nombre_dispositivo = get_red_LAN_dev( )
    end

    
    -- CPU --
    medidor_internet(cr,posicion_x, posicion_y,radio, 
        wifi_nombre_dispositivo, eth_nombre_dispositivo,
        ancho_banda_bajada_internet_Mbps, ancho_banda_subida_internet_Mbps)


    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end


function medidor_internet(cr, centro_x, centro_y, radio, wifi_disp, eth_disp, vel_bajada_internet_Mbps, vel_subida_internet_Mbps)
    
    local interfaz_red = ""

    if conky_parse("${addr " .. eth_disp .."}") ==  "No Address" then
        interfaz_red = wifi_disp
    else
        interfaz_red = eth_disp
    end

 
    local vel_subida_valor=conky_parse("${upspeedf " .. interfaz_red .. "}") -- en KiB/s
    local vel_bajada_valor=conky_parse("${downspeedf " .. interfaz_red .. "}") -- en KiB/s

    local vel_bajada_valor_Mbps=vel_bajada_valor*0.008192 -- convercion de KiB/s a Mbps
    local vel_subida_valor_Mbps=vel_subida_valor*0.008192 -- convercion de KiB/s a Mbps


    -- Calculo de los porcentajes para los medidores
    local porcentaje_vel_bajada_internet=(vel_bajada_valor_Mbps*100)/vel_bajada_internet_Mbps
    local porcentaje_vel_subida_internet=(vel_subida_valor_Mbps*100)/vel_subida_internet_Mbps

    -- Redondearlos despues de los calculos
    porcentaje_vel_bajada_internet= round(porcentaje_vel_bajada_internet,0)
    porcentaje_vel_subida_internet= round(porcentaje_vel_subida_internet,0)
    vel_bajada_internet_Mbps= round(vel_bajada_internet_Mbps,1)
    vel_subida_internet_Mbps= round(vel_subida_internet_Mbps,1)

    -- mostrar medidor
    set_color_fusia(cr)
    hacer_arco_medidor(cr,centro_x,centro_y,radio,0,100,porcentaje_vel_bajada_internet,true)

    set_color_azul(cr)
    local radio_interno1 = radio * get_medidor_relacion_arco_interno( )/100 -- porcentaje menor al radio
    hacer_arco_medidor(cr,centro_x,centro_y,radio_interno1,0,100,porcentaje_vel_subida_internet,false)


    -- mostrar texto
    set_color_blanco(cr)

    local escala = calcular_escala_respecto_radio(radio)
    local texto=porcentaje_vel_bajada_internet .. "%"
    local texto_posicion_x = centro_x+10
    local texto_posicion_y = centro_y+(get_letra_size_grande(escala)/2)

    -- ajustar alieacion izquierda del texto
    if escala < 1 then texto_posicion_x = centro_x + (10*escala)/2 end

    mostrar_texto_grande(cr,texto_posicion_x,texto_posicion_y, texto, escala)

    texto=vel_bajada_internet_Mbps .. " /" .. vel_subida_internet_Mbps .. "Mbps"
    texto_posicion_y = texto_posicion_y + get_letra_size_pequenna( escala ) + 1
    mostrar_texto_pequenno(cr,texto_posicion_x,texto_posicion_y, texto, escala)

    texto = "UP " .. porcentaje_vel_subida_internet .. "%"
    texto_posicion_y = centro_y + radio_interno1 + get_letra_size_pequenna( escala )/3
    mostrar_texto_pequenno(cr,texto_posicion_x,texto_posicion_y, texto, escala)

    texto_posicion_y = centro_y + radio + get_letra_size_median( escala )/3
    mostrar_texto_mediano(cr,texto_posicion_x,texto_posicion_y,"Internet", escala)

end