-- blofeld customisations for gauges
--
-- the function customise is executed by the main script; this script needs to
-- populate the supplied table with the details for the required values
function customise(params)
   params['cpuDisplayName'] = 'i5-4310U'
   params['coreTemps'] = { '${hwmon 2 temp 1} °C' }
   params['rfkillObj'] = 'rfkill1'
end
