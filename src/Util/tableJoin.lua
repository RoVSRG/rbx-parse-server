return function(t1, t2)
	local ret = {}
	
	for i, v in pairs(t1) do
		ret[i] = v
	end
	
	for i, v in pairs(t2) do
		ret[i] = v
	end
	
	return ret
end