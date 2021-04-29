local _config = require(script.Parent.Parent._config)
local HttpService = game:GetService("HttpService")

local function withClassName(className, endpoint)
	if endpoint then
		return _config:withBaseUrl(string.format("/classes/%s/%s", className, endpoint))
	end
	return _config:withBaseUrl(string.format("/classes/%s", className))
end

return withClassName