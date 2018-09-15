--雾动机龙 强力突进
function c98727009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98727009)
	e1:SetTarget(c98727009.target)
	e1:SetOperation(c98727009.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98727109)
	e2:SetTarget(c98727009.reptg)
	e2:SetValue(1)
	e2:SetOperation(c98727009.repop)
	c:RegisterEffect(e2)
end
function c98727009.spfilter(c,e,tp)
	return c:IsSetCard(0xd8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98727009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98727009.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98727009.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98727009.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabelObject(tc)
		e1:SetCondition(c98727009.descon)
		e1:SetOperation(c98727009.desop)
		Duel.RegisterEffect(e1,tp)
		tc:RegisterFlagEffect(98727009,RESET_EVENT+0x1fe0000,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c98727009.efilter)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function c98727009.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(98727009)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c98727009.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c98727009.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c98727009.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return eg:GetCount()==1 and e:GetHandler():IsAbleToRemove() and tc:IsFaceup() and tc:IsSetCard(0xd8)
		and tc:IsLocation(LOCATION_ONFIELD) and tc:IsControler(tp) and tc:IsAbleToHand() and aux.exccon(e) end
	e:SetLabelObject(tc)
	return Duel.SelectYesNo(tp,aux.Stringid(98727009,0))
end
function c98727009.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	if not tc:IsSetCard(0xd8) then return end
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
end
