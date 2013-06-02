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

-- Return the cpu bar graph for the core
function conky_cpuBar(core)
   return string.format('${cpubar cpu%s}', core + 1)
end

-- Return any mounts in /media
function conky_mediaMounts(template)
   local result = nil
   local mount = nil
   local line = nil
   local procMounts = io.open('/proc/mounts')
   for line in procMounts:lines() do
      local mount = string.match(line, '/media/[^/ ]+')
      if (mount) then
	 if (result) then 
	    result = string.format('%s ${%s %s}', result, template, mount)
	 else
	    result = string.format('${%s %s}', template, mount)
	 end
      end
   end
   procMounts:close()
   return result or ''
end
