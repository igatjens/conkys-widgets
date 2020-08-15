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


-- formato de color rgba - format rgba
local color_azul = {0.098,0.863,1,1}
local color_verde = {0.604,0.871,0,1}
local color_rojo = {1,0,0,1}
local color_fusia = {0.961,0,0.561,1}
local color_morado = {0.729,0,1,1}
local color_naranja = {1,0.42,0,1}
local color_blanco = {1,1,1,1}

function set_color( cr, tabla_color)
	cairo_set_source_rgba (cr,tabla_color[1],tabla_color[2],tabla_color[3],tabla_color[4])
end


function set_color_azul( cr )
	set_color(cr, color_azul)
end


function set_color_verde( cr )
	set_color(cr, color_verde)
end


function set_color_rojo( cr )
	set_color(cr, color_rojo)
end


function set_color_fusia( cr )
	set_color(cr, color_fusia)
end


function set_color_morado( cr )
	set_color(cr, color_morado)
end


function set_color_naranja( cr )
	set_color(cr, color_naranja)
end


function set_color_blanco( cr )
	set_color(cr, color_blanco)
end