--月灵 月下胜地
function c19002032.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c19002032.accon)
	e2:SetOperation(c19002032.acop)
	c:RegisterEffect(e2)   
	--BBBBBBBB
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19002032,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c19002032.thcost)
	e3:SetTarget(c19002032.thtg)
	e3:SetOperation(c19002032.thop)
	c:RegisterEffect(e3)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(c19002032.desreptg)
	e5:SetOperation(c19002032.desrepop)
	c:RegisterEffect(e5) 
end
function c19002032.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0x1)>0 end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c19002032.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x1,1,REASON_EFFECT)
end
function c19002032.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1,3,REASON_COST)
end
function c19002032.filter(c)
	return c:IsSetCard(0xc750) and c:IsAbleToHand()
end
function c19002032.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c19002032.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19002032.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c19002032.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c19002032.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c19002032.cfilter(c)
	return bit.band(c:GetPreviousPosition(),POS_FACEDOWN)~=0 and bit.band(c:GetPosition(),POS_FACEUP)~=0
end
function c19002032.accon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19002032.cfilter,1,e:GetHandler())
end
function c19002032.acop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1,1)
end