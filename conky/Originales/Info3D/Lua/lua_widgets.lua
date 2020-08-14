-- 2014-02-17 by xeXpanderx

require 'cairo'

------------------------- CONFIGURATION  ----------------------------------

------------------------- Transparency, from 0 to 1 -------------------------
transp = 0.5
------------------------- CPU config -------------------------
cpu_x_step = 10
cpu_y_step = 8
grades = 8
number_of_cpus = 8
cpu_x_start = 60
cpu_y_start = 60
cpu_widget_x_start = 15
cpu_widget_y_start = 0
cpu_widget_width = 190
cpu_widget_height = 285
------------------------- Free space -------------------------
free_space_widget_x_start = 15
free_space_widget_y_start = 330
free_space_widget_width = 190
free_space_widget_height = 240
free_space_x_start = 120
free_space_y_start = 430
free_space_radius = 50
------------------------- Temperatures -------------------------
temperatures_widget_x_start = 15
temperatures_widget_y_start = 615
temperatures_widget_width = 190
temperatures_widget_height = 265
temperatures_x_start = 120
temperatures_y_start = 620













































------------------------- Heavy code --------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--                                                                 rgb_to_r_g_b
-- converts color in hexa to decimal
--
function rgb_to_r_g_b(colour, alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end
--------------------------------------------------------------------------------------------------------------------------		

keep_y = 0

function horizontal_bar (cr, start_x,start_y, conky_value)
	cairo_set_operator(cr,CAIRO_OPERATOR_SOURCE)
	cairo_set_line_width (cr, 1);
	
	local percent_per_block = 100.0 / 20.0
	local step= 0
	local number_of_charged_blocks = math.floor((conky_value/percent_per_block)+0.5)

	cairo_stroke(cr)
	for i=1,20 do
	  cairo_rectangle (cr, start_x+step, start_y, 5, 20);
	  cairo_close_path(cr)
	  if i <= number_of_charged_blocks then
	    cairo_set_source_rgba(cr, 0,0,0,transp)	
	    cairo_fill(cr)
	  else
	    cairo_set_source_rgba(cr, 0,0,0,transp-0.3)  
	    cairo_fill(cr)
	  end
	  step = step + 8
	end
	cairo_set_source_rgba(cr, 0,0,0,transp)
end

function draw_circles(cr, x_start,y_start,radius, angle_1, angle_2, free_perc, angle_step)
	 cairo_select_font_face (cr, "Dejavu Sans Condensed", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
	 local number_of_circles = 360 / angle_step
	 local angle_start = 90
	 cairo_set_line_width(cr, 1)
	 local percent_per_circle = 100.0 / number_of_circles
	 local number_of_nonfree_circles = math.floor(((100.0 - tonumber(free_perc)) / percent_per_circle)+0.5)
	 cairo_set_source_rgba(cr, 0,0,0,transp)
	 
	for i=1,number_of_circles do
	  cairo_arc(cr,x_start+(radius*math.cos(angle_start*(math.pi/180.0))),y_start-(radius+5)+radius-(radius*math.sin(angle_start*(math.pi/180.0))),4,angle1,angle2)
	  if i <= number_of_nonfree_circles then
	    cairo_set_source_rgba(cr, 0,0,0,transp)
	    cairo_fill(cr)
	  else
	    cairo_set_source_rgba(cr, 0,0,0,transp-0.3)
	    cairo_fill(cr)
	  end
	  angle_start = angle_start - angle_step
	end
	cairo_set_source_rgba(cr, 0,0,0,transp)
	
end

function draw_widget(cr, x,y, str_conky, font_size, height, width)
	cairo_select_font_face (cr, "Dejavu Sans Condensed", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
  	cairo_set_line_width (cr, 3);
	cairo_set_operator(cr,CAIRO_OPERATOR_SOURCE)
	cairo_set_source_rgba(cr, 0,0,0,transp-0.3)	
	cairo_move_to (cr, x+10, y+27)
	cairo_arc(cr,x+10,y+27,5,0,2*math.pi) 
	cairo_move_to (cr, x+10, y+27)
	cairo_rel_line_to (cr, width, 0)
	cairo_rel_line_to (cr, 8, 8)
	cairo_rel_line_to (cr, 0, height)
	cairo_rel_line_to (cr, -8, 8)
	cairo_rel_line_to (cr, -width, 0)
	cairo_stroke (cr);
	cairo_close_path(cr)
	cairo_arc(cr,x+10,y+height+16+27,5,0,2*math.pi) 
	cairo_stroke(cr)
	
	cairo_move_to (cr, x+15, y+22)
	cairo_set_source_rgba(cr, 0,0,0,transp)
	cairo_set_font_size (cr, font_size);
	cairo_show_text (cr, str_conky)
	cairo_set_source_rgba(cr, 0,0,0,transp)
end

function draw_vertical_bars_3d(cr, x_start,y_start,x_step,y_step,grades, current_value)
	cairo_select_font_face (cr, "Dejavu Sans Condensed", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
	cairo_set_operator(cr,CAIRO_OPERATOR_SOURCE)
	cairo_set_source_rgba(cr, 0,0,0,transp)
	cairo_move_to(cr,x_start,y_start)
	cairo_rel_line_to(cr,-x_step,-y_step)
	cairo_rel_line_to(cr,x_step-x_step,y_step)
	cairo_rel_line_to(cr, x_step,y_step)
	cairo_rel_line_to(cr, x_step-x_step,-y_step)
	cairo_rel_line_to(cr, x_step,-y_step)
	cairo_rel_line_to(cr, x_step-x_step,y_step)
	cairo_rel_line_to(cr, -x_step,y_step)
	cairo_close_path(cr)

	if math.floor((current_value/(100.0/grades))+0.5) < grades then
	  cairo_stroke(cr)
	else
	  cairo_fill(cr)
	end
	
	cairo_move_to(cr, x_start+x_step,y_start-y_step)
	cairo_rel_line_to(cr, -x_step, -y_step)
	cairo_rel_line_to(cr, -x_step, y_step)
	cairo_stroke(cr)

	for i=1,(grades-1) do
	  cairo_move_to(cr, x_start+x_step,y_start+y_step*1.5*(i-1))
	  cairo_rel_line_to(cr, -x_step*0.25,y_step*0.25)
	  cairo_rel_line_to(cr, x_step*0.25,y_step*0.25)
	  cairo_stroke(cr)
	  cairo_move_to(cr, x_start-x_step*0.75,y_start+y_step*0.25+y_step*1.5*(i-1))
	  cairo_rel_line_to(cr, -x_step*0.25,y_step*0.25)
	  cairo_stroke(cr)
	  cairo_move_to(cr, x_start, y_start+y_step*1.5*i)
	  keep_y = (y_start+y_step*1.5*i+y_step) - y_start
	  cairo_rel_line_to(cr, -x_step, -y_step)
	  cairo_rel_line_to(cr, x_step-x_step, y_step)
	  cairo_rel_line_to(cr,x_step,y_step)
	  cairo_rel_line_to(cr,x_step,-y_step)
	  cairo_rel_line_to(cr,x_step-x_step,-y_step)
	  cairo_rel_line_to(cr,-x_step,y_step)
	  cairo_rel_line_to(cr,x_step-x_step,y_step)
	  cairo_close_path(cr)
	  if math.floor((current_value/(100.0/grades))+0.5) >= (grades-i) then
	    cairo_fill(cr)
	  else
	    cairo_stroke(cr)
	  end
	  
	end
end

function draw_function(cr)
  local w,h=conky_window.width,conky_window.height	
  cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
  cairo_set_line_width(cr, 1)
  cairo_set_source_rgba(cr, 0,0,0,transp)
  cairo_select_font_face (cr, "Dejavu Sans Condensed", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);


--- CPU section ---
  cairo_close_path(cr)
  cairo_set_font_size (cr, 10);
    
  counter = 1
  if number_of_cpus > 1 and number_of_cpus % 2 == 0 then
    if (number_of_cpus / 2) <= 4 then
      for j=1, 2 do
	for i=1, (number_of_cpus/2) do
	  str = '${cpu cpu' .. tostring(counter) .. '}'
	  draw_vertical_bars_3d(cr, cpu_x_start+cpu_x_step*4*(i-1),cpu_y_start+(keep_y+50)*(j-1),cpu_x_step,cpu_y_step,grades, tonumber(conky_parse(str)))
	  cairo_move_to(cr, cpu_x_start+cpu_x_step*4*(i-1)-3, cpu_y_start+(keep_y+50)*(j-1)+(keep_y+15))
	  cairo_show_text(cr, conky_parse(str) .. "%")	  
	  counter = counter+1
	end
      end
    end
  else
    draw_CPU(cr, cpu_x_start,cpu_y_start,cpu_x_step,cpu_y_step,grades, tonumber(conky_parse('${cpu cpu1}')))
  end

  draw_widget(cr, cpu_widget_x_start,cpu_widget_y_start, "CPU", 16, cpu_widget_height, cpu_widget_width) 
  
--- Free space section ---
  draw_widget(cr, free_space_widget_x_start,free_space_widget_y_start, "Free space", 16, free_space_widget_height, free_space_widget_width)
  angle1 = 0.0  * (math.pi/180.0);  
  angle2 = 360.0 * (math.pi/180.0);
  free_hd1 = conky_parse("${fs_free_perc /}")
  free_hd2 = conky_parse("${fs_free_perc /home}")
  
  draw_circles(cr, free_space_x_start,free_space_y_start,free_space_radius, angle_1, angle_2, free_hd1, 10)
  draw_circles(cr, free_space_x_start,free_space_y_start+120,free_space_radius, angle_1, angle_2, free_hd2, 10)
  cairo_set_source_rgba(cr, 0,0,0,transp)
  cairo_move_to (cr, free_space_x_start-20, free_space_y_start);
  cairo_show_text(cr, "R: " .. free_hd1 .. "%")
  cairo_move_to (cr,free_space_x_start-20, free_space_y_start+120);
  cairo_show_text(cr, "H: " .. free_hd2 .. "%")

  

--- Temperatures ---
  cairo_set_operator(cr,CAIRO_OPERATOR_OVER)
  draw_widget(cr, temperatures_widget_x_start,temperatures_widget_y_start, "Temperatures", 16, temperatures_widget_height, temperatures_widget_width)
  cairo_select_font_face (cr, "Dejavu Sans Condensed", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
  cairo_set_font_size (cr, 10);
  tmp = conky_parse("${exec sensors|grep 'Core 0:'|awk '{print $3}'| cut -b2,3,4,5}")
  horizontal_bar (cr, temperatures_x_start-75,temperatures_y_start+60, tonumber(tmp))
  cairo_close_path(cr)
  cairo_move_to(cr, temperatures_x_start-10, temperatures_y_start+50)
  --cairo_show_text(cr, "CPU 0: " .. tmp .. "\194\176C")
  cairo_show_text(cr, "CPU 0")
  
  tmp = conky_parse("${exec sensors|grep 'Core 1:'|awk '{print $3}'| cut -b2,3,4,5}")
  horizontal_bar (cr, temperatures_x_start-75,temperatures_y_start+110, tmp)
  cairo_move_to(cr, temperatures_x_start-10, temperatures_y_start+100)
  cairo_show_text(cr, "CPU 1")
  
  tmp = conky_parse("${exec sensors|grep 'Core 2:'|awk '{print $3}'| cut -b2,3,4,5}")
  horizontal_bar (cr, temperatures_x_start-75,temperatures_y_start+160, tmp)
  cairo_move_to(cr, temperatures_x_start-10, temperatures_y_start+150)
  cairo_show_text(cr, "CPU 2")
  
  tmp = conky_parse("${exec sensors|grep 'Core 3:'|awk '{print $3}'| cut -b2,3,4,5}")
  horizontal_bar (cr, temperatures_x_start-75,temperatures_y_start+210, tmp)
  cairo_move_to(cr, temperatures_x_start-10, temperatures_y_start+200)
  cairo_show_text(cr, "CPU 3")
  
  
  tmp = conky_parse("${exec nvidia-smi | grep 'GeForce' -A 1 | tail -n 1 | awk '{print $3}' | cut -b1,2}")
  horizontal_bar (cr, temperatures_x_start-75,temperatures_y_start+260, tmp)
  cairo_move_to(cr, temperatures_x_start-25, temperatures_y_start+250)
  cairo_show_text(cr, "Nvidia GPU")
end

function conky_start_widgets()
	local function draw_conky_function(cr)
		local str=''
		local value=0		
		draw_function(cr)
	end
	
	-- Check that Conky has been running for at least 5s

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
	
	local cr=cairo_create(cs)	
	
	local updates=conky_parse('${updates}')
	update_num=tonumber(updates)
	
	if update_num>5 then
		draw_conky_function(cr)
	end
	cairo_surface_destroy(cs)
	cairo_destroy(cr)
end
