-- blofeld customisations for gauges
--
-- the function customise is executed by the main script; this script needs to
-- populate the supplied table with the details for the required values
function customise(params)
   params['coreTemps'] = { '${hwmon temp 2} °C',
			   '${hwmon temp 2} °C',
			}
   params['hddTemp'] = '${hwmon 1 temp 3} °C'
end