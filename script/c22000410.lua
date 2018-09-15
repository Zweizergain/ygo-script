--从者Saber 吉尔·雷·德
function c22000410.initial_effect(c)
	--ritual level
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_RITUAL_LEVEL)
	e0:SetValue(c22000410.rlevel)
	c:RegisterEffect(e0)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22000410,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,22000410)
	e1:SetTarget(c22000410.tg)
	e1:SetOperation(c22000410.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCountLimit(1,22000410)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22000410,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,22000410)
	e3:SetCondition(c22000410.thcon)
	e3:SetTarget(c22000410.thtg)
	e3:SetOperation(c22000410.thop)
	c:RegisterEffect(e3)
end
function c22000410.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0xfff) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c22000410.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c22000410.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22000410.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c22000410.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22000410.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22000410.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c22000410.filter2(c)
	return c:IsSetCard(0xfff) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c22000410.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22000410.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22000410.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22000410.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
