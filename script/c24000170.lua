--颠倒的谎言世界
function c24000170.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c24000170.condition)
	c:RegisterEffect(e1)
	--summon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c24000170.sumlimit1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetTarget(c24000170.sumlimit2)
	c:RegisterEffect(e4)
	--activate cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetCondition(c24000170.accon1)
	e5:SetTarget(c24000170.actarget1)
	e5:SetCost(c24000170.accost1)
	e5:SetOperation(c24000170.acop1)
	c:RegisterEffect(e5)
	--activate cost
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_ACTIVATE_COST)
	e6:SetRange(LOCATION_SZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetCondition(c24000170.accon)
	e6:SetTarget(c24000170.actarget)
	e6:SetCost(c24000170.accost)
	e6:SetOperation(c24000170.acop)
	c:RegisterEffect(e6)
end
function c24000170.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c24000170.sumlimit1(e,c,sump,sumtype,sumpos,targetp,se)
	return Duel.GetActivityCount(sump,ACTIVITY_SPSUMMON)>0
end
function c24000170.sumlimit2(e,c,sump,sumtype,sumpos,targetp,se)
	return Duel.GetActivityCount(sump,ACTIVITY_NORMALSUMMON)>0
end
function c24000170.actarget(e,te,tp)
	return te:GetHandler():IsType(TYPE_SPELL)
end
function c24000170.accon(e)
	c24000170[0]=false
	return true
end
function c24000170.acfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c24000170.actarget(e,te,tp)
	return te:IsActiveType(TYPE_SPELL) and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c24000170.accost(e,te,tp)
	return Duel.IsExistingMatchingCard(c24000170.acfilter,tp,LOCATION_DECK,0,1,nil)
end
function c24000170.acop(e,tp,eg,ep,ev,re,r,rp)
	if c24000170[0] then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c24000170.acfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	c24000170[0]=true
end
function c24000170.accon1(e)
	c24000170[0]=false
	return true
end
function c24000170.acfilter1(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c24000170.actarget1(e,te,tp)
	return te:IsActiveType(TYPE_TRAP) and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c24000170.accost1(e,te,tp)
	return Duel.IsExistingMatchingCard(c24000170.acfilter1,tp,LOCATION_DECK,0,1,nil)
end
function c24000170.acop1(e,tp,eg,ep,ev,re,r,rp)
	if c24000170[0] then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c24000170.acfilter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	c24000170[0]=true
end
