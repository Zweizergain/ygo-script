--御主 间桐雁夜
function c21000050.initial_effect(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21000050,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,21000050)
	e1:SetCondition(c21000050.condition)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c21000050.target)
	e1:SetOperation(c21000050.operation)
	c:RegisterEffect(e1)
end
function c21000050.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfff)
end
function c21000050.condition(e)
	return Duel.GetMatchingGroupCount(c21000050.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)>=1
end
function c21000050.filter(c)
	return c:IsFaceup()
end
function c21000050.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c21000050.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21000050.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c21000050.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c21000050.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_BASE_ATTACK)
		e3:SetValue(tc:GetBaseAttack()/2)
		tc:RegisterEffect(e3)
	end
end