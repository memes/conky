-- Simple lua script for conky

-- Default parameters for objects; override in host specific file
local params = {
}

-- Prepare the one time variables
function conky_startup()
   local hostname = conky_parse('${nodename_short}')
   local customisation_file = string.sub(string.gsub(debug.getinfo(1).source, 'conky\.lua', hostname .. '.lua'), 2)
   local customisation_script, error = loadfile(customisation_file)
   if (not error) then
      customisation_script()
      customise(params)
   end
end

-- Return the cpu type for this system
function conky_cpuDisplayName()
   return params['cpuDisplayName'] or ''
end

-- Return the battery object for this system
function conky_batteryObj()
   return string.format('${battery_bar %s}',  params['batteryObj'] or 'BAT0')
end

-- Return the cpu temperature for core
function conky_cpuTemp(core)
   local coreIndex = tonumber(core)
   if (params['coreTemps'] and params['coreTemps'][coreIndex + 1]) then
      return params['coreTemps'][coreIndex + 1]
   else
      return ''
   end
end

-- Return the HDD temperature
function conky_hddTemp()
   return params['hddTemp'] or ''
end