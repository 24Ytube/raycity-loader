local HttpService = game:GetService("HttpService")
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local req = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)

local function sha256(str)
  if crypt and crypt.hash then
    return crypt.hash(str, "sha256")
  elseif syn and syn.crypt and syn.crypt.hash then
    return syn.crypt.hash(str, "sha256")
  end
  return tostring(str)
end

local successTs, ts = pcall(function()
  return tostring(math.floor(workspace:GetServerTimeNow()))
end)
if not successTs or not ts then
  ts = tostring(os.time())
end

local secret = "TRX#9vK2$mP8@qL5!wZ7*nB4&xR6^jF3"
local sig = sha256(tostring(getgenv().Key) .. ":" .. tostring(hwid) .. ":" .. ts .. ":" .. secret)

local successReq, res = pcall(function()
  return req({
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
end)

if not successReq or not res then
  warn("[RaycityRB Error] ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ (Request Failed)")
  return
end

-- รองรับทั้ง res.Body (B ใหญ่) และ res.body (b เล็ก) ของแต่ละ Executor
local responseBody = res.Body or res.body

if responseBody then
  local loadSuccess, loadErr = pcall(function()
    loadstring(responseBody)()
  end)
  if not loadSuccess then
    warn("[RaycityRB Loadstring Error]: " .. tostring(loadErr))
  end
else
  warn("[RaycityRB Error] ไม่พบข้อมูลใน Body ของ Response")
end
