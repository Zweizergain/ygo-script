--星曜之怒
function c21520149.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
--	e1:SetCountLimit(1,21520149)
	e1:SetCondition(c21520149.condition)
	e1:SetTarget(c21520149.target1)
	e1:SetOperation(c21520149.operation)
	c:RegisterEffect(e1)
	--disable effect
----[[
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520149,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
--	e2:SetCountLimit(1,21520149+EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c21520149.condition)
	e2:SetTarget(c21520149.target2)
	e2:SetOperation(c21520149.operation)
	c:RegisterEffect(e2)
--]]
end
function c21520149.cfilter(c)
	return c:IsFaceup() and c:IsCode(21520133)
end
function c21520149.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21520149.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c21520149.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c21520149.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c21520149.filter(chkc) end
	if chk==0 then
		return Duel.IsExistingTarget(c21520149.filter,tp,0,LOCATION_MZONE,1,nil)
	end
	if (Duel.GetFlagEffect(tp,21520149)==0
		and Duel.IsExistingTarget(c21520149.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(21520149,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c21520149.filter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.RegisterFlagEffect(tp,21520149,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else
		e:SetProperty(0)
	end
end
function c21520149.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c21520149.filter(chkc) end
	if chk==0 then return Duel.GetFlagEffect(tp,21520149)==0
		and Duel.IsExistingTarget(c21520149.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c21520149.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.RegisterFlagEffect(tp,21520149,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c21520149.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c21520149.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21520149.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c21520149.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c21520149.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c21520149.rcon)
		tc:RegisterEffect(e1,true)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c21520149.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
