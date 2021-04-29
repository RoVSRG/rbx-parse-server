local _config = require(script.Parent._config)
local HttpService = game:GetService("HttpService")

local withClassName = require(script.Parent.Util.withClassName)

local Query = {}

function Query.new(className)
	local query = {}

	local fields = {}

	local url = withClassName(className)

	function query:where(where)
		fields.where = where
		return self
	end
	
	function query:order(field)
		fields.order = field
		return self
	end
	
	function query:skip(number)
		fields.skip = number
		return self
	end
	
	function query:excludeKeys(keys)
		fields.excludeKeys = table.concat(keys, ",")
		return self
	end
	
	function query:keys(keys)
		fields.keys = table.concat(keys, ",")
		return self
	end
	
	function query:include(keys)
		fields.include = table.concat(keys, ",")
		return self
	end

	function query:execute()
		local fieldNumber = 0
		for k, v in pairs(fields) do
			fieldNumber += 1
			local delimiter = (fieldNumber == 1) and "?" or "&"
			
			if typeof(v) == "table" then
				local serialized = HttpService:JSONEncode(v)
				url ..= string.format("%s%s=%s", delimiter, k, HttpService:UrlEncode(serialized))
			else
				url ..= string.format("%s%s=%s", delimiter, k, HttpService:UrlEncode(v))
			end
		end

		local response = HttpService:RequestAsync({
			Url = url,
			Method = "GET",
			Headers = _config:getHeaders()
		})

		if response.Success then
			return HttpService:JSONDecode(response.Body).results, true
		end

		return HttpService:JSONDecode(response.Body), false
	end

	return query
end

return Query
