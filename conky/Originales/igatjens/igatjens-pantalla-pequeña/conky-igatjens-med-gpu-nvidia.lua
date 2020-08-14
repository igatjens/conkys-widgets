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

    local mostrar_temperatura = true

    local radio = calcular_radio_medidor(conky_window.height)
    local posicion_x = calcular_posicion_x_medidor( radio ) + get_med_gpu_nvidia_margen_izquierdo( )
    local posicion_y = calcular_posicion_y_medidor( radio )
    
    -- GPU --
    if mostrar_temperatura then
        local escala = calcular_escala_respecto_radio(radio)
        local posicion_x_temp = posicion_x + 80*escala
        local posicion_y_temp = posicion_y - 30*escala
        local radio_temp = 20*escala

        medidor_temp_gpu(cr, posicion_x_temp, posicion_y_temp, radio_temp)
    end

    medidor_gpu(cr, posicion_x, posicion_y, radio)



    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end


function medidor_gpu(cr, centro_x, centro_y, radio)
    
    local gpu_valor=conky_parse("${nvidia gpuutil}")
    local vram_valor=conky_parse("${nvidia membwutil}")

    -- medidor GPU
    set_color_fusia(cr)
    hacer_arco_medidor(cr,centro_x,centro_y,radio,0,100,gpu_valor,true)

    -- medidor VRAM
    set_color_verde(cr)
    local radio_interno1 = radio * get_medidor_relacion_arco_interno( )/100 -- porcentaje menor al radio
    hacer_arco_medidor(cr,centro_x,centro_y,radio_interno1,0,100,vram_valor,false)


    -- mostrar texto
    set_color_blanco(cr)

    --local escala = calcular_escala_respecto_ventana(conky_window.width, conky_window.height)
    local escala = calcular_escala_respecto_radio(radio)
    local texto=gpu_valor .. "%"
    local texto_posicion_x = centro_x+10
    local texto_posicion_y = centro_y+(get_letra_size_grande(escala)/2)

    -- ajustar alieacion izquierda del texto
    if escala < 1 then texto_posicion_x = centro_x + (10*escala)/2 end

    mostrar_texto_grande(cr,texto_posicion_x,texto_posicion_y, texto, escala)

    texto=conky_parse("${nvidia gpufreq}") .. " MHz"
    texto_posicion_y = texto_posicion_y + get_letra_size_pequenna( escala ) + 1
    mostrar_texto_pequenno(cr,texto_posicion_x,texto_posicion_y, texto, escala)

    texto = "VRAM " .. vram_valor .. "%"
    texto_posicion_y = centro_y + radio_interno1 + get_letra_size_pequenna( escala )/3
    mostrar_texto_pequenno(cr,texto_posicion_x,texto_posicion_y, texto, escala)

    texto_posicion_y = centro_y + radio + get_letra_size_median( escala )/3
    mostrar_texto_mediano(cr,texto_posicion_x,texto_posicion_y,"GPU", escala)

end


function medidor_temp_gpu(cr, centro_x, centro_y, radio)
    -- body

    -- Formato de linea
    set_color_rojo(cr)
    
    local gpu_valor=conky_parse("${nvidia temp}")


    hacer_arco_medidor(cr,centro_x,centro_y,radio,0,100,gpu_valor, true)
    

    -- Mostrar texto
    set_color_blanco(cr)
    local escala = calcular_escala_respecto_radio(radio)

    local texto=gpu_valor .. "ºC"
    local ajuste_size_texto = 1.2
    mostrar_texto_grande(cr,centro_x-5*escala,centro_y+30*escala, texto, escala*ajuste_size_texto)
    mostrar_texto_mediano(cr,centro_x+10*escala,centro_y+radio+15*escala,"GPU", escala*ajuste_size_texto)

end