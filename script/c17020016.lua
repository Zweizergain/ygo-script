--樱火装机核心 利维坦
function c17020016.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x702),2,2)	
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17020016,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,17020016)
	e1:SetCondition(c17020016.thcon)
	e1:SetTarget(c17020016.thtg)
	e1:SetOperation(c17020016.thop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17020016,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,17020116)
	e2:SetCondition(c17020016.thcon2)
	e2:SetTarget(c17020016.thtg2)
	e2:SetOperation(c17020016.thop2)
	c:RegisterEffect(e2)
	--LINK monster
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetValue(TYPE_LINK)
	c:RegisterEffect(e3)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c17020016.efilter)
	c:RegisterEffect(e4)
end
function c17020016.efilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsReason(REASON_DESTROY)
end
function c17020016.thfilter2(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c17020016.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c17020016.thfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17020016.thfilter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c17020016.thfilter2,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c17020016.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c17020016.drcfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_PZONE+LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsType(TYPE_PENDULUM)
end
function c17020016.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c17020016.drcfilter,1,nil,tp)
end
function c17020016.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c17020016.thfilter(c,tp)
	return c:IsSetCard(0x702) and c:IsType(TYPE_PENDULUM) and ((Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) or c:IsLocation(LOCATION_PZONE)) and c:IsAbleToHand()
end
function c17020016.pcfilter(c)
	return c:IsSetCard(0x702) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17020016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17020016.thfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,nil,tp) and Duel.IsExistingMatchingCard(c17020016.pcfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_PZONE+LOCATION_MZONE)
end
function c17020016.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c17020016.thfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,nil,tp)
	if g:GetCount()<=0 or Duel.SendtoHand(g,nil,REASON_EFFECT)<=0 or (not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=Duel.SelectMatchingCard(tp,c17020016.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
	   Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end



