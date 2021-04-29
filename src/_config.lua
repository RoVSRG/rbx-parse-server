local tableJoin = require(script.Parent.Util.tableJoin)

local _config = {}

_config.data = {
	appId = "",
	baseUrl = ""
}

function _config:getHeaders(extraHeaders)
	local headers = {
		["X-Parse-Application-Id"] = self.data.appId,
		["Content-Type"] = "application/json"
	}
	
	if extraHeaders == "table" then
		headers = tableJoin(headers, extraHeaders)
	end
	
	return headers
end

function _config:withBaseUrl(endpoint)
	return string.format("%s%s", self.data.baseUrl, endpoint)
end

return _config
