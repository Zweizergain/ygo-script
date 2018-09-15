--影依回转
function c98706004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98706004+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c98706004.activate)
	c:RegisterEffect(e1)
end
function c98706004.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,98706004,RESET_PHASE+PHASE_END,0,1)
end
