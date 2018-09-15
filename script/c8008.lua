--守护意愿 沙耶
function c8008.initial_effect(c)
	 --end battle phase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c8008.condition)
	e1:SetCost(c8008.cost)
	e1:SetOperation(c8008.operation)
	c:RegisterEffect(e1)
	--end battle phase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8008,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c8008.condition1)
	e2:SetCost(c8008.cost1)
	e2:SetOperation(c8008.operation1)
	c:RegisterEffect(e2)
end
function c8008.wfilter(c)
	return not c:IsSetCard(0x901) and c:IsType(TYPE_MONSTER)
end
function c8008.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and not Duel.IsExistingMatchingCard(c8008.wfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c8008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c8008.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
function c8008.condition1(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c8008.cffilter(c)
	return c:IsSetCard(0x901) and not c:IsPublic()
end
function c8008.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.IsExistingMatchingCard(c8008.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c8008.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c8008.cfilter(c)
	return c:IsSetCard(0x901) and not c:IsPublic()
end
function c8008.operation1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

