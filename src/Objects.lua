local Promise = require(script.Parent.Deps.Promise)
local _config = require(script.Parent._config)
local HttpService = game:GetService("HttpService")

local withClassName = require(script.Parent.Util.withClassName)


local Query = require(script.Parent.Query)

local Objects = {}

function Objects.class(className)	
	local self = {}
	
	function self:create(object)
		return Promise.new(function(resolve, reject)
			local url = withClassName(className)
			local response = HttpService:RequestAsync({
				Url = url,
				Method = "POST",
				Headers = _config:getHeaders(),
				Body = HttpService:JSONEncode(object)
			})
			
			if response.Success then
				resolve(HttpService:JSONDecode(response.Body))
				return
			end

			reject(HttpService:JSONDecode(response.Body))
		end)
	end
	
	function self:get(objectId)
		return Promise.new(function(resolve, reject)
			local url = withClassName(className, objectId)
			local response = HttpService:RequestAsync({
				Url = url,
				Method = "GET",
				Headers = _config:getHeaders()
			})
			
			if response.Success then
				resolve(HttpService:JSONDecode(response.Body))
				return
			end
			
			reject(HttpService:JSONDecode(response.Body))
		end)
	end
	
	function self:update(objectId, updateDocument)
		return Promise.new(function(resolve, reject)
			local url = withClassName(className, objectId)
			local response = HttpService:RequestAsync({
				Url = url,
				Method = "PUT",
				Body = HttpService:JSONEncode(updateDocument),
				Headers = _config:getHeaders()
			})
			
			resolve(HttpService:JSONDecode(response.Body))
		end)
	end
	
	function self:query()
		return Query.new(className)
	end
	
	function self:delete(objectId)
		return Promise.new(function(resolve, reject)
			local url = withClassName(className, objectId)
			local response = HttpService:RequestAsync({
				Url = url,
				Method = "DELETE",
				Headers = _config:getHeaders()
			})

			resolve(HttpService:JSONDecode(response.Body))
		end)
	end
	
	return self
end

return Objects
