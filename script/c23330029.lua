--残霞幻灵 沫
function c23330029.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x555),4,3)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23330029,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,23330029)
	e1:SetTarget(c23330029.thtg)
	e1:SetOperation(c23330029.thop)
	c:RegisterEffect(e1)
	--change atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101001039,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCountLimit(1,23330129)
	e2:SetCondition(c23330029.atkcon)
	e2:SetCost(c23330029.atkcost)
	e2:SetTarget(c23330029.atktg)
	e2:SetOperation(c23330029.atkop)
	c:RegisterEffect(e2)
end
function c23330029.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c23330029.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL) and bc:IsRelateToBattle()
end
function c23330029.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() or not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	local ct=0
	if Duel.IsPlayerCanDiscardDeck(tp,3) then
	   ct=Duel.AnnounceNumber(tp,1,2,3)
	elseif Duel.IsPlayerCanDiscardDeck(tp,2) then
	   ct=Duel.AnnounceNumber(tp,1,2)  
	else   
	   ct=1
	end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if Duel.DiscardDeck(tp,ct,REASON_EFFECT)~=0 and g:GetCount()>0 then
	   local max,atk=g:GetMaxGroup(Card.GetAttack)
	   if atk>c:GetAttack() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	   end
	end
end
function c23330029.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23330029.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),e:GetHandler()) and Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c23330029.afilter(c,rc)
	return c:IsFaceup() and c:GetAttack()>rc:GetAttack()
end
function c23330029.thfilter(c)
	return c:IsCode(23330011) and c:IsAbleToHand()
end
function c23330029.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23330029.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c23330029.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c23330029.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end