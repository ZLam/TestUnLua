--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_PlayerController_C = Class()

function BP_PlayerController_C:Initialize(Initializer)
    self.CurMoveAxis = UE4.FVector2D(0, 0)
    self.TurnRate = 100;
end

--function BP_PlayerController_C:UserConstructionScript()
--end

-- function BP_PlayerController_C:ReceiveBeginPlay()
-- end

--function BP_PlayerController_C:ReceiveEndPlay()
--end

-- function BP_PlayerController_C:ReceiveTick(DeltaSeconds)
-- end

--function BP_PlayerController_C:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function BP_PlayerController_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_PlayerController_C:ReceiveActorEndOverlap(OtherActor)
--end

function BP_PlayerController_C:MoveForward(AxisValue)
    -- print(string.format("move forward : %s", AxisValue))

    self.CurMoveAxis.X = AxisValue
    self:PostCurMoveAxis()
end

function BP_PlayerController_C:MoveRight(AxisValue)
    -- print(string.format("move right : %s", AxisValue))

    self.CurMoveAxis.Y = AxisValue
    self:PostCurMoveAxis()
end

function BP_PlayerController_C:RotateYaw(AxisValue)
    local tRotate = self:GetControlRotation()
    tRotate.Yaw = tRotate.Yaw + AxisValue * self.TurnRate * UE4.UGameplayStatics.GetWorldDeltaSeconds(self)
    self:SetControlRotation(tRotate)
end

function BP_PlayerController_C:PostCurMoveAxis()
    local tMoveAxis = UE4.FVector(self.CurMoveAxis.X, self.CurMoveAxis.Y, 0)
    local Cube = self:K2_GetPawn()

    if (Cube) then
        Cube:SetMoveAxis(tMoveAxis)
    end
end

return BP_PlayerController_C
