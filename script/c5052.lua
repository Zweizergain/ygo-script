--另一个世界！
function c5052.initial_effect(c)
	 --remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c5052.condition)
	e1:SetCountLimit(1,5052)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c5052.target)
	e1:SetOperation(c5052.operation)
	c:RegisterEffect(e1)
end
function c5052.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x900)
end
function c5052.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c5052.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c5052.filter(c)
	return c:IsAbleToRemove()
end
function c5052.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c5052.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c5052.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c5052.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c5052.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	if tc:IsControler(1-tp) then seq=seq+16 end
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE_FIELD)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
		e2:SetLabel(seq)
		e2:SetLabelObject(tc)
		e2:SetCondition(c5052.discon)
		e2:SetOperation(c5052.disop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c5052.discon(e,c)
	if e:GetLabelObject():IsLocation(LOCATION_REMOVED) then return true end
	return false
end
function c5052.disop(e,tp)
	local dis1=bit.lshift(0x1,e:GetLabel())
	return dis1
end
