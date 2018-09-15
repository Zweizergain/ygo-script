local m=13570521
local cm=_G["c"..m]
cm.name="歪秤 冰之巨魔"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Link
	aux.AddLinkProcedure(c,cm.lfilter,2)
	--Atk Down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(cm.target)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
end
--Link
function cm.lfilter(c)
	return c:IsLinkRace(RACE_FIEND)
end
--Atk Down
function cm.target(e,c)
	return c:IsFaceup() and not c:IsLinkState()
end
function cm.atkval(e,c)
	return math.ceil(c:GetAttack()/2)
end