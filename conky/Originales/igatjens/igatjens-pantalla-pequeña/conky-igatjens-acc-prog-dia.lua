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



    medidor_progreso_tiempo(cr, posicion_x, posicion_y, radio)

    


    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end


function medidor_progreso_tiempo(cr, centro_x, centro_y, radio)

    local porcentaje_reduccion = (get_medidor_relacion_arco_interno( )/100)

    local dia_en_segundos = 86400

    local year_actual = os.date("%Y")
    local year_siguiente = year_actual+1

    local mes_actual = os.date("%m")
    local mes_siguente = mes_actual + 1

    local dia_actual = os.date("%d")


    local cantidad_dias_year = (os.time{year=year_siguiente, month=1, day=1, hour=0} - os.time{year=year_actual, month=1, day=1, hour=0}) / dia_en_segundos

    --calcular cantidad de días del mes
    local cantidad_dias_mes = 1

    if mes_actual ~= 12 then
        cantidad_dias_mes = (os.time{year=year_actual, month=mes_siguente, day=1, hour=0} - os.time{year=year_actual, month=mes_actual, day=1, hour=0}) / dia_en_segundos
    else
        mes_siguente = 1
        cantidad_dias_mes = (os.time{year=year_siguiente, month=mes_siguente, day=1, hour=0} - os.time{year=year_actual, month=mes_actual, day=1, hour=0}) / dia_en_segundos
    end
    

    local minuto_cero_hoy = os.time{year = year_actual, month = mes_actual, day = dia_actual, hour = 0, min = 0, sec = 0}
    local minuto_actual_del_dia = os.time()


    -- pruebas
    -- minuto_actual_del_dia = minuto_cero_hoy + 3600 * 12

    local minuto_inicio_dia_laboral = minuto_cero_hoy + (60 * get_hora_laboral_inicio() + get_minuto_laboral_inicio() ) * 60
    local minuto_fin_dia_laboral = minuto_cero_hoy + (60 * get_hora_laboral_fin() + get_minuto_laboral_fin() ) * 60

    if minuto_fin_dia_laboral < minuto_inicio_dia_laboral then
        if (minuto_inicio_dia_laboral < minuto_actual_del_dia) and (minuto_actual_del_dia < (minuto_cero_hoy + dia_en_segundos)) then
            minuto_fin_dia_laboral = minuto_fin_dia_laboral + dia_en_segundos
        else
            minuto_inicio_dia_laboral = minuto_inicio_dia_laboral - dia_en_segundos
        end
    end


    local minuto_actual_dia_laboral = minuto_actual_del_dia - minuto_inicio_dia_laboral
    local porciento_dia_laboral = porcentaje(minuto_fin_dia_laboral-minuto_inicio_dia_laboral, minuto_actual_dia_laboral)
    local en_jornada_laboral = true

    if porciento_dia_laboral < 0 then
        porciento_dia_laboral = 0
        en_jornada_laboral = false
    elseif porciento_dia_laboral > 100 then
        
        if porciento_dia_laboral < 120 then
        porciento_dia_laboral = 100
        else
            porciento_dia_laboral = 0
        end

        en_jornada_laboral = false
    end


    local escala = calcular_escala_respecto_radio(radio)

    -- mostrar progreso del dia
    local posicion_x_medidor_dia = centro_x + 80*escala + 7
    local posicion_y_medidor_dia = centro_y - 30*escala - 10
    local radio_medidor_dia = 20*escala

    medidor_prog_dia(cr, posicion_x_medidor_dia, posicion_y_medidor_dia, radio_medidor_dia, os.date("%a"), porcentaje(dia_en_segundos, minuto_actual_del_dia - minuto_cero_hoy))



    -- mostrar dia laboral
    set_color_verde(cr)
    hacer_arco_medidor(cr,centro_x,centro_y,radio,0,100,porciento_dia_laboral,true)



    -- Medidor mes
    local radio_interno1 = radio*porcentaje_reduccion
    local dia_del_mes = dia_actual
    
  
    set_color_morado(cr)
    hacer_arco_medidor(cr,centro_x,centro_y,radio_interno1,0,cantidad_dias_mes,dia_del_mes,false)
    

    


    -- Medidor year
    local separacion = 12

    if escala > 1 then
        separacion = separacion * escala
    end

    local radio_interno2=radio_interno1-(separacion)
    local dia_del_year = os.date("*t").yday

    

    set_color_azul(cr)
    hacer_arco_medidor(cr,centro_x,centro_y,radio_interno2,0,cantidad_dias_year,dia_del_year,false)
    



    -- mostrar texto
    set_color_blanco(cr)

    --local escala = calcular_escala_respecto_ventana(conky_window.width, conky_window.height)
    local texto = porciento_dia_laboral .. "%"
    local texto_posicion_x = centro_x+10
    local texto_posicion_y = centro_y+(get_letra_size_grande(escala)/2)

    -- ajustar alieacion izquierda del texto
    if escala < 1 then texto_posicion_x = centro_x + (10*escala)/2 end

    mostrar_texto_grande(cr,texto_posicion_x,texto_posicion_y, texto, escala)


    texto = year_actual .. "   " .. porcentaje(cantidad_dias_year, dia_del_year) .. "%"
    texto_posicion_y = centro_y + radio_interno2 + get_letra_size_pequenna( escala )/3
    mostrar_texto_pequenno(cr,texto_posicion_x,texto_posicion_y, texto, escala)


    texto = os.date("%B   ") .. porcentaje(cantidad_dias_mes, dia_del_mes) .. "%"
    texto_posicion_y = centro_y + radio_interno1 + get_letra_size_pequenna( escala )/3
    mostrar_texto_pequenno(cr,texto_posicion_x,texto_posicion_y, texto, escala)

    if en_jornada_laboral == false then
        texto = "Fuera de joranda"
        texto_posicion_y = centro_y + radio - get_letra_size_pequenna( escala )/3 + 3
        mostrar_texto_pequenno(cr,texto_posicion_x,texto_posicion_y, texto, escala)

        texto = os.date("%H:%M", minuto_inicio_dia_laboral) .. " - " .. os.date("%H:%M", minuto_fin_dia_laboral)
        texto_posicion_y = centro_y + radio + get_letra_size_median( escala )/3 + 2
        mostrar_texto_pequenno(cr,texto_posicion_x,texto_posicion_y, texto, escala)
    else
        texto = os.date("%H:%M", minuto_actual_del_dia)
        --texto = "miércoles"
        texto_posicion_y = centro_y + radio + get_letra_size_median( escala )/3
        mostrar_texto_mediano(cr,texto_posicion_x,texto_posicion_y, texto, escala)

        texto = "/" .. os.date("%H:%M", minuto_fin_dia_laboral)
        mostrar_texto_pequenno(cr,texto_posicion_x+radio,texto_posicion_y, texto, escala)
    end

end




function medidor_prog_dia(cr, centro_x, centro_y, radio, dia, valor)
    -- body

    -- Formato de linea
    set_color_azul(cr)
    

    hacer_arco_medidor(cr,centro_x,centro_y,radio,0,100,valor, true)
    

    -- Mostrar texto
    set_color_blanco(cr)
    local escala = calcular_escala_respecto_radio(radio)

    local texto= valor .. "%"
    local ajuste_size_texto = 1.2
    mostrar_texto_grande(cr,centro_x-5*escala,centro_y+30*escala, texto, escala*ajuste_size_texto)
    mostrar_texto_mediano(cr,centro_x+10*escala,centro_y+radio+15*escala, dia, escala*ajuste_size_texto)

end