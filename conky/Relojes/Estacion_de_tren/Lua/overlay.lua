require 'imlib2'

function init_drawing_surface()
    imlib_context_set_dither(1)
end

function draw_image()
    init_drawing_surface()
    
    --you'll need to change the path here (keep it absolute!)
    image = imlib_load_image("/home/deco/.conky/flipclock/overlay.png")
    if image == nil then return end
    imlib_context_set_image(image)
    imlib_render_image_on_drawable(20,49)
    imlib_free_image()
end



function conky_start()
    if conky_window == nil then return end
    draw_image()
end
