--恶魔的出征
function c35310015.initial_effect(c)
	c:EnableCounterPermit(0x16)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--effectgain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c35310015.eftg)
	e2:SetOperation(c35310015.efop)
	c:RegisterEffect(e2)	
	--Add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c35310015.acop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c35310015.destg)
	e4:SetValue(c35310015.value)
	e4:SetOperation(c35310015.desop)
	c:RegisterEffect(e4)
end
c35310015.setname="acfiend"
function c35310015.dfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and c:IsSetCard(0x3656) and c:IsControler(tp)
end
function c35310015.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c35310015.dfilter,nil,tp)
		return count>0 and Duel.IsCanRemoveCounter(tp,1,0,0x16,2,REASON_COST)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c35310015.value(e,c)
	return c35310015.dfilter(c,e:GetHandlerPlayer())
end
function c35310015.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,1,0,0x16,2,REASON_COST)
end
function c35310015.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousSetCard(0x3656)
end
function c35310015.acop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c35310015.cfilter,1,nil,tp) then
		e:GetHandler():AddCounter(0x16,1)
	end
end
function c35310015.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3656) and c:IsType(TYPE_NORMAL)
end
function c35310015.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c35310015.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c35310015.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c35310015.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c35310015.efop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
	   tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0)	 
	end
end
