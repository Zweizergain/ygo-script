local m=13570952
local cm=_G["c"..m]
cm.name="歪秤 MSC七叶"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Effect Draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.drcon)
	e2:SetValue(2)
	c:RegisterEffect(e2)
	--Self Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.descon)
	c:RegisterEffect(e3)
end
--Effect Draw
function cm.drcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==0
end
--Self Destroy
function cm.desfilter(c)
	return c:IsType(TYPE_SPELL) and not c:IsType(TYPE_FIELD)
end
function cm.descon(e)
	return Duel.IsExistingMatchingCard(cm.desfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end