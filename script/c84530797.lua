--幻灭神话 妖精之森
function c84530797.initial_effect(c)
	c:EnableCounterPermit(0x831)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,84530797+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c84530797.target)
	e1:SetOperation(c84530797.activate)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetOperation(c84530797.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x8351))
	e4:SetValue(c84530797.atkval)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c84530797.thcost)
	e5:SetTarget(c84530797.thtg)
	e5:SetOperation(c84530797.thop)
	c:RegisterEffect(e5)
end
function c84530797.atkval(e,c)
	return e:GetHandler():GetCounter(0x831)*125
end
function c84530797.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0x831,3,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x831)
end
function c84530797.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x831,3)
	end
end
function c84530797.ctfilter(c)
	return c:IsFaceup() and (c:GetLevel()==1 or c:GetRank()==1 or c:GetLink()==1) and c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x8351)
end
function c84530797.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c84530797.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0x831,1)
	end
end
function c84530797.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x831,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x831,3,REASON_COST)
end
function c84530797.thfilter(c)
	return c:IsAttack(500) and c:IsDefense(0) and c:IsSetCard(0x8351) and c:IsAbleToHand()
end
function c84530797.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84530797.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c84530797.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c84530797.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
