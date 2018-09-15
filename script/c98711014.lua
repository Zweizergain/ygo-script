--吸血鬼移地
function c98711014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c98711014.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98711014,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,98711014)
	e2:SetCondition(c98711014.tgcon)
	e2:SetTarget(c98711014.tgtg)
	e2:SetOperation(c98711014.tgop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98711014,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98711034)
	e3:SetCondition(c98711014.thcon)
	e3:SetTarget(c98711014.thtg)
	e3:SetOperation(c98711014.thop)
	c:RegisterEffect(e3)
end
function c98711014.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:GetPreviousControler()==tp
end
function c98711014.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98711014.cfilter,1,nil,1-tp)
end
function c98711014.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function c98711014.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<3 then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK):RandomSelect(tp,3)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c98711014.filter(c,tp)
	return c:IsCode(98711013) and c:GetActivateEffect():IsActivatable(tp)
end
function c98711014.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c98711014.filter,tp,LOCATION_DECK,0,nil,tp)
	if tc and Duel.SelectYesNo(tp,aux.Stringid(98711014,0)) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c98711014.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c98711014.thfilter(c)
	return c:IsSetCard(0x8e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98711014.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98711014.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98711014.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c98711014.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98711014.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
