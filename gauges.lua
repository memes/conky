--
-- Generate gauges for conky
--  heavily inspired by conky_grey, etc, but all new code

-- Use cairo libraries for drawing
require 'cairo'

-- default parameters used in the absence of specific parameters
-- default gauge arc; 3/4 circle with starting point at 6 o'clock
-- default gauge sizing; 24px with line width of 5px
-- default caption sizing; Liberation Sans 7pt Bold
-- default gauge colouring; white with alpha 0.3 for value, 
--                          white with alpha 0.1 for remainder of arc,
--                          white with alpha 1.0 for values above critical point
--                          critical point defined as 90% of range
local default = {
   start_radian = math.pi / 2,
   end_radian = 2 * math.pi,
   radius = 24,
   width = 5,
   used_colour = 0xffffff,
   used_alpha = 0.5,
   used_dash = nil,
   unused_colour = 0xffffff,
   unused_alpha = 0.1,
   unused_dash = nil,
   critical_colour = 0xffffff,
   critical_alpha = 1.0,
   critical_trip = 0.9,
   inverse_trip = false,
   caption_font = 'Liberation Sans',
   caption_font_size = 7.0,
   caption_font_slant = CAIRO_FONT_SLANT_NORMAL,
   caption_font_weight = CAIRO_FONT_WEIGHT_BOLD,
   caption_colour = 0xffffff,
   caption_alpha = 0.5,
   caption_offset = 5,
   caption_rotate = true,
   indicator_font = 'Liberation Sans',
   indicator_font_size = 7.0,
   indicator_font_slant = CAIRO_FONT_SLANT_NORMAL,
   indicator_font_weight = CAIRO_FONT_WEIGHT_NORMAL,
   indicator_colour = 0xffffff,
   indicator_alpha = 0.3,
   indicator_offset = 9,
}

-- get a colour tuple for the supplied rgb and alpha values
function get_rgba_tuple(rgb, alpha)
  return ((rgb / 0x010000) % 0x000100) / 255., ((rgb / 0x000100) % 0x000100) / 255., (rgb % 0x000100) / 255., alpha
end

-- returns the value of a parameter or a default value
function get_parameter(key, params)
   local value = nil
   if (key) then
      if (params) then
	 value = params[key]
      end
      if (value == nil) then
	 value = default[key]
      end
   end
   return value
end

-- draws a gauge that is shaded according to the value passed
function draw_gauge(display, value, params)
   -- make sure that value is between 0 and 1
   local sanitised_value = math.min(1, math.max(0, get_fraction(value, params) or 0))
   local start_radian = get_parameter('start_radian', params)
   local end_radian = get_parameter('end_radian', params)
   while (end_radian < start_radian) do
      end_radian = end_radian + 2 * math.pi;
   end

   local position_radian = sanitised_value * (end_radian - start_radian) +
                          start_radian;
   if (position_radian > end_radian) then
      position_radian = end_radian
   end

   local x, y, radius, width, critical, inverse_trip =
      get_parameter('x', params),
      get_parameter('y', params),
      get_parameter('radius', params),
      get_parameter('width', params),
      get_parameter('critical_trip', params),
      get_parameter('inverse_trip', params)
   if (x and y and radius and width) then
      -- draw the value arc
      local used_dash = get_parameter('used_dash', params)
      if (used_dash and used_dash > 0) then
	 cairo_set_dash(display, used_dash, 1, used_dash / 2)
      end
      cairo_arc(display, x, y, radius, start_radian, position_radian)
      if (critical and critical > 0 and
	  ((not inverse_trip and sanitised_value >= critical) or
	  (inverse_trip and sanitised_value <= critical))) then
	 cairo_set_source_rgba(display,
			       get_rgba_tuple(get_parameter('critical_colour', params),
					      get_parameter('critical_alpha', params)))
      else
	 cairo_set_source_rgba(display,
			       get_rgba_tuple(get_parameter('used_colour', params),
					      get_parameter('used_alpha', params)))
      end
      cairo_set_line_width(display, width)
      cairo_stroke(display)
      if (used_dash and used_dash > 0) then
	 cairo_set_dash(display, 0, 0, 0)
      end

      -- draw the remaining unused portion of the arc, if necessary
      if (position_radian < end_radian) then	
	 local unused_dash = get_parameter('unused_dash', params)
         if (unused_dash and unused_dash > 0) then
	    cairo_set_dash(display, unused_dash, 1, 0)
	 end
         cairo_arc(display, x, y, radius, position_radian, end_radian)
         cairo_set_source_rgba(display,
                               get_rgba_tuple(get_parameter('unused_colour',
                                                            params),
                                              get_parameter('unused_alpha',
                                                            params)))
         cairo_stroke(display)
	 if (unused_dash and unused_dash > 0) then
	    cairo_set_dash(display, 0, 0, 0)
	 end
      end

      -- draw caption?
      local caption = get_parameter('caption', params)
      if (caption) then
         local cfont, cfont_size, cfont_slant, cfont_weight, cfont_colour,
               cfont_alpha, coffset, crotate =
            get_parameter('caption_font', params),
            get_parameter('caption_font_size', params),
            get_parameter('caption_font_slant', params),
            get_parameter('caption_font_weight', params),
            get_parameter('caption_colour', params),
            get_parameter('caption_alpha', params),
            get_parameter('caption_offset', params),
            get_parameter('caption_rotate', params)
         if (coffset == nil) then
            coffset = 0
         end
         local xc = radius * math.cos(start_radian) + x +
                    (width / 2) * math.sin((math.pi / 2) - start_radian) +
                    coffset * math.cos((math.pi / 2) - start_radian)
         local yc = radius * math.sin(start_radian) + y +
                    (width / 2) * math.cos((math.pi / 2) - start_radian) -
                    coffset * math.sin((math.pi / 2) - start_radian)
         cairo_select_font_face(display, cfont, cfont_slant, cfont_weight);
         cairo_set_font_size(display, cfont_size)
         cairo_set_source_rgba(display,
                               get_rgba_tuple(cfont_colour, cfont_alpha))

         cairo_move_to(display, xc, yc)
         if (crotate) then
            cairo_rotate(display, start_radian - (math.pi / 2))            
         end
         cairo_show_text(display, caption)
         cairo_stroke(display)
      end

      -- draw indicator value
      local ifont, ifont_size, ifont_slant, ifont_weight, ifont_colour,
            ifont_alpha, ioffset =
         get_parameter('indicator_font', params),
         get_parameter('indicator_font_size', params),
         get_parameter('indicator_font_slant', params),
         get_parameter('indicator_font_weight', params),
         get_parameter('indicator_colour', params),
         get_parameter('indicator_alpha', params),
         get_parameter('indicator_offset', params)
      cairo_select_font_face(display, ifont, ifont_slant, ifont_weight);
      cairo_set_font_size(display, ifont_size)
      cairo_set_source_rgba(display,
                            get_rgba_tuple(ifont_colour, ifont_alpha))
      local e = cairo_text_extents_t:create()
      cairo_text_extents(display, value, e)
      local xi = (radius + ioffset) * math.cos(position_radian) + x -
                 (e.width / 2 + e.x_bearing)
      local yi = (radius + ioffset) * math.sin(position_radian) + y -
                 (e.height / 2 + e.y_bearing)
      cairo_move_to(display, xi, yi)
      cairo_show_text(display, value)
      cairo_stroke(display)
   end
end

-- given a value and a maximum and minimum value, return the fraction of unity
-- that matches the value position between maximum and minimum
-- Note: in the absence of params defaults to 0-100 as range of values
function get_fraction(value, params)
   local sanitised_value = value or 0
   local min_value = params['min_value'] or 0
   local max_value = params['max_value'] or 100

   -- just in case of reversed values
   if (min_value > max_value) then
      max_value = params['min_value'] or 100
      min_value = params['max_value'] or 0
   end

   return math.min(1, (sanitised_value - min_value) / (max_value - min_value));
end

-- return the conky value for the function/variable and argument combination
function get_conky_value(data)
   local value = nil
   local name, argument = data['name'], data['arg'] or ''
   if (name) then
      local raw_value = conky_parse(string.format('${%s %s}', name, argument))
      if (raw_value) then
	 value = tonumber(raw_value)
      end
   end
   return value
end

-- conky entry point
function conky_main()
   if (conky_window == nil) then
      return
   end

   -- try to load a file named after the current host and use it to customise
   -- the parameters used by the gauges
   local params = {}
   local hostname = conky_parse('${nodename_short}')
   local customisation_file = string.sub(string.gsub(debug.getinfo(1).source, 'gauges', hostname), 2)
   local customisation_script, error = loadfile(customisation_file)
   if (not error) then
      customisation_script()
      customise(params)
   end
   
   local surface = cairo_xlib_surface_create(conky_window.display,
					     conky_window.drawable,
					     conky_window.visual,
					     conky_window.width,
					     conky_window.height)
   local display = cairo_create(surface)
   local updates = conky_parse('${updates}')
   local update_num = tonumber(updates) or 0
   if (update_num > 5) then
      for index, data in ipairs(params) do
	 local value = get_conky_value(data)
	 if (value) then
	    draw_gauge(display, value, data)
	 end
      end
   end
  
   cairo_surface_destroy(surface);
   cairo_destroy(display)
end
