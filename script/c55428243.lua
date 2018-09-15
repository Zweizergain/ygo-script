--ボーラの蟲惑魔
function c55428243.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c55428243.efilter)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c55428243.condition)
	e2:SetTarget(c55428243.sptg)
	e2:SetOperation(c55428243.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c55428243.condition2)
	c:RegisterEffect(e3)
	--effect stop
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(55428243,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)	
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,55428243)
    e4:SetTarget(c55428243.target)
	e4:SetOperation(c55428243.drop)
	c:RegisterEffect(e4)
end
function c55428243.efilter(e,te)
	local c=te:GetHandler()
	return c:GetType()==TYPE_TRAP and (c:IsSetCard(0x4c) or c:IsSetCard(0x89))
end
function c55428243.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c55428243.cfilter(c,tp)
	return c:GetSummonPlayer()==1-tp
end
function c55428243.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c55428243.cfilter,1,nil,tp)
end
function c55428243.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c55428243.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)>0 then
		c:CompleteProcedure()
	end
end
function c55428243.filter2(c,e,tp)
	return c:IsReason(REASON_EFFECT) and c:IsType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==1-tp
		and c:IsLocation(LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED) and c:IsCanBeEffectTarget(e)
end
function c55428243.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c55428243.filter2(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c55428243.filter2,1,nil,e,tp) and re:IsActiveType(TYPE_TRAP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local 	g=eg:FilterSelect(tp,c55428243.filter2,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end
function c55428243.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c55428243.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(tc:GetCode())
	Duel.RegisterEffect(e1,tp)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c55428243.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsCode(e:GetLabel())
end
