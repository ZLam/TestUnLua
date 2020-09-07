--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_Cube_C = Class()

function BP_Cube_C:Initialize(Initializer)
    self.MoveAxis = UE4.FVector(0, 0, 0);
end

--function BP_Cube_C:UserConstructionScript()
--end

function BP_Cube_C:ReceiveBeginPlay()
    print(self.K2_GetActorLocation)
    print(self.K2_SetActorLocation)
    print(self.Arrow.bHiddenInGame)
end

--function BP_Cube_C:ReceiveEndPlay()
--end

function BP_Cube_C:ReceiveTick(DeltaSeconds)
    if ((self.MoveAxis) and (self.MoveAxis.X ~= 0 or self.MoveAxis.Y ~= 0 or self.MoveAxis.Z ~= 0)) then
        local CurPos = self:K2_GetActorLocation()
        local Forward = self:GetActorForwardVector();
        local Right = self:GetActorRightVector();
        local Direction = Forward * self.MoveAxis.X + Right * self.MoveAxis.Y
        local ToPos = CurPos + Direction * self.Speed * DeltaSeconds;
        self:K2_SetActorLocation(ToPos)

        self.Arrow:SetVisibility(true)
        local ToRotate = UE4.UKismetMathLibrary.Conv_VectorToRotator(Direction)
        self.Arrow:K2_SetWorldRotation(ToRotate)
    else
        if (self.Arrow) then
            if (self.Arrow:IsVisible()) then
                self.Arrow:SetVisibility(false)
            end
        end
    end
end

--function BP_Cube_C:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function BP_Cube_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_Cube_C:ReceiveActorEndOverlap(OtherActor)
--end

function BP_Cube_C:SetMoveAxis(InMoveAxis)
    self.MoveAxis = InMoveAxis
end

return BP_Cube_C
