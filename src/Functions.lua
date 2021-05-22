local Promise = require(script.Parent.Deps.Promise)
local _config = require(script.Parent._config)
local HttpService = game:GetService("HttpService")

local Functions = {}

function Functions.call(functionName, params)
    return Promise.new(function(resolve, reject)
        local url = _config:withBaseUrl(string.format("/functions/%s", functionName))

        local fieldNumber = 0
        for k, v in pairs(params) do
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
            Method = "POST",
            Headers = _config:getHeaders()
        })

        if response.Success then
            resolve(HttpService:JSONDecode(response.Body).result)
            return
        end

        reject(HttpService:JSONDecode(response.Body))
    end)
end

return Functions
