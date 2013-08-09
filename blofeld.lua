-- blofeld customisations for gauges
--
-- the function customise is executed by the main script; this script needs to
-- populate the supplied table with the details for the required values
function customise(params)
   params['cpuDisplayName'] = 'i7-3520M'
   params['coreTemps'] = { '${hwmon 2 temp 2} °C',
			   '${hwmon 2 temp 2} °C',
			   '${hwmon 2 temp 3} °C',
			   '${hwmon 2 temp 3} °C',
			}
end
