local GuncelVersion = "1.0.4" -- Güncel versiyon numarası

local key = MachoAuthenticationKey()
local yetki = MachoWebRequest("141.98.112.145:4040/license/" .. key)
local calistir = false
local bitmezamani

-- Lisans kontrolü ve menü başlatma
if yetki == "emir" then -- Eğer yetki "emir" ise (geçersiz key)
    MachoMenuNotification("Coder Menu", "Lisansınız Mevcut Değil !")
    -- Menü başlatılmaz, kodun geri kalanı çalışmaz
elseif not yetki or yetki == "" or yetki:find("%.") then -- Eğer yetki boşsa veya "." içeriyorsa (sunucu aktif değil/tarih yok)
    MachoMenuNotification("Coder Menu", "Sunucu aktif değil, lütfen iletişime geçiniz.")
    -- Menü başlatılmaz, kodun geri kalanı çalışmaz
else -- yetki geçerli bir JSON stringi ise
    bitmezamani = yetki
    calistir = os.date("%Y-%m-%d")

    -- Menü boyutları ve başlangıç koordinatları
    local MenuSize = vec2(800, 500)
    local MenuStartCoords = vec2(500, 500)
    local TabSectionWidth = 150 -- Sol taraftaki sekme çubuğunun genişliği

    local MenuWindow = MachoMenuTabbedWindow("Decwork", MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y, TabSectionWidth)
    
    local menu = 1
    -- Menü renk ve tuş ayarları
    MachoMenuSetAccent(MenuWindow, 64, 224, 208)
    MachoMenuSetKeybind(MenuWindow, 0x2E)

    -- Sekme: Menüyü Kapat
    local FirstTab = MachoMenuAddTab(MenuWindow, "Ana Menü")
    local FirstSection = MachoMenuGroup(FirstTab, "Ana Menü", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150, MenuSize.y)
    MachoMenuNotification("Coder Menu", "Menü Aktif DELETE Tuşuna basın.")
	MachoMenuNotification("Coder Menu", "Renkli Çubuktan tutup taşıyabilirsiniz.")
    TextHandleKalanSure = MachoMenuText(FirstSection, "Kalan Süre: Yükleniyor...")

    TextHandleGuncellemeDurumu = MachoMenuText(FirstSection, "Güncelleme Durumu: Yükleniyor...")

    Citizen.CreateThread(function()
        local version = MachoWebRequest("141.98.112.145:4040/version")
            
        if version == "Bulunamadı" then
            MachoMenuSetText(TextHandleGuncellemeDurumu, "Güncelleme Durumu: Bulunamadı!")
        elseif version ~= GuncelVersion then
            MachoMenuSetText(TextHandleGuncellemeDurumu, "Sürümünüz Güncel Değil! Lütfen discord.gg/reinav\nAdresinden Yenisini İndirebilirsiniz!\n")
        else
            MachoMenuSetText(TextHandleGuncellemeDurumu, "Güncelleme Durumu: Sürümünüz Güncel!.")
        end

        if bitmezamani then
            -- JSON stringini parse et
            local expirationTime = ParseJson(bitmezamani)
    
            if expirationTime then
                -- Varsayılan değerlerle eksik alanları tamamla
                local expirationUnix = os.time({
                    year = expirationTime.year or 1970, -- Varsayılan yıl
                    month = expirationTime.month or 1, -- Varsayılan ay
                    day = expirationTime.day or 1, -- Varsayılan gün
                    hour = expirationTime.hour or 0, -- Varsayılan saat
                    min = expirationTime.min or 0, -- Varsayılan dakika
                    sec = expirationTime.sec or 0 -- Varsayılan saniye
                })
    
                -- Şu anki zamanı al
                local currentTime = os.time()
    
                -- Kalan süreyi hesapla
                local remainingTime = expirationUnix - currentTime

                if remainingTime > 0 then
                    -- Gün, saat, dakika, saniye olarak hesapla
                    local days = math.floor(remainingTime / 86400)
                    local hours = math.floor((remainingTime % 86400) / 3600)
                    local minutes = math.floor((remainingTime % 3600) / 60)
                    local seconds = remainingTime % 60
    
                    -- Kalan süreyi göster
                    local remainingText = string.format("Kalan Süre: %d gün, %d saat, %d dakika", days, hours, minutes)
                    MachoMenuSetText(TextHandleKalanSure, remainingText)
                else
                    -- Süre dolduysa
                    MachoMenuSetText(TextHandleKalanSure, "Kalan Süre: Süre Doldu!")
                end
            end
        end
        Citizen.Wait(40000)
        while true do
            Citizen.Wait(40000) -- Her saniyede bir güncelle
            local version = MachoWebRequest("141.98.112.145:4040/version")
            
            if version == "Bulunamadı" then
                MachoMenuSetText(TextHandleGuncellemeDurumu, "Güncelleme Durumu: Bulunamadı!")
            elseif version ~= GuncelVersion then
                MachoMenuSetText(TextHandleGuncellemeDurumu, "Sürümünüz Güncel Değil!")
            else
                MachoMenuSetText(TextHandleGuncellemeDurumu, "Güncelleme Durumu: Sürümünüz Güncel!")
            end

            if bitmezamani then
                -- JSON stringini parse et
                local expirationTime = ParseJson(bitmezamani)
    
                if expirationTime then
                    -- Varsayılan değerlerle eksik alanları tamamla
                    local expirationUnix = os.time({
                        year = expirationTime.year or 1970, -- Varsayılan yıl
                        month = expirationTime.month or 1, -- Varsayılan ay
                        day = expirationTime.day or 1, -- Varsayılan gün
                        hour = expirationTime.hour or 0, -- Varsayılan saat
                        min = expirationTime.min or 0, -- Varsayılan dakika
                        sec = expirationTime.sec or 0 -- Varsayılan saniye
                    })
    
                    -- Şu anki zamanı al
                    local currentTime = os.time()
    
                    -- Kalan süreyi hesapla
                    local remainingTime = expirationUnix - currentTime

                    if remainingTime > 0 then
                        -- Gün, saat, dakika, saniye olarak hesapla
                        local days = math.floor(remainingTime / 86400)
                        local hours = math.floor((remainingTime % 86400) / 3600)
                        local minutes = math.floor((remainingTime % 3600) / 60)
                        local seconds = remainingTime % 60
    
                        -- Kalan süreyi göster
                        local remainingText = string.format("Kalan Süre: %d gün, %d saat, %d dakika", days, hours, minutes)
                        MachoMenuSetText(TextHandleKalanSure, remainingText)
                    else
                        -- Süre dolduysa
                        MachoMenuSetText(TextHandleKalanSure, "Kalan Süre: Süre Doldu!")
                    end
                end
            end
            Citizen.Wait(20000)
        end
    end)


    -- İd Göster/Gizle Butonu
    local idgoster = false

    MachoMenuCheckbox(FirstSection, "ID Göster/Gizle - Safe", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        idgoster = true
        MachoMenuNotification("Menü", "ID Göster/Gizle durumu: Açık")
    end, function()
        idgoster = false
        MachoMenuNotification("Menü", "ID Göster/Gizle durumu: Kapalı")
    end)
    
    

    local isInvisible = false
    local isInvisible2 = false

    -- Görünmezlik Aç/Kapat Tikli Buton
    MachoMenuCheckbox(FirstSection, "Görünmezlik - Safe", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        local playerPed = PlayerPedId()
        local playerVeh = GetVehiclePedIsIn(playerPed, false)
    
        MachoInjectResource('qb-core', [[
            local playerPed = PlayerPedId()
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
    
            -- Diğerleri için görünmez
            SetEntityVisible(playerPed, false, false)
            NetworkSetEntityInvisibleToNetwork(playerPed, true)
            SetEntityAlpha(playerPed, 0, false)
    
            if playerVeh ~= 0 then
                SetEntityVisible(playerVeh, false, false)
                NetworkSetEntityInvisibleToNetwork(playerVeh, true)
                SetEntityAlpha(playerVeh, 0, false)
            end
    
            -- Kendin için görünür
            SetEntityLocallyVisible(playerPed)
            SetEntityAlpha(playerPed, 255, false)
    
            if playerVeh ~= 0 then
                SetEntityLocallyVisible(playerVeh)
                SetEntityAlpha(playerVeh, 255, false)
            end
        ]])
        isInvisible = true
    end, function()
        local playerPed = PlayerPedId()
        local playerVeh = GetVehiclePedIsIn(playerPed, false)
    
        MachoInjectResource('qb-core', [[
            local playerPed = PlayerPedId()
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
    
            -- Görünür yap
            SetEntityVisible(playerPed, true, false)
            NetworkSetEntityInvisibleToNetwork(playerPed, false)
            ResetEntityAlpha(playerPed)
    
            if playerVeh ~= 0 then
                SetEntityVisible(playerVeh, true, false)
                NetworkSetEntityInvisibleToNetwork(playerVeh, false)
                ResetEntityAlpha(playerVeh)
            end
        ]])
        isInvisible = false
    end)
    
    -- Sürekli görünürlük/görünmezlik koruma (bypass destekli)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if isInvisible then
                local playerPed = PlayerPedId()
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
    
                SetEntityVisible(playerPed, false, false)
                NetworkSetEntityInvisibleToNetwork(playerPed, true)
                SetEntityAlpha(playerPed, 0, false)
    
                if playerVeh ~= 0 then
                    SetEntityVisible(playerVeh, false, false)
                    NetworkSetEntityInvisibleToNetwork(playerVeh, true)
                    SetEntityAlpha(playerVeh, 0, false)
                end
    
                SetEntityLocallyVisible(playerPed)
                SetEntityAlpha(playerPed, 255, false)
    
                if playerVeh ~= 0 then
                    SetEntityLocallyVisible(playerVeh)
                    SetEntityAlpha(playerVeh, 255, false)
                end
            end
        end
    end)
    
    

    MachoMenuButton(FirstSection, "Tpm - Safe", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        TriggerEvent("txcl:tpToWaypoint")
    end)

    MachoMenuButton(FirstSection, "Revive - Safe", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        TriggerEvent('hospital:client:Revive', PlayerPedId())
    end)

    local noclipActive = false
    local playerPed = PlayerPedId()
    local noclipSpeed = 2.0
    local fallAnimDict = "move_jump"
    local fallAnim = "land_roll"
    
    function LoadAnimDict(dict)
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
    end
    
    -- Safe Noclip Tikli Buton
    MachoMenuCheckbox(FirstSection, "Noclip - Safe", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        MachoInjectResource('qb-core', [[
            local playerPed = PlayerPedId()
            local fallAnimDict = "move_jump"
            local fallAnim = "land_roll"
            RequestAnimDict(fallAnimDict)
            while not HasAnimDictLoaded(fallAnimDict) do
                Citizen.Wait(0)
            end
            TaskPlayAnim(playerPed, fallAnimDict, fallAnim, 8.0, -8.0, -1, 49, 0, false, false, false)
            SetPedToRagdoll(playerPed, 1000, 1000, 0, true, true, false)
            SetEntityCollision(playerPed, false, false)
            SetEntityAlpha(playerPed, 150, false)
            SetEntityInvincible(playerPed, true)
        ]])
        noclipActive = true
    end, function()
        MachoInjectResource('qb-core', [[
            local playerPed = PlayerPedId()
            ClearPedTasks(playerPed)
            SetEntityCollision(playerPed, true, true)
            ResetEntityAlpha(playerPed)
            SetEntityInvincible(playerPed, false)
        ]])
        noclipActive = false
    end)
    
    -- Noclip hareket kontrolü
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            playerPed = PlayerPedId()
    
            if noclipActive then
                local coords = GetEntityCoords(playerPed)
                local camRot = GetGameplayCamRot(2)
                local heading = math.rad(camRot.z)
                local speed = noclipSpeed
    
                if IsControlPressed(0, 32) then
                    coords = coords + vector3(speed * math.sin(heading), speed * -math.cos(heading), 0.0)
                end
                if IsControlPressed(0, 33) then
                    coords = coords + vector3(-speed * math.sin(heading), -speed * -math.cos(heading), 0.0)
                end
                if IsControlPressed(0, 34) then
                    coords = coords + vector3(speed * math.cos(heading), speed * math.sin(heading), 0.0)
                end
                if IsControlPressed(0, 35) then
                    coords = coords + vector3(-speed * math.cos(heading), -speed * math.sin(heading), 0.0)
                end
                if IsControlPressed(0, 21) then
                    coords = coords + vector3(0.0, 0.0, speed)
                end
                if IsControlPressed(0, 36) then
                    coords = coords + vector3(0.0, 0.0, -speed)
                end
    
                SetEntityCoordsNoOffset(playerPed, coords.x, coords.y, coords.z, true, true, true)
    
                if not IsEntityPlayingAnim(playerPed, fallAnimDict, fallAnim, 3) then
                    TaskPlayAnim(playerPed, fallAnimDict, fallAnim, 8.0, -8.0, -1, 49, 0, false, false, false)
                end
    
                if not IsPedRagdoll(playerPed) then
                    SetPedToRagdoll(playerPed, 1000, 1000, 0, true, true, false)
                end
    
                SetEntityRotation(playerPed, 0.0, 0.0, camRot.z, 2, true)
            end
        end
    end)

    local originalCameraCoords = vector3(0, 0, 0)
    local isCameraActive = false
    local playerPed = PlayerPedId()
    local playerHeading = 0
    local flyCam = nil
    local isFrozen = false
    local camSpeed = 2.0
    local fallAnimDict = "move_jump"
    local fallAnim = "land_roll"
    
    function LoadAnimDict(dict)
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
    end
    
    -- Function to create the camera
    function CreateCamera()
        local playerCoords = GetEntityCoords(playerPed, true) -- Oyuncunun tam koordinatlarını al
        originalCameraCoords = playerCoords + vector3(0.0, 0.0, 1.5) -- Oyuncunun başının 1.5 birim üstünden başla
        playerHeading = GetEntityHeading(playerPed)
        flyCam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
        SetCamCoord(flyCam, originalCameraCoords.x, originalCameraCoords.y, originalCameraCoords.z)
        SetCamRot(flyCam, 0.0, 0.0, playerHeading, 2)
        RenderScriptCams(true, false, 0, true, true)
        isCameraActive = true
        FreezeEntityPosition(playerPed, true)
        isFrozen = true
    end
    
    -- Function to destroy the camera
    function DestroyCamera()
        if isCameraActive then
            RenderScriptCams(false, false, 0, true, true)
            DestroyCam(flyCam, false)
            isCameraActive = false
            FreezeEntityPosition(playerPed, false)
            isFrozen = false
        end
    end
    
    -- Safe Freecam Menu
    MachoMenuCheckbox(FirstSection, "Freecam - Safe", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        MachoInjectResource('qb-core', [[
            local playerPed = PlayerPedId()
            local fallAnimDict = "move_jump"
            local fallAnim = "land_roll"
            RequestAnimDict(fallAnimDict)
            while not HasAnimDictLoaded(fallAnimDict) do
                Citizen.Wait(0)
            end
            TaskPlayAnim(playerPed, fallAnimDict, fallAnim, 8.0, -8.0, -1, 49, 0, false, false, false)
            SetPedToRagdoll(playerPed, 1000, 1000, 0, true, true, false)
            SetEntityCollision(playerPed, false, false)
            SetEntityAlpha(playerPed, 150, false)
            SetEntityInvincible(playerPed, true)
        ]])
        CreateCamera()
    end, function()
        MachoInjectResource('qb-core', [[
            local playerPed = PlayerPedId()
            ClearPedTasks(playerPed)
            SetEntityCollision(playerPed, true, true)
            ResetEntityAlpha(playerPed)
            SetEntityInvincible(playerPed, false)
        ]])
        DestroyCamera()
    end)
    
    -- Main thread for camera movement
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            playerPed = PlayerPedId()
    
            if isCameraActive then
                local camCoords = GetCamCoord(flyCam)
                local camRot = GetCamRot(flyCam, 2)
                local heading = math.rad(camRot.z)
                local speed = camSpeed
    
                -- Keyboard movement controls
                if IsControlPressed(0, 32) then -- W
                    camCoords = camCoords + vector3(speed * math.sin(heading), speed * -math.cos(heading), 0.0)
                end
                if IsControlPressed(0, 33) then -- S
                    camCoords = camCoords + vector3(-speed * math.sin(heading), -speed * -math.cos(heading), 0.0)
                end
                if IsControlPressed(0, 34) then -- A
                    camCoords = camCoords + vector3(speed * math.cos(heading), speed * math.sin(heading), 0.0)
                end
                if IsControlPressed(0, 35) then -- D
                    camCoords = camCoords + vector3(-speed * math.cos(heading), -speed * math.sin(heading), 0.0)
                end
                if IsControlPressed(0, 38) then -- E (yukarı)
                    camCoords = camCoords + vector3(0.0, 0.0, speed)
                end
                if IsControlPressed(0, 44) then -- Q (aşağı)
                    camCoords = camCoords + vector3(0.0, 0.0, -speed)
                end
    
                SetCamCoord(flyCam, camCoords.x, camCoords.y, camCoords.z)
    
                -- Mouse rotation controls
                local rightAxisX = GetDisabledControlNormal(0, 1) * -2.0 -- Invert X-axis
                local rightAxisY = GetDisabledControlNormal(0, 2) * -2.0 -- Invert Y-axis
                local newCamRotX = camRot.x + rightAxisY * speed
                local newCamRotZ = camRot.z - rightAxisX * speed
                SetCamRot(flyCam, newCamRotX, 0.0, newCamRotZ, 2)
    
                -- Animation and ragdoll effects
                if not IsEntityPlayingAnim(playerPed, fallAnimDict, fallAnim, 3) then
                    TaskPlayAnim(playerPed, fallAnimDict, fallAnim, 8.0, -8.0, -1, 49, 0, false, false, false)
                end
    
                if not IsPedRagdoll(playerPed) then
                    SetPedToRagdoll(playerPed, 1000, 1000, 0, true, true, false)
                end
            end
        end
    end)

    MachoMenuButton(FirstSection, "Menüyü Kapat", function()
        menu = 0
        MachoMenuDestroy(MenuWindow)
    end)

    --MenuSliderHandle = MachoMenuSlider(SecondSection, "Slider", 10, 0, 100, "%", 0, function(Value)
    --    print("Slider updated with value ".. Value)
    --end)
--
    --MachoMenuCheckbox(SecondSection, "Checkbox",
    --    function()
    --        print("Enabled")
    --    end,
    --    function()
    --        print("Disabled")
    --    end
    --)


    -- Sekme: Araç Menüsü
    local VehicleTab = MachoMenuAddTab(MenuWindow, "Araç Menüsü")

    -- Grup: Araç Oluşturma
    local VehicleSection = MachoMenuGroup(VehicleTab, "Araç Oluştur", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150, MenuSize.y)

    -- Başlık: Araç Modeli Gir
    MachoMenuText(VehicleSection, "Araç Modeli Girin (örnek: sultan)")

    -- Araç Modeli için metin girişi
    local VehicleModelInput = MachoMenuInputbox(VehicleSection, "Araç Modeli", "Örn: sultan")

    -- Anahtar verme durumu değişkeni
    local GiveKey = false

    -- Araç Anahtarı Alınsın mı? (Checkbox)
    MachoMenuCheckbox(VehicleSection, "Araç Anahtarı Alınsın mı?", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        GiveKey = true
    end, function()
        GiveKey = false
    end)

    -- Araç Oluşturma Butonu
    MachoMenuButton(VehicleSection, "Aracı Oluştur", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        local modelName = MachoMenuGetInputbox(VehicleModelInput)

        if modelName and modelName ~= "" then
            MachoInjectResource('qb-core', string.format([[
                local modelName = "%s"
                local modelHash = GetHashKey(modelName)
                local giveKey = %s

                if not IsModelInCdimage(modelHash) then
                    TriggerEvent('chat:addMessage', { args = { '^1Araç Sistemi:', 'Geçersiz model: %s' } })
                    return
                end

                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                    Wait(0)
                end

                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)

                if vehicle and vehicle ~= 0 then
                    SetVehicleCustomPrimaryColour(vehicle, 255, 255, 255)
                    SetVehicleCustomSecondaryColour(vehicle, 255, 255, 255)
                    TaskWarpPedIntoVehicle(ped, vehicle, -1)

                    if giveKey then
                        local plate = GetVehicleNumberPlateText(vehicle)
                        TriggerEvent("vehiclekeys:client:SetOwner", plate)
                        TriggerEvent('chat:addMessage', { args = { '^2Araç Sistemi:', 'Araç oluşturuldu ve anahtar verildi!' } })
                    else
                        TriggerEvent('chat:addMessage', { args = { '^2Araç Sistemi:', 'Araç oluşturuldu! (Anahtar yok)' } })
                    end
                else
                    TriggerEvent('chat:addMessage', { args = { '^1Araç Sistemi:', 'Araç oluşturulamadı!' } })
                end

                SetModelAsNoLongerNeeded(modelHash)
            ]], modelName, tostring(GiveKey), modelName))

            if GiveKey then
                MachoMenuNotification("Araç Sistemi", "Araç oluşturuldu ve anahtar verildi!")
            else
                MachoMenuNotification("Araç Sistemi", "Araç oluşturuldu (Anahtar verilmedi)!")
            end
        else
            MachoMenuNotification("Hata", "Geçerli bir araç modeli giriniz!")
        end
    end)





        -- RC Hırsızlığı Butonu
        MachoMenuButton(VehicleSection, "Database Araba Hırsızlığı Başlat", function()
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            if veh == 0 then
                MachoMenuNotification("Hata", "Araçta değilsin!")
                return
            end

            local plate = GetVehicleNumberPlateText(veh)
            local myId = GetPlayerServerId(PlayerId())

            MachoLockLogger() -- Event logger'ı kilitle
            MachoInjectResource('qb-core', string.format([[
                local myId = %d
                local plate = "%s"
                for _, player in ipairs(GetActivePlayers()) do
                    local otherId = GetPlayerServerId(player)
                    if otherId ~= myId then
                        TriggerServerEvent("hhfw:GiveRC", otherId, myId, plate)
                        TriggerEvent('chat:addMessage', { args = { 'Adamın Aracına El Koydun :', 'Denendi: ' .. otherId .. ' -> ' .. myId .. ' | Plaka: ' .. plate } })
                        Wait(200)
                    end
                end
            ]], myId, plate))

            MachoMenuNotification("Bilgi", "RC hırsızlığı başlatıldı! Plaka: " .. plate)
        end)


    -- Sekme: Troll Menüsü
    local TrollTab = MachoMenuAddTab(MenuWindow, "Troll Menüsü")

    -- Grup 1: Oyunculara Yönelik (Araç Ram ve NPC Spawn için)
    local PlayerSection = MachoMenuGroup(TrollTab, "Oyunculara Yönelik", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150, MenuSize.y)
    

    -- Başlık: Araç Ram
    MachoMenuText(PlayerSection, "Araç Ram")

    -- Oyuncu ID için metin girişi (Araç Ram)
    local PlayerIdInputBoxHandle = MachoMenuInputbox(PlayerSection, "Hedef Oyuncu ID (Araç Ram)", "Örn: 123")

    -- Ram Player butonu
    MachoMenuButton(PlayerSection, "Oyuncuya Araç Fırlat", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        local targetId = tonumber(MachoMenuGetInputbox(PlayerIdInputBoxHandle))
        if targetId and targetId > 0 then
            MachoInjectResource('qb-core', string.format([[
                local playerId = GetPlayerFromServerId(%d)
                if playerId then
                    local targetPed = GetPlayerPed(playerId)
                    local targetCoords = GetEntityCoords(targetPed)
                    local offset = GetOffsetFromEntityInWorldCoords(targetPed, 0, -2.0, 0)
                    local vehModel = "futo"
                    RequestModel(vehModel)
                    while not HasModelLoaded(vehModel) do
                        Citizen.Wait(0)
                    end
                    local vehicle = CreateVehicle(vehModel, offset.x, offset.y, offset.z, GetEntityHeading(targetPed), true, true)
                    SetEntityVisible(vehicle, false, true)
                    if DoesEntityExist(vehicle) then
                        NetworkRequestControlOfEntity(vehicle)
                        SetVehicleDoorsLocked(vehicle, 4)
                        SetVehicleForwardSpeed(vehicle, 120.0)
                    end
                    TriggerEvent('chat:addMessage', { args = { '^2Araç Sistemi:', 'Araç fırlatıldı! Hedef ID: %d' } })
                else
                    TriggerEvent('chat:addMessage', { args = { '^1Araç Sistemi:', 'Oyuncu bulunamadı! ID: %d' } })
                end
            ]], targetId, targetId, targetId))
            MachoMenuNotification("Araç Sistemi", "Araç fırlatma işlemi başlatıldı! Hedef ID: " .. targetId)
        else
            MachoMenuNotification("Hata", "Geçerli bir oyuncu ID giriniz!")
        end
    end)

    -- Başlık: NPC Spawn
    MachoMenuText(PlayerSection, "NPC Saldırısı")

    -- Oyuncu ID için metin girişi (NPC Spawn)
    local NpcTargetIdInputBoxHandle = MachoMenuInputbox(PlayerSection, "Hedef Oyuncu ID (NPC)", "Örn: 123")

    -- NPC Spawn butonu
    MachoMenuButton(PlayerSection, "NPC'leri Başlat", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        local targetId = tonumber(MachoMenuGetInputbox(NpcTargetIdInputBoxHandle))
        if targetId and targetId > 0 then
            if isSpawning then
                MachoMenuNotification("Hata", "NPC'ler zaten spawn ediliyor! Önce durdurun.")
                return
            end
            isSpawning = true
            MachoMenuNotification("NPC Sistemi", "NPC spawn işlemi başlatıldı! Hedef ID: " .. targetId)
            Citizen.CreateThread(function()
                while isSpawning do
                    MachoInjectResource('qb-core', string.format([[
                        local npcModel = "g_m_y_ballasout_01"
                        local weaponHash = "weapon_minigun"
                        local radius = 5.0
                        local numberOfPeds = 3
                        local playerPed = GetPlayerPed(GetPlayerFromServerId(%d))
                        if not DoesEntityExist(playerPed) then
                            TriggerEvent('chat:addMessage', { args = { '^1NPC Sistemi:', 'Hedef oyuncu bulunamadı!' } })
                            return
                        end
                        local playerPos = GetEntityCoords(playerPed)
                        RequestModel(npcModel)
                        while not HasModelLoaded(npcModel) do
                            Citizen.Wait(100)
                        end
                        for i = 0, numberOfPeds - 1 do
                            local angle = (i / numberOfPeds) * (2 * math.pi)
                            local spawnX = playerPos.x + radius * math.cos(angle)
                            local spawnY = playerPos.y + radius * math.sin(angle)
                            local spawnZ = playerPos.z
                            local npc = CreatePed(4, npcModel, spawnX, spawnY, spawnZ, 0.0, true, false)
                            GiveWeaponToPed(npc, GetHashKey(weaponHash), 250, false, true)
                            SetPedCombatAttributes(npc, 5, true)
                            SetPedCombatRange(npc, 2)
                            SetPedCombatMovement(npc, 3)
                            TaskCombatPed(npc, playerPed, 0, 16)
                            SetEntityAsNoLongerNeeded(npc)
                        end
                    ]], targetId, targetId))
                    Wait(2000) -- Her iki saniyede bir ped spawn et
                end
            end)
        else
            MachoMenuNotification("Hata", "Geçerli bir oyuncu ID giriniz!")
        end
    end)

    -- NPC Spawn durdurma butonu
    MachoMenuButton(PlayerSection, "NPC'leri Durdur", function()
        if isSpawning then
            isSpawning = false
            MachoMenuNotification("NPC Sistemi", "NPC spawn işlemi durduruldu!")
        else
            MachoMenuNotification("Bilgi", "NPC spawn işlemi zaten durdurulmuş.")
        end
    end)

    

    local BringTargetIdInputBoxHandle = MachoMenuInputbox(PlayerSection, "Bring Hedef Oyuncu ID", "Örn: 123")

    -- Kendine Bringle butonu
    MachoMenuButton(PlayerSection, "Kendine Bringle", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        local targetId = tonumber(MachoMenuGetInputbox(BringTargetIdInputBoxHandle))
        if targetId and targetId > 0 then
            MachoInjectResource('qb-core', string.format([[
                local playerPed = PlayerPedId()
                local originalPos = GetEntityCoords(playerPed)
                local targetPed = GetPlayerPed(GetPlayerFromServerId(%d))
                if targetPed and targetPed ~= 0 then
                    local targetCoords = GetEntityCoords(targetPed)
                    if targetCoords then
                        SetEntityCoords(playerPed, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, true)
                        TriggerServerEvent('ServerValidEmote', '%d', 'horse', 'horse', 1405553601)
                        Citizen.Wait(100)
                        SetEntityCoords(playerPed, originalPos.x, originalPos.y, originalPos.z, false, false, false, true)
                        TriggerEvent('chat:addMessage', { args = { '^2Bring Exploit:', 'TP ve Hedef ID: %d' } })
                    else
                        TriggerEvent('chat:addMessage', { args = { '^1Bring Exploit:', 'Hedef oyuncunun pozisyonu alınamadı! ID: %d' } })
                    end
                else
                    TriggerEvent('chat:addMessage', { args = { '^1Bring Exploit:', 'Oyuncu bulunamadı! ID: %d' } })
                end
            ]], targetId, targetId, targetId, targetId, targetId))
            MachoMenuNotification("Bring Exploit", "TP   işlemi başlatıldı! Hedef ID: " .. targetId)
        else
            MachoMenuNotification("Hata", "Geçerli bir oyuncu ID giriniz!")
        end
    end)

    local robbing = false
    local takip = false
    local attachedTo = nil
    local attachedTo2 = nil
    local attachedTo3 = nil
    local originalPos = nil
    local originalPos2 = nil
    local originalPos3 = nil
    local isInvisible = false
    local isInvisible2 = false
    local isInvisible3 = false

    -- Görünmezlik Fonksiyonu
    local function SetTrueInvisibility(state)
        local playerPed = PlayerPedId()
        if state then
            SetEntityVisible(playerPed, false, false)
            NetworkSetEntityInvisibleToNetwork(playerPed, true)
            SetEntityAlpha(playerPed, 0, false)
            isInvisible = true
        else
            SetEntityVisible(playerPed, true, false)
            NetworkSetEntityInvisibleToNetwork(playerPed, false)
            ResetEntityAlpha(playerPed)
            isInvisible = false
        end
    end

    -- Kendine görünür kalma
    CreateThread(function()
        while true do
            Wait(0)
            if isInvisible then
                local ped = PlayerPedId()
                SetEntityLocallyVisible(ped)
                SetEntityAlpha(ped, 255, false)
            end
        end
    end)

    -- MachoMenu inputbox
    local takipInput = MachoMenuInputbox(PlayerSection, "Takip ID", "Hedef Oyuncu ID")

    -- TAKİP ET butonu
    MachoMenuButton(PlayerSection, "Takip Et/Çık", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        if takip then
            local playerPed = PlayerPedId()
            takip = false
            DetachEntity(playerPed, true, false)
            SetTrueInvisibility(false)
            if DoesEntityExist(attachedTo2) then
                ClearPedTasks(attachedTo2)
            end
            attachedTo2 = nil
            if originalPos2 then
                SetEntityCoords(playerPed, originalPos2.x, originalPos2.y, originalPos2.z, false, false, false, false)
            end
            MachoInjectResource('qb-core', [[
                local playerPed = PlayerPedId()
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
        
                -- Görünür yap
                SetEntityVisible(playerPed, true, false)
                NetworkSetEntityInvisibleToNetwork(playerPed, false)
                ResetEntityAlpha(playerPed)
        
                if playerVeh ~= 0 then
                    SetEntityVisible(playerVeh, true, false)
                    NetworkSetEntityInvisibleToNetwork(playerVeh, false)
                    ResetEntityAlpha(playerVeh)
                end
            ]])
            isInvisible2 = false
            MachoMenuNotification("Takip", "Takip bırakıldı ve geri dönüldü.")
            return
        end

        local targetId = tonumber(MachoMenuGetInputbox(takipInput))
        if not targetId or targetId <= 0 then
            MachoMenuNotification("Hata", "Geçerli bir ID girin!")
            return
        end

        local playerId = GetPlayerFromServerId(targetId)
        if playerId == -1 then
            MachoMenuNotification("Hata", "Oyuncu bulunamadı.")
            return
        end

        local playerPed = PlayerPedId()
        local targetPed = GetPlayerPed(playerId)
        if not DoesEntityExist(targetPed) then
            MachoMenuNotification("Hata", "Hedef ped yok.")
            return
        end

        takip = true
        attachedTo2 = targetPed
        originalPos2 = GetEntityCoords(playerPed)

        MachoInjectResource('qb-core', [[
            local playerPed = PlayerPedId()
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
    
            -- Diğerleri için görünmez
            SetEntityVisible(playerPed, false, false)
            NetworkSetEntityInvisibleToNetwork(playerPed, true)
            SetEntityAlpha(playerPed, 0, false)
    
            if playerVeh ~= 0 then
                SetEntityVisible(playerVeh, false, false)
                NetworkSetEntityInvisibleToNetwork(playerVeh, true)
                SetEntityAlpha(playerVeh, 0, false)
            end
    
            -- Kendin için görünür
            SetEntityLocallyVisible(playerPed)
            SetEntityAlpha(playerPed, 255, false)
    
            if playerVeh ~= 0 then
                SetEntityLocallyVisible(playerVeh)
                SetEntityAlpha(playerVeh, 255, false)
            end
        ]])
        isInvisible2 = true

        --AttachEntityToEntity(playerPed, targetPed, 11816, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 1, true)
        --AttachEntityToEntity(playerPed, targetPed, 11816, 0.5, 0.0, 2.0, 0.0, 0.0, 0.0, false, false, false, false, 1, true)
        AttachEntityToEntity(playerPed, targetPed, 11816, 0.5, -2.0, 2.0, 0.0, 0.0, 0.0, false, false, false, false, 1, true)

        -- Animasyon
        --local dict, anim = "missminuteman_1ig_2", "handsup_base"
        --RequestAnimDict(dict)
        --while not HasAnimDictLoaded(dict) do Wait(0) end
        --TaskPlayAnim(targetPed, dict, anim, 8.0, -8.0, -1, 49, 0, false, false, false)

        -- Takip izleme thread'i
        CreateThread(function()
            while takip do
                Wait(5)
                if IsPauseMenuActive() then
                    takip = false
                    DetachEntity(playerPed, true, false)
                    SetTrueInvisibility(false)
                    if DoesEntityExist(attachedTo2) then
                        ClearPedTasks(attachedTo2)
                    end
                    if originalPos then
                        SetEntityCoords(playerPed, originalPos.x, originalPos.y, originalPos.z, false, false, false, false)
                    end
                    attachedTo2 = nil
                    MachoMenuNotification("Takip", "Takip sona erdi, konuma dönüldü.")
                end

                if isInvisible2 then
                    local playerPed = PlayerPedId()
        
                    SetEntityVisible(playerPed, false, false)
                    NetworkSetEntityInvisibleToNetwork(playerPed, true)
                    SetEntityAlpha(playerPed, 0, false)
        
                    SetEntityLocallyVisible(playerPed)
                    SetEntityAlpha(playerPed, 255, false)
                end
            end
        end)
    end)

    -- TAKİP ET butonu
    -- TAKİP ET butonu
    MachoMenuButton(PlayerSection, "Takip Et ve Envanter Aç / Çık", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        if robbing then
            local playerPed = PlayerPedId()
            robbing = false
            DetachEntity(playerPed, true, false)
            SetTrueInvisibility(false)
            if DoesEntityExist(attachedTo) then
                ClearPedTasks(attachedTo)
            end
            attachedTo = nil
            if originalPos then
                SetEntityCoords(playerPed, originalPos.x, originalPos.y, originalPos.z, false, false, false, false)
            end
            -- Görünürlük ayarlarını sıfırla
            SetEntityVisible(playerPed, true, false)
            NetworkSetEntityInvisibleToNetwork(playerPed, false)
            ResetEntityAlpha(playerPed)
            isInvisible3 = false
            MachoMenuNotification("Takip", "Takip bırakıldı ve geri dönüldü.")
            return
        end

        local targetId = tonumber(MachoMenuGetInputbox(takipInput))
        if not targetId or targetId <= 0 then
            MachoMenuNotification("Hata", "Geçerli bir ID girin!")
            return
        end

        local playerId = GetPlayerFromServerId(targetId)
        if playerId == -1 then
            MachoMenuNotification("Hata", "Oyuncu bulunamadı.")
            return
        end

        local playerPed = PlayerPedId()
        local targetPed = GetPlayerPed(playerId)
        if not DoesEntityExist(targetPed) then
            MachoMenuNotification("Hata", "Hedef ped yok.")
            return
        end

        robbing = true
        attachedTo = targetPed
        originalPos = GetEntityCoords(playerPed)

        -- Görünmezlik ayarları
        SetEntityVisible(playerPed, false, false)
        NetworkSetEntityInvisibleToNetwork(playerPed, true)
        SetEntityAlpha(playerPed, 0, false)

        isInvisible3 = true

        AttachEntityToEntity(playerPed, targetPed, 11816, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

        -- Animasyon
        local dict, anim = "missminuteman_1ig_2", "handsup_base"
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(0) end
        TaskPlayAnim(targetPed, dict, anim, 8.0, -8.0, -1, 49, 0, false, false, false)

        -- Takip izleme thread'i
        CreateThread(function()
            while robbing do
                Wait(5)
                if IsPauseMenuActive() then
                    robbing = false
                    DetachEntity(playerPed, true, false)
                    SetTrueInvisibility(false)
                    if DoesEntityExist(attachedTo) then
                        ClearPedTasks(attachedTo)
                    end
                    if originalPos then
                        SetEntityCoords(playerPed, originalPos.x, originalPos.y, originalPos.z, false, false, false, false)
                    end
                    attachedTo = nil
                    isInvisible3 = false
                    MachoMenuNotification("Takip", "Takip sona erdi, konuma dönüldü.")
                end
                if isInvisible3 then
                    local playerPed55 = PlayerPedId()
        
                    SetEntityVisible(playerPed55, false, false)
                    NetworkSetEntityInvisibleToNetwork(playerPed55, true)
                    SetEntityAlpha(playerPed55, 0, false)
        
                    SetEntityLocallyVisible(playerPed55)
                    SetEntityAlpha(playerPed55, 255, false)
                end
            end
        end)

        -- Envanteri aç (2 kez deneme)
        TriggerEvent('ox_inventory:openInventory', 'otherplayer', targetId)
    end)

    -- TAKİPTEN ÇIK butonu
    -- MachoMenuButton(PlayerSection, "Takipten Çık", function()
    --     if calistir ~= os.date("%Y-%m-%d") then
    --         MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
    --         return
    --     end
    --     if robbing then
    --         local playerPed = PlayerPedId()
    --         robbing = false
    --         DetachEntity(playerPed, true, false)
    --         SetTrueInvisibility(false)
    --         if DoesEntityExist(attachedTo) then
    --             ClearPedTasks(attachedTo)
    --         end
    --         attachedTo = nil
    --         if originalPos then
    --             SetEntityCoords(playerPed, originalPos.x, originalPos.y, originalPos.z, false, false, false, false)
    --         end
    --         MachoMenuNotification("Takip", "Takip bırakıldı ve geri dönüldü.")
    --     else
    --         MachoMenuNotification("Takip", "Takipte değilsin.")
    --     end
    -- end)

    MachoMenuButton(PlayerSection, "Yakındaki Oyuncunun Envanterini Aç", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        MachoInjectResource('ox_inventory', [[
            local function GetClosestPlayer()
                local closestPlayer = -1
                local closestDistance = -1
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)

                for _, playerId in ipairs(GetActivePlayers()) do
                    local targetPed = GetPlayerPed(playerId)
                    if targetPed ~= playerPed then
                        local targetCoords = GetEntityCoords(targetPed)
                        local distance = #(playerCoords - targetCoords)

                        if closestDistance == -1 or distance < closestDistance then
                            closestPlayer = playerId
                            closestDistance = distance
                        end
                    end
                end

                return closestPlayer, closestDistance
            end

            local function ForceAnimationOnPlayer(ped)
                local dict = "dead"
                local anim = "dead_a"

                if not HasAnimDictLoaded(dict) then
                    RequestAnimDict(dict)
                    while not HasAnimDictLoaded(dict) do
                        Wait(10)
                    end
                end

                TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 49, 0, false, false, false)
            end

            local closestPlayer, distance = GetClosestPlayer()

            if closestPlayer ~= -1 and distance <= 2.0 then
                local targetPed = GetPlayerPed(closestPlayer)
                ForceAnimationOnPlayer(targetPed)
                TriggerEvent('ox_inventory:openInventory', 'otherplayer', GetPlayerServerId(closestPlayer))
            end
        ]])
    end)
    

    -- Oyuncuyu kafese kapatma fonksiyonu
function CagePlayer(player)
    local ped = GetPlayerPed(player)
    if not ped or ped <= 0 then
        MachoMenuNotification("Hata!", "Geçersiz oyuncu pedi.")
        return
    end

    local coords = GetEntityCoords(ped)
    if not coords then
        MachoMenuNotification("Hata!", "Oyuncunun kordinatları alınamadı.")
        return
    end

    local inveh = IsPedInAnyVehicle(ped)

    if inveh then
        -- Araç içindeyken oluşturulan kafes
        local obj = CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 6.8, coords.y + 1, coords.z - 1.5, false, true, true)
        SetEntityHeading(obj, 90.0)
        
        CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 0.6, coords.y + 6.8, coords.z - 1.5, false, true, true)
        
        CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 0.6, coords.y - 4.8, coords.z - 1.5, false, true, true)

        local obj2 = CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x + 4.8, coords.y + 1, coords.z - 1.5, false, true, true)
        SetEntityHeading(obj2, 90.0)
        
        obj = CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 6.8, coords.y + 1, coords.z + 1.3, false, true, true)
        SetEntityHeading(obj, 90.0)
        
        CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 0.6, coords.y + 6.8, coords.z + 1.3, false, true, true)
        
        CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 0.6, coords.y - 4.8, coords.z + 1.3, false, true, true)

        obj2 = CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x + 4.8, coords.y + 1, coords.z + 1.3, false, true, true)
        SetEntityHeading(obj2, 90.0)
    else
        -- Araç dışında oluşturulan kafes
        local obj = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.6, coords.y - 1, coords.z - 1, true, true, true)
        FreezeEntityPosition(obj, true)
        
        local obj2 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.55, coords.y - 1.05, coords.z - 1, true, true, true)
        SetEntityHeading(obj2, 90.0)
        FreezeEntityPosition(obj2, true)
        
        local obj3 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.6, coords.y + 0.6, coords.z - 1, true, true, true)
        FreezeEntityPosition(obj3, true)
        
        local obj4 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x + 1.05, coords.y - 1.05, coords.z - 1, true, true, true)
        SetEntityHeading(obj4, 90.0)
        FreezeEntityPosition(obj4, true)
        
        local obj5 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.6, coords.y - 1, coords.z + 1.5, true, true, true)
        FreezeEntityPosition(obj5, true)
        
        local obj6 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.55, coords.y - 1.05, coords.z + 1.5, true, true, true)
        SetEntityHeading(obj6, 90.0)
        FreezeEntityPosition(obj6, true)
        
        local obj7 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.6, coords.y + 0.6, coords.z + 1.5, true, true, true)
        FreezeEntityPosition(obj7, true)
        
        local obj8 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x + 1.05, coords.y - 1.05, coords.z + 1.5, true, true, true)
        SetEntityHeading(obj8, 90.0)
        FreezeEntityPosition(obj8, true)
    end
end

-- Hata ayıklamak için oyuncu ID'lerini listeleme (opsiyonel)
-- RegisterCommand("listplayers", function()
--     print("Çevrimiçi Oyuncular:")
--     for _, serverId in ipairs(GetActivePlayers()) do
--         local clientId = GetPlayerFromServerId(serverId)
--         if clientId ~= -1 then
--             local name = GetPlayerName(clientId) or "Bilinmeyen"
--             print("Server ID: " .. serverId .. ", Client ID: " .. clientId .. ", İsim: " .. name)
--         end
--     end
-- end, false)

-- MachoMenu Butonu ve Input Kutusu
local CageTargetIdInputBoxHandle = MachoMenuInputbox(PlayerSection, "Kafes Hedef Oyuncu ID", "Örn: 123")

MachoMenuButton(PlayerSection, "Oyuncuyu Kafese Kapat", function()
    if calistir ~= os.date("%Y-%m-%d") then
        MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
        return
    end
    local targetId = tonumber(MachoMenuGetInputbox(CageTargetIdInputBoxHandle))
    if targetId and targetId > 0 then
        MachoInjectResource('qb-core', string.format([[
            local targetClientId = GetPlayerFromServerId(%d)
            if targetClientId == -1 then
                TriggerEvent('chat:addMessage', { args = { '^1Kafes:', 'Oyuncu bulunamadı! ID: %d' } })
                return
            end
            local ped = GetPlayerPed(targetClientId)
            if not ped or ped <= 0 then
                TriggerEvent('chat:addMessage', { args = { '^1Kafes:', 'Geçersiz oyuncu pedi! ID: %d' } })
                return
            end
            local coords = GetEntityCoords(ped)
            if not coords then
                TriggerEvent('chat:addMessage', { args = { '^1Kafes:', 'Koordinatlar alınamadı! ID: %d' } })
                return
            end
            local inveh = IsPedInAnyVehicle(ped)
            if inveh then
                local obj = CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 6.8, coords.y + 1, coords.z - 1.5, false, true, true)
                SetEntityHeading(obj, 90.0)
                CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 0.6, coords.y + 6.8, coords.z - 1.5, false, true, true)
                CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 0.6, coords.y - 4.8, coords.z - 1.5, false, true, true)
                local obj2 = CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x + 4.8, coords.y + 1, coords.z - 1.5, false, true, true)
                SetEntityHeading(obj2, 90.0)
                obj = CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 6.8, coords.y + 1, coords.z + 1.3, false, true, true)
                SetEntityHeading(obj, 90.0)
                CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 0.6, coords.y + 6.8, coords.z + 1.3, false, true, true)
                CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 0.6, coords.y - 4.8, coords.z + 1.3, false, true, true)
                obj2 = CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x + 4.8, coords.y + 1, coords.z + 1.3, false, true, true)
                SetEntityHeading(obj2, 90.0)
            else
                local obj = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.6, coords.y - 1, coords.z - 1, true, true, true)
                FreezeEntityPosition(obj, true)
                local obj2 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.55, coords.y - 1.05, coords.z - 1, true, true, true)
                SetEntityHeading(obj2, 90.0)
                FreezeEntityPosition(obj2, true)
                local obj3 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.6, coords.y + 0.6, coords.z - 1, true, true, true)
                FreezeEntityPosition(obj3, true)
                local obj4 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x + 1.05, coords.y - 1.05, coords.z - 1, true, true, true)
                SetEntityHeading(obj4, 90.0)
                FreezeEntityPosition(obj4, true)
                local obj5 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.6, coords.y - 1, coords.z + 1.5, true, true, true)
                FreezeEntityPosition(obj5, true)
                local obj6 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.55, coords.y - 1.05, coords.z + 1.5, true, true, true)
                SetEntityHeading(obj6, 90.0)
                FreezeEntityPosition(obj6, true)
                local obj7 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.6, coords.y + 0.6, coords.z + 1.5, true, true, true)
                FreezeEntityPosition(obj7, true)
                local obj8 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x + 1.05, coords.y - 1.05, coords.z + 1.5, true, true, true)
                SetEntityHeading(obj8, 90.0)
                FreezeEntityPosition(obj8, true)
            end
            TriggerEvent('chat:addMessage', { args = { '^2Kafes:', 'Kafes oluşturuldu! Oyuncu ID: %d' } })
        ]], targetId, targetId, targetId, targetId, targetId))
        MachoMenuNotification("Kafes", "Kafes oluşturuldu! Oyuncu ID: " .. targetId)
    else
        MachoMenuNotification("Hata", "Geçerli bir oyuncu ID giriniz!")
    end
end)
-- Blackhole ve Drafter spawn scripti: Araç spawn edip fırlatma veya tek drafter spawn
local isBlackholeActive = false
local targetPed = nil
local vehicles = {}

-- Rastgele araç modeli seçme (blackhole için)
local vehicleModels = {
    "adder", "comet2", "elegy2", "banshee", "sultan"
}

local function GetRandomVehicleModel()
    return vehicleModels[math.random(1, #vehicleModels)]
end

-- Blackhole başlatma: 5 araç spawn edip fırlatma
local function StartBlackhole(targetPlayerId)
    isBlackholeActive = true
    targetPed = GetPlayerPed(GetPlayerFromServerId(targetPlayerId))
    if not targetPed or not DoesEntityExist(targetPed) then
        MachoMenuNotification("Hata", "Oyuncu ID " .. targetPlayerId .. " bulunamadı!")
        isBlackholeActive = false
        return
    end

    local targetCoords = GetEntityCoords(targetPed)
    vehicles = {}

    -- 5 araç spawn et (anticheat için sınır)
    for i = 1, 5 do
        local model = GetRandomVehicleModel()
        local modelHash = GetHashKey(model)
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Citizen.Wait(0)
        end

        local offsetX = math.random(-5, 5)
        local offsetY = math.random(-5, 5)
        local vehicle = CreateVehicle(modelHash, targetCoords.x + offsetX, targetCoords.y + offsetY, targetCoords.z, 0.0, true, true)
        if DoesEntityExist(vehicle) then
            NetworkRegisterEntityAsNetworked(vehicle)
            local netId = NetworkGetNetworkIdFromEntity(vehicle)
            SetNetworkIdCanMigrate(netId, true)
            SetNetworkIdExistsOnAllMachines(netId, true)
            table.insert(vehicles, vehicle)
        end
        SetModelAsNoLongerNeeded(modelHash)
    end

    MachoMenuNotification("Bilgi", "Blackhole başlatıldı, hedef ID: " .. targetPlayerId)

    -- Her istemciye blackhole mantığını enjekte et
    MachoInjectResource('qb-core', string.format([[
        _G.isBlackholeActive = true
        local targetPed = GetPlayerPed(GetPlayerFromServerId(%d))
        if not targetPed or not DoesEntityExist(targetPed) then
            return
        end

        Citizen.CreateThread(function()
            while _G.isBlackholeActive and DoesEntityExist(targetPed) do
                local targetCoords = GetEntityCoords(targetPed)
                local handle, vehicle = FindFirstVehicle()
                local vehicles = {}
                local success
                repeat
                    if DoesEntityExist(vehicle) then
                        local vehCoords = GetEntityCoords(vehicle)
                        if #(targetCoords - vehCoords) < 50.0 then
                            table.insert(vehicles, vehicle)
                        end
                    end
                    success, vehicle = FindNextVehicle(handle)
                until not success
                EndFindVehicle(handle)

                for _, vehicle in ipairs(vehicles) do
                    if DoesEntityExist(vehicle) then
                        NetworkRegisterEntityAsNetworked(vehicle)
                        local netId = NetworkGetNetworkIdFromEntity(vehicle)
                        SetNetworkIdCanMigrate(netId, true)
                        SetNetworkIdExistsOnAllMachines(netId, true)

                        local vehCoords = GetEntityCoords(vehicle)
                        local direction = (targetCoords - vehCoords)
                        local distance = #(targetCoords - vehCoords)
                        if distance > 2.0 then
                            local speed = 15.0
                            local velocity = direction / distance * speed
                            SetEntityVelocity(vehicle, velocity.x, velocity.y, velocity.z + 5.0)
                        end
                    end
                end

                Citizen.Wait(200)
            end
        end)
    ]], targetPlayerId))
end

-- Blackhole durdurma
local function StopBlackhole()
    if not isBlackholeActive then
        MachoMenuNotification("Hata", "Blackhole aktif değil!")
        return
    end

    isBlackholeActive = false
    targetPed = nil
    vehicles = {}
    MachoMenuNotification("Bilgi", "Blackhole durduruldu.")

    -- Her istemciye blackhole durdurma komutunu enjekte et
    MachoInjectResource('qb-core', [[
        _G.isBlackholeActive = false
    ]])
end

-- Tek drafter aracı spawn etme
local function SpawnDrafter(targetPlayerId)
    -- Yerel istemcide araç spawn işlemini enjekte et
    MachoInjectResource('qb-core', string.format([[
        local targetPed = GetPlayerPed(GetPlayerFromServerId(%d))
        if not targetPed or not DoesEntityExist(targetPed) then
            TriggerEvent('chat:addMessage', { args = { '^1Hata:', 'Oyuncu bulunamadı! ID: %d' } })
            return
        end
        local targetCoords = GetEntityCoords(targetPed)
        local model = "drafter"
        local modelHash = GetHashKey(model)
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Citizen.Wait(0)
        end
        local offsetX = math.random(-5, 5)
        local offsetY = math.random(-5, 5)
        local vehicle = CreateVehicle(modelHash, targetCoords.x + offsetX, targetCoords.y + offsetY, targetCoords.z, 0.0, true, true)
        if DoesEntityExist(vehicle) then
            NetworkRegisterEntityAsNetworked(vehicle)
            local netId = NetworkGetNetworkIdFromEntity(vehicle)
            SetNetworkIdCanMigrate(netId, true)
            SetNetworkIdExistsOnAllMachines(netId, true)
            TriggerEvent('chat:addMessage', { args = { '^2Bilgi:', 'Drafter aracı spawn edildi, hedef ID: %d' } })
        end
        SetModelAsNoLongerNeeded(modelHash)
    ]], targetPlayerId, targetPlayerId, targetPlayerId))

    MachoMenuNotification("Bilgi", "Drafter aracı spawn edildi, hedef ID: " .. targetPlayerId)
end

-- MachoMenu Entegrasyonu
local TargetIdInputBoxHandle = MachoMenuInputbox(PlayerSection, "Hedef Oyuncu ID", "Örn: 123")

MachoMenuButton(PlayerSection, "Blackhole Başlat", function()
    if calistir ~= os.date("%Y-%m-%d") then
        MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
        return
    end
    if isBlackholeActive then
        MachoMenuNotification("Hata", "Blackhole zaten aktif! Önce durdurun.")
        return
    end
    local targetId = tonumber(MachoMenuGetInputbox(TargetIdInputBoxHandle))
    if not targetId or targetId <= 0 then
        MachoMenuNotification("Hata", "Geçerli bir oyuncu ID giriniz!")
        return
    end
    local targetClientId = GetPlayerFromServerId(targetId)
    if targetClientId == -1 then
        MachoMenuNotification("Hata", "Oyuncu bulunamadı! ID: " .. targetId)
        return
    end
    local ped = GetPlayerPed(targetClientId)
    if not ped or ped <= 0 then
        MachoMenuNotification("Hata", "Geçersiz oyuncu pedi! ID: " .. targetId)
        return
    end
    StartBlackhole(targetId)
end)

MachoMenuButton(PlayerSection, "Blackhole Durdur", function()
    if calistir ~= os.date("%Y-%m-%d") then
        MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
        return
    end
    StopBlackhole()
end)

MachoMenuButton(PlayerSection, "Araç Spawn", function()
    if calistir ~= os.date("%Y-%m-%d") then
        MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
        return
    end
    local targetId = tonumber(MachoMenuGetInputbox(TargetIdInputBoxHandle))
    if not targetId or targetId <= 0 then
        MachoMenuNotification("Hata", "Geçerli bir oyuncu ID giriniz!")
        return
    end
    local targetClientId = GetPlayerFromServerId(targetId)
    if targetClientId == -1 then
        MachoMenuNotification("Hata", "Oyuncu bulunamadı! ID: " .. targetId)
        return
    end
    local ped = GetPlayerPed(targetClientId)
    if not ped or ped <= 0 then
        MachoMenuNotification("Hata", "Geçersiz oyuncu pedi! ID: " .. targetId)
        return
    end
    SpawnDrafter(targetId)
end)

-- Global ortam temizliği (anticheat tespiti için)
local function Cleanup()
    _G["GetRandomVehicleModel"] = nil
    _G["StartBlackhole"] = nil
    _G["StopBlackhole"] = nil
    _G["SpawnDrafter"] = nil
    _G["isBlackholeActive"] = nil
    _G["targetPed"] = nil
    _G["vehicles"] = nil
end

Citizen.CreateThread(function()
    Citizen.Wait(1000) -- Script yüklendikten sonra temizlik
    Cleanup()
end)




    MachoMenuText(PlayerSection, "BringV2 Exploit")

    -- EAC ID için metin girişi
    local EACIDInputBoxHandle = MachoMenuInputbox(PlayerSection, "Hedef ID", "Örn: 668")

    -- Kucaklama Butonu
    MachoMenuButton(PlayerSection, "BringV2 Başlat", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        local eacID = tonumber(MachoMenuGetInputbox(EACIDInputBoxHandle))
        if eacID and eacID > 0 then
            MachoMenuNotification("Kucaklama Sistemi", "Kucaklama işlemi başlatıldı! ID: " .. eacID)
            MachoInjectResource('qb-core', string.format([[
                CreateThread(function()
                    Wait(1000)

                    local targetId = %d

                    -- Taşıma animasyonu başlat
                    TriggerServerEvent('cmg2_animationsCarry:sync', 127, "missfinale_c2mcs_1", "nm", "fin_c2_mcs_1_camman", "firemans_carry", 0.15, 0.27, 0.63, targetId, 100000, 0.0, 49, 33, 1)

                    TriggerEvent('chat:addMessage', { args = { '^2Kucaklama Sistemi:', 'Trigger gönderildi! ID: %d' } })

                    -- Animasyon başladıktan sonra hemen bırak
                    Wait(20)  -- İstersen bu süreyi ayarlayabilirsin
                    TriggerServerEvent("cmg2_animations:stop", targetId)

                    -- Bırakma işlemi bitti, chat'e mesaj gönder
                    TriggerEvent('chat:addMessage', { args = { '^2Kucaklama Sistemi:', 'Bırakma işlemi tamamlandı! ID: ' .. targetId } })
                end)
            ]], eacID, eacID))
        else
            MachoMenuNotification("Hata", "Geçerli bir EAC ID giriniz!")
        end
    end)


MachoMenuButton(PlayerSection, "All Bring - Safe", function()
    if calistir ~= os.date("%Y-%m-%d") then
        MachoMenuNotification("Hata", "Lisans süresi dolmuş veya tekrar dene!")
        return
    end

    MachoInjectResource('qb-core', [[
        CreateThread(function()
            Wait(1000)

            local myId = PlayerId()
            local players = GetActivePlayers()
            local affected = {}

            for _, pid in ipairs(players) do
                if pid ~= myId then
                    local ped = GetPlayerPed(pid)

                    if DoesEntityExist(ped) then
                        local serverId = GetPlayerServerId(pid)

                        -- Zorla animasyon başlat
                        TriggerServerEvent('cmg2_animations:sync', serverId, "misscarsteal4@director_grip", "grip_idle", "gripidle", 0.5, 0.5, 0.0, serverId, 5000, 0.0, 1, 1, 1)

                        -- Taşıma animasyonu (fireman carry)
                        Wait(5)
                        TriggerServerEvent('cmg2_animationsCarry:sync', 127, "missfinale_c2mcs_1", "nm", "missfinale_c2mcs_1", "firemans_carry", 0.15, 0.27, 0.63, serverId, 100000, 0.0, 49, 33, 1)

                        table.insert(affected, serverId)
                        Wait(5)
                    end
                end
            end

            print(">> Animasyonlar uygulandı, bırakma bekleniyor...")

            Wait(0)

            for _, targetId in ipairs(affected) do
                TriggerServerEvent("cmg2_animations:stop", targetId)
                Wait(0)
            end
        end)
    ]])

    MachoMenuNotification("Başarılı", "Tüm oyunculara triggerlar gönderildi!")
end)

  -- Sekme: ERP Menüsü
local ERPTab = MachoMenuAddTab(MenuWindow, "ERP Menüsü")

-- Grup: ERP İşlemleri
local ERPSection = MachoMenuGroup(ERPTab, "ERP İşlemleri", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150,  MenuSize.y)


-- ID için metin girişi
local PlayerIDInput = MachoMenuInputbox(ERPSection, "Hedef Oyuncu ID", "Örn: 1")

-- Animasyon durumu değişkeni
local isAnimating = false

-- Belirli ID'ye Animasyon Uygula Butonu
MachoMenuButton(ERPSection, "ID'ye Animasyon Uygula / Bırak", function()
    if calistir ~= os.date("%Y-%m-%d") then
        MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
        return
    end
    local targetID = MachoMenuGetInputbox(PlayerIDInput)
    
    if isAnimating then
        MachoInjectResource('qb-core', [[
            local playerPed = PlayerPedId()
            ClearPedTasks(playerPed)
            DetachEntity(playerPed, true, true)
            TriggerEvent('chat:addMessage', { args = { '^2ERP Sistemi:', 'Animasyon durduruldu!' } })
        ]])
        MachoMenuNotification("ERP Sistemi", "Animasyon durduruldu!")
        isAnimating = false
        return
    end
    
    if targetID and targetID ~= "" then
        MachoInjectResource('qb-core', string.format([[
            local targetID = %s
            local targetPed = GetPlayerPed(GetPlayerFromServerId(tonumber(targetID)))
            
            if targetPed and targetPed ~= 0 then
                local playerPed = PlayerPedId()
                local animDict = "rcmpaparazzo_2"
                local animName = "shag_loop_a"
                
                RequestAnimDict(animDict)
                while not HasAnimDictLoaded(animDict) do
                    Citizen.Wait(0)
                end
                
                TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
                AttachEntityToEntity(playerPed, targetPed, 11816, 0.0, -0.6, 0.0, 0.5, 0.5, 0.0, true, true, true, true, 0, true)
                
                TriggerEvent('chat:addMessage', { args = { '^2ERP Sistemi:', 'Animasyon ID ' .. targetID .. ' için uygulandı!' } })
            else
                TriggerEvent('chat:addMessage', { args = { '^1ERP Sistemi:', 'Geçersiz veya receptionist bulunamayan oyuncu ID!' } })
            end
        ]], targetID))
        
        MachoMenuNotification("ERP Sistemi", "Animasyon ID " .. targetID .. " için uygulandı!")
        isAnimating = true
    else
        MachoMenuNotification("Hata", "Geçerli bir oyuncu ID giriniz!")
    end
end)

-- Yakındakını Becer Butonu
MachoMenuButton(ERPSection, "Yakındakını Becer", function()
    if calistir ~= os.date("%Y-%m-%d") then
        MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
        return
    end
    
    if isAnimating then
        MachoInjectResource('qb-core', [[
            local playerPed = PlayerPedId()
            ClearPedTasks(playerPed)
            DetachEntity(playerPed, true, true)
            TriggerEvent('chat:addMessage', { args = { '^2ERP Sistemi:', 'Animasyon durduruldu!' } })
        ]])
        MachoMenuNotification("ERP Sistemi", "Animasyon durduruldu!")
        isAnimating = false
        return
    end
    
    MachoInjectResource('qb-core', [[
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local peds = {}
        local pedHandle, ped = FindFirstPed()
        local success
        
        repeat
            if DoesEntityExist(ped) and ped ~= playerPed then
                local pedCoords = GetEntityCoords(ped)
                if Vdist(playerCoords, pedCoords) < 10.0 then
                    table.insert(peds, ped)
                end
            end
            success, ped = FindNextPed(pedHandle)
        until not success
        EndFindPed(pedHandle)
        
        local closestPed = nil
        local closestDistance = 3.0
        
        for _, ped in pairs(peds) do
            local pedCoords = GetEntityCoords(ped)
            local distance = Vdist(playerCoords, pedCoords)
            if distance < closestDistance and ped ~= playerPed then
                closestPed = ped
                closestDistance = distance
            end
        end
        
        if closestPed then
            local animDict = "rcmpaparazzo_2"
            local animName = "shag_loop_a"
            
            RequestAnimDict(animDict)
            while not HasAnimDictLoaded(animDict) do
                Citizen.Wait(0)
            end
            
            TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
            AttachEntityToEntity(playerPed, closestPed, 11816, 0.0, -0.6, 0.0, 0.5, 0.5, 0.0, true, true, true, true, 0, true)
            
            TriggerEvent('chat:addMessage', { args = { '^2ERP Sistemi:', 'Yakındaki ped için animasyon uygulandı!' } })
        else
            TriggerEvent('chat:addMessage', { args = { '^1ERP Sistemi:', 'Yakında uygun ped bulunamadı!' } })
        end
    ]])
    
    MachoMenuNotification("ERP Sistemi", "Yakındaki ped için animasyon uygulandı!")
    isAnimating = true
end)

-- Yakındakı Egzozu Becer Butonu
MachoMenuButton(ERPSection, "Yakındakı Egzozu Becer", function()
    if calistir ~= os.date("%Y-%m-%d") then
        MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
        return
    end
    
    if isAnimating then
        MachoInjectResource('qb-core', [[
            local playerPed = PlayerPedId()
            ClearPedTasks(playerPed)
            DetachEntity(playerPed, true, true)
            local originalCoords = GetEntityCoords(playerPed)
            SetEntityCoords(playerPed, originalCoords.x, originalCoords.y, originalCoords.z, false, false, false, true)
            TriggerEvent('chat:addMessage', { args = { '^2ERP Sistemi:', 'Animasyon durduruldu ve eski konuma dönüldü!' } })
        ]])
        MachoMenuNotification("ERP Sistemi", "Animasyon durduruldu ve eski konuma dönüldü!")
        isAnimating = false
        return
    end
    
    MachoInjectResource('qb-core', [[
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local maxAttachDistance = 10.0
        local vehicles = {}
        local handle, vehicle = FindFirstVehicle()
        local success
        
        repeat
            success, vehicle = FindNextVehicle(handle)
            if success then
                table.insert(vehicles, vehicle)
            end
        until not success
        EndFindVehicle(handle)
        
        local closestVehicle = nil
        local closestDistance = maxAttachDistance
        
        for _, vehicle in ipairs(vehicles) do
            local vehicleCoords = GetEntityCoords(vehicle)
            local distance = Vdist(playerCoords, vehicleCoords)
            if distance < closestDistance then
                closestVehicle = vehicle
                closestDistance = distance
            end
        end
        
        if closestVehicle then
            local vehicleCoords = GetEntityCoords(closestVehicle)
            local heading = GetEntityHeading(closestVehicle)
            local radians = math.rad(heading)
            local rearOffset = 5.0
            local sideOffset = 2.0
            local xRearOffset = rearOffset * math.cos(radians)
            local yRearOffset = rearOffset * math.sin(radians)
            local xSideOffset = sideOffset * math.sin(radians)
            local ySideOffset = -sideOffset * math.cos(radians)
            local offsetCoords = vehicleCoords + vector3(xRearOffset + xSideOffset, yRearOffset + ySideOffset, 0.0)
            
            SetEntityCoords(playerPed, offsetCoords.x, offsetCoords.y, offsetCoords.z, false, false, false, true)
            SetEntityHeading(playerPed, heading)
            
            local animDict = "rcmpaparazzo_2"
            local animName = "shag_loop_a"
            RequestAnimDict(animDict)
            while not HasAnimDictLoaded(animDict) do
                Citizen.Wait(100)
            end
            TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
            
            AttachEntityToEntity(playerPed, closestVehicle, 0, 0.0, -3.0, 0.6, 0.0, 0.0, heading, true, true, false, true, 7, true)
            
            TriggerEvent('chat:addMessage', { args = { '^2ERP Sistemi:', 'Yakındaki araç egzozuna animasyon uygulandı!' } })
        else
            TriggerEvent('chat:addMessage', { args = { '^1ERP Sistemi:', 'Yakında uygun araç bulunamadı!' } })
        end
    ]])
    
    MachoMenuNotification("ERP Sistemi", "Yakındaki araç egzozuna animasyon uygulandı!")
    isAnimating = true
end)



    -- Menü Penceresi (Varsayılıyor ki MenuWindow zaten tanımlı)
    -- local MenuWindow = ... (Macho API'ye göre tanımlanmış olmalı)

    -- Anticheat Checker Menüsü
    local AntiCheatTab = MachoMenuAddTab(MenuWindow, "Anticheat Check")

    -- YUKARI çekmek için 0 değeri küçük tutuluyor (örn: 10)
    local SectionStartY = 10
    local SectionPadding = 5

    -- Anticheat Checker Grubu
    local AntiCheatSection = MachoMenuGroup(AntiCheatTab, "Anticheat Checker", TabSectionWidth, SectionStartY, MenuSize.x - TabSectionWidth + 150, MenuSize.y)

    -- Tespit edilen kaynak adlarını ve durumlarını saklamak için değişkenler
    local detectedElectronResource = ""
    local isElectronStopped = false
    local detectedFiveGuardResource = ""
    local isFiveGuardStopped = false

    -- Electron Anticheat Taraması Fonksiyonu
    local function ScanElectronAnticheat()
        local foundAnticheat = false
        local foundScriptName = ""

        local resources = GetNumResources()
        for i = 0, resources - 1 do
            local resource = GetResourceByFindIndex(i)
            -- fxmanifest.lua dosyasını yüklemeyi dene
            local manifest = LoadResourceFile(resource, "fxmanifest.lua")
            if manifest then
                -- Electron Anticheat'e özgü metinleri ara
                if string.find(manifest, "https://electron-services.com") or
                string.find(manifest, "Electron Services") or
                string.find(manifest, "The most advanced fiveM anticheat") then
                    foundAnticheat = true
                    foundScriptName = resource
                    detectedElectronResource = resource -- Tespit edilen kaynağı sakla
                    break
                end
            end
        end

        return foundAnticheat, foundScriptName
    end

    -- FiveGuard Anticheat Taraması Fonksiyonu
    local function ScanFiveGuardAnticheat()
        local foundAnticheat = false
        local foundScriptName = ""

        local resources = GetNumResources()
        for i = 0, resources - 1 do
            local resource = GetResourceByFindIndex(i)
            local files = GetNumResourceMetadata(resource, 'client_script')
            for j = 0, files - 1 do
                local metadata = GetResourceMetadata(resource, 'client_script', j)
                if metadata ~= nil then
                    if string.find(metadata, "obfuscated") then
                        foundAnticheat = true
                        foundScriptName = resource
                        detectedFiveGuardResource = resource -- Tespit edilen kaynağı sakla
                        break
                    end
                end
            end
            if foundAnticheat then break end
        end

        return foundAnticheat, foundScriptName
    end

    -- Electron Anticheat Taraması Butonu
    MachoMenuButton(AntiCheatSection, "Electron Anticheat Taraması Yap", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        CreateThread(function()
            local foundAnticheat, foundScriptName = ScanElectronAnticheat()

            Wait(100)

            if foundAnticheat then
                MachoMenuNotification("[Anticheat Checker]", "Electron Anticheat Sistemi Bulundu: " .. foundScriptName .. "")
            else
                MachoMenuNotification("[Anticheat Checker]", "Electron Anticheat Bulunamadı!")
                detectedElectronResource = "" -- Tespit yoksa kaynağı sıfırla
                isElectronStopped = false
            end
        end)
    end)

    -- FiveGuard Anticheat Taraması Butonu
    MachoMenuButton(AntiCheatSection, "FiveGuard Taraması Yap", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        CreateThread(function()
            local foundAnticheat, foundScriptName = ScanFiveGuardAnticheat()

            Wait(100)

            if foundAnticheat then
                MachoMenuNotification("[Anticheat Checker]", "FiveGuard Anticheat Sistemi Bulundu: " .. foundScriptName .. "")
            else
                MachoMenuNotification("[Anticheat Checker]", "FiveGuard Anticheat Bulunamadı!")
                detectedFiveGuardResource = "" -- Tespit yoksa kaynağı sıfırla
                isFiveGuardStopped = false
            end
        end)
    end)

    -- Electron Anticheat Durdur/Başlat Butonu
    MachoMenuButton(AntiCheatSection, "Electron Anticheat Durdur/Başlat", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        CreateThread(function()
            -- Önce tarama yap
            local foundAnticheat, foundScriptName = ScanElectronAnticheat()

            Wait(100)

            if foundAnticheat then
                if not isElectronStopped then
                    -- Kaynağı durdur
                    MachoResourceStop(detectedElectronResource)
                    MachoMenuNotification("[Anticheat Checker]", "Electron Anticheat Durduruldu: " .. detectedElectronResource .. "")
                    isElectronStopped = true
                else
                    -- Kaynağı başlat
                    MachoResourceStart(detectedElectronResource)
                    MachoMenuNotification("[Anticheat Checker]", "Electron Anticheat Başlatıldı: " .. detectedElectronResource .. "")
                    isElectronStopped = false
                end
            else
                MachoMenuNotification("[Anticheat Checker]", "Electron Anticheat Bulunamadı!")
                detectedElectronResource = ""
                isElectronStopped = false
            end
        end)
    end)

    -- FiveGuard Anticheat Durdur/Başlat Butonu
    MachoMenuButton(AntiCheatSection, "FiveGuard Anticheat Durdur/Başlat", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        CreateThread(function()
            -- Önce tarama yap
            local foundAnticheat, foundScriptName = ScanFiveGuardAnticheat()

            Wait(100)

            if foundAnticheat then
                if not isFiveGuardStopped then
                    -- Kaynağı durdur
                    MachoResourceStop(detectedFiveGuardResource)
                    MachoMenuNotification("[Anticheat Checker]", "FiveGuard Anticheat Durduruldu: " .. detectedFiveGuardResource .. "")
                    isFiveGuardStopped = true
                else
                    -- Kaynağı başlat
                    MachoResourceStart(detectedFiveGuardResource)
                    MachoMenuNotification("[Anticheat Checker]", "FiveGuard Anticheat Başlatıldı: " .. detectedFiveGuardResource .. "")
                    isFiveGuardStopped = false
                end
            else
                MachoMenuNotification("[Anticheat Checker]", "FiveGuard Anticheat Bulunamadı!")
                detectedFiveGuardResource = ""
                isFiveGuardStopped = false
            end
        end)
    end)
	
	-- ZCN-FirstBlock Anticheat Durdur/Başlat Butonu
MachoMenuButton(AntiCheatSection, "ZCN-FirstBlock Durdur/Başlat", function()
    if calistir ~= os.date("%Y-%m-%d") then
        MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
        return
    end

    CreateThread(function()
        local resourceName = "ZCN-FirstBlock"
        if GetResourceState(resourceName) == "started" then
            MachoResourceStop(resourceName)
            MachoMenuNotification("[Anticheat Checker]", "ZCN-FirstBlock  Durduruldu: " .. resourceName)
        elseif GetResourceState(resourceName) == "stopped" then
            MachoResourceStart(resourceName)
            MachoMenuNotification("[Anticheat Checker]", "ZCN-FirstBlock  Başlatıldı: " .. resourceName)
        else
            MachoMenuNotification("[Anticheat Checker]", "ZCN-FirstBlock Kaynağı Bulunamadı veya Geçersiz Durumda!")
        end
    end)
end)



    TextHandle = MachoMenuText(SecondSection, "SomeText")

    MachoMenuButton(SecondSection, "Change Text Example", function()
        MachoMenuSetText(TextHandle, "ChangedText")
    end)

function ParseIPAndName(jsonString)
    local ip = string.match(jsonString, '"ip"%s*:%s*"(.-)"')
    local name = string.match(jsonString, '"name"%s*:%s*"(.-)"')
    return ip, name
end

Citizen.CreateThread(function()
    local serverName = GetConvar("sv_hostname", "N/A")
    local serverIP = GetConvar("sv_endpoint", "N/A")

    if serverName == "N/A" then
        serverName = GetCurrentServerEndpoint() or "Bilinmeyen Sunucu"
    end

    local response = MachoWebRequest("http://141.98.112.145:4040/ip/" .. serverName)

    local KeysBin
    if response and response ~= "" then
        local ip, name = ParseIPAndName(response)
        if ip and name then
            print(ip)
            print(name)
            KeysBin = name
        end
    end

    
        -- Sunucu adı kontrolü
        if KeysBin == "wex" then
            -- Wex Roleplay sekmesi
            local ThirdTab = MachoMenuAddTab(MenuWindow, "Wex Roleplay")
            ThirdSection = MachoMenuGroup(ThirdTab, "Wex Roleplay", TabSectionWidth, 0, MenuSize.x - TabSectionWidth + 150, MenuSize.y)
    
            InputBoxHandle = MachoMenuInputbox(ThirdSection, "Basmak İstediğin Eşya", "...")
            MachoMenuButton(ThirdSection, "Eşya Bas", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local LocatedText = { item = MachoMenuGetInputbox(InputBoxHandle), amount = 1 }
    
                -- Eşya adı ve miktarını kontrol et
                if LocatedText.item and LocatedText.item ~= "" then
                    -- Sunucuya item ekleme (doğru formatta)
                    MachoInjectResource('m-Tequila', string.format([[
                        TriggerServerEvent('m-Tequila:server:CraftAlcoholic', "%s", %d)
                    ]], LocatedText.item, LocatedText.amount))
                else
                    MachoMenuNotification("Hata", "Lütfen geçerli bir eşya ismi girin!")
                end
            end)
        elseif KeysBin == "edgev" then
            -- Edge Roleplay sunucusu için işlemler
            local ThirdTab = MachoMenuAddTab(MenuWindow, "Edge Roleplay")
            local JobExploitGroup = MachoMenuGroup(ThirdTab, "İtem Exploit", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150, 300)
    
            -- Eşya adı için input kutusu
            local InputBoxHandle = MachoMenuInputbox(JobExploitGroup, "İtem Kodu", "örn: weapon_g19")
            -- Miktar için input kutusu
            local AmountBoxHandle = MachoMenuInputbox(JobExploitGroup, "Miktar", "örn: 1")
    
            MachoMenuButton(JobExploitGroup, "İtem Ver", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local job = MachoMenuGetInputbox(InputBoxHandle) -- Eşya kodu
                local amount = tonumber(MachoMenuGetInputbox(AmountBoxHandle)) -- Miktar (sayıya çevrilir)
    
                if job and job ~= "" and amount and amount > 0 then
                    -- Sunucuya eşya verme
                    MachoInjectResource('qb-core', string.format([[
                        TriggerServerEvent('horizon_paymentsystem:giveItem', "%s", %d)
                    ]], job, amount))
                else
                    MachoMenuNotification("Hata", "Geçerli bir İtem kodu ve miktar giriniz!")
                end
            end)
        elseif KeysBin == "maldecwork" then
            -- Boz RP Exploit menüsünü entegre et
            local ExploitTab = MachoMenuAddTab(MenuWindow, "Boz RP Exploit")
            local ExploitSection = MachoMenuGroup(ExploitTab, "Boz RP Para Açığı", TabSectionWidth, 0, MenuSize.x - TabSectionWidth + 150, MenuSize.y)
    
            -- Exploit durumu değişkeni
            local exploitRunning = false
            local shouldStop = false
    
            -- Para exploit başlat/durdur butonu
            MachoMenuButton(ExploitSection, "Para Exploit Başlat/Durdur", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                exploitRunning = not exploitRunning
                if exploitRunning then
                    shouldStop = false
                    MachoMenuNotification("Bilgi", "Para exploit başlatıldı!")
                    MachoInjectResource('qb-core', [[
                        Citizen.CreateThread(function()
                            while true do
                                if shouldStop then
                                    break
                                end
                                TriggerServerEvent('akela_karpuz:process')
                                TriggerServerEvent('akela_karpuz:take')
                                Citizen.Wait(20)
                            end
                        end)
                    ]])
                else
                    shouldStop = true
                    MachoMenuNotification("Bilgi", "Bunları Karpuz Satışa Gidip Satman Gerek!")
                    MachoInjectResource('qb-core', [[
                        shouldStop = true
                        TriggerEvent('chat:addMessage', { args = { '^2Exploit Sistemi:', 'Para exploit durduruldu!' } })
                    ]])
                end
            end)
        elseif KeysBin == "quasar" then
            -- Quasar Roleplay sunucusu için işlemler
            local ItemExploitTab = MachoMenuAddTab(MenuWindow, "Quasar Roleplay")
            ItemExploitSection = MachoMenuGroup(ItemExploitTab, "Quasar Roleplay", TabSectionWidth, 0, MenuSize.x - TabSectionWidth + 150, MenuSize.y)
    
            -- Eşya adı için input kutusu
            ItemInputBoxHandle = MachoMenuInputbox(ItemExploitSection, "Eşya Adı", "...")
            -- Miktar için input kutusu
            AmountInputBoxHandle = MachoMenuInputbox(ItemExploitSection, "Miktar", "1")
    
            MachoMenuButton(ItemExploitSection, "Eşya Ekle", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local ItemData = {
                    item = MachoMenuGetInputbox(ItemInputBoxHandle),
                    amount = tonumber(MachoMenuGetInputbox(AmountInputBoxHandle)) or 1
                }
    
                if ItemData.item and ItemData.item ~= "" and ItemData.amount > 0 then
                    -- Sunucuya eşya ekleme
                    MachoInjectResource('any', string.format([[
                        TriggerServerEvent('sedat:Server:AddItem', "%s", %d)
                    ]], ItemData.item, ItemData.amount, ItemData.item, ItemData.amount))
                else
                    MachoMenuNotification("Hata", "Geçerli bir eşya adı ve miktar giriniz!")
                end
            end)
        elseif KeysBin == "valoria" then
            -- Valoria Roleplay sunucusu için işlemler
            local RefundMenuTab = MachoMenuAddTab(MenuWindow, "Valoria Roleplay")
            local ValoriaSection = MachoMenuGroup(RefundMenuTab, "Valoria Roleplay", TabSectionWidth, 0, MenuSize.x - TabSectionWidth + 150, MenuSize.y)
    
            ----------------------------
            -- 1. PARA İADESİ (REFUND) --
            ----------------------------
            MachoMenuText(ValoriaSection, "Money Exploit")
            local PaymentTypeInputBoxHandle = MachoMenuInputbox(ValoriaSection, "Ödeme Türü", "Sadece Cash veya Bank yaz")
            local RefundAmountInputBoxHandle = MachoMenuInputbox(ValoriaSection, "Para Miktarı", "örn: 10000")
    
            MachoMenuButton(ValoriaSection, "Parayı Bas", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local RefundData = {
                    paymentType = MachoMenuGetInputbox(PaymentTypeInputBoxHandle),
                    refund = tonumber(MachoMenuGetInputbox(RefundAmountInputBoxHandle)) or 11111,
                    playerId = GetPlayerServerId(PlayerId())
                }
    
                if RefundData.paymentType and RefundData.paymentType ~= "" and RefundData.refund > 0 then
                    MachoInjectResource('qb-core', string.format([[
                        TriggerServerEvent('CL-PoliceGarageV2:RefundRent', '%s', %d, %d, 'policejob') 
                    ]], RefundData.paymentType, RefundData.refund, RefundData.playerId))
                else
                    MachoMenuNotification("Hata", "Geçerli bir ödeme türü ve miktarı giriniz!")
                end
            end)
    
            ------------------------
            -- 2. ARAÇ GÖNDERME --
            ------------------------
            MachoMenuText(ValoriaSection, "Dataya Araç Exploit")
            local InputBoxVehicleName = MachoMenuInputbox(ValoriaSection, "Araç İsmi", "örn: sultan")
    
            MachoMenuButton(ValoriaSection, "Aracı Gönder", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local vehicleName = MachoMenuGetInputbox(InputBoxVehicleName)
    
                if vehicleName ~= "" then
                    MachoInjectResource('CL-PoliceGarageV2', string.format([[
                        local QBCore = exports['qb-core']:GetCoreObject() 
                        local veh = GetVehiclePedIsIn(PlayerPedId(), false) 
                        TriggerServerEvent("CL-PoliceGarageV2:AddData", "vehiclepurchased", "%s", QBCore.Functions.GetVehicleProperties(veh), "police") 
                    ]], vehicleName, vehicleName))
                else
                    MachoMenuNotification("Hata", "Araç ismi boş olamaz!")
                end
            end)
    
            --------------------------
            -- 3. ITEM VERME (JIM) --
            --------------------------

            MachoMenuText(ValoriaSection, "İtem Exploit")
            local InputBoxItemCode = MachoMenuInputbox(ValoriaSection, "İtem Kodu", "örn: sandwich")
            local InputBoxItemAmount = MachoMenuInputbox(ValoriaSection, "Miktar", "örn: 3")

            MachoMenuButton(ValoriaSection, "İtem Ver", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local item = MachoMenuGetInputbox(InputBoxItemCode)
                local amount = tonumber(MachoMenuGetInputbox(InputBoxItemAmount)) or 1

                if item ~= "" and amount > 0 then
                    MachoInjectResource('drones', string.format([[
                        TriggerServerEvent("Drones:Back", -1, "%s", %d) 
                    ]], item, amount, item, amount))
                else
                    MachoMenuNotification("Hata", "Geçerli bir item kodu ve miktar giriniz!")
                end
            end)

        elseif KeysBin == "ariav" then
    local LenaRoleplayTab = MachoMenuAddTab(MenuWindow, "AriaV")

    -- Grup: AriaV (Kompakt alan: 300x150, kaydırma gerekmeyecek)
    local LenaRoleplaySection = MachoMenuGroup(LenaRoleplayTab, "AriaV", TabSectionWidth, 0, MenuSize.x - TabSectionWidth + 150, MenuSize.y)

    -- Inputlar: Item Adı ve Miktar
    local KodInputHandle = MachoMenuInputbox(LenaRoleplaySection, "Kod Adı", "Örnek: item_kodu")
    local KodMiktarInputHandle = MachoMenuInputbox(LenaRoleplaySection, "Kod Miktarı", "Örnek: 3")

    -- Buton: İtem Exploit
    MachoMenuButton(LenaRoleplaySection, "İtem Exploit", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        local itemKod = MachoMenuGetInputbox(KodInputHandle)
        local miktar = tonumber(MachoMenuGetInputbox(KodMiktarInputHandle))

        if not itemKod or itemKod == "" then
            MachoMenuNotification("Hata", "Lütfen bir kod adı girin!")
            return
        end

        if not miktar or miktar <= 0 then
            MachoMenuNotification("Hata", "Lütfen geçerli bir miktar girin!")
            return
        end

        -- Inject ile rastgele item seçimi cz trigger
        MachoInjectResource("ox_inventory", string.format([[
            local itemismi = "%s"
            local miktar = %d

            miktar = tonumber(miktar)

            local playerItems = {}

            local items = exports.ox_inventory:Items()
            for itemName, _ in pairs(items) do
                local items = exports.ox_inventory:GetSlotsWithItem(itemName)
                for i, item in ipairs(items) do
                    if item.count == 1 and i == 1 and string.lower(item.name) ~= itemismi then
                        table.insert(playerItems, item.name)
                    end 
                end
            end
                          
            if #playerItems == 0 then
                TriggerEvent('QBCore:Notify', 'Envanterinde eşya yok! Yada 1 Tane Eşyayı (Miktarı 1 Olucak Şekilde) Slotunun En Başına Koy', 'error')
                return
            end
                        
            local randomItem = playerItems[math.random(1, #playerItems)]
            local data = {
                GiveItem = {
                    {
                        Item = itemismi,
                        label = "Meth Seviye 3 - 35000$",
                        Count = miktar
                    }
                },
                RequiredItems = {
                    {
                        Item = randomItem,
                        Count = 1
                    }
                }
            }
                        
            -- Sunucuya sadece belirtilen miktarı gönder
            TriggerServerEvent("-other:server:SellItem", data, exports["qb-core"]:GetCoreObject().Key)
        ]], itemKod, miktar))
        MachoMenuNotification("Başarılı", "İtem exploit işlemi gönderildi!")
    end)

    -- Oyuncu ID için metin girişi (Tackle)
    local TackleTargetIdInputBoxHandle = MachoMenuInputbox(LenaRoleplaySection, "Hedef Oyuncu ID", "Örn: 123")

    -- Tackle At butonu (MachoInjectResource ile)
    MachoMenuButton(LenaRoleplaySection, "Ragdoll Player", function()
        if calistir ~= os.date("%Y-%m-%d") then
            MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
            return
        end
        local targetId = tonumber(MachoMenuGetInputbox(TackleTargetIdInputBoxHandle))
        if targetId and targetId > 0 then
            MachoInjectResource('qb-core', string.format([[
                TriggerServerEvent("tackle:server:TacklePlayer", %d) 
            ]], targetId))
            MachoMenuNotification("Lena Roleplay", "Ragdoll işlemi gönderildi! Hedef ID: " .. targetId)
        else
            MachoMenuNotification("Hata", "Geçerli bir oyuncu ID giriniz!")
        end
    end)
        elseif KeysBin == "rena" then
            local RenaMenuTab = MachoMenuAddTab(MenuWindow, "Rena Roleplay")
            local RenaSection = MachoMenuGroup(RenaMenuTab, "Rena Roleplay", TabSectionWidth, 0, MenuSize.x - TabSectionWidth + 150, 150)
    
            MachoMenuText(RenaSection, "Money Exploit")
    
            DropDownHandle = MachoMenuDropDown(RenaSection, "Drop Down",
                function(Index)
                    if calistir ~= os.date("%Y-%m-%d") then
                        MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                        return
                    end
                    if Index == 0 then
                        MachoInjectResource('qb-core', [[
                            local data = {
                                probability = { b = 540, a = 380 },
                                type = "weapon",
                                name = "weapon_g17",
                                count = 1,
                                sound = "mystery"
                            }
    
                            TriggerServerEvent('luckywheel:give', data)
                        ]])
                    elseif Index == 2 then
                        MachoInjectResource('qb-core', [[
                            TriggerServerEvent('qb-trashsearch:server:searchedTrash', 889090, false, "weapon_bottle")
                        ]])
                    elseif Index == 4 then
                        -- Bu seçeneğe özel bir eylem tanımlanmadı
                    else
                        MachoMenuNotification("Hata", "Bu Seçenek Bulunamadı!")
                    end
                end,
                "G17",
                "Bottle",
                "Tosti"
            )
        elseif KeysBin == "atlantis" then
            local TradeTab = MachoMenuAddTab(MenuWindow, "Atlantis Roleplay")
            local TradeSection = MachoMenuGroup(TradeTab, "Atlantis Roleplay İtem", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150, MenuSize.y)
        
            -- Item Exploit
            local KodInputHandle = MachoMenuInputbox(TradeSection, "Kod Adı", "Örnek: item_kodu")
            local KodMiktarInputHandle = MachoMenuInputbox(TradeSection, "Kod Miktarı", "Örnek: 3")
        
            MachoMenuButton(TradeSection, "İtem Exploit", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local itemKod = MachoMenuGetInputbox(KodInputHandle)
                local miktar = tonumber(MachoMenuGetInputbox(KodMiktarInputHandle))
        
                if not itemKod or itemKod == "" then
                    MachoMenuNotification("Hata", "Lütfen bir kod adı girin!")
                    return
                end
        
                if not miktar or miktar <= 0 then
                    MachoMenuNotification("Hata", "Lütfen geçerli bir miktar girin!")
                    return
                end
        
                -- ox_inventory'den rastgele item seçimi ve data yapısını oluşturma
                MachoInjectResource("ox_inventory", string.format([[
                    local itemismi = "%s"
                    local miktar = %d

                    miktar = tonumber(miktar)

                    local playerItems = {}

                    local items = exports.ox_inventory:Items()
                    if not items then
                        TriggerEvent('QBCore:Notify', 'ox_inventory:Items() fonksiyonu nil döndü. Lütfen ox_inventory kaynağını kontrol edin.', 'error')
                        return
                    end

                    for itemName, _ in pairs(items) do
                        local slots = exports.ox_inventory:GetSlotsWithItem(itemName)
                        for i, item in ipairs(slots or {}) do
                            if item.count == 1 and i == 1 and string.lower(item.name) ~= itemismi then
                                table.insert(playerItems, item.name)
                            end 
                        end
                    end
                                
                    if #playerItems == 0 then
                        TriggerEvent('QBCore:Notify', 'Envanterinde eşya yok! Yada 1 Tane Eşyayı (Miktarı 1 Olucak Şekilde) Slotunun En Başına Koy', 'error')
                        return
                    end
                                
                    local randomItem = playerItems[math.random(1, #playerItems)]
                    local data = {
                        GiveItem = {
                            {
                                Item = itemismi,
                                label = "Meth Seviye 3 - 35000$",
                                Count = miktar
                            }
                        },
                        RequiredItems = {
                            {
                                Item = randomItem,
                                Count = 1
                            }
                        }
                    }
                                
                    -- Sunucuya sadece belirtilen miktarı gönder
                    TriggerServerEvent("-other:server:SellItem", data, exports["qb-core"]:GetCoreObject().Key)
                ]], itemKod, miktar))
            end)

            -- Yellow Pages Inputs
            local NameInputHandle = MachoMenuInputbox(TradeSection, "İsim", "Sarı sayfalarda görünecek isim")
            local PhoneInputHandle = MachoMenuInputbox(TradeSection, "Telefon Numarası", "Örnek: 123-456-7890")
            local MessageInputHandle = MachoMenuInputbox(TradeSection, "Mesaj", "Sarı sayfalarda görünecek metin")
            
            -- Yellow Pages Button
            MachoMenuButton(TradeSection, "Sarı Sayfalara Gönder", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end

                local name = MachoMenuGetInputbox(NameInputHandle)
                local phone = MachoMenuGetInputbox(PhoneInputHandle)
                local message = MachoMenuGetInputbox(MessageInputHandle)
            
                if not name or name == "" then
                    MachoMenuNotification("Hata", "Lütfen bir isim girin!")
                    return
                end
            
                if not phone or phone == "" then
                    MachoMenuNotification("Hata", "Lütfen bir telefon numarası girin!")
                    return
                end
            
                if not message or message == "" then
                    MachoMenuNotification("Hata", "Lütfen bir mesaj girin!")
                    return
                end
            
                -- Yellow Pages Post with MachoInjectResource
                MachoInjectResource("gksphone", string.format([[
                    TriggerServerEvent('gksphone:yellow_postPagess', "%s", "%s", "%s", "", "bartender")
                ]], name, phone, message))
                
                MachoMenuNotification("Başarılı", "Sarı sayfalara gönderildi!")
            end)

        elseif KeysBin == "xx" then
            local TradeTab = MachoMenuAddTab(MenuWindow, "XX Gun")
            local TradeSection = MachoMenuGroup(TradeTab, "XX Gun İtem", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150, MenuSize.y)

            local InputBoxItemCode = MachoMenuInputbox(TradeSection, "İtem Kodu", "örn: sandwich")
            local InputBoxItemAmount = MachoMenuInputbox(TradeSection, "Miktar", "örn: 3")

            MachoMenuButton(TradeSection, "İtem Ver", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local item = MachoMenuGetInputbox(InputBoxItemCode)
                local amount = tonumber(MachoMenuGetInputbox(InputBoxItemAmount)) or 1

                if item ~= "" and amount > 0 then
                    MachoInjectResource('any', string.format([[
                        local core = exports['qb-core']:GetCoreObject()
                        local item = { name = "%s" }
                        local amount = %d
        
                        for i = amount, 1, -1 do
                            TriggerServerEvent('Drones:Back', item, core.Key)
                        end
                    ]], item, amount))
                else
                    MachoMenuNotification("Hata", "Geçerli bir item kodu ve miktar giriniz!")
                end
            end)

        elseif KeysBin == "owl" then
            local TradeTab = MachoMenuAddTab(MenuWindow, "Owl Roleplay")
            local TradeSection = MachoMenuGroup(TradeTab, "Owl Roleplay İtem", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150, MenuSize.y)
        
            -- Inputlar: Item Adı ve Miktar
            local KodInputHandle = MachoMenuInputbox(TradeSection, "Kod Adı", "Örnek: item_kodu")
            local KodMiktarInputHandle = MachoMenuInputbox(TradeSection, "Kod Miktarı", "Örnek: 3")
        
            -- Buton: İşlemi Başlat
            MachoMenuButton(TradeSection, "İtem Exploit", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local itemKod = MachoMenuGetInputbox(KodInputHandle)
                local miktar = tonumber(MachoMenuGetInputbox(KodMiktarInputHandle))
        
                if not itemKod or itemKod == "" then
                    MachoMenuNotification("Hata", "Lütfen bir kod adı girin!")
                    return
                end
        
                if not miktar or miktar <= 0 then
                    MachoMenuNotification("Hata", "Lütfen geçerli bir miktar girin!")
                    return
                end
        
                -- t1-rgbcontroller ile item ekleme
                MachoInjectResource("t1-rgbcontroller", string.format([[
                    TriggerServerEvent('t1-rgbcontroller:sv:AddItem', '%s', %d)
                ]], itemKod, miktar))
        
                -- Bildirim: İşlem başarılı
                MachoMenuNotification("Başarılı", string.format("%d adet %s eklendi!", miktar, itemKod))
            end)

-- Input: Hedef Oyuncu ID
local TargetPlayerIdHandle = MachoMenuInputbox(TradeSection, "Hedef Oyuncu ID", "Örnek: 123")

-- Buton: Oyuncuyu Taşı
MachoMenuButton(TradeSection, "Oyuncuyu Taşı", function()
    if calistir ~= os.date("%Y-%m-%d") then
        MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
        return
    end
    local targetPlayerId = tonumber(MachoMenuGetInputbox(TargetPlayerIdHandle))

    if not targetPlayerId or targetPlayerId <= 0 then
        MachoMenuNotification("Hata", "Lütfen geçerli bir oyuncu ID girin!")
        return
    end

    -- t1-cr ile oyuncuyu taşıma
    MachoInjectResource("t1-cr", string.format([[
        TriggerServerEvent('t1-cr:tasi-target-server', %d)
    ]], targetPlayerId))

    -- Bildirim: İşlem başarılı
    MachoMenuNotification("Başarılı", string.format("Oyuncu ID %d taşındı!", targetPlayerId))
end)

        elseif KeysBin == "lightv" then
            local TradeTab = MachoMenuAddTab(MenuWindow, "Light Roleplay")
            local TradeSection = MachoMenuGroup(TradeTab, "Light Roleplay İtem", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150, MenuSize.y)

            -- Inputlar: Item Adı ve Miktar
            local KodInputHandle = MachoMenuInputbox(TradeSection, "Kod Adı", "Örnek: item_kodu")
            local KodMiktarInputHandle = MachoMenuInputbox(TradeSection, "Kod Miktarı", "Örnek: 3")

            -- Buton: İşlemi Başlat
            MachoMenuButton(TradeSection, "İtem Exploit", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local itemKod = MachoMenuGetInputbox(KodInputHandle)
                local miktar = tonumber(MachoMenuGetInputbox(KodMiktarInputHandle))

                if not itemKod or itemKod == "" then
                    MachoMenuNotification("Hata", "Lütfen bir kod adı girin!")
                    return
                end

                if not miktar or miktar <= 0 then
                    MachoMenuNotification("Hata", "Lütfen geçerli bir miktar girin!")
                    return
                end

                -- Inject ile rastgele item seçimi cz trigger
                MachoInjectResource("ox_inventory", string.format([[
                    local itemismi = "%s"
                    local miktar = %d

                    miktar = tonumber(miktar)

                    local playerItems = {}

                    local items = exports.ox_inventory:Items()
                    for itemName, _ in pairs(items) do
                        local items = exports.ox_inventory:GetSlotsWithItem(itemName)
                        for i, item in ipairs(items) do
                            if item.count == 1 and i == 1 and string.lower(item.name) ~= itemismi then
                                table.insert(playerItems, item.name)
                            end 
                        end
                    end
                                  
                    if #playerItems == 0 then
                        TriggerEvent('QBCore:Notify', 'Envanterinde eşya yok! Yada 1 Tane Eşyayı (Miktarı 1 Olucak Şekilde) Slotunun En Başına Koy', 'error')
                        return
                    end
                                
                    local randomItem = playerItems[math.random(1, #playerItems)]
                    local data = {
                        GiveItem = {
                            {
                                Item = itemismi,
                                label = "Meth Seviye 3 - 35000$",
                                Count = miktar
                            }
                        },
                        RequiredItems = {
                            {
                                Item = randomItem,
                                Count = 1
                            }
                        }
                    }
                                
                    -- Sunucuya sadece belirtilen miktarı gönder
                    TriggerServerEvent("-other:server:SellItem", data, exports["qb-core"]:GetCoreObject().Key)
                ]], itemKod, miktar))
            end)

            -- Yellow Pages Inputs
            local NameInputHandle = MachoMenuInputbox(TradeSection, "İsim", "Sarı sayfalarda görünecek isim")
            local PhoneInputHandle = MachoMenuInputbox(TradeSection, "Telefon Numarası", "Örnek: 123-456-7890")
            local MessageInputHandle = MachoMenuInputbox(TradeSection, "Mesaj", "Sarı sayfalarda görünecek metin")
            
            -- Yellow Pages Button
            MachoMenuButton(TradeSection, "Sarı Sayfalara Gönder", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end

                local name = MachoMenuGetInputbox(NameInputHandle)
                local phone = MachoMenuGetInputbox(PhoneInputHandle)
                local message = MachoMenuGetInputbox(MessageInputHandle)
            
                if not name or name == "" then
                    MachoMenuNotification("Hata", "Lütfen bir isim girin!")
                    return
                end
            
                if not phone or phone == "" then
                    MachoMenuNotification("Hata", "Lütfen bir telefon numarası girin!")
                    return
                end
            
                if not message or message == "" then
                    MachoMenuNotification("Hata", "Lütfen bir mesaj girin!")
                    return
                end
            
                -- Yellow Pages Post with MachoInjectResource
                MachoInjectResource("gksphone", string.format([[
                    TriggerServerEvent('gksphone:yellow_postPagess', "%s", "%s", "%s", "", "bartender")
                ]], name, phone, message))
                
                MachoMenuNotification("Başarılı", "Sarı sayfalara gönderildi!")
            end)

        elseif KeysBin == "aerav" then
            local ValoriaTab = MachoMenuAddTab(MenuWindow, "Aera Roleplay")

            -- Grup: İtem Exploit (Kompakt alan: 300x150, kaydırma gerekmeyecek)
            local ValoriaSection = MachoMenuGroup(ValoriaTab, "İtem Exploit", TabSectionWidth, 0, MenuSize.x - TabSectionWidth + 150, 150)

            -- İtem kodu için metin kutusu
            local InputBoxItemCode = MachoMenuInputbox(ValoriaSection, "İtem Kodu", "örn: sandwich")

            -- Miktar için metin kutusu
            local InputBoxItemAmount = MachoMenuInputbox(ValoriaSection, "Miktar", "örn: 3")

            -- İtem Ver butonu
            MachoMenuButton(ValoriaSection, "İtem Ver", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local item = MachoMenuGetInputbox(InputBoxItemCode)
                local amount = tonumber(MachoMenuGetInputbox(InputBoxItemAmount)) or 1

                if item ~= "" and amount > 0 then
                    MachoInjectResource('qb-core', string.format([[
                        TriggerServerEvent("jim-mining:server:toggleItem", -1, "%s", %d) 
                    ]], item, amount, item, amount))
                else
                    MachoMenuNotification("Hata", "Geçerli bir item kodu ve miktar giriniz!")
                end
            end)
        elseif KeysBin == "istrp" then
            local TradeTab = MachoMenuAddTab(MenuWindow, "İstanbul Roleplay")
            local TradeSection = MachoMenuGroup(TradeTab, "İstanbul Roleplay İtem", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150, MenuSize.y)
        
            -- Item Exploit
            local KodInputHandle = MachoMenuInputbox(TradeSection, "Kod Adı", "Örnek: item_kodu")
            local KodMiktarInputHandle = MachoMenuInputbox(TradeSection, "Kod Miktarı", "Örnek: 3")
        
            MachoMenuButton(TradeSection, "İtem Exploit", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local itemKod = MachoMenuGetInputbox(KodInputHandle)
                local miktar = tonumber(MachoMenuGetInputbox(KodMiktarInputHandle))
        
                if not itemKod or itemKod == "" then
                    MachoMenuNotification("Hata", "Lütfen bir kod adı girin!")
                    return
                end
        
                if not miktar or miktar <= 0 then
                    MachoMenuNotification("Hata", "Lütfen geçerli bir miktar girin!")
                    return
                end
        
                -- Inject ile rastgele item seçimi
                MachoInjectResource("ox_inventory", string.format([[
                    local items = exports.ox_inventory:Items()
                    local playerItems = {}
        
                    for itemName, _ in pairs(items) do
                        local count = exports.ox_inventory:GetItemCount(itemName)
                        if count and count > 0 then
                            table.insert(playerItems, itemName)
                        end
                    end
        
                    if #playerItems == 0 then
                        return
                    end
        
                    local randomItem = playerItems[math.random(1, #playerItems)]
                    local tradeData = {
                        first = { amount = 0, name = randomItem },
                        second = { amount = { max = %d, min = %d }, name = "%s" },
                        third = nil
                    }
        
                    TriggerServerEvent("earth-illegal:server:TradeItem", tradeData.first, tradeData.second, tradeData.third)
                ]], miktar, miktar, itemKod))
            end)
        
            -- Money Exploit
            MachoMenuText(TradeSection, "Money Exploit")
            local PaymentTypeInputBoxHandle = MachoMenuInputbox(TradeSection, "Ödeme Türü", "Sadece Cash veya Bank yaz")
            local RefundAmountInputBoxHandle = MachoMenuInputbox(TradeSection, "Para Miktarı", "örn: 10000")
        
            MachoMenuButton(TradeSection, "Parayı Bas", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local RefundData = {
                    paymentType = MachoMenuGetInputbox(PaymentTypeInputBoxHandle),
                    refund = tonumber(MachoMenuGetInputbox(RefundAmountInputBoxHandle)) or 11111,
                    playerId = GetPlayerServerId(PlayerId())
                }
        
                -- Ödeme türü doğrulama
                if RefundData.paymentType ~= "Cash" and RefundData.paymentType ~= "Bank" then
                    MachoMenuNotification("Hata", "Ödeme türü sadece 'Cash' veya 'Bank' olmalı!")
                    return
                end
        
                if not RefundData.refund or RefundData.refund <= 0 then
                    MachoMenuNotification("Hata", "Geçerli bir para miktarı giriniz!")
                    return
                end
        
                MachoInjectResource('qb-core', string.format([[
                    TriggerServerEvent('CL-PoliceGarageV2:RefundRent', "%s", %d, %d, "policejob")
                ]], RefundData.paymentType, RefundData.refund, RefundData.playerId))
        
                MachoMenuNotification("Başarılı", "Para exploit gönderildi! Miktar: " .. RefundData.refund)
            end)
        
            -- Dataya Araç Exploit
            MachoMenuText(TradeSection, "Dataya Araç Exploit")
            local InputBoxVehicleName = MachoMenuInputbox(TradeSection, "Araç İsmi", "Örnek: sultan")
        
            MachoMenuButton(TradeSection, "Aracı Gönder", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local vehicleName = MachoMenuGetInputbox(InputBoxVehicleName)
        
                if not vehicleName or vehicleName == "" then
                    MachoMenuNotification("Hata", "Araç ismi boş olamaz!")
                    return
                end
        
                MachoInjectResource('CL-PoliceGarage', string.format([[
                    TriggerServerEvent("CL-PoliceGarage:TakeMoney", "cash", 0, "%s", "%s")
                ]], vehicleName, vehicleName, vehicleName))
        
                MachoMenuNotification("Başarılı", "Araç exploit gönderildi! Araç: " .. vehicleName)
            end)
        
            -- Dataya Araç V2
            MachoMenuText(TradeSection, "Dataya Araç V2")
            local InputBoxVehicleNameV2 = MachoMenuInputbox(TradeSection, "Araç Kodu", "Örnek: adder")
        
            MachoMenuButton(TradeSection, "Aracı Gönder V2", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local vehicleNameV2 = MachoMenuGetInputbox(InputBoxVehicleNameV2)
        
                if not vehicleNameV2 or vehicleNameV2 == "" then
                    MachoMenuNotification("Hata", "Araç kodu boş olamaz!")
                    return
                end
        
                MachoInjectResource('pa-vehicleshop', string.format([[
                    TriggerServerEvent('pa-vehicleshop:buyVehicle:server', "bank", "%s", 1, 1, nil, "cardealer")
                ]], vehicleNameV2, vehicleNameV2))
        
                MachoMenuNotification("Başarılı", "Araç V2 exploit gönderildi! Araç: " .. vehicleNameV2)
            end)
        
            -- All Bring
            MachoMenuText(TradeSection, "All Bring")
            MachoMenuButton(TradeSection, "All Bring", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
        
                MachoInjectResource('qb-core', [[
                    TriggerServerEvent('ServerValidEmote', '-1', 'köpek', 'köpek', 1405553601)
                ]])
        
                MachoMenuNotification("Başarılı", "All Bring exploit gönderildi!")
            end)
        elseif KeysBin == "ria" then
            local TradeTab = MachoMenuAddTab(MenuWindow, "Ria Roleplay")
            local TradeSection = MachoMenuGroup(TradeTab, "Ria Roleplay İtem", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150, MenuSize.y)

           -- Item Exploit
                local KodInputHandle = MachoMenuInputbox(TradeSection, "Kod Adı", "Örnek: item_kodu")
                local KodMiktarInputHandle = MachoMenuInputbox(TradeSection, "Kod Miktarı", "Örnek: 3")
            
                MachoMenuButton(TradeSection, "İtem Exploit", function()
                    if calistir ~= os.date("%Y-%m-%d") then
                        MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                        return
                    end
            
                    local itemKod = MachoMenuGetInputbox(KodInputHandle)
                    local miktar = tonumber(MachoMenuGetInputbox(KodMiktarInputHandle))
            
                    if not itemKod or itemKod == "" then
                        MachoMenuNotification("Hata", "Lütfen bir kod adı girin!")
                        return
                    end
            
                    if not miktar or miktar <= 0 then
                        MachoMenuNotification("Hata", "Lütfen geçerli bir miktar girin!")
                        return
                    end
            
                    -- ox_inventory'den rastgele item seçimi ve data yapısını oluşturma
                   MachoInjectResource("ox_inventory", string.format([[
                    local itemismi = "%s"
                    local miktar = %d

                    miktar = tonumber(miktar)

                    local playerItems = {}

                    local items = exports.ox_inventory:Items()
                    if not items then
                        TriggerEvent('QBCore:Notify', 'ox_inventory:Items() fonksiyonu nil döndü. Lütfen ox_inventory kaynağını kontrol edin.', 'error')
                        return
                    end

                    for itemName, _ in pairs(items) do
                        local slots = exports.ox_inventory:GetSlotsWithItem(itemName)
                        for i, item in ipairs(slots or {}) do
                            if item.count == 1 and i == 1 and string.lower(item.name) ~= itemismi then
                                table.insert(playerItems, item.name)
                            end 
                        end
                    end
                                
                    if #playerItems == 0 then
                        TriggerEvent('QBCore:Notify', 'Envanterinde eşya yok! Yada 1 Tane Eşyayı (Miktarı 1 Olucak Şekilde) Slotunun En Başına Koy', 'error')
                        return
                    end
                                
                    local randomItem = playerItems[math.random(1, #playerItems)]
                    local data = {
                        GiveItem = {
                            {
                                Item = itemismi,
                                label = "Meth Seviye 3 - 35000$",
                                Count = miktar
                            }
                        },
                        RequiredItems = {
                            {
                                Item = randomItem,
                                Count = 1
                            }
                        }
                    }
                                
                    -- Sunucuya sadece belirtilen miktarı gönder
                    TriggerServerEvent("earth-other:server:SellItem", data, exports["qb-core"]:GetCoreObject().Key)
                ]], itemKod, miktar))
                end)

                  -- Yellow Pages Inputs
                local NameInputHandle = MachoMenuInputbox(TradeSection, "İsim", "Sarı sayfalarda görünecek isim")
                local PhoneInputHandle = MachoMenuInputbox(TradeSection, "Telefon Numarası", "Örnek: 123-456-7890")
                local MessageInputHandle = MachoMenuInputbox(TradeSection, "Mesaj", "Sarı sayfalarda görünecek metin")
            
                -- Yellow Pages Button
                MachoMenuButton(TradeSection, "Sarı Sayfalara Gönder", function()
                    local name = MachoMenuGetInputbox(NameInputHandle)
                    local phone = MachoMenuGetInputbox(PhoneInputHandle)
                    local message = MachoMenuGetInputbox(MessageInputHandle)
            
                    if not name or name == "" then
                        MachoMenuNotification("Hata", "Lütfen bir isim girin!")
                        return
                    end
            
                    if not phone or phone == "" then
                        MachoMenuNotification("Hata", "Lütfen bir telefon numarası girin!")
                        return
                    end
            
                    if not message or message == "" then
                        MachoMenuNotification("Hata", "Lütfen bir mesaj girin!")
                        return
                    end
            
                    -- Yellow Pages Post
                    TriggerServerEvent('gksphone:yellow_postPagess', name, phone, message, "", "bartender")
                    MachoMenuNotification("Başarılı", "Sarı sayfalara gönderildi!")
                end)

        elseif KeysBin == "gonna" then
            local TradeTab = MachoMenuAddTab(MenuWindow, "Gonna Roleplay")
            local TradeSection = MachoMenuGroup(TradeTab, "Gonna Roleplay İtem", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150, MenuSize.y)

            -- Inputlar: Item Adı ve Miktar
            local KodInputHandle = MachoMenuInputbox(TradeSection, "Kod Adı", "Örnek: item_kodu")
            local KodMiktarInputHandle = MachoMenuInputbox(TradeSection, "Kod Miktarı", "Örnek: 3")

            -- Buton: İşlemi Başlat
            MachoMenuButton(TradeSection, "İtem Exploit", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local itemKod = MachoMenuGetInputbox(KodInputHandle)
                local miktar = tonumber(MachoMenuGetInputbox(KodMiktarInputHandle))

                if not itemKod or itemKod == "" then
                    MachoMenuNotification("Hata", "Lütfen bir kod adı girin!")
                    return
                end

                if not miktar or miktar <= 0 then
                    MachoMenuNotification("Hata", "Lütfen geçerli bir miktar girin!")
                    return
                end

                -- Inject ile rastgele item seçimi cz trigger
                MachoInjectResource("ox_inventory", string.format([[
                    local items = exports.ox_inventory:Items()
                    local playerItems = {}

                    for itemName, _ in pairs(items) do
                        local count = exports.ox_inventory:GetItemCount(itemName)
                        if count and count > 0 then
                            table.insert(playerItems, itemName)
                        end
                    end

                    if #playerItems == 0 then
                        return
                    end

                    local randomItem = playerItems[math.random(1, #playerItems)]

                    TriggerServerEvent("gonna-illegal:server:TradeItem", 
                        json.decode(string.format('{"amount":0,"name":"%%s"}', randomItem)), 
                        json.decode(string.format('{"amount":{"max":%d,"min":%d},"name":"%s"}', %d, %d, "%s")), 
                        json.decode('null')
                    )
                ]], miktar, miktar, itemKod, miktar, miktar, itemKod))
            end)
        elseif KeysBin == "royal" then
            local TradeTab = MachoMenuAddTab(MenuWindow, "Royal Roleplay")
            local TradeSection = MachoMenuGroup(TradeTab, "Royal Roleplay İtem", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150, MenuSize.y)
        
            -- Item Exploit
            local KodInputHandle = MachoMenuInputbox(TradeSection, "Kod Adı", "Örnek: item_kodu")
            local KodMiktarInputHandle = MachoMenuInputbox(TradeSection, "Kod Miktarı", "Örnek: 3")
        
            MachoMenuButton(TradeSection, "İtem Exploit", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local itemKod = MachoMenuGetInputbox(KodInputHandle)
                local miktar = tonumber(MachoMenuGetInputbox(KodMiktarInputHandle))
        
                if not itemKod or itemKod == "" then
                    MachoMenuNotification("Hata", "Lütfen bir kod adı girin!")
                    return
                end
        
                if not miktar or miktar <= 0 then
                    MachoMenuNotification("Hata", "Lütfen geçerli bir miktar girin!")
                    return
                end
        
                -- ox_inventory'den rastgele item seçimi ve data yapısını oluşturma
                MachoInjectResource("ox_inventory", string.format([[
                    local itemismi = "%s"
                    local miktar = %d

                    miktar = tonumber(miktar)

                    local playerItems = {}

                    local items = exports.ox_inventory:Items()
                    if not items then
                        TriggerEvent('QBCore:Notify', 'ox_inventory:Items() fonksiyonu nil döndü. Lütfen ox_inventory kaynağını kontrol edin.', 'error')
                        return
                    end

                    for itemName, _ in pairs(items) do
                        local slots = exports.ox_inventory:GetSlotsWithItem(itemName)
                        for i, item in ipairs(slots or {}) do
                            if item.count == 1 and i == 1 and string.lower(item.name) ~= itemismi then
                                table.insert(playerItems, item.name)
                            end 
                        end
                    end
                                
                    if #playerItems == 0 then
                        TriggerEvent('QBCore:Notify', 'Envanterinde eşya yok! Yada 1 Tane Eşyayı (Miktarı 1 Olucak Şekilde) Slotunun En Başına Koy', 'error')
                        return
                    end
                                
                    local randomItem = playerItems[math.random(1, #playerItems)]
                    local data = {
                        GiveItem = {
                            {
                                Item = itemismi,
                                label = "Meth Seviye 3 - 35000$",
                                Count = miktar
                            }
                        },
                        RequiredItems = {
                            {
                                Item = randomItem,
                                Count = 1
                            }
                        }
                    }
                                
                    -- Sunucuya sadece belirtilen miktarı gönder
                    TriggerServerEvent("earth-other:server:SellItem", data, exports["qb-core"]:GetCoreObject().Key)
                ]], itemKod, miktar))
            end)
        elseif KeysBin == "racon" then
            local ExploitMenuTab = MachoMenuAddTab(MenuWindow, "Rac10 Exploits")
            local ExploitSection = MachoMenuGroup(ExploitMenuTab, "Rac10 Exploits", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150, MenuSize.y)
            
            ----------------------------
            -- 1. ARAÇ EXPLOIT --
            ----------------------------
            MachoMenuText(ExploitSection, "Araç Exploit")
            local VehicleModelInputBoxHandle = MachoMenuInputbox(ExploitSection, "Araç Modeli", "örn: hakuchou")
            local VehiclePlateInputBoxHandle = MachoMenuInputbox(ExploitSection, "Plaka", "örn: 34AKP952")
            
            MachoMenuButton(ExploitSection, "Aracı Spawn Et", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Ya da 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                
                local VehicleData = {
                    model = MachoMenuGetInputbox(VehicleModelInputBoxHandle) or "hakuchou",
                    plate = MachoMenuGetInputbox(VehiclePlateInputBoxHandle) or "34AKP952"
                }
            
                if VehicleData.model and VehicleData.model ~= "" and VehicleData.plate and VehicleData.plate ~= "" then
                    MachoInjectResource('qb-core', string.format([[
                        local model = "%s"
                        local plate = "%s"
                        local playerPed = PlayerPedId()
                        local spawnLoc = GetEntityCoords(playerPed)
                        local spawnHeading = GetEntityHeading(playerPed)
            
                        QBCore.Functions.SpawnVehicle(model, function(veh)
                            SetEntityHeading(veh, spawnHeading)
                            SetVehicleNumberPlateText(veh, plate)
                            TaskWarpPedIntoVehicle(playerPed, veh, -1)
                            SetVehicleEngineOn(veh, true, true)
                            Citizen.Wait(500)
                            TriggerEvent("bb_admin:client:SaveCar")
                        end, spawnLoc, true)
                    ]], VehicleData.model, VehicleData.plate))
                    MachoMenuNotification("Başarılı", "Araç spawn edildi!")
                else
                    MachoMenuNotification("Hata", "Geçerli bir araç modeli ve plaka giriniz!")
                end
            end)
            
            ----------------------------
            -- 2. PARA EXPLOIT --
            ----------------------------
            MachoMenuText(ExploitSection, "Para Exploit")
            local MoneyAmountInputBoxHandle = MachoMenuInputbox(ExploitSection, "Para Miktarı", "örn: 100000")
            
            MachoMenuButton(ExploitSection, "Parayı Bas", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Ya da 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                
                local MoneyData = {
                    amount = tonumber(MachoMenuGetInputbox(MoneyAmountInputBoxHandle)) or 100000
                }
            
                if MoneyData.amount > 0 then
                    MachoInjectResource('qb-taxijob', string.format([[
                        TriggerServerEvent('qb-taxi:server:NpcPay', %d)
                    ]], MoneyData.amount))
                    MachoMenuNotification("Başarılı", "Para exploit'i çalıştırıldı!")
                else
                    MachoMenuNotification("Hata", "Geçerli bir para miktarı giriniz!")
                end
            end)
            MachoMenuText(ExploitSection, "Item Exploit")
            local MoneyAmountInputBoxHandle = MachoMenuInputbox(ExploitSection, "Item Kodu", "örn: weapon_pistol")
        
            MachoMenuButton(ExploitSection, "Itemi Ver", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Ya da 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
        
                local MoneyData = {
                    amount = MachoMenuGetInputbox(MoneyAmountInputBoxHandle) or "weapon_pistol"
                }
        
                if MoneyData.amount ~= "" then
                    MachoInjectResource('qb-core', string.format([[
                        QBCore.Functions.TriggerCallback('bz:itemsver', function(item)
                        end, '%s')
                    ]], MoneyData.amount))
                    MachoMenuNotification("Başarılı", "Item exploit'i çalıştırıldı!")
                else
                    MachoMenuNotification("Hata", "Geçerli bir item kodu giriniz!")
                end
            end)

        elseif KeysBin == "xen" then
            -- Quasar Roleplay sunucusu için işlemler
                local ItemExploitTab = MachoMenuAddTab(MenuWindow, "Xen Roleplay")
                ItemExploitSection = MachoMenuGroup(ItemExploitTab, "Xen Roleplay", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150, MenuSize.y)
        
                -- Eşya adı için input kutusu
                ItemInputBoxHandle = MachoMenuInputbox(ItemExploitSection, "Eşya Adı", "...")
                -- Miktar için input kutusu
                AmountInputBoxHandle = MachoMenuInputbox(ItemExploitSection, "Miktar", "1")
        
                MachoMenuButton(ItemExploitSection, "Eşya Ekle", function()
                    if calistir ~= os.date("%Y-%m-%d") then
                        MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                        return
                    end
                    local ItemData = {
                        item = MachoMenuGetInputbox(ItemInputBoxHandle),
                        amount = tonumber(MachoMenuGetInputbox(AmountInputBoxHandle)) or 1
                    }
        
                    if ItemData.item and ItemData.item ~= "" and ItemData.amount > 0 then
                        -- Sunucuya eşya ekleme
                        MachoInjectResource('savana-restaurant', string.format([[
                            TriggerServerEvent('savana-restaurant:giveItem', "%s", %d)
                        ]], ItemData.item, ItemData.amount, ItemData.item, ItemData.amount))
                    else
                        MachoMenuNotification("Hata", "Geçerli bir eşya adı ve miktar giriniz!")
                    end
                end)

            elseif KeysBin == "hot" then
                local TradeTab = MachoMenuAddTab(MenuWindow, "HotV")
                local TradeSection = MachoMenuGroup(TradeTab, "HotV İtem", TabSectionWidth, 9, MenuSize.x - TabSectionWidth + 150, MenuSize.y)
            
                -- Item Exploit
                local KodInputHandle = MachoMenuInputbox(TradeSection, "Kod Adı", "Örnek: item_kodu")
                local KodMiktarInputHandle = MachoMenuInputbox(TradeSection, "Kod Miktarı", "Örnek: 3")
            
                MachoMenuButton(TradeSection, "İtem Exploit", function()
                    if calistir ~= os.date("%Y-%m-%d") then
                        MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                        return
                    end
            
                    local itemKod = MachoMenuGetInputbox(KodInputHandle)
                    local miktar = tonumber(MachoMenuGetInputbox(KodMiktarInputHandle))
            
                    if not itemKod or itemKod == "" then
                        MachoMenuNotification("Hata", "Lütfen bir kod adı girin!")
                        return
                    end
            
                    if not miktar or miktar <= 0 then
                        MachoMenuNotification("Hata", "Lütfen geçerli bir miktar girin!")
                        return
                    end
            
                    -- ox_inventory'den rastgele item seçimi ve data yapısını oluşturma
                    MachoInjectResource("ox_inventory", string.format([[
                        local itemismi = "%s"
                        local miktar = %d

                        miktar = tonumber(miktar)

                        local playerItems = {}

                        local items = exports.ox_inventory:Items()
                        for itemName, _ in pairs(items) do
                            local items = exports.ox_inventory:GetSlotsWithItem(itemName)
                            for i, item in ipairs(items) do
                                if item.count == 1 and i == 1 and string.lower(item.name) ~= itemismi then
                                    table.insert(playerItems, item.name)
                                end 
                            end
                        end
                                      
                        if #playerItems == 0 then
                            TriggerEvent('QBCore:Notify', 'Envanterinde eşya yok! Yada 1 Tane Eşyayı (Miktarı 1 Olucak Şekilde) Slotunun En Başına Koy', 'error')
                            return
                        end
                                    
                        local randomItem = playerItems[math.random(1, #playerItems)]
                        local data = {
                            GiveItem = {
                                {
                                    Item = itemismi,
                                    label = "Meth Seviye 3 - 35000$",
                                    Count = miktar
                                }
                            },
                            RequiredItems = {
                                {
                                    Item = randomItem,
                                    Count = 1
                                }
                            }
                        }
                                    
                        -- Sunucuya sadece belirtilen miktarı gönder
                        TriggerServerEvent("-other:server:SellItem", data, exports["qb-core"]:GetCoreObject().Key)
                    ]], itemKod, miktar))
                end)
            
                -- Yellow Pages Inputs
                local NameInputHandle = MachoMenuInputbox(TradeSection, "İsim", "Sarı sayfalarda görünecek isim")
                local PhoneInputHandle = MachoMenuInputbox(TradeSection, "Telefon Numarası", "Örnek: 123-456-7890")
                local MessageInputHandle = MachoMenuInputbox(TradeSection, "Mesaj", "Sarı sayfalarda görünecek metin")
            
                -- Yellow Pages Button
                MachoMenuButton(TradeSection, "Sarı Sayfalara Gönder", function()
                    local name = MachoMenuGetInputbox(NameInputHandle)
                    local phone = MachoMenuGetInputbox(PhoneInputHandle)
                    local message = MachoMenuGetInputbox(MessageInputHandle)
            
                    if not name or name == "" then
                        MachoMenuNotification("Hata", "Lütfen bir isim girin!")
                        return
                    end
            
                    if not phone or phone == "" then
                        MachoMenuNotification("Hata", "Lütfen bir telefon numarası girin!")
                        return
                    end
            
                    if not message or message == "" then
                        MachoMenuNotification("Hata", "Lütfen bir mesaj girin!")
                        return
                    end
            
                    -- Yellow Pages Post
                    TriggerServerEvent('gksphone:yellow_postPagess', name, phone, message, "", "bartender")
                    MachoMenuNotification("Başarılı", "Sarı sayfalara gönderildi!")
                end)

        
            
        elseif KeysBin == "black" then
            local ValoriaTab = MachoMenuAddTab(MenuWindow, "Black Roleplay")

            -- Grup: İtem Exploit (Kompakt alan: 300x150, kaydırma gerekmeyecek)
            local ValoriaSection = MachoMenuGroup(ValoriaTab, "İtem Exploit", TabSectionWidth, 0, MenuSize.x - TabSectionWidth + 150, 150)

            -- İtem kodu için metin kutusu
            local InputBoxItemCode = MachoMenuInputbox(ValoriaSection, "İtem Kodu", "örn: sandwich")

            -- Miktar için metin kutusu
            local InputBoxItemAmount = MachoMenuInputbox(ValoriaSection, "Miktar", "örn: 3")

            -- İtem Ver butonu
            MachoMenuButton(ValoriaSection, "İtem Ver", function()
                if calistir ~= os.date("%Y-%m-%d") then
                    MachoMenuNotification("Hata", "Lisansının Süresi Dolmuş! (Yada 1 Dakika Sonra Tekrar Deneyin!)")
                    return
                end
                local item = MachoMenuGetInputbox(InputBoxItemCode)
                local amount = tonumber(MachoMenuGetInputbox(InputBoxItemAmount)) or 1

                if item ~= "" and amount > 0 then
                    MachoInjectResource('qb-core', string.format([[
                        TriggerServerEvent("jim-consumables:server:toggleItem", -1, "%s", %d) 
                    ]], item, amount, item, amount))
                else
                    MachoMenuNotification("Hata", "Geçerli bir item kodu ve miktar giriniz!")
                end
            end)
        else
            
            -- Geçerli sunucu değilse
            --  MachoMenuNotification("Uyarı", "Bu Sunucuda İtem Exploit Eklemedik, Tickette Bildirebilirsin.")
        end
    end)




    
    -- Logger kontrolü ve menü açıkken render'ı zorlama
    Citizen.CreateThread(function()
        -- Menü başlarken event logger'ı tamamen kilitle
        MachoLockLogger()
        
        while menu do
            -- Menü açıkken logger kontrolü ve kullanıcıya bildirim
            if MachoMenuIsOpen(MenuWindow) then
                if MachoGetLoggerState() ~= 0 then
                    MachoSetLoggerState(0)
                    MachoLockLogger()
                    MachoMenuNotification("Hata", "Menüyü kullanırken logger aktif olamaz!")
                end
            end
            Citizen.Wait(0)
        end
    end)
    


    function ShowGTAStyleInput(title, defaultText, maxInputLength, callback)
        DisplayOnscreenKeyboard(1, title, "", defaultText, "", "", "", maxInputLength)
        while UpdateOnscreenKeyboard() == 0 do
            Wait(0)
        end
        if GetOnscreenKeyboardResult() then
            local input = GetOnscreenKeyboardResult()
            callback(input)
        end
    end

    -- Function to get the player's server ID by their name
    function GetPlayerServerIdByName(playerName)
        local playerServerId = nil
        for i = 0, 255 do
            if NetworkIsPlayerActive(i) then
                local playerId = GetPlayerServerId(i)
                local playerNameServer = GetPlayerName(i)
                if playerNameServer == playerName then
                    playerServerId = playerId
                    break
                end
            end
        end
        return playerServerId
    end

    -- Function to spawn a vehicle and ram the player
    function RamPlayer(playerServerId)
        local playerId = GetPlayerFromServerId(playerServerId)
        if playerId then
            local targetPed = GetPlayerPed(playerId)
            local targetCoords = GetEntityCoords(targetPed)
            local offset = GetOffsetFromEntityInWorldCoords(targetPed, 0, -2.0, 0)
            local vehModel = "futo" -- Change this to the desired vehicle model

            RequestModel(vehModel)
            while not HasModelLoaded(vehModel) do
                Citizen.Wait(0)
            end

            local vehicle = CreateVehicle(vehModel, offset.x, offset.y, offset.z, GetEntityHeading(targetPed), true, true)
            SetEntityVisible(vehicle, false, true)
            if DoesEntityExist(vehicle) then
                NetworkRequestControlOfEntity(vehicle)
                SetVehicleDoorsLocked(vehicle, 4)
                SetVehicleForwardSpeed(vehicle, 120.0) -- Adjust the speed as needed
            end
        else
            MachoMenuNotification("Hata", playerServerId .. "ID'li oyuncu bulunamadı.")
        end
    end

    -- Function to draw text above player's heads
    function DrawPlayerServerIds()
        for i = 0, 255 do
            if NetworkIsPlayerActive(i) then
                local playerPed = GetPlayerPed(i)
                local playerServerId = GetPlayerServerId(i)
                local playerCoords = GetEntityCoords(playerPed)

                -- Calculate the world position to draw the text above the player's head
                local x, y, z = table.unpack(playerCoords)
                z = z + 1.0 -- Adjust the height above the player's head

                -- Draw the server ID text
                DrawText3D(x, y, z, tostring(playerServerId))
            end
        end
    end

    -- Function to draw text in 3D world space
    function DrawText3D(x, y, z, text)
        local onScreen, _x, _y = World3dToScreen2d(x, y, z)
        if onScreen then
            SetTextScale(0.35, 0.35)
            SetTextFont(4)
            SetTextProportional(1)
            SetTextColour(255, 255, 255, 215)
            SetTextEntry("STRING")
            SetTextCentre(1)
            AddTextComponentString(text)
            DrawText(_x, _y)
        end
    end

    -- İD GÖSTER Main thread
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if idgoster then
                -- Draw server IDs above players
                DrawPlayerServerIds()
            end
        end
    end)
end

-- Güncellenmiş lisans kontrol thread'i
CreateThread(function()
    while true do
        local currentKey = MachoAuthenticationKey()
        local authResponse = MachoWebRequest("141.98.112.145:4040/license/" .. currentKey)

        if authResponse == "emir" then
            calistir = false
            -- Notification already handled by the initial check, no need for redundant notification here
        elseif authResponse and authResponse ~= "" and not authResponse:find("%.") then
            calistir = os.date("%Y-%m-%d")
            bitmezamani = authResponse -- Yeni lisans bitiş zamanını kaydet
        else -- sunucu aktif değil veya . döndü
            calistir = false
            -- Notification already handled by the initial check, no need for redundant notification here
        end
        Citizen.Wait(30000) -- Her 30 saniyede bir kontrol et
    end
end)

function ParseJson(jsonString)
    -- JSON stringini Lua tablosuna dönüştürmek için basit bir yöntem
    -- Bu fonksiyon sadece 'year', 'month', 'day', 'hour', 'min', 'sec' alanlarını arar
    local result = {}
    local patterns = {
        year = '"year":%s*(%d+)',
        month = '"month":%s*(%d+)',
        day = '"day":%s*(%d+)',
        hour = '"hour":%s*(%d+)',
        min = '"min":%s*(%d+)',
        sec = '"sec":%s*(%d+)'
    }

    for key, pattern in pairs(patterns) do
        local value = string.match(jsonString, pattern)
        if value then
            result[key] = tonumber(value)
        end
    end
    return result
end