local _config = require(script.Parent._config)
local HttpService = game:GetService("HttpService")

local withClassName = require(script.Parent.Util.withClassName)

local Query = require(script.Parent.Query)

local Objects = {}

function Objects.class(className)	
	local self = {}
	
	function self:create(object)
		local url = withClassName(className)
		local response = HttpService:RequestAsync({
			Url = url,
			Method = "POST",
			Headers = _config:getHeaders(),
			Body = HttpService:JSONEncode(object)
		})
		
		return HttpService:JSONDecode(response.Body)
	end
	
	function self:get(objectId)
		local url = withClassName(className, objectId)
		local response = HttpService:RequestAsync({
			Url = url,
			Method = "GET",
			Headers = _config:getHeaders()
		})
		
		if response.Success then
			return HttpService:JSONDecode(response.Body).results, false
		end
		
		return HttpService:JSONDecode(response.Body), false
	end
	
	function self:update(objectId, updateDocument)
		local url = withClassName(className, objectId)
		local response = HttpService:RequestAsync({
			Url = url,
			Method = "PUT",
			Body = HttpService:JSONEncode(updateDocument),
			Headers = _config:getHeaders()
		})
		
		return HttpService:JSONDecode(response.Body)
	end
	
	function self:query()
		return Query.new(className)
	end
	
	function self:delete(objectId)
		local url = withClassName(className, objectId)
		local response = HttpService:RequestAsync({
			Url = url,
			Method = "DELETE",
			Headers = _config:getHeaders()
		})

		return HttpService:JSONDecode(response.Body)
	end
	
	return self
end

return Objects
