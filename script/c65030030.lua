--醒觉的二重阴影
function c65030030.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsXyzType,TYPE_NORMAL),5,3)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c65030030.indval)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e0)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c65030030.efilter)
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
	--slash!!
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e5:SetCountLimit(1,65030030)
	e5:SetCost(c65030030.cost)
	e5:SetTarget(c65030030.target)
	e5:SetOperation(c65030030.operation)
	c:RegisterEffect(e5)
end
c65030030.setname="DoppelShader"
function c65030030.indval(e,c)
	return c:IsType(TYPE_EFFECT)
end
function c65030030.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c65030030.fil1(c)
	local code=c:GetCode()
	return c:IsAbleToDeckOrExtraAsCost() and c:IsType(TYPE_NORMAL) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c65030030.fil2,tp,LOCATION_GRAVE,0,1,nil,code)
end
function c65030030.fil2(c,code)
	local code2=c:GetCode()
	return c:IsAbleToDeckOrExtraAsCost() and not c:IsCode(code) and c:IsType(TYPE_NORMAL) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c65030030.fil3,tp,LOCATION_GRAVE,0,1,nil,code,code2)
end
function c65030030.fil3(c,code,code2)
	return c:IsAbleToDeckOrExtraAsCost() and not c:IsCode(code) and not c:IsCode(code2) and c:IsType(TYPE_NORMAL) and c:IsType(TYPE_MONSTER) 
end
function c65030030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(c65030030.fil1,tp,LOCATION_GRAVE,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local tc1=Duel.SelectMatchingCard(tp,c65030030.fil1,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	local code=tc1:GetCode()
	local tc2=Duel.SelectMatchingCard(tp,c65030030.fil2,tp,LOCATION_GRAVE,0,1,1,nil,code):GetFirst()
	local code2=tc2:GetCode()
	local tc3=Duel.SelectMatchingCard(tp,c65030030.fil3,tp,LOCATION_GRAVE,0,1,1,nil,code,code2):GetFirst()
	local g=Group.FromCards(tc1,tc2,tc3)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c65030030.efffil(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c65030030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030030.efffil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetChainLimit(c65030030.chlimit)
end
function c65030030.chlimit(e,ep,tp)
	return tp==ep or not e:IsActiveType(TYPE_MONSTER) 
end
function c65030030.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65030030.efffil,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_TRIGGER)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SET_ATTACK_FINAL)
		e4:SetValue(0)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e5)
		tc=g:GetNext()
	end
end