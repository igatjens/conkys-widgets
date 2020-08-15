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





require "conky-igatjens-lib-tools"
require "conky-igatjens-lib-texto"

local ancho_linea = 10
local ancho_linea_fina = 5
local relacion_arco_interno = 70
local radio_medidor_referencia = 73
local margen_izq = 10
local margen_arriba_abajo = 5

function get_medidor_ancho_linea( )
    return ancho_linea
end

function get_medidor_ancho_linea_fina( )
    return ancho_linea_fina
end

function get_medidor_relacion_arco_interno( )
    return relacion_arco_interno
end

function get_medidor_margen_izq( )
    return margen_izq
end

function get_margen_arriba_abajo( )
    return margen_arriba_abajo
end

function hacer_arco(cr, centro_x, centro_y, radio, arco_inicio, arco_fin)
    -- body
    cairo_arc (cr, centro_x, centro_y, radio, arco_inicio, arco_fin)
    cairo_stroke (cr)
end



-- crea un medidor con opción de fondo
function hacer_arco_compuesto( cr, centro_x, centro_y, radio, min_valor, max_valor, valor, mostrar_fondo, grosor_arco_medicion, grosor_arco_fondo)
    -- body
    -- Medidas
    local arco_inicio=0.5*math.pi
    local arco_fin=1.8*math.pi
    mostrar_fondo = mostrar_fondo or false
    grosor_arco_medicion= grosor_arco_medicion or 10
    grosor_arco_fondo= grosor_arco_fondo or 2

    
    if mostrar_fondo == true then
        -- Formato de linea fondo
        cairo_set_line_width (cr,grosor_arco_fondo)
        cairo_set_line_cap  (cr, CAIRO_LINE_CAP_BUTT)
        -- cairo_set_line_cap  (cr, CAIRO_LINE_CAP_SQUARE)

        -- Dibujar arco de fondo
        radio_arco_fondo= radio-(grosor_arco_medicion/2)+(grosor_arco_fondo/2)
        hacer_arco (cr, centro_x, centro_y, radio_arco_fondo, arco_inicio, arco_fin)
    end


    local medicion= (100/(max_valor-min_valor))*valor

    -- Dibujar arco de medicion
    local arco_fin=(((medicion/100)*1.3)+0.5)*math.pi
    cairo_set_line_width (cr,grosor_arco_medicion)
    hacer_arco (cr, centro_x, centro_y, radio, arco_inicio, arco_fin)

end


-- crea un medidor normal
function hacer_arco_medidor( cr, centro_x, centro_y, radio, min_valor, max_valor, valor, mostrar_fondo)

    mostrar_fondo = mostrar_fondo or false
    hacer_arco_compuesto( cr, centro_x, centro_y, radio, min_valor, max_valor, valor, mostrar_fondo, ancho_linea, 2)

end


-- crea un medidor con un de ancho fino sin fondo
function hacer_arco_medidor_fino( cr, centro_x, centro_y, radio, min_valor, max_valor, valor)

    hacer_arco_compuesto( cr, centro_x, centro_y, radio, min_valor, max_valor, valor, false, ancho_linea_fina, 2)

end


function calcular_radio_medidor( alto_ventana )
    return alto_ventana/2 - ancho_linea*0.5 - 3 - margen_arriba_abajo
end

function calcular_posicion_x_medidor( radio )
  local ajuste_margen_medidor = ancho_linea/2
  return radio+ajuste_margen_medidor+margen_izq
end

function calcular_posicion_y_medidor( radio )
  local ajuste_margen_medidor = ancho_linea/2
  return radio+ajuste_margen_medidor+margen_arriba_abajo
end

function calcular_escala_respecto_radio( radio )
    return porcentaje(radio_medidor_referencia, radio)/100
end