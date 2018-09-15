--百夜★秩之鱼
function c44447005.initial_effect(c)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44447005,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_HAND)
	e1:SetCountLimit(1,44447005)
	e1:SetCost(c44447005.cost)
	e1:SetOperation(c44447005.operation)
	c:RegisterEffect(e1)
	--Normal monster
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_ADD_TYPE)
	e11:SetRange(LOCATION_GRAVE)
	e11:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e11)
end
function c44447005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) and e:GetHandler():IsAbleToGraveAsCost() end
	Duel.Draw(1-tp,1,REASON_COST)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c44447005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c44447005.rmcon1)
	e1:SetTarget(c44447005.rmtg1)
	e1:SetOperation(c44447005.rmop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c44447005.regcon)
	e2:SetOperation(c44447005.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c44447005.rmcon2)
	e3:SetTarget(c44447005.rmtg2)
	e3:SetOperation(c44447005.rmop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c44447005.rmfilter(c,p)
	return Duel.IsPlayerCanRemove(p,c) and not c:IsType(TYPE_TOKEN)
end
function c44447005.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	if re and re:GetHandler():IsCode(44447005) then return false end
	return rp~=tp and (not re or not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c44447005.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local ct=g:GetCount()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,30459350)
		and ct>0 and g:IsExists(c44447005.rmfilter,1,nil,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
end
function c44447005.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local ct=1
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(1-tp,c44447005.rmfilter,ct,ct,nil,1-tp)
		Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
	end
end
function c44447005.regcon(e,tp,eg,ep,ev,re,r,rp)
	if re and re:GetHandler():IsCode(44447005) then return false end
	return rp~=tp and re and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c44447005.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,44447005,RESET_CHAIN,0,1)
end
function c44447005.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,44447005)>0
end
function c44447005.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local ct=g:GetCount()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,30459350)
		and ct>0 and g:IsExists(c44447005.rmfilter,1,nil,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
end
function c44447005.rmop2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local n=Duel.GetFlagEffect(tp,44447005)
	Duel.ResetFlagEffect(tp,44447005)
    local ct=n
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(1-tp,c44447005.rmfilter,ct,ct,nil,1-tp)
		Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
	end
end