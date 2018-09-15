local m=13570423
local cm=_G["c"..m]
cm.name="歪秤 女武神瓦尔基里"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro
	aux.AddSynchroProcedure(c,cm.tfilter,aux.NonTuner(cm.ntfilter),1)
	--Atk Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.target)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	--Attack All
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
--Synchro
function cm.tfilter(c)
	return c:IsRace(RACE_FAIRY)
end
function cm.ntfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
--Atk Up
function cm.target(e,c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end