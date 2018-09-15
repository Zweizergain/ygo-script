--|双子恶灵|
function c4100428.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4100428,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c4100428.cost)
	e1:SetTarget(c4100428.thtg)
	e1:SetOperation(c4100428.thop)
	c:RegisterEffect(e1)
	--cannot remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)
	--30459350 chk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(4100428)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	c:RegisterEffect(e4)
end
function c4100428.cfcost(c)
	return c:IsAbleToRemoveAsCost()
end
function c4100428.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=e:GetHandler():IsReleasable()
	local b2=Duel.IsExistingMatchingCard(c4100428.cfcost,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	if b2 and not b1 then
		local tg=Duel.GetFirstMatchingCard(c4100428.cfcost,tp,LOCATION_GRAVE,0,nil)
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	else
		Duel.Release(e:GetHandler(),REASON_COST)
	end
end
function c4100428.thfilter(c)
	return c:IsCode(4100413) or (c:IsSetCard(0x46) and c:IsType(TYPE_SPELL)) and c:IsAbleToHand()
end
function c4100428.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4100428.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:GetHandler():RegisterFlagEffect(4100428,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c4100428.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c4100428.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

