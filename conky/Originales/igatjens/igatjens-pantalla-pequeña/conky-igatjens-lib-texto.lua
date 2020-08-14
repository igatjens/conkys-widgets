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





local letra_size_grande = 50
local letra_size_mediana = 30
local letra_size_etiqueta = 18
local letra_size_pequenna = 15


function set_fuente( cr )
	font="URW Gothic L"
	-- font="Arial"
	-- font="DejaVu Sans"
	-- font="Ubuntu"
	-- font="DejaVu Sans Mono"
	-- font="FreeMono"
	font_slant=CAIRO_FONT_SLANT_NORMAL
	font_face=CAIRO_FONT_WEIGHT_NORMAL
	cairo_select_font_face (cr, font, font_slant, font_face)
end


function mostrar_texto(cr, posicion_x, posicon_y, font_size, texto, alinear )

	alinear = alinear or "izquierda"
	local x = posicion_x
    cairo_set_font_size (cr, font_size)


	if alinear ~= "izquierda" then
		local extents = cairo_text_extents_t:create()
		tolua.takeownership(extents)
		
		cairo_text_extents(cr, texto, extents)

		if alinear == "centro" then
			local ancho_texto = extents.width
			local tolerancia = 15

			ancho_texto = round(ancho_texto/tolerancia) * tolerancia
			x = posicion_x - (ancho_texto / 2 + extents.x_bearing)
		elseif alinear == "derecha" then
			x = posicion_x - (extents.width + extents.x_bearing)
		end
	end


    cairo_move_to (cr,x,posicon_y)
    cairo_show_text (cr,texto)
    cairo_stroke (cr)
end



function corregir_escala_letra( escala )
	if escala > 1 then escala = 1 end
	return escala
end



function get_letra_size_grande( escala )
	return letra_size_grande*corregir_escala_letra(escala)
end

function get_letra_size_median( escala )
	return letra_size_mediana*corregir_escala_letra(escala)
end

function get_letra_size_etiqueta( escala )
	return letra_size_etiqueta*corregir_escala_letra(escala)
end

function get_letra_size_pequenna( escala )
	return letra_size_pequenna*corregir_escala_letra(escala)
end



function mostrar_texto_grande( cr, posicion_x, posicon_y, texto, escala)
	escala = corregir_escala_letra(escala)
	mostrar_texto(cr, posicion_x, posicon_y, letra_size_grande*escala, texto)
end

function mostrar_texto_mediano( cr, posicion_x, posicon_y, texto, escala)
	escala = corregir_escala_letra(escala)
	mostrar_texto(cr, posicion_x, posicon_y, letra_size_mediana*escala, texto)
end

function mostrar_texto_etiqueta( cr, posicion_x, posicon_y, texto, escala)
	escala = corregir_escala_letra(escala)
	mostrar_texto(cr, posicion_x, posicon_y, letra_size_etiqueta*escala, texto)
end

function mostrar_texto_pequenno( cr, posicion_x, posicon_y, texto, escala)
	escala = corregir_escala_letra(escala)
	mostrar_texto(cr, posicion_x, posicon_y, letra_size_pequenna*escala, texto)
end

