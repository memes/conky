-- iapetus customisations for gauges
--
-- the function customise is executed by the main script; this script needs to
-- populate the supplied table with the details for the required values

-- Setup 
function customise(params)
   params['cpuDisplayName'] = 'i7-3630QM'
   params['batteryObj'] = 'BAT1'
   params['coreTemps'] = { '${hwmon 1 temp 2} °C',
			   '${hwmon 1 temp 2} °C',
			   '${hwmon 1 temp 3} °C',
			   '${hwmon 1 temp 3} °C',
			   '${hwmon 1 temp 4} °C',
			   '${hwmon 1 temp 4} °C',
			   '${hwmon 1 temp 5} °C',
			   '${hwmon 1 temp 5} °C',
			}
end
