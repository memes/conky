-- ganymede customisations for gauges
--
-- the function customise is executed by the main script; this script needs to
-- populate the supplied table with the details for the required gauages
function customise(params)
   -- display a clock
   table.insert(params, { name = 'time', arg = '%I',
			  x = 120, y = 80, radius = 53, width = 3,
			  start_radian = 3 * math.pi / 2,
			  end_radian = 7 * math.pi / 2,
			  used_alpha = 0.3, unused_alpha = 0.0,
			  indicator_font_size = 10.0,
			  indicator_font_weight = CAIRO_FONT_WEIGHT_BOLD,
			  indicator_offset = -9, indicator_alpha = 0.6,
			  max_value = 12,
			  critical_trip = 0,
		       })
   table.insert(params, { name = 'time', arg = '%M',
			  x = 120, y = 80, radius = 57, width = 2,
			  start_radian = 3 * math.pi / 2,
			  end_radian = 7 * math.pi / 2,
			  used_alpha = 0.3,
			  indicator_font_size = 9.0, indicator_alpha = 0.6,
			  max_value = 60,
			  critical_trip = 0,
		       })
   table.insert(params, { name = 'time', arg = '%S',
			  x = 120, y = 80, radius = 50, width = 2,
			  start_radian = 3 * math.pi / 2,
			  end_radian = 7 * math.pi / 2,
			  used_alpha = 0.2, 
			  used_dash = 2.662366656, -- 50 * 2 * pi / 118
			  unused_alpha = 0.0,
			  indicator_font_size = 12.0, indicator_alpha = 0.3,
			  indicator_offset = - 9,
			  max_value = 60,
			  critical_trip = 0,
		       })
   -- CPU with multiple-cores; one gauge showing an aggregate
   table.insert(params, { name = 'cpu', arg = 'cpu0',
                          x = 85, y = 190,
                       })
   -- Memory and swap use as percentage
   table.insert(params, { name = 'memperc',
			  x = 85, y = 285,
		       })
   table.insert(params, { name = 'swapperc',
			  x = 85, y = 285, radius = 18,
			  indicator_offset = -9,
		       })
   -- Temperature; one gauge for CPU core, using a range of 30-110C with
   --              captions indicating which is which. Assume that 90C is
   --              critical so adjust to 0.75
   table.insert(params, { name = 'hwmon', arg = 'temp 1', caption = 'CPU',
			  x = 85, y = 380,
			  min_value = 30, max_value = 110, critical_trip = 0.75,
		       })
   -- Battery charge gauge; indicate a low trip of 20%
   table.insert(params, { name = 'battery_percent',
			  x = 85, y = 475, caption = 'BAT',
			  critical_trip = 0.2, inverse_trip = true,
		       })
   -- Volume
   table.insert(params, { name = 'mixer',
			  x = 85, y = 570,
			  critical_trip = 0.8,
		       })
end
