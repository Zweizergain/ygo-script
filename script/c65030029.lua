--牺牲的二重阴影
function c65030029.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),5,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65030029,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,65030029)
	e1:SetCondition(c65030029.atkcon)
	e1:SetCost(c65030029.atkcost)
	e1:SetOperation(c65030029.atkop)
	c:RegisterEffect(e1)
	--Overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(c65030029,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c65030029.overcon)
	e2:SetTarget(c65030029.overtg)
	e2:SetOperation(c65030029.overop)
	c:RegisterEffect(e2)
	--Normal monster
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_REMOVE_TYPE)
	e4:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e4)
	local e6=e4:Clone()
	e6:SetValue(TYPE_XYZ)
	c:RegisterEffect(e6)
end
c65030029.setname="DoppelShader"
function c65030029.overcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE) 
end
function c65030029.overfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c65030029.layfil,tp,LOCATION_GRAVE,0,1,nil) 
end
function c65030029.layfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_NORMAL)
end
function c65030029.overtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65030029.overfil(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c65030029.overfil,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65030029.overfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c65030029.overop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,c65030029.layfil,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			local gc=g:GetFirst()
			Duel.Overlay(tc,Group.FromCards(gc))
		end
	end
end
function c65030029.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c65030029.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()>0 and e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c65030029.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c65030029.atktg)
	e1:SetValue(c65030029.atkval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c65030029.atktg(e,c)
	return c.setname=="DoppelShader"
end
function c65030029.fil(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_NORMAL)
end
function c65030029.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	local num=Duel.GetMatchingGroupCount(c65030029.fil,tp,LOCATION_GRAVE,0,nil)
	return num*200 
end