natives_version = "1663599433"
util.require_natives(natives_version)
local json = require("json")


local function memScan(name, pattern, callback)
    local addr = memory.scan(pattern)
    if addr == 0 then
        util.log("Failed to find " .. name .. " pattern")
        found_all = false
        return
    end
    callback(addr)
    util.log("Found " .. name)
end

local function round(val:float, to:int = 1)
    if to < 0 then
        to = math.abs(to)
        val, tmp = math.modf(val/to)
        if tmp >= 0.5 then
            return (val+1)*to
        else return val*to end
    else 
        val, tmp = math.modf(val*to)
        if tmp >= 0.5 then
            return (val+1)/to
        else 
            return val/to 
        end
    end
end

local function contains(arr, val)
    for index, value in ipairs(arr) do
        if value == val then
            return true
        end
    end

    return false
end

local function nToHexStr(val: number)
    local res = string.format("%X", val)
    for i = 1, 16 - string.len(res) do
        res = "0" .. res
    end
    return res
end
local function hexStrToN(val: string)
    local res = tonumber(val, 16)
    return res
end

local function replace_char(pos, str, r)
    return str:sub(1, pos-1) .. r .. str:sub(pos+1)
end
local function uintToBitStr(num, cnt)
    local bitStr = ""
    for i=0, cnt-1 do
        bitStr = tostring(num%2) .. bitStr
        num = num//2
    end
    return bitStr
end
local function bitStrToUint(bitStr)
    local num = 0
    for i=0, #bitStr-1 do
        num = num + (tonumber(bitStr:sub(#bitStr-i, #bitStr-i)) * (math.floor(2 ^ i)))
    end
    return num
end

local function rplStr(str: string, ind:int, val: string)
    return ("%s%s%s"):format(str:sub(1,ind-1), val, str:sub(ind+1))
end

Mem = {}
function Mem:new(addr: long)
	local obj = {}
		obj.addr = addr or 0
	
	

	function obj:get()
		return obj.addr
	end
	function obj:set(addr: long)
		obj.addr = addr
	end
	function obj:offset(offset: long)
        offset = offset or 0
		local addr = memory.read_long(obj.addr)
		if addr == 0 then
			return self
		end
		obj.addr = addr + offset
		return self
	end
    function obj:c()
        local copy = Mem:new(obj.addr)
        return copy
    end 
	function obj:isNil()
        if obj.addr == 0 then return true end
        if memory.read_long(obj.addr) == 0 then return true end
        return false
    end


    function obj:readByte(offset)
        offset = offset or 0
        if obj.addr == 0 then return nil end
        local res = memory.read_byte(obj.addr + offset)
        return res
    end
    function obj:readUbyte(offset)
        offset = offset or 0
        if obj.addr == 0 then return nil end
        local res = memory.read_ubyte(obj.addr + offset)
        return res
    end
    function obj:readShort(offset)
        offset = offset or 0
        if obj.addr == 0 then return nil end
        local res = memory.read_short(obj.addr + offset)
        return res
    end
    function obj:readUshort(offset)
        offset = offset or 0
        if obj.addr == 0 then return nil end
        local res = memory.read_ushort(obj.addr + offset)
        return res
    end
    function obj:readInt(offset)
        offset = offset or 0
        if obj.addr == 0 then return nil end
        local res = memory.read_int(obj.addr + offset)
        return res
    end
    function obj:readUint(offset)
        offset = offset or 0
        if obj.addr == 0 then return nil end
        local res = memory.read_uint(obj.addr + offset)
        return res
    end
    function obj:readLong(offset)
        offset = offset or 0
        if obj.addr == 0 then return nil end
        local res = memory.read_long(obj.addr + offset)
        return res
    end
    function obj:readFloat(offset)
        offset = offset or 0
        if obj.addr == 0 then return nil end
        local res = memory.read_float(obj.addr + offset)
        return res
    end
    function obj:readString(offset)
        offset = offset or 0
        if obj.addr == 0 then return nil end
        local res = memory.read_string(obj.addr + offset)
        return res
    end

    function obj:writeByte(val: int, offset, writeIfNil: bool = false)
        offset = offset or 0
        if obj.addr == 0 then
            if writeIfNil then
                memory.write_byte(obj.addr + offset, val)
            end
            return false 
        end
        memory.write_byte(obj.addr + offset, val)
        return true
    end
    function obj:writeUbyte(val: int, offset, writeIfNil: bool = false)
        offset = offset or 0
        if obj.addr == 0 then
            if writeIfNil then
                memory.write_ubyte(obj.addr + offset, val)
            end
            return false 
        end
        memory.write_ubyte(obj.addr + offset, val)
        return true
    end
    function obj:writeShort(val: int, offset, writeIfNil: bool = false)
        offset = offset or 0
        if obj.addr == 0 then
            if writeIfNil then
                memory.write_short(obj.addr + offset, val)
            end
            return false 
        end
        memory.write_short(obj.addr + offset, val)
        return true
    end
    function obj:writeUshort(val: int, offset, writeIfNil: bool = false)
        offset = offset or 0
        if obj.addr == 0 then
            if writeIfNil then
                memory.write_ushort(obj.addr + offset, val)
            end
            return false 
        end
        memory.write_ushort(obj.addr + offset, val)
        return true
    end
    function obj:writeInt(val: int, offset, writeIfNil: bool = false)
        offset = offset or 0
        if obj.addr == 0 then
            if writeIfNil then
                memory.write_int(obj.addr + offset, val)
            end
            return false 
        end
        memory.write_int(obj.addr + offset, val)
        return true
    end
    function obj:writeUint(val: int, offset, writeIfNil: bool = false)
        offset = offset or 0
        if obj.addr == 0 then
            if writeIfNil then
                memory.write_uint(obj.addr + offset, val)
            end
            return false 
        end
        memory.write_uint(obj.addr + offset, val)
        return true
    end
    function obj:writeLong(val: int, offset, writeIfNil: bool = false)
        offset = offset or 0
        if obj.addr == 0 then
            if writeIfNil then
                memory.write_long(obj.addr + offset, val)
            end
            return false 
        end
        memory.write_long(obj.addr + offset, val)
        return true
    end
    function obj:writeFloat(val: number, offset, writeIfNil: bool = false)
        offset = offset or 0
        if obj.addr == 0 then
            if writeIfNil then
                memory.write_float(obj.addr + offset, val)
            end
            return false 
        end
        memory.write_float(obj.addr + offset, val)
        return true
    end
    function obj:writeString(val: string, offset, writeIfNil: bool = false)
        offset = offset or 0
        if obj.addr == 0 then
            if writeIfNil then
                memory.write_string(obj.addr + offset, val)
            end
            return false 
        end
        memory.write_string(obj.addr + offset, val)
        return true
    end
    function obj:writeV3(val: Vector3, offset, writeIfNil: bool = false)
        offset = offset or 0
        if obj.addr == 0 then
            if writeIfNil then
                memory.write_vector3(obj.addr + offset, val)
            end
            return false 
        end
        memory.write_vector3(obj.addr + offset, val)
        return true
    end

    
    

	setmetatable(obj, self)
    self.__index = self; return obj
end


function delete_object(model)
    local hash = util.joaat(model)
    for k, object in pairs(entities.get_all_objects_as_handles()) do
        if ENTITY.GET_ENTITY_MODEL(object) == hash then
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(object, false, false) 
            entities.delete_by_handle(object)
        end
    end
end

-- Scan pointers

local worldPtr
memScan("Ped Factory", "48 8B 05 ? ? ? ? 45 ? ? ? ? 48 8B 48 08 48 85 C9 74 07", function (ptr)
	worldPtr = memory.rip(ptr + 3)
end)

local CCamPtr
memScan("cCamera", "48 8B 05 ? ? ? ? 4A 8B 1C F0", function (ptr)
	CCamPtr = memory.rip(ptr + 3)
end)

local DPPtr -- deluxo patch ptr
memScan("DP", "F3 0F 11 59 30 F3 0F 11 41 3C F3 0F 58 CA F3 0F", function (ptr)
	DPPtr = ptr
end)

local VBPtr -- vehicle base ptr
memScan("VB", "CD CC CC BC 00 00 00 00 CD CC CC 3D CD CC CC 3E", function (ptr)
	VBPtr = ptr - 0x18
end)


local LocalisationPtr = worldPtr - 0x596074

onEnter = {}
onTick = {}
onPreStop = {}
onStop = {}

onTick[0] = function () end
onPreStop[0] = function () end
onStop[0] = function () end

gOnStopVal = {}

-- Main vars 
local gVehicleState = {}
local l = 0
gVehicleState.lastPedVehicle = Mem:new(worldPtr):offset(0x08):offset(0xD10).readLong()
gVehicleState.lastPedVehicleId = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false) 
if gVehicleState.lastPedVehicle == 0 then
    gVehicleState.lastPedVehicleHandlingPtr = 0
else
    gVehicleState.lastPedVehicleHandlingPtr = Mem:new(worldPtr):offset(0x08):offset(0xD10):offset(0x918).readLong()
end
gVehicleState.currentPedVehicleId = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false) 
gVehicleState.currentPedVehiclePtr = Mem:new(worldPtr):offset(0x08):offset(0xD10)
gVehicleState.vehicleChanged = gVehicleState.lastPedVehicle ~= gVehicleState.currentPedVehiclePtr.readLong()
gVehicleState.vehicleChanged = true
gVehicleState.currentVehicleEntry = gVehicleState.currentPedVehiclePtr.readLong()
gVehicleState.isCurrentVehicleEntry = function () return gVehicleState.currentVehicleEntry == gVehicleState.currentPedVehiclePtr.readLong() end 
onTick[#onTick+1] = function ()
    if gVehicleState.vehicleChanged then
        gVehicleState.lastPedVehicle = Mem:new(worldPtr):offset(0x08):offset(0xD10).readLong()
        gVehicleState.lastPedVehicleId = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false) 
        if gVehicleState.lastPedVehicle == 0 then
            gVehicleState.lastPedVehicleHandlingPtr = 0
        else
            gVehicleState.lastPedVehicleHandlingPtr = Mem:new(worldPtr):offset(0x08):offset(0xD10):offset(0x918).readLong()
        end
        gVehicleState.currentPedVehicleId = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false) 
        gVehicleState.currentPedVehiclePtr = Mem:new(worldPtr):offset(0x08):offset(0xD10)
        gVehicleState.vehicleChanged = gVehicleState.lastPedVehicle ~= gVehicleState.currentPedVehiclePtr.readLong()
        gVehicleState.currentVehicleEntry = gVehicleState.currentPedVehiclePtr.readLong()
    else
        gVehicleState.currentPedVehicleId = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false) 
        gVehicleState.currentPedVehiclePtr = Mem:new(worldPtr):offset(0x08):offset(0xD10)
        gVehicleState.vehicleChanged = gVehicleState.lastPedVehicle ~= gVehicleState.currentPedVehiclePtr.readLong()
        gVehicleState.currentVehicleEntry = gVehicleState.currentPedVehiclePtr.readLong()
    end
end

-- Menu folders
local vehicleFolder = menu.list(menu.my_root(), "Vehicle", {}, "")
local camOptions = menu.list(menu.my_root(), "Cam Options", {}, "")

local speedometer = menu.list(vehicleFolder, "Speedometer", {}, "")

local speedometerPosX = 0.925
local speedometerPosY = 0.72

menu.toggle_loop(speedometer, "Enable speedometer", {"speedometer"}, "", function()
	local isInVeh = PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false)
	if not isInVeh or HUD.IS_PAUSE_MENU_ACTIVE() or HUD.IS_WARNING_MESSAGE_ACTIVE() or CAM.IS_SCREEN_FADED_OUT() or CAM.IS_SCREEN_FADING_OUT() or CAM.IS_SCREEN_FADING_IN() then
		return
	end
	local pCar = entities.get_user_vehicle_as_handle()
	local vSpeed = ENTITY.GET_ENTITY_SPEED(pCar) * 3.6
	vSpeed = math.floor(vSpeed)
	local vSpeedStr = tostring(vSpeed)
	HUD.SET_TEXT_FONT(2);
	HUD.SET_TEXT_SCALE(0.9, 0.9);
	HUD.SET_TEXT_OUTLINE();
	HUD.BEGIN_TEXT_COMMAND_DISPLAY_TEXT("STRING");
	HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME( "KMPH");
	HUD.END_TEXT_COMMAND_DISPLAY_TEXT(speedometerPosX, speedometerPosY, 1);

	local textOffset = string.len(vSpeedStr) * 0.01	+ 0.005

	HUD.SET_TEXT_FONT(2);
	HUD.SET_TEXT_SCALE(0.9, 0.9);
	HUD.SET_TEXT_OUTLINE();
	HUD.BEGIN_TEXT_COMMAND_DISPLAY_TEXT("STRING");
	HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(vSpeedStr);
	HUD.END_TEXT_COMMAND_DISPLAY_TEXT(speedometerPosX - textOffset , speedometerPosY, 1);
end)

menu.slider_float(speedometer, "Speedometer position X", {}, "", 0.0*1000, 1.0*1000, speedometerPosX*1000, 10.0, function(capacity) 
    speedometerPosX = capacity / 1000
end)

menu.slider_float(speedometer, "speedometer position Y", {}, "", 0.0*1000, 1.0*1000, speedometerPosY*1000, 10.0, function(capacity) 
    speedometerPosY = capacity / 1000
end)


local function toggleHornBoost(toggle, vehicle)
    if vehicle.isNil() then return end
    local hornBoostPtr = Mem:new(vehicle.get()):offset(0x58B)
    local val = memory.read_byte(hornBoostPtr.get())
    if toggle then
        local tmp = uintToBitStr(val, 8)
        tmp = replace_char(#tmp-6,tmp, "1")
        memory.write_byte(hornBoostPtr.get(), bitStrToUint(tmp))
    else
        
        local tmp = uintToBitStr(val, 8)
        tmp = replace_char(#tmp-6,tmp, "0")
        memory.write_byte(hornBoostPtr.get(), bitStrToUint(tmp))
    end
end

local afterburnerOnPlanes = false

local hbState = false
local hbToggle = menu.toggle(vehicleFolder, "Horn boost", {"vehiclehornboost"}, "Do what it does. ", function(on)
    hbState = on
end)

local boostedVehicles = {}
boostedVehicles[util.joaat("Oppressor2")] = true
boostedVehicles[util.joaat("Toreador")] = true
boostedVehicles[util.joaat("Oppressor")] = true
boostedVehicles[util.joaat("voltic2")] = true
boostedVehicles[util.joaat("Scramjet")] = true
boostedVehicles[util.joaat("vigilante")] = true
boostedVehicles[util.joaat("thruster")] = true
boostedVehicles[util.joaat("starling")] = true
boostedVehicles[util.joaat("mogul")] = true
boostedVehicles[util.joaat("bombushka")] = true
boostedVehicles[util.joaat("tula")] = true

local setHornBoostForAll = false
local entry = true
onTick[#onTick+1] = function()
    if gVehicleState.vehicleChanged or entry then
        if gVehicleState.lastPedVehicle ~= 0 and not entry then
            local lastPedVehicleHash = ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId)
            if boostedVehicles[lastPedVehicleHash] ~= nil and boostedVehicles[lastPedVehicleHash] == true then
                toggleHornBoost(true, Mem:new(gVehicleState.lastPedVehicle + 0x20))
            else 
                toggleHornBoost(false, Mem:new(gVehicleState.lastPedVehicle + 0x20))
            end
        end

        if not gVehicleState.currentPedVehiclePtr.isNil() then
            local checkBoost = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x20):offset(0x58B):readByte()
            
            local checkBoost = uintToBitStr(checkBoost, 8)
            if tonumber(checkBoost:sub(#checkBoost-6, #checkBoost-6)) == 1 then
                menu.set_value(hbToggle, true)
                hbState = true
            else
                if not setHornBoostForAll then
                    menu.set_value(hbToggle, false)
                    hbState = false
                end
            end
        end 
    elseif not gVehicleState.currentPedVehiclePtr.isNil() then
        toggleHornBoost(hbState or afterburnerOnPlanes, Mem:new(gVehicleState.currentPedVehiclePtr.readLong()+0x20))
    end
    
    entry = false
end
onStop[#onStop+1] = function ()
    if not gVehicleState.currentPedVehiclePtr.isNil() then
        if boostedVehicles[ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId)] then
            toggleHornBoost(true, Mem:new(gVehicleState.lastPedVehicle + 0x20))
        else
            toggleHornBoost(false, Mem:new(gVehicleState.lastPedVehicle + 0x20))
        end
    end
end




menu.toggle_loop(vehicleFolder, "Horn boost instant recharge", {"hbinstantrecharge"}, "Do what it does. ", function()
    if gVehicleState.currentPedVehiclePtr.isNil() then return end
    hbInstantRechargePtr = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x300)
    local val = memory.read_float(hbInstantRechargePtr.get())
    local hbIsReady = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x2FB)
    local lastPedVehicleHash = ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId)

    if hbIsReady:readByte(0x02) == 0 then  
        -- util.yield()
        local setHBVal = 1.25
        if lastPedVehicleHash == util.joaat("Oppressor2") or lastPedVehicleHash == util.joaat("Toreador") then
            setHBVal = 1.0
        elseif lastPedVehicleHash == util.joaat("Scramjet") then
            setHBVal = 2.25
        elseif lastPedVehicleHash == util.joaat("starling") then
            setHBVal = 25
        elseif lastPedVehicleHash == util.joaat("mogul") or lastPedVehicleHash == util.joaat("tula") then
            setHBVal = 5
        elseif lastPedVehicleHash == util.joaat("bombushka") then
            setHBVal = 7.5
        end

        memory.write_float(hbInstantRechargePtr.get(), setHBVal)
    end
end)


menu.toggle_loop(vehicleFolder, "Afterburner on planes", {"planesafterburner"}, "Do what it does.\n(Shift on controller or L3 on gamepad) \n(Acceleration speed depends on the value below)", function()
    if gVehicleState.currentPedVehiclePtr.isNil() then return end
    if not VEHICLE.IS_THIS_MODEL_A_PLANE(ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId)) then 
        afterburnerOnPlanes = false
        return 
    end
    if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false) then return end
    hbInstantRechargePtr = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x300)
    local val = memory.read_float(hbInstantRechargePtr.get())
    local hbIsReady = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x2FB)
    local lastPedVehicleHash = ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId)
    hbIsReady:writeByte(1, 0x02)
    afterburnerOnPlanes = true
    local setHBVal = 1.25
    if lastPedVehicleHash == util.joaat("Oppressor2") or lastPedVehicleHash == util.joaat("Toreador") then
        setHBVal = 1.0
    elseif lastPedVehicleHash == util.joaat("Scramjet") then
        setHBVal = 2.25
    elseif lastPedVehicleHash == util.joaat("starling") then
        setHBVal = 25
    elseif lastPedVehicleHash == util.joaat("mogul") or lastPedVehicleHash == util.joaat("tula") then
        setHBVal = 5
    elseif lastPedVehicleHash == util.joaat("bombushka") then
        setHBVal = 7.5
    end

    memory.write_float(hbInstantRechargePtr.get(), setHBVal)
    
end, function ()
    
    afterburnerOnPlanes = false
end)

local hbSpeedPtr = 0
if not gVehicleState.currentPedVehiclePtr.isNil() then
    hbSpeedPtr = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x918):offset(0x120)
end
local hbSpeed = menu.slider_float(vehicleFolder, "Horn boost speed", {"hbspeed"}, "Set horn boost speed for current vehicle", 0.0, 999999999*100 , 
hbSpeedPtr ~= 0 and hbSpeedPtr:readFloat()*100 or 3000, 10*100,  function(capacity)
    if gVehicleState.currentPedVehiclePtr.isNil() then return end
    hbSpeedPtr = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x918):offset(0x120)
    capacity /= 100
    hbSpeedPtr:writeFloat(capacity)
end)

local onEntryHbSpeed = 0
if not gVehicleState.currentPedVehiclePtr.isNil() then
    onEntryHbSpeed = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x918):offset(0x120):readFloat()
end
local hbSpeedFromStartTick = 0
onTick[#onTick+1] = function ()
    if hbSpeedFromStartTick == 1 then
        menu.set_value(hbSpeed, onEntryHbSpeed*100)
        hbSpeedFromStartTick = 2
    end
    if gVehicleState.vehicleChanged and not gVehicleState.currentPedVehiclePtr:isNil() then
        menu.set_value(hbSpeed, Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x918):offset(0x120):readFloat()*100)
    end
    if hbSpeedFromStartTick == 0 then
        hbSpeedFromStartTick = 1
    end
end

menu.toggle(vehicleFolder, "Set horn boost speed for all vehicles", {}, "", function(on)
    setHornBoostForAll = on
end)

-- Acceleration

local accelerationVal = 0
local accelerationPtr = 0
if not gVehicleState.currentPedVehiclePtr.isNil() then
    accelerationPtr = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x8A4)
    accelerationVal = round(accelerationPtr.readFloat(), 10000) or 0
end

local setVehicleAcceleration = function(val)
    if gVehicleState.currentVehicleEntry == 0 then return end
    accelerationPtr = Mem:new(gVehicleState.currentVehicleEntry + 0x8A4)
    accelerationPtr:writeFloat(val)
    accelerationVal = val
end

local onEntryAcceleretionvalue = accelerationVal
local accelerationFromStartTick = 0
local vehicleAcceleration = menu.slider_float(vehicleFolder, "Acceleration", {"vehicleacceleration"}, 
"Changes the engine power of your vehicle. \n(Speed may be limited by air resistance)", 0.0, 999999999*10000, 
not gVehicleState.currentPedVehiclePtr.isNil() and math.floor(round(accelerationPtr.readFloat(), 10000)*10000+0.1) or 0, 0.1*10000,  function(capacity)
    if gVehicleState.currentPedVehiclePtr.isNil() then return end
    capacity /= 10000
    setVehicleAcceleration(capacity)
end)
vehicleAcceleration.precision = 4
onTick[#onTick+1] = function ()
    if accelerationFromStartTick == 1 then
        menu.set_value(vehicleAcceleration, math.floor(onEntryAcceleretionvalue *10000))
        accelerationFromStartTick = 2
    end
    if gVehicleState.vehicleChanged then
        if gVehicleState.currentVehicleEntry ~= 0 then
            accelerationPtr = Mem:new(gVehicleState.currentVehicleEntry + 0x8A4)
            accelerationVal = round(accelerationPtr.readFloat(), 10000)
            menu.set_value(vehicleAcceleration, math.floor(accelerationVal *10000))
        else
            menu.set_value(vehicleAcceleration, 0)
        end
    else
        if gVehicleState.currentVehicleEntry ~= 0 then
            setVehicleAcceleration(accelerationVal)
        end
    end
    if accelerationFromStartTick == 0 then
        accelerationFromStartTick = 1
    end
end
onPreStop[#onPreStop+1] = function ()
    gOnStopVal.accelerationValue = accelerationVal
end
onStop[#onStop+1] = function ()
    if gVehicleState.currentVehicleEntry ~= 0 then
        setVehicleAcceleration(gOnStopVal.accelerationValue)
    end
end

-- Wheel Drive bias

local gtmp = 0

local function isVehicleEngineWheelDrive(model)
    if (VEHICLE.IS_THIS_MODEL_A_CAR(model) or VEHICLE.IS_THIS_MODEL_A_BIKE(model) or VEHICLE.IS_THIS_MODEL_A_QUADBIKE(model) or VEHICLE.IS_THIS_MODEL_AN_AMPHIBIOUS_CAR(model) or VEHICLE.IS_THIS_MODEL_AN_AMPHIBIOUS_QUADBIKE(model)) and (not VEHICLE.IS_THIS_MODEL_A_BICYCLE(model)) then
        return true
    end
    return false
end

local wheelDrivePtr = Mem:new()
local wDriveTogglePrt = Mem:new()
local flDriveTogglePtr = Mem:new()
local frDriveTogglePtr = Mem:new()
local blDriveTogglePtr = Mem:new()
local brDriveTogglePtr = Mem:new()
if not gVehicleState.currentPedVehiclePtr.isNil() and isVehicleEngineWheelDrive(ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId)) then
    wheelDrivePtr = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x918):offset(0x48)
    wDriveTogglePtr = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0xBD0)
    if not wDriveTogglePtr.isNil() then 
        flDriveTogglePtr = Mem:new(wDriveTogglePtr.get()):offset(0x00):offset(0x204)
        if wDriveTogglePtr.c():offset(0x08):readByte(0x05) ~= 0 and wDriveTogglePtr.c():offset(0x00):readByte(0x05) == wDriveTogglePtr.c():offset(0x08):readByte(0x05) then
            frDriveTogglePtr = Mem:new(wDriveTogglePtr.get()):offset(0x08):offset(0x204)  
            if wDriveTogglePtr.c():offset(0x10):readByte(0x05) ~= 0 and wDriveTogglePtr.c():offset(0x08):readByte(0x05) == wDriveTogglePtr.c():offset(0x10):readByte(0x05) then
                blDriveTogglePtr = Mem:new(wDriveTogglePtr.get()):offset(0x10):offset(0x204)
                if wDriveTogglePtr.c():offset(0x18):readByte(0x05) ~= 0 and wDriveTogglePtr.c():offset(0x10):readByte(0x05) == wDriveTogglePtr.c():offset(0x18):readByte(0x05) then
                    brDriveTogglePtr = Mem:new(wDriveTogglePtr.get()):offset(0x18):offset(0x204)
                end
            end 
        end
        
        if memory.read_float(wheelDrivePtr.get()) == 1 and memory.read_float(wheelDrivePtr.get()+0x04) == 0 then
            gtmp = 1*100
        else
            gtmp = math.floor(round(memory.read_float(wheelDrivePtr.get())/2, 100)*100)
        end
    end
end

local wheelDriveBias = function(capacity, vehiclePtr)
    if vehiclePtr.isNil() and (not isVehicleEngineWheelDrive(ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId))) then return end
    wheelDrivePtr = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x918):offset(0x48)
    wDriveTogglePtr = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0xBD0)
    if wDriveTogglePtr.isNil() then return end
    flDriveTogglePtr = Mem:new(wDriveTogglePtr.get()):offset(0x00):offset(0x204)
    if wDriveTogglePtr.c():offset(0x08):readByte(0x05) ~= 0 and wDriveTogglePtr.c():offset(0x00):readByte(0x05) == wDriveTogglePtr.c():offset(0x08):readByte(0x05) then
        frDriveTogglePtr = Mem:new(wDriveTogglePtr.get()):offset(0x08):offset(0x204)  
        if wDriveTogglePtr.c():offset(0x10):readByte(0x05) ~= 0 and wDriveTogglePtr.c():offset(0x08):readByte(0x05) == wDriveTogglePtr.c():offset(0x10):readByte(0x05) then
            blDriveTogglePtr = Mem:new(wDriveTogglePtr.get()):offset(0x10):offset(0x204)
            if wDriveTogglePtr.c():offset(0x18):readByte(0x05) ~= 0 and wDriveTogglePtr.c():offset(0x10):readByte(0x05) == wDriveTogglePtr.c():offset(0x18):readByte(0x05) then
                brDriveTogglePtr = Mem:new(wDriveTogglePtr.get()):offset(0x18):offset(0x204)
            else brDriveTogglePtr = Mem:new() end
        else 
            blDriveTogglePtr = Mem:new()
            brDriveTogglePtr = Mem:new()
        end
    else 
        frDriveTogglePtr = Mem:new()
        blDriveTogglePtr = Mem:new()
        brDriveTogglePtr = Mem:new() 
    end
    if capacity == 0 then
        memory.write_float(wheelDrivePtr.get(), 0)
        memory.write_float(wheelDrivePtr.get()+0x04, 1)
        if not flDriveTogglePtr.isNil() then
            local flb = nToHexStr(flDriveTogglePtr:readByte())
            if contains({"5"}, flb[-1]) then
                if contains({"2", "8", "0", "4"}, flb[-2]) then
                    flb = rplStr(flb, -2, flb[-2]+1)
                    flDriveTogglePtr:writeByte(hexStrToN(flb))
                end
            elseif contains({"A", "2"}, flb[-1]) then
                if contains({"3","9","1","5"}, flb[-2]) then
                    flb = rplStr(flb, -2, flb[-2]-1)
                    flDriveTogglePtr:writeByte(hexStrToN(flb))
                end
            end
        end
        if not frDriveTogglePtr.isNil() then
            local frb = nToHexStr(frDriveTogglePtr:readByte())
            if contains({"6"}, frb[-1]) then
                if contains({"2", "8", "0", "4"}, frb[-2]) then
                    frb = rplStr(frb, -2, frb[-2]+1)
                    frDriveTogglePtr:writeByte(hexStrToN(frb))
                end
            elseif contains({"8", "9"}, frb[-1]) then
                if contains({"3","9","1","5"}, frb[-2]) then
                    frb = rplStr(frb, -2, frb[-2]-1)
                    frDriveTogglePtr:writeByte(hexStrToN(frb))
                end
            end
        end
        if not blDriveTogglePtr.isNil() then
            local blb = nToHexStr(blDriveTogglePtr:readByte())
            if contains({"4", "6", "E"}, blb[-1]) then
                if contains({"2", "8", "0", "4"}, blb[-2]) then
                    blb = rplStr(blb, -2, blb[-2]+1)
                    blDriveTogglePtr:writeByte(hexStrToN(blb))
                end
            end
        end
        if not brDriveTogglePtr.isNil() then
            local brb = nToHexStr(brDriveTogglePtr:readByte())
            if contains({"4", "C"}, brb[-1]) then
                if contains({"2", "8", "0", "4"}, brb[-2]) then
                    brb = rplStr(brb, -2, brb[-2]+1)
                    brDriveTogglePtr:writeByte(hexStrToN(brb))
                end
            end
        end




    elseif capacity/100 == 1 then
        memory.write_float(wheelDrivePtr.get(), 1)
        memory.write_float(wheelDrivePtr.get()+0x04, 0)
        if not flDriveTogglePtr.isNil() then
            local flb = nToHexStr(flDriveTogglePtr:readByte())
            if contains({"5"}, flb[-1]) then
                if contains({"3","9","1","5"}, flb[-2]) then
                    flb = rplStr(flb, -2, flb[-2]-1)
                    flDriveTogglePtr:writeByte(hexStrToN(flb))
                end
            elseif contains({"A", "2"}, flb[-1]) then
                if contains({"2", "8", "0", "4"}, flb[-2]) then
                    flb = rplStr(flb, -2, flb[-2]+1)
                    flDriveTogglePtr:writeByte(hexStrToN(flb))
                end
            end
        end
        if not frDriveTogglePtr.isNil() then
            local frb = nToHexStr(frDriveTogglePtr:readByte())
            if contains({"6"}, frb[-1]) then
                if contains({"3","9","1","5"}, frb[-2]) then
                    frb = rplStr(frb, -2, frb[-2]-1)
                    frDriveTogglePtr:writeByte(hexStrToN(frb))
                end
            elseif contains({"8", "9"}, frb[-1]) then
                if contains({"2", "8", "0", "4"}, frb[-2]) then
                    frb = rplStr(frb, -2, frb[-2]+1)
                    frDriveTogglePtr:writeByte(hexStrToN(frb))
                end
            end
        end
        if not blDriveTogglePtr.isNil() then
            local blb = nToHexStr(blDriveTogglePtr:readByte())
            if contains({"4", "6", "E"}, blb[-1]) then
                if contains({"3","9","1","5"}, blb[-2]) then
                    blb = rplStr(blb, -2, blb[-2]-1)
                    blDriveTogglePtr:writeByte(hexStrToN(blb))
                end
            end
        end
        if not brDriveTogglePtr.isNil() then
            local brb = nToHexStr(brDriveTogglePtr:readByte())
            if contains({"4", "C"}, brb[-1]) then
                if contains({"3","9","1","5"}, brb[-2]) then
                    brb = rplStr(brb, -2, brb[-2]-1)
                    brDriveTogglePtr:writeByte(hexStrToN(brb))
                end
            end
        end


    elseif capacity/100 > 0 and capacity/100 < 1 then
        local tmp = 2 * (capacity/100)
        memory.write_float(wheelDrivePtr.get(), tmp)
        memory.write_float(wheelDrivePtr.get()+0x04, 2-tmp)
        if not flDriveTogglePtr.isNil() then
            local flb = nToHexStr(flDriveTogglePtr:readByte())
            if contains({"5"}, flb[-1]) then
                if contains({"2", "8", "0", "4"}, flb[-2]) then
                    flb = rplStr(flb, -2, flb[-2]+1)
                    flDriveTogglePtr:writeByte(hexStrToN(flb))
                end
            elseif contains({"A", "2"}, flb[-1]) then
                if contains({"2", "8", "0", "4"}, flb[-2]) then
                    flb = rplStr(flb, -2, flb[-2]+1)
                    flDriveTogglePtr:writeByte(hexStrToN(flb))
                end
            end
        end
        if not frDriveTogglePtr.isNil() then
            local frb = nToHexStr(frDriveTogglePtr:readByte())
            if contains({"6"}, frb[-1]) then
                if contains({"2", "8", "0", "4"}, frb[-2]) then
                    frb = rplStr(frb, -2, frb[-2]+1)
                    frDriveTogglePtr:writeByte(hexStrToN(frb))
                end
            elseif contains({"8", "9"}, frb[-1]) then
                if contains({"2", "8", "0", "4"}, frb[-2]) then
                    frb = rplStr(frb, -2, frb[-2]+1)
                    frDriveTogglePtr:writeByte(hexStrToN(frb))
                end
            end
        end
        if not blDriveTogglePtr.isNil() then
            local blb = nToHexStr(blDriveTogglePtr:readByte())
            if contains({"4", "6", "E"}, blb[-1]) then
                if contains({"2", "8", "0", "4"}, blb[-2]) then
                    blb = rplStr(blb, -2, blb[-2]+1)
                    blDriveTogglePtr:writeByte(hexStrToN(blb))
                end
            end
        end
        if not brDriveTogglePtr.isNil() then
            local brb = nToHexStr(brDriveTogglePtr:readByte())
            if contains({"4", "C"}, brb[-1]) then
                if contains({"2", "8", "0", "4"}, brb[-2]) then
                    brb = rplStr(brb, -2, brb[-2]+1)
                    brDriveTogglePtr:writeByte(hexStrToN(brb))
                end
            end
        end
    else
        util.toast( "Some wheel drive memory error", TOAST_DEFAULT)
    end
end

local fwDriveBias = menu.slider_float(vehicleFolder, "Front wheel drive bias", {"fwdrivebias"}, "Do what it does. ", 0.0, 1*100 , 
not gVehicleState.currentPedVehiclePtr.isNil() and gtmp or 0, 0.01*100, function(capacity) wheelDriveBias(capacity, gVehicleState.currentPedVehiclePtr) end )

if gVehicleState.currentPedVehiclePtr.isNil() or not isVehicleEngineWheelDrive(ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId)) then
    menu.set_visible(fwDriveBias, flase)
end

local onEntryWheelDriveValue = menu.get_value(fwDriveBias)
local wheelDriveFromStartTick = 0
onTick[#onTick+1] = function ()
    if wheelDriveFromStartTick == 1 then
        menu.set_value(fwDriveBias, onEntryWheelDriveValue)
        wheelDriveFromStartTick = 2
    end
    if gVehicleState.vehicleChanged then
        if  isVehicleEngineWheelDrive(ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId)) and not gVehicleState.currentPedVehiclePtr:isNil() then
            if not menu.get_visible(fwDriveBias) then
                menu.set_visible(fwDriveBias, true)
            end
            wheelDrivePtr = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x918):offset(0x48)
            if wheelDrivePtr.readFloat() == 1 and wheelDrivePtr.readFloat(0x04) == 0 then
                tmp = 1*100
            else
                tmp = math.floor(round(wheelDrivePtr.readFloat()/2, 100)*100)
            end
            menu.set_value(fwDriveBias, tmp)
        else
            if menu.get_visible(fwDriveBias) then
                menu.set_visible(fwDriveBias, flase)
            end
        end
    end
    if wheelDriveFromStartTick == 0 then
        wheelDriveFromStartTick = 1
    end
end

local onEntryVehicleTrgetable = nil
local setVehicleUntargetable = false
local setVehicleUntargetableTriggered = false
menu.toggle(vehicleFolder, 'Set vehicle untargetable' ,{"setvehicleuntargetable"}, "Do what it does. \n(Sometimes breaks if u use seamless join)", function(toggle)
    setVehicleUntargetable = toggle
    setVehicleUntargetableTriggered = toggle
end)

local isPlayerInVehicleVU = false
onTick[#onTick+1] = function ()
    local playerEnvehicle = not isPlayerInVehicleVU and PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false)
    local playerExvehicle = isPlayerInVehicleVU and not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false)
    isPlayerInVehicleVU = PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false)
    if setVehicleUntargetable then
        if gVehicleState.vehicleChanged then
            if onEntryVehicleTrgetable ~= nil then
                if gVehicleState.lastPedVehicle ~= 0 then
                    Mem:new(gVehicleState.lastPedVehicle + 0x0A9E):writeByte(onEntryVehicleTrgetable)
                end
                
                onEntryVehicleTrgetable = nil
            end
        elseif playerExvehicle then
            if onEntryVehicleTrgetable ~= nil then
                if gVehicleState.lastPedVehicle ~= 0 then
                    Mem:new(gVehicleState.lastPedVehicle + 0x0A9E):writeByte(onEntryVehicleTrgetable)
                end
                onEntryVehicleTrgetable = nil
            end
        end 
        if (gVehicleState.vehicleChanged or playerEnvehicle or setVehicleUntargetableTriggered) and (not gVehicleState.currentPedVehiclePtr.isNil()) and isPlayerInVehicleVU 
        and gVehicleState.isCurrentVehicleEntry() then
            if onEntryVehicleTrgetable == nil then
                onEntryVehicleTrgetable = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x0A9E).readByte()
            end
            Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x0A9E):writeByte(0)
            setVehicleUntargetableTriggered = false
        end
    else
        if onEntryVehicleTrgetable ~= nil then
            if isPlayerInVehicleVU and not (gVehicleState.vehicleChanged) then
                if not gVehicleState.currentPedVehiclePtr.isNil() then
                    Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x0A9E):writeByte(1)
                end
            else    
            end
            onEntryVehicleTrgetable = nil
        end
    end
end 

-- deluxo transform
local function isThisVehicle4Wheel(vehicleHash)
    return VEHICLE.IS_THIS_MODEL_A_CAR(vehicleHash) or VEHICLE.IS_THIS_MODEL_A_QUADBIKE(vehicleHash) or VEHICLE.IS_THIS_MODEL_AN_AMPHIBIOUS_CAR(vehicleHash) or VEHICLE.IS_THIS_MODEL_AN_AMPHIBIOUS_QUADBIKE(vehicleHash)
end

local function vehicleSpoofPatch(toggle)
    if toggle then
        Mem:new(DPPtr):writeLong(hexStrToN("110FF39090901AEB"))

        Mem:new(DPPtr - 0x6A5BF):writeLong(hexStrToN("90909090909009EB"))
        Mem:new(DPPtr - 0x452BA):writeLong(hexStrToN("40468B90909003EB"))
        Mem:new(DPPtr - 0x45113):writeLong(hexStrToN("D3C60F90909003EB"))
        Mem:new(DPPtr - 0x450F9):writeLong(hexStrToN("590FF390909008EB"))
        Mem:new(DPPtr - 0x45078):writeLong(hexStrToN("F6854D90909003EB"))
        Mem:new(DPPtr - 0x44ED4):writeLong(hexStrToN("D0C60F90909003EB"))

        Mem:new(DPPtr + 0x171C9):writeLong(hexStrToN("90909090909006EB"))
        Mem:new(DPPtr - 0x44CF6):writeLong(hexStrToN("90909090909007EB"))
        Mem:new(DPPtr - 0x44CF6 + 8):writeByte(hexStrToN("90"))
        Mem:new(DPPtr - 0x44AFF):writeLong(hexStrToN("90909090909006EB"))
        Mem:new(DPPtr - 0x448DC):writeLong(hexStrToN("F3057690909003EB"))
        return toggle
    else
        Mem:new(DPPtr):writeLong(hexStrToN("110FF33059110FF3"))

        Mem:new(DPPtr - 0x6A5BF):writeLong(hexStrToN("0000009CB0590FF3"))
        Mem:new(DPPtr - 0x452BA):writeLong(hexStrToN("40468B3C40590FF3"))
        Mem:new(DPPtr - 0x45113):writeLong(hexStrToN("D3C60F3448590FF3"))
        Mem:new(DPPtr - 0x450F9):writeLong(hexStrToN("590FF33450590FF3"))
        Mem:new(DPPtr - 0x45078):writeLong(hexStrToN("F6854D7C48100FF3"))
        Mem:new(DPPtr - 0x44ED4):writeLong(hexStrToN("D0C60F3858100FF3"))

        Mem:new(DPPtr + 0x171C9):writeLong(hexStrToN("0000009480100FF3"))
        Mem:new(DPPtr - 0x44CF6):writeLong(hexStrToN("00008888100F44F3"))
        Mem:new(DPPtr - 0x44CF6 + 8):writeByte(hexStrToN("00"))
        Mem:new(DPPtr - 0x44AFF):writeLong(hexStrToN("0000008C80100FF3"))
        Mem:new(DPPtr - 0x448DC):writeLong(hexStrToN("F305763070590FF3"))
        return toggle
    end
end

local enableOppressor2Mod = false
local enableDeluxoMod = false
local enableDeluxoModTriggered = false
local enableOppressor2ModE = true
local enableDeluxoModE = true
local function onVehicleSpoofNeeded() return enableDeluxoMod or enableOppressor2Mod end
local function onVehicleSpoofAToDisable() return enableDeluxoModE and enableOppressor2ModE end
local lastVehicleDeluxoSpoof = nil
local isPlayerInVehicle = false
menu.toggle(vehicleFolder, 'Deluxo Mod' ,{"enableodeluxomod"}, 
"This will allow you to fly any car like a Deluxo \n(Works on cars and quad bike. Any 4< wheel vehicle) \n(button to switch modes below)", function(toggle)
    enableDeluxoMod = toggle
    enableDeluxoModTriggered = toggle
end, enableDeluxoMod)


onTick[#onTick+1] = function ()
    local playerEnvehicle = not isPlayerInVehicle and PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false)
    local playerExvehicle = isPlayerInVehicle and not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false)
    isPlayerInVehicle = PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false)
    if onVehicleSpoofNeeded() then vehicleSpoofPatch(onVehicleSpoofNeeded()) end
    enableDeluxoModE = false
    if enableDeluxoMod then
        if gVehicleState.vehicleChanged then
            if lastVehicleDeluxoSpoof ~= nil and lastVehicleDeluxoSpoof ~= 0 and gVehicleState.lastPedVehicleHandlingPtr ~= 0 and gVehicleState.lastPedVehicleHandlingPtr ~= nil then
                if ENTITY.DOES_ENTITY_EXIST(gVehicleState.lastPedVehicleId) and ENTITY.GET_ENTITY_MODEL(gVehicleState.lastPedVehicleId) ~= util.joaat("deluxo") then
                    VEHICLE.SET_SPECIAL_FLIGHT_MODE_RATIO(gVehicleState.lastPedVehicleId, 0.001)
                    VEHICLE.SET_SPECIAL_FLIGHT_MODE_TARGET_RATIO(gVehicleState.lastPedVehicleId, 0)
                    util.yield()
                end
                if gVehicleState.lastPedVehicleHandlingPtr ~= 0 then
                    Mem:new(gVehicleState.lastPedVehicleHandlingPtr + 0x158):offset(0x0):writeLong(lastVehicleDeluxoSpoof)
                end
                
                lastVehicleDeluxoSpoof = nil
            end
        elseif playerExvehicle then
            if lastVehicleDeluxoSpoof ~= nil and lastVehicleDeluxoSpoof ~= 0 then
                if ENTITY.DOES_ENTITY_EXIST(gVehicleState.lastPedVehicleId) and ENTITY.GET_ENTITY_MODEL(gVehicleState.lastPedVehicleId) ~= util.joaat("deluxo") then
                    VEHICLE.SET_SPECIAL_FLIGHT_MODE_RATIO(gVehicleState.lastPedVehicleId, 0.001)
                    VEHICLE.SET_SPECIAL_FLIGHT_MODE_TARGET_RATIO(gVehicleState.lastPedVehicleId, 0)
                    util.yield()
                end
                
                if gVehicleState.lastPedVehicleHandlingPtr ~= 0 then
                    Mem:new(gVehicleState.lastPedVehicleHandlingPtr + 0x158):offset(0x0):writeLong(lastVehicleDeluxoSpoof)
                end
                lastVehicleDeluxoSpoof = nil
            end
        end 
        if (gVehicleState.vehicleChanged or playerEnvehicle or enableDeluxoModTriggered) and (not gVehicleState.currentPedVehiclePtr.isNil()) and isPlayerInVehicle 
        and gVehicleState.isCurrentVehicleEntry() and isThisVehicle4Wheel(ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId)) 
        and ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId) ~= util.joaat("deluxo") then
            lastVehicleDeluxoSpoof = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x918):offset(0x158):offset(0x0).readLong()
            Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x918):offset(0x158):offset(0x0):writeLong(Mem:new(VBPtr):offset(0xEA0):offset(0x158):offset(0x0):readLong())
            enableDeluxoModTriggered = false
        end
    else
        if lastVehicleDeluxoSpoof ~= nil and lastVehicleDeluxoSpoof ~= 0 then
            if ENTITY.DOES_ENTITY_EXIST(gVehicleState.lastPedVehicleId) then
                VEHICLE.SET_SPECIAL_FLIGHT_MODE_RATIO(gVehicleState.lastPedVehicleId, 0.001)
                VEHICLE.SET_SPECIAL_FLIGHT_MODE_TARGET_RATIO(gVehicleState.lastPedVehicleId, 0)
                util.yield()
            end
            if isPlayerInVehicle and not (gVehicleState.vehicleChanged) then
                if not gVehicleState.currentPedVehiclePtr.isNil() then
                    Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x918):offset(0x158):offset(0x0):writeLong(lastVehicleDeluxoSpoof)
                end
            else    
                Mem:new(gVehicleState.lastPedVehicleHandlingPtr + 0x158):offset(0x0):writeLong(lastVehicleDeluxoSpoof)
            end
            lastVehicleDeluxoSpoof = nil
        end
        enableDeluxoModE = true
    end
end
onPreStop[#onPreStop+1] = function ()
    if lastVehicleDeluxoSpoof ~= nil and lastVehicleDeluxoSpoof ~= 0 then
        if ENTITY.DOES_ENTITY_EXIST(gVehicleState.lastPedVehicleId) then
            VEHICLE.SET_SPECIAL_FLIGHT_MODE_RATIO(gVehicleState.lastPedVehicleId, 0.001)
            VEHICLE.SET_SPECIAL_FLIGHT_MODE_TARGET_RATIO(gVehicleState.lastPedVehicleId, 0)
        end
    end
end
onStop[#onStop+1] = function ()
    if lastVehicleDeluxoSpoof ~= nil and lastVehicleDeluxoSpoof ~= 0 then
        if PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false) and not (gVehicleState.vehicleChanged) then
            if not gVehicleState.currentPedVehiclePtr.isNil() then
                Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x918):offset(0x158):offset(0x0):writeLong(lastVehicleDeluxoSpoof)
            end
        else    
            Mem:new(gVehicleState.lastPedVehicleHandlingPtr + 0x158):offset(0x0):writeLong(lastVehicleDeluxoSpoof)
        end
        lastVehicleDeluxoSpoof = nil
    end
end

local enableDeluxoTransform = false
local deluxoTransformOnTransition = false
local ttdmMenu = menu.toggle(vehicleFolder, 'Transform to Deluxo mod' ,{"transformodeluxomode"}, 
"Switches the vehicle to Deluxo flight mode \n(Enable the above function first)", function(toggle)
    if enableDeluxoMod and (not enableDeluxoModTriggered) and gVehicleState.currentPedVehicleId and ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId) ~= util.joaat("deluxo") 
    and isThisVehicle4Wheel(ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId)) and not deluxoTransformOnTransition then
        if toggle and Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x362).readShort() ~= 0x3F80 then
            enableDeluxoTransform = true
            deluxoTransformOnTransition = true
            VEHICLE.SET_SPECIAL_FLIGHT_MODE_RATIO(gVehicleState.currentPedVehicleId, 0)
            VEHICLE.SET_SPECIAL_FLIGHT_MODE_TARGET_RATIO(gVehicleState.currentPedVehicleId, 1)
            while gVehicleState.currentVehicleEntry ~= 0 and (not gVehicleState.vehicleChanged) 
            and Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x362).readShort() ~= 0x3F80 do
                util.yield()
            end
            deluxoTransformOnTransition = false
        elseif not toggle and Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x362).readShort() ~= 0x0 then
            enableDeluxoTransform = false
            deluxoTransformOnTransition = true
            VEHICLE.SET_SPECIAL_FLIGHT_MODE_RATIO(gVehicleState.currentPedVehicleId, 1)
            VEHICLE.SET_SPECIAL_FLIGHT_MODE_TARGET_RATIO(gVehicleState.currentPedVehicleId, 0)
            while gVehicleState.currentVehicleEntry ~= 0 and (not gVehicleState.vehicleChanged) 
            and Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x362).readShort() ~= 0x0 do
                util.yield()
            end
            deluxoTransformOnTransition = false
        end
    end
end, enableDeluxoTransform)

local isPlayerInVehicleTransform = false
util.create_tick_handler(function ()
    
    local playerEnvehicle = not isPlayerInVehicleTransform and PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false)
    local playerExvehicle = isPlayerInVehicleTransform and not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false)
    isPlayerInVehicleTransform = PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false)
    if not (enableDeluxoMod and (not enableDeluxoModTriggered) and gVehicleState.currentPedVehicleId and ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId) ~= util.joaat("deluxo")) 
    or gVehicleState.vehicleChanged or playerExvehicle or playerEnvehicle or not isPlayerInVehicleTransform then
        if menu.get_value(ttdmMenu) then
            menu.set_value(ttdmMenu, false)
            enableDeluxoTransform = false
        end
    end
    if deluxoTransformOnTransition then
        menu.set_value(ttdmMenu, enableDeluxoTransform)
    else
        if enableDeluxoMod and (not enableDeluxoModTriggered) and gVehicleState.currentPedVehicleId and ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId) ~= util.joaat("deluxo") 
        and isThisVehicle4Wheel(ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId)) then
            if enableDeluxoTransform then
                VEHICLE.SET_SPECIAL_FLIGHT_MODE_RATIO(gVehicleState.lastPedVehicleId, 1)
                VEHICLE.SET_SPECIAL_FLIGHT_MODE_TARGET_RATIO(gVehicleState.lastPedVehicleId, 1)
            else
                VEHICLE.SET_SPECIAL_FLIGHT_MODE_RATIO(gVehicleState.lastPedVehicleId, 0)
                VEHICLE.SET_SPECIAL_FLIGHT_MODE_TARGET_RATIO(gVehicleState.lastPedVehicleId, 0)
            end
        end
    end
end)

local function isThisVehicle4Wheel(vehicleHash)
    return VEHICLE.IS_THIS_MODEL_A_BIKE(vehicleHash) or VEHICLE.IS_THIS_MODEL_A_BICYCLE(vehicleHash)
end

local enableOppressor2ModTriggered = false
local lastVehicleOp2Spoof = nil
local enableOp2Transform = false
menu.toggle(vehicleFolder, 'Oppressor MK2 Mod' ,{"enableop2mod"}, 
"This will allow you to fly on any bike or motorcycle like on Oppressor MK 2 \n(Button to switch the mode below)", function(toggle)
    enableOppressor2Mod = toggle
    enableOppressor2ModTriggered = toggle
end, enableOppressor2Mod)

menu.toggle(vehicleFolder, 'Transform to Oppressor MK2' ,{"transformop2mode"}, 
"Switches bike or motorbike to flight mode Oppressor MK 2 \n(Enable above function first)", function(toggle)
    enableOp2Transform = toggle
end, enableOp2Transform)

local isPlayerOnBike = false
onTick[#onTick+1] = function ()
    local playerEnbike = not isPlayerOnBike and PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false)
    local playerExbike = isPlayerOnBike and not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false)
    isPlayerOnBike = PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false)
    if onVehicleSpoofNeeded() then vehicleSpoofPatch(onVehicleSpoofNeeded()) end
    enableOppressor2ModE = false
    if enableOppressor2Mod then
        if gVehicleState.vehicleChanged then
            if lastVehicleOp2Spoof ~= nil and lastVehicleOp2Spoof ~= 0 and gVehicleState.lastPedVehicleHandlingPtr ~= 0 and gVehicleState.lastPedVehicleHandlingPtr ~= nil then
                local engineWasOn = false
                if ENTITY.DOES_ENTITY_EXIST(gVehicleState.lastPedVehicleId) and ENTITY.GET_ENTITY_MODEL(gVehicleState.lastPedVehicleId) ~= util.joaat("oppressor2") then
                    Mem:new(gVehicleState.lastPedVehicle + 0x362):writeShort(0x3D74)
                    util.yield()
                    Mem:new(gVehicleState.lastPedVehicle + 0x362):writeShort(0x0000)
                end
                if gVehicleState.lastPedVehicleHandlingPtr ~= 0 then
                    Mem:new(gVehicleState.lastPedVehicleHandlingPtr + 0x158):writeLong(lastVehicleOp2Spoof)
                end
                
                lastVehicleOp2Spoof = nil
            end
        elseif playerExbike then
            if lastVehicleOp2Spoof ~= nil and lastVehicleOp2Spoof ~= 0 then
                local engineWasOn = false
                if ENTITY.DOES_ENTITY_EXIST(gVehicleState.lastPedVehicleId) and ENTITY.GET_ENTITY_MODEL(gVehicleState.lastPedVehicleId) ~= util.joaat("oppressor2") then
                    Mem:new(gVehicleState.lastPedVehicle + 0x362):writeShort(0x3D74)
                    util.yield()
                    Mem:new(gVehicleState.lastPedVehicle + 0x362):writeShort(0x0000)
                end
                
                if gVehicleState.lastPedVehicleHandlingPtr ~= 0 then
                    Mem:new(gVehicleState.lastPedVehicleHandlingPtr + 0x158):writeLong(lastVehicleOp2Spoof)
                end
                lastVehicleOp2Spoof = nil
            end
        end 
        if (gVehicleState.vehicleChanged or playerEnbike or enableOppressor2ModTriggered or enableOp2Transform) and (not gVehicleState.currentPedVehiclePtr.isNil()) and isPlayerOnBike 
        and gVehicleState.isCurrentVehicleEntry() and isThisVehicle4Wheel(ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId)) 
        and ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId) ~= util.joaat("oppressor2") and enableOp2Transform then
            if lastVehicleOp2Spoof == nil or lastVehicleOp2Spoof == 0 then
                lastVehicleOp2Spoof = Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x918):offset(0x158).readLong()
                Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x918):offset(0x158):writeLong(Mem:new(VBPtr):offset(0xFF0):offset(0x158):readLong())
                enableOppressor2ModTriggered = false
            end
        end
        if ENTITY.GET_ENTITY_MODEL(gVehicleState.lastPedVehicleId) ~= util.joaat("oppressor2") and not enableOp2Transform then
            if lastVehicleOp2Spoof ~= nil and lastVehicleOp2Spoof ~= 0 then
                local engineWasOn = false
                if ENTITY.DOES_ENTITY_EXIST(gVehicleState.lastPedVehicleId) and ENTITY.GET_ENTITY_MODEL(gVehicleState.lastPedVehicleId) ~= util.joaat("oppressor2") then
                    Mem:new(gVehicleState.lastPedVehicle + 0x362):writeShort(0x3D74)
                    util.yield()
                    Mem:new(gVehicleState.lastPedVehicle + 0x362):writeShort(0x0000)
                end
                
                if gVehicleState.lastPedVehicleHandlingPtr ~= 0 then
                    Mem:new(gVehicleState.lastPedVehicleHandlingPtr + 0x158):writeLong(lastVehicleOp2Spoof)
                end
                lastVehicleOp2Spoof = nil
            end
        end
    else
        if lastVehicleOp2Spoof ~= nil and lastVehicleOp2Spoof ~= 0 then
            if ENTITY.DOES_ENTITY_EXIST(gVehicleState.lastPedVehicleId) and ENTITY.GET_ENTITY_MODEL(gVehicleState.lastPedVehicleId) ~= util.joaat("oppressor2") then
                Mem:new(gVehicleState.lastPedVehicle + 0x362):writeShort(0x3D74)
                util.yield()
                Mem:new(gVehicleState.lastPedVehicle + 0x362):writeShort(0x0000)
            end
            if isPlayerOnBike and not (gVehicleState.vehicleChanged) then
                if not gVehicleState.currentPedVehiclePtr.isNil() then
                    Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x918):offset(0x158):writeLong(lastVehicleOp2Spoof)
                end
            else    
                Mem:new(gVehicleState.lastPedVehicleHandlingPtr + 0x158):writeLong(lastVehicleOp2Spoof)
            end
            lastVehicleOp2Spoof = nil
        end
        enableOppressor2ModE = true
        
    end
end
onPreStop[#onPreStop+1] = function ()
    if lastVehicleOp2Spoof ~= nil and lastVehicleOp2Spoof ~= 0 then
        if ENTITY.DOES_ENTITY_EXIST(gVehicleState.lastPedVehicleId) and ENTITY.GET_ENTITY_MODEL(gVehicleState.lastPedVehicleId) ~= util.joaat("oppressor2") then
            Mem:new(gVehicleState.lastPedVehicle + 0x362):writeShort(0x3D74)
        end
    end
end
onStop[#onStop+1] = function ()
    if lastVehicleOp2Spoof ~= nil and lastVehicleOp2Spoof ~= 0 then
        if ENTITY.DOES_ENTITY_EXIST(gVehicleState.lastPedVehicleId) and ENTITY.GET_ENTITY_MODEL(gVehicleState.lastPedVehicleId) ~= util.joaat("oppressor2") then
            Mem:new(gVehicleState.lastPedVehicle + 0x362):writeShort(0x0000)
        end
        if isPlayerOnBike and not (gVehicleState.vehicleChanged) then
            if not gVehicleState.currentPedVehiclePtr.isNil() then
                Mem:new(gVehicleState.currentPedVehiclePtr.get()):offset(0x918):offset(0x158):writeLong(lastVehicleOp2Spoof)
            end
        else    
            Mem:new(gVehicleState.lastPedVehicleHandlingPtr + 0x158):writeLong(lastVehicleOp2Spoof)
        end
        lastVehicleOp2Spoof = nil
    end
end

-- input settings

menu.toggle_loop(vehicleFolder, 'Boost on B gamepad' ,{"rebindboostonbgamepad"}, 
"This will allow you to enable and disable boost in the vehicle (if available) on the B button on the gamepad instead of L3", function()
    local player = PLAYER.PLAYER_ID()
    if players.is_using_controller(player) then
        PAD.DISABLE_CONTROL_ACTION(0, 80, true)
        PAD.DISABLE_CONTROL_ACTION(0, 351, true)
        PAD.DISABLE_CONTROL_ACTION(0, 352, true)
    else
        if not PAD.IS_CONTROL_ENABLED(0, 80) then
            PAD.ENABLE_CONTROL_ACTION(0, 80, true)
        end
        if not PAD.IS_CONTROL_ENABLED(0, 351) then
            PAD.ENABLE_CONTROL_ACTION(0, 351, true)
        end
        if not PAD.IS_CONTROL_ENABLED(0, 352) then
            PAD.ENABLE_CONTROL_ACTION(0, 352, true)
        end
    end
    if PAD.IS_DISABLED_CONTROL_JUST_RELEASED(0, 80) and players.is_using_controller(player) 
    and not HUD.IS_PAUSE_MENU_ACTIVE()  and PAD.IS_CONTROL_JUST_RELEASED(0, 177) and PAD.IS_CONTROL_JUST_RELEASED(0, 202) then
        if Mem:new(worldPtr):offset(0x08):offset(0xD10).readLong() ~= 0 and Mem:new(worldPtr):offset(0x08):offset(0xD10):offset(0xC28):offset(0):offset(0x44).readByte() ~= 1 then
            if VEHICLE.GET_IS_VEHICLE_ENGINE_RUNNING(PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)) then
                if Mem:new(worldPtr):offset(0x08):offset(0xD10):offset(0x2FD).readByte() == 0 then
                    Mem:new(worldPtr):offset(0x08):offset(0xD10):offset(0x2F8):writeByte(1)
                else
                    Mem:new(worldPtr):offset(0x08):offset(0xD10):offset(0x2F8):writeByte(0)
                end
            end
        end
    end
    if gVehicleState.currentVehicleEntry ~= 0 then
        if VEHICLE.IS_THIS_MODEL_A_PLANE(ENTITY.GET_ENTITY_MODEL(gVehicleState.currentPedVehicleId))
        and Mem:new(gVehicleState.currentVehicleEntry + 0x1F4A ):readShort() ~= 0 then
            Mem:new(gVehicleState.currentVehicleEntry + 0x2F8):writeByte(0)
        end
    end
end)


-- Cam Options
local camOffsetXPtr = Mem:new(CCamPtr):offset(0):offset(0x2C0):offset(0x208):offset(0x118)

local setCamXOffset = function(val)
    camOffsetXPtr = Mem:new(CCamPtr):offset(0):offset(0x2C0):offset(0x208):offset(0x118)
    memory.write_float(camOffsetXPtr.get(), val)
end

local camXOffset = menu.slider_float(camOptions, "Cam X Offset", {"parcisctiptcamxoffset"}, "(Dosnt work on first face cam)", -1*999999999*100, 999999999*100,
math.floor(round(memory.read_float(camOffsetXPtr.get()), 100)*100), 0.1*100,  function(capacity)
    camOffsetXPtr = Mem:new(CCamPtr):offset(0):offset(0x2C0):offset(0x208):offset(0x118)
    capacity /= 100
    setCamXOffset(capacity)
end)

local camZoomPtr = Mem:new(CCamPtr):offset(0):offset(0x2C0):offset(0x208):offset(0x168)

local setCamZoom = function(val)
    camZoomPtr = Mem:new(CCamPtr):offset(0):offset(0x2C0):offset(0x208):offset(0x168)
    memory.write_float(camZoomPtr.get(), val)
end

local camZoom = menu.slider_float(camOptions, "Cam Zoom", {"parcisctiptcamzoom"}, "(Dosnt work on first face cam)", -1*0.4*100, 999999999*100,
math.floor(round(memory.read_float(camZoomPtr.get()), 100)*100), 0.1*100,  function(capacity)
    camZoomPtr = Mem:new(CCamPtr):offset(0):offset(0x2C0):offset(0x208):offset(0x168)
    capacity /= 100
    setCamZoom(capacity)
end)

local camOffsetZPtr = Mem:new(CCamPtr):offset(0):offset(0x2C0):offset(0x208):offset(0x88)

local setCamZOffset = function(val)
    camOffsetZPtr = Mem:new(CCamPtr):offset(0):offset(0x2C0):offset(0x208):offset(0x88)
    memory.write_float(camOffsetZPtr.get(), val)
end

local camZOffset = menu.slider_float(camOptions, "Cam Z Offset", {"parcisctiptcamzoffset"}, "(Dosnt work on first face cam)", 0.5*100, 999999999*100,
math.floor(round(memory.read_float(camOffsetZPtr.get()), 100)*100), 0.1*100,  function(capacity)
    camOffsetZPtr = Mem:new(CCamPtr):offset(0):offset(0x2C0):offset(0x208):offset(0x88)
    capacity /= 100
    setCamZOffset(capacity)
end)


local pedVehicleOffsetXPtr = Mem:new(CCamPtr):offset(0):offset(0x2C0):offset(0x210):offset(0x7C)

local setPedVehicleXOffset = function(val)
    pedVehicleOffsetXPtr = Mem:new(CCamPtr):offset(0):offset(0x2C0):offset(0x210):offset(0x7C)
    memory.write_float(pedVehicleOffsetXPtr.get(), val)
end

local pedVehicleOffset = menu.slider_float(camOptions, "Ped vehicle X Offset", {"parcisctiptpedvehxoffset"}, "The offset of ped relative to the vehicle. Works on bikes and motorcycles", -100*100, 100*100,
math.floor(round(memory.read_float(pedVehicleOffsetXPtr.get()), 100)*100), 0.1*100,  function(capacity)
    pedVehicleOffsetXPtr = Mem:new(CCamPtr):offset(0):offset(0x2C0):offset(0x210):offset(0x7C)
    capacity /= 100
    setPedVehicleXOffset(capacity)
end)

local pedVehicleOffsetZPtr = Mem:new(CCamPtr):offset(0):offset(0x2C0):offset(0x210):offset(0x8C)

local setPedVehicleZOffset = function(val)
    pedVehicleOffsetZPtr = Mem:new(CCamPtr):offset(0):offset(0x2C0):offset(0x210):offset(0x8C)
    memory.write_float(pedVehicleOffsetZPtr.get(), val)
end

local pedVehicleOffset = menu.slider_float(camOptions, "Ped vehicle Z Offset", {"parcisctiptpedvehzoffset"}, "The offset of ped relative to the vehicle. Works on bikes and motorcycles", -100*100, 100*100,
math.floor(round(memory.read_float(pedVehicleOffsetZPtr.get()), 100)*100), 0.1*100,  function(capacity)
    pedVehicleOffsetZPtr = Mem:new(CCamPtr):offset(0):offset(0x2C0):offset(0x210):offset(0x8C)
    capacity /= 100
    setPedVehicleZOffset(capacity)
end)

-- Localisation options

local localisations <const> = {
    [0] = {"English"},
    [1] = {"French"},
    [2] = {"German"},
    [3] = {"Italian"},
    [4] = {"Spanish"},
    [5] = {"Brasilian"},
    [6] = {"Polish"},
    [7] = {"Russian"},
    [8] = {"Korean"},
    [9] = {"Chinese (traditional)"},
    [10] = {"Japanese"},
    [11] = {"Mexican"},
    [12] = {"Chinese (Simplified)"},
}

menu.list_select(menu.my_root() ,"Localisation", {}, 
"This will automatically change your localization to the selected one. \n(If the localization has not changed, open and close the pause menu)", localisations, Mem:new(LocalisationPtr).readByte(), function(value)
    Mem:new(LocalisationPtr):writeByte(value)
    PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 200, 1)
    util.yield(100)
    PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 200, 1)
end)

-- On functions

onTick[#onTick+1] = function ()
    if onVehicleSpoofAToDisable() then 
        vehicleSpoofPatch(not onVehicleSpoofAToDisable()) 
    end
    
    
end

util.on_pre_stop(function()
    for i in onPreStop do
        onPreStop[i]()
    end
end)

util.on_stop(function()
    for i in onStop do
        onStop[i]()
    end
    vehicleSpoofPatch(false)
end)

while true do
    for i in onTick do
        onTick[i]()
    end
    util.yield()
end
 
