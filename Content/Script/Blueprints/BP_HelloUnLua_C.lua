--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local Test = require "Test.Test"

local BP_HelloUnLua_C = Class()

function BP_HelloUnLua_C:Initialize(Initializer)
    print("BP_HelloUnLua_C:Initialize")
end

function BP_HelloUnLua_C:UserConstructionScript()
    print("BP_HelloUnLua_C:UserConstructionScript")
end

function BP_HelloUnLua_C:ReceiveBeginPlay()
    print("BP_HelloUnLua_C:ReceiveBeginPlay")

    local tParams = {BP = self}
    local tObj = Test.new(tParams);

    -- UE4.AActor.GetVelocity()
end

function BP_HelloUnLua_C:ReceiveEndPlay()
    print("BP_HelloUnLua_C:ReceiveEndPlay")
end

function BP_HelloUnLua_C:ReceiveTick(DeltaSeconds)
    -- print("BP_HelloUnLua_C:ReceiveTick " .. DeltaSeconds)
end

--function BP_HelloUnLua_C:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function BP_HelloUnLua_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_HelloUnLua_C:ReceiveActorEndOverlap(OtherActor)
--end

return BP_HelloUnLua_C
