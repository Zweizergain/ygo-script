function c89380006.initial_effect(c)
	c:SetUniqueOnField(1,1,89380006)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c89380006.spcon)
	e1:SetCost(c89380006.spcost)
	e1:SetOperation(c89380006.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c89380006.drcon)
	e2:SetCost(c89380006.drcost)
	e2:SetOperation(c89380006.drop)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCondition(c89380006.spcono)
	c:RegisterEffect(e3)
end
function c89380006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,89380009)
end
function c89380006.spcono(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_MZONE,0,nil,89380009)==0 
end
function c89380006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c89380006.eqfilter(c)
	return c:IsCode(89380009) and c:IsFaceup()
end
function c89380006.eqfilter2(c)
	return c:IsCode(89380006) and c:IsFaceup()
end
function c89380006.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(c89380006.negcon)
	e1:SetOperation(c89380006.negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)if Duel.IsExistingMatchingCard(c89380006.eqfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsLocation(LOCATION_GRAVE) and not Duel.IsExistingMatchingCard(c89380006.eqfilter2,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(89380006,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c89380006.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if not (g and Duel.Equip(tp,c,g:GetFirst(),false)) then return end
		local e1=Effect.CreateEffect(g:GetFirst())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c89380006.eqlimit)
		c:RegisterEffect(e1)
	end
end
function c89380006.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) 
end
function c89380006.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c89380006.eqlimit(e,c)
	return e:GetOwner()==c
end
function c89380006.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_EQUIP)
end
function c89380006.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c89380006.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(c89380006.negcon)
	e1:SetOperation(c89380006.negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
end