local HttpService = game:GetService("HttpService")
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local req = (syn and syn.request) or (http and http.request) or http_request or request

local function sha256(str)
  if crypt and crypt.hash then
    return crypt.hash(str, "sha256")
  end
  return ""
end

local ts = tostring(os.time())
local secret = "TREX_RAYCITY_2026_SECRET"
local sig = sha256(tostring(getgenv().Key) .. ":" .. tostring(hwid) .. ":" .. ts .. ":" .. secret)

local res = req({
  Url = "https://raycityrb-auth.trainergo123.workers.dev/",
  Method = "POST",
  Headers = { ["Content-Type"] = "application/json" },
  Body = HttpService:JSONEncode({
    key = tostring(getgenv().Key),
    hwid = tostring(hwid),
    ts = ts,
    sig = sig
  })
})

if res and res.Body then
  loadstring(res.Body)()
end
