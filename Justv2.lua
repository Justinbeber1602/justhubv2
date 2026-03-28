-- [[ JUST | HYBRID OVERDRIVE SYSTEM - RAYFIELD EDITION ]] --
local WEB_APP_URL = "https://script.google.com/macros/s/AKfycbzFbMdoFGVCC16aX84qJbj3A3h5kq0t9ogIplDavHu4ICjTpTWs-OrwiW96lWx8AtkE/exec" 
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1487485984277790923/oX0zT3HS-L7BSoNNhUefQI9pGNltqfl83Affl75bPOEQVyHm9rYJq2G-uWIZTfPKkhnd" 

-- Load Rayfield Library (UI ยอดนิยม)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

_G.SteadyFarm = false
local accessType = nil

-- === [ ระบบหลังบ้าน: Webhook & Whitelist ] ===
local function sendWebhook(msg)
    pcall(function()
        local data = {["embeds"] = {{["title"] = "🚀 JUST Status", ["description"] = msg, ["color"] = 0x00A2FF, ["footer"] = {["text"] = os.date("%X")}}}}
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if req then req({Url = DISCORD_WEBHOOK, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)}) end
    end)
end

local function callSheets(action, seconds)
    local url = WEB_APP_URL .. "?user=" .. player.Name .. "&action=" .. action .. "&use=" .. (seconds or 0) .. "&t=" .. tick()
    local success, result = pcall(function() return game:HttpGet(url) end)
    if success and result and result ~= "" then
        local raw = tostring(result):lower()
        if raw == "not_found" then return nil, "ไม่พบชื่อใน Whitelist" end
        if raw == "true" then return "permanent", 9999 end
        local hours = tonumber(result)
        if hours and hours > 0 then return "hours", hours else return nil, "เวลาหมดแล้ว" end
    end
    return nil, "Error: เชื่อมต่อเซิร์ฟเวอร์ไม่ได้"
end

-- ตรวจสอบสิทธิ์
local status, val = callSheets("check")
if not status then
    player:Kick("\n❌ JUST PRESTIGE ❌\n" .. tostring(val))
    return
end
accessType = status
sendWebhook("👤 **" .. player.Name .. "** เข้าใช้งาน\n⌛ สิทธิ์: **" .. (accessType == "permanent" and "Lifetime" or "Hourly") .. "**")

-- === [ สร้างหน้าต่าง UI ด้วย Rayfield ] ===
local Window = Rayfield:CreateWindow({
   Name = "JUST Hub | V 1",
   LoadingTitle = "Authenticating...",
   LoadingSubtitle = "by Prestige",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false -- เราใช้ระบบ Whitelist ของเราเองแล้ว
})

local MainTab = Window:CreateTab("Auto Farm", 4483362458) -- ไอคอนรูปคอยน์/ดาว

-- === [ ฟังก์ชันฟาร์ม (ULTRA-HARD ของคุณ 100%) ] ===
local function startUltraFarm()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")

    local seat = hum.SeatPart
    if not seat then
        Rayfield:Notify({Title = "แจ้งเตือน", Content = "⏳ กรุณานั่งบนเบาะคนขับก่อน...", Duration = 5, Image = 4483362458})
        repeat task.wait(0.5) seat = hum.SeatPart until seat or not _G.SteadyFarm
    end

    if seat then
        local car = seat.Parent
        warn("🔥 [OVERDRIVE] ระบบเริ่มทำงาน...")
        sendWebhook("🔥 **เริ่มฟาร์มแบบ Ultra-Hard**\n🚗 รถ: " .. car.Name)

        local startPos = seat.CFrame
        local Waypoints = {
            startPos * CFrame.new(0, 0, 800),
            startPos * CFrame.new(800, 0, 800),
            startPos * CFrame.new(800, 0, 0),
            startPos
        }

        -- 2. ระบบ GOD-GLUE & SUPER NO-CLIP
        task.spawn(function()
            while _G.SteadyFarm do
                pcall(function()
                    if hum and seat then
                        if not hum.Sit then hum.Sit = true end
                        root.CFrame = seat.CFrame
                        root.Velocity = Vector3.new(0,0,0)
                        root.RotVelocity = Vector3.new(0,0,0)
                    end
                    for _, p in pairs(car:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.CanCollide = false
                            p.Velocity = Vector3.new(0,0,0)
                        end
                    end
                end)
                RunService.Stepped:Wait()
            end
        end)

        -- 3. ระบบวาร์ปนรก (The Overdrive Loop)
        task.spawn(function()
            local remote = game.RobloxReplicatedStorage:WaitForChild("UpdatePlayerProfileSettings")
            while _G.SteadyFarm do
                for _, point in ipairs(Waypoints) do
                    if not _G.SteadyFarm then break end
                    pcall(function()
                        seat.CFrame = point
                        for i = 1, 20 do
                            for _, v in pairs(car:GetDescendants()) do
                                if v:IsA("BasePart") and (v.Name:lower():find("wheel") or v.Name:lower():find("tire")) then
                                    v.RotVelocity = v.CFrame.RightVector * 1500
                                end
                            end
                            RunService.Heartbeat:Wait()
                        end
                        for i = 1, 10 do remote:FireServer() end
                    end)
                    task.wait(0.05)
                end
            end
        end)
    else
        warn("❌ หาเบาะไม่เจอ!")
    end
end

-- === [ ส่วนควบคุม UI ] ===
MainTab:CreateSection("Main Controls")

local Toggle = MainTab:CreateToggle({
   Name = "auto fram",
   CurrentValue = false,
   Flag = "FarmToggle",
   Callback = function(Value)
      _G.SteadyFarm = Value
      if _G.SteadyFarm then
          startUltraFarm()
      else
          sendWebhook("🛑 **หยุดฟาร์ม**")
      end
   end,
})

MainTab:CreateSection("Player Info")
MainTab:CreateLabel("User: " .. player.Name)
MainTab:CreateLabel("Access: " .. (accessType == "permanent" and "Lifetime" or "Hourly"))

-- ระบบหักเวลาเบื้องหลัง
task.spawn(function()
    while true do
        task.wait(60)
        if accessType == "hours" and _G.SteadyFarm then
            local s, timeLeft = callSheets("update", 60)
            if not s or (type(timeLeft) == "number" and timeLeft <= 0) then
                _G.SteadyFarm = false
                sendWebhook("⚠️ **หมดเวลา**\nผู้เล่น: " .. player.Name)
                player:Kick("\n❌ หมดเวลาการใช้งาน! ❌")
                break
            end
        end
    end
end)

Rayfield:Notify({Title = "JUST Hub", Content = "Whitelist สำเร็จ! ยินดีต้อนรับ", Duration = 5})
