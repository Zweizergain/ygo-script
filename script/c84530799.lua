--幻灭神话 妖精·樱
function c84530799.initial_effect(c)
	c:SetSPSummonOnce(84530799)
	--link summon
	aux.AddLinkProcedure(c,c84530799.matfilter,1)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84530799,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,84530799)
	e1:SetCondition(c84530799.thcon)
	e1:SetCost(c84530799.thcost)
	e1:SetTarget(c84530799.thtg)
	e1:SetOperation(c84530799.thop)
	c:RegisterEffect(e1)
		--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84530799,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,845307990)
	e2:SetTarget(c84530799.atktg)
	e2:SetOperation(c84530799.atkop)
	c:RegisterEffect(e2)
end
function c84530799.matfilter(c)
	return (c:GetLevel()==1 or c:GetRank()==1 or c:GetLink()==1) and c:IsSetCard(0x8351)
end
function c84530799.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c84530799.costfilter(c)
	return c:GetLevel()==1 and c:IsSetCard(0x8351) and c:IsDiscardable()
end
function c84530799.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84530799.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c84530799.costfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c84530799.thfilter(c)
	return c:IsSetCard(0x8352) and c:IsAbleToHand()
end
function c84530799.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84530799.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c84530799.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c84530799.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c84530799.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c84530799.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c84530799.matfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c84530799.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c84530799.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_SELF_TURN+PHASE_END)
		e1:SetValue(c84530799.efilter)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_SELF_TURN+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c84530799.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end