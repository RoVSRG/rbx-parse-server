local _config = require(script._config)
local tableJoin = require(script.Util.tableJoin)

local Objects = require(script.Objects)

local ParseServer = {}

function ParseServer.new()
	local self = {}
	
	function self:setBaseUrl(baseUrl)
		_config.data.baseUrl = baseUrl
		return self
	end
	
	function self:setAppId(appId)
		_config.data.appId = appId
		return self
	end
	
	return tableJoin(self, {
		Objects = Objects
	})	
end


return ParseServer
