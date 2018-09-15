local m=13570103
local cm=_G["c"..m]
cm.name="歪秤旅者 北河阿卡丽"
function cm.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	--Atk & Def Up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.atktg)
	e2:SetValue(200)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
--Special Summon
function cm.spfilter1(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function cm.spfilter2(c)
	return not cm.spfilter1(c)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_MZONE,0,1,nil)
		and not Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_MZONE,0,1,nil)
end
--Atk & Def Up
function cm.atktg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end