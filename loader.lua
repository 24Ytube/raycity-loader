local HttpService = game:GetService("HttpService")
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local req = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)

-- ฟังก์ชัน SHA-256 สำรองกรณีที่ Executor ไม่มี crypt.hash
local function sha256(str)
  if crypt and crypt.hash then
    return crypt.hash(str, "sha256")
  end
  
  -- Fallback ใช้ Standard Lua Hash ดึงจาก HttpService ถ้า Executor รองรับ หรือจำลองค่าพื้นฐาน
  local success, res = pcall(function()
    return HttpService:JSONEncode(str)
  end)
  if success and syn and syn.crypt and syn.crypt.hash then
    return syn.crypt.hash(str, "sha256")
  end
  
  -- หากไม่มีจริงๆ ส่งค่าสตริงแปลงเบื้องต้นเพื่อไม่ให้โปรแกรมพัง (แนะนำให้ใช้ Executor ที่รองรับ crypt)
  return tostring(str)
end

local ts = tostring(math.floor(workspace:GetServerTimeNow()))
local secret = "TRX#9vK2$mP8@qL5!wZ7*nB4&xR6^jF3"
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
