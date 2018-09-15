--梦幻的领导力
function c23000110.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,23000110+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c23000110.target)
	e1:SetOperation(c23000110.activate)
	c:RegisterEffect(e1)
end
function c23000110.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xfff)
end
function c23000110.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23000110.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c23000110.filter2(c,e)
	return c:IsFaceup() and c:IsSetCard(0xfff) and not c:IsImmuneToEffect(e)
end
function c23000110.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c23000110.filter2,tp,LOCATION_MZONE,0,nil,e)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(23000110,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		tc=sg:GetNext()
	end
	sg:KeepAlive()
end