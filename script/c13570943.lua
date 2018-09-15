local m=13570943
local cm=_G["c"..m]
cm.name="歪秤 MSC重炮兵"
function cm.initial_effect(c)
	--Dual
	aux.EnableDualAttribute(c)
	--Trap Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetCondition(aux.IsDualState)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
end
--Trap Activate
function cm.target(e,c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP)
end