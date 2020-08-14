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
local num_nucleos = 0  -- establecer en 0 para autodeteccion

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

    -- Obtener numero de nucleos
    if num_nucleos == 0 then
        num_nucleos = get_num_nucleos( )
    end

    local mostrar_temperatura = get_med_cpu_mostrar_temp( )
    local sensor_temperatura = get_med_cpu_temp_dev( )   -- requiere de sensord, valor entre 1 y 5  - buscar con comando sensors

    local radio = calcular_radio_medidor(conky_window.height )
    local posicion_x = calcular_posicion_x_medidor( radio ) + get_med_cpu_margen_izquierdo( )
    local posicion_y = calcular_posicion_y_medidor( radio )

    
    -- CPU --
    if mostrar_temperatura then
        local escala = calcular_escala_respecto_radio(radio)
        local posicion_x_temp = posicion_x + 80*escala
        local posicion_y_temp = posicion_y - 30*escala
        local radio_temp = 20*escala

        medidor_temp_cpu(cr, posicion_x_temp, posicion_y_temp, radio_temp, sensor_temperatura)
    end

    medidor_cpu(cr, posicion_x, posicion_y, radio, num_nucleos)

    


    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end



                   

function medidor_cpu(cr, centro_x, centro_y, radio, num_nucleos)

    -- Medidor general
    set_color_azul(cr)
    local cpu_valor=conky_parse("${cpu}")
    -- cpu_valor=200
    hacer_arco_medidor(cr,centro_x,centro_y,radio,0,100,cpu_valor,true)



    -- Medidores de nucleos
    local relacion_radio_interno1 = get_medidor_relacion_arco_interno( ) -- porcentaje menor al radio
    local separacion_radios_internos=6 -- separación entre los 

    if num_nucleos > 8 then 
        relacion_radio_interno1=90
    elseif num_nucleos > 4 then
        relacion_radio_interno1=80
    end

    local radio_interno = {}

    radio_interno[1]=(relacion_radio_interno1*radio)/100
    for i=2,num_nucleos do
        radio_interno[i] = radio_interno[i-1]-separacion_radios_internos
    end

    local secuencia_colores = {"fusia","azul","naranja","verde"}
    local mostrar_color = ""
    local cpu_valor_nucleo = 0

    for i=1,num_nucleos do
        
        mostrar_color = secuencia_colores[((i-1)%#secuencia_colores) + 1]
        
        if mostrar_color == "fusia" then
            set_color_fusia(cr)
        elseif mostrar_color == "azul" then
            set_color_azul(cr)
        elseif mostrar_color == "naranja" then
            set_color_naranja(cr)
        elseif mostrar_color == "verde" then
            set_color_verde(cr)
        else
            mostrar_texto(cr,10,10*i,10, "error: secuencia_colores nucleos CPU")
        end

        cpu_valor_nucleo=conky_parse("${cpu cpu" .. i .. "}")
        hacer_arco_medidor_fino(cr,centro_x,centro_y,radio_interno[i],0,100,cpu_valor_nucleo)
    end



   
    -- Mostrar texto
    set_color_blanco(cr)

    --local escala = calcular_escala_respecto_ventana(conky_window.width, conky_window.height)
    local escala = calcular_escala_respecto_radio(radio)
    local texto=cpu_valor .. "%"
    local texto_posicion_x = centro_x+10
    local texto_posicion_y = centro_y+(get_letra_size_grande(escala)/2)

    -- ajustar alieacion izquierda del texto
    if escala < 1 then texto_posicion_x = centro_x + (10*escala)/2 end

    mostrar_texto_grande(cr,texto_posicion_x,texto_posicion_y, texto, escala)

    texto=conky_parse("${freq_g}") .. " GHz"
    texto_posicion_y = texto_posicion_y + get_letra_size_pequenna( escala ) + 1
    mostrar_texto_pequenno(cr,texto_posicion_x,texto_posicion_y, texto, escala)

    texto_posicion_y = centro_y + radio + get_letra_size_median( escala )/3
    mostrar_texto_mediano(cr,texto_posicion_x,texto_posicion_y,"CPU", escala)

end


function medidor_temp_cpu(cr, centro_x, centro_y, radio, sensor_temperatura)
    -- body

    -- Formato de linea
    set_color_rojo(cr)
    
    local cpu_valor=conky_parse("${hwmon temp " .. sensor_temperatura .. "}")


    hacer_arco_medidor(cr,centro_x,centro_y,radio,0,100,cpu_valor, true)
    

    -- Mostrar texto
    set_color_blanco(cr)
    local escala = calcular_escala_respecto_radio(radio)

    local texto=cpu_valor .. "ºC"
    local ajuste_size_texto = 1.2
    mostrar_texto_grande(cr,centro_x-5*escala,centro_y+30*escala, texto, escala*ajuste_size_texto)
    mostrar_texto_mediano(cr,centro_x+10*escala,centro_y+radio+15*escala,"CPU", escala*ajuste_size_texto)

end