--this is a lua script for use in conky



--==============================================================================
--                            conky-igatjens.lua
--
--  author  : Isaías Gatjens M - Twitter @igatjens
--  version : v2.0 for Conky Manager
--  license : Distributed under the terms of GNU GPL version 2 or later
--
--
--  notes   : uses conky conf newer >v1.10
--==============================================================================





function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end


function porcentaje( valor_referencia, valor_actual)
	return round( (valor_actual*100)/valor_referencia, 0 )
end


function get_num_nucleos( )
	local num_nucleos = tonumber(conky_parse("${execi 300 nproc}"))
	--local num_nucleos = tonumber(conky_parse("${execi 300 cat /proc/cpuinfo | grep processor | wc -l}"))
	return num_nucleos or 0
end