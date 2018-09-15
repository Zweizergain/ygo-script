--巨舰护罩充能
function c13257207.initial_effect(c)
	c:SetUniqueOnField(1,0,13257207)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13257207,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c13257207.ctcon)
	e2:SetOperation(c13257207.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
end
function c13257207.ctfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x353) and c:IsControler(tp)
end
function c13257207.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13257207.ctfilter,1,nil,tp)
end
function c13257207.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c13257207.ctfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		if not tc:IsCanAddCounter(0x353,1) then
			tc:EnableCounterPermit(0x353)
		end
		tc:AddCounter(0x353,2)
		--Destroy replace
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTarget(c13257207.desreptg)
		e1:SetOperation(c13257207.desrepop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c13257207.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE)
		and e:GetHandler():GetCounter(0x353)>0 end
	return true
end
function c13257207.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RemoveCounter(ep,0x353,1,REASON_EFFECT)
	Duel.RaiseEvent(c,EVENT_REMOVE_COUNTER+0x353,e,REASON_EFFECT+REASON_REPLACE,tp,tp,1)
end
