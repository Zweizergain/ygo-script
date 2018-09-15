--s
function c12234405.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12234405.target)
	e1:SetOperation(c12234405.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c12234405.reptg)
	e2:SetValue(c12234405.repval)
	e2:SetOperation(c12234405.repop)
	c:RegisterEffect(e2)
end
function c12234405.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsCode(12234404)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c12234405.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c12234405.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c12234405.repval(e,c)
	return c12234405.repfilter(c,e:GetHandlerPlayer())
end
function c12234405.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c12234405.atkfilter(c)
	return c:IsFaceup() and c:IsCode(12234404) and c:GetFlagEffect(12234405)==0
end
function c12234405.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c12234405.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12234405.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c12234405.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c12234405.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:GetFlagEffect(12234405)==0 then
			tc:RegisterFlagEffect(12234405,RESET_EVENT+0x1fe0000,0,0)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end