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

    local part1 = get_med_disk_paticion01( )
    local part2 = get_med_disk_paticion02( )
    local part3 = get_med_disk_paticion03( )

    
    -- CPU --
    medidor_discos(cr, posicion_x, posicion_y, radio, part1, part2, part3)

    


    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end


function medidor_discos(cr, centro_x, centro_y, radio, part1, part2, part3)

    part1 = part1 or "/"
    part2 = part2 or "/home"
    part3 = part3 or ""
    
    local part1_porciento=conky_parse("${fs_used_perc " .. part1 .."}")
    local part2_porciento=conky_parse("${fs_used_perc " .. part2 .."}")
    local part3_porciento=conky_parse("${fs_used_perc " .. part3 .."}")

    local porcentaje_reduccion = get_medidor_relacion_arco_interno( )/100

    if part3 ~= "" then
        porcentaje_reduccion = porcentaje_reduccion + 0.05
        part3_porciento=conky_parse("${fs_used_perc " .. part3 .."}")
    end

    -- mostrar medidor
    set_color_morado(cr)
    hacer_arco_medidor(cr,centro_x,centro_y,radio,0,100,part1_porciento,true)



    -- Medidor particion2
    local radio_interno1=radio*porcentaje_reduccion
    if part2 ~= "" then
        set_color_azul(cr)
        hacer_arco_medidor(cr,centro_x,centro_y,radio_interno1,0,100,part2_porciento,false)
    end


    local escala = calcular_escala_respecto_radio(radio)


    -- Medidor particion3
    local radio_interno2 = 1
    if part3 ~= "" then
        set_color_verde(cr)
        radio_interno2=radio_interno1-(17*escala)
        hacer_arco_medidor(cr,centro_x,centro_y,radio_interno2,0,100,part3_porciento,false)
    end



    -- mostrar texto
    set_color_blanco(cr)

    --local escala = calcular_escala_respecto_ventana(conky_window.width, conky_window.height)
    local texto="Disk"
    local texto_posicion_x = centro_x+10
    local texto_posicion_y = centro_y+(get_letra_size_grande(escala)/2)

    -- ajustar alieacion izquierda del texto
    if escala < 1 then texto_posicion_x = centro_x + (10*escala)/2 end

    mostrar_texto_grande(cr,texto_posicion_x,texto_posicion_y, texto, escala)

    if part3 ~= "" then
        texto = part3_porciento .. "% " .. part3
        texto_posicion_y = centro_y + radio_interno2 + get_letra_size_pequenna( escala )/3
        mostrar_texto_pequenno(cr,texto_posicion_x,texto_posicion_y, texto, escala)
    end
    if part2 ~= "" then
        texto = part2_porciento .. "% " .. part2
        texto_posicion_y = centro_y + radio_interno1 + get_letra_size_pequenna( escala )/3
        mostrar_texto_pequenno(cr,texto_posicion_x,texto_posicion_y, texto, escala)
    end
    texto = part1_porciento .. "% " .. part1
    texto_posicion_y = centro_y + radio + get_letra_size_median( escala )/3
    mostrar_texto_mediano(cr,texto_posicion_x,texto_posicion_y, texto, escala)

end