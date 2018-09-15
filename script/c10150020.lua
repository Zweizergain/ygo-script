--守护之誓
function c10150020.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c10150020.spcon)
	e1:SetTarget(c10150020.sptg)
	e1:SetOperation(c10150020.spop)
	c:RegisterEffect(e1)	
end

function c10150020.cfilter(c,tp)
	return c:IsControler(tp) and c:GetPreviousControler()==tp
		and c:IsReason(REASON_DESTROY) and c:IsCode(18175965)
end

function c10150020.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10150020.cfilter,1,nil,tp)
end

function c10150020.filter(c,e,tp)
	return c:IsCode(34022290) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10150020.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10150020.filter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end

function c10150020.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10150020.filter,tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c10150020.efilter)
		e1:SetOwnerPlayer(tp)
		g:GetFirst():RegisterEffect(e1)	
	end
end

function c10150020.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
