--召唤之索尔德
--DoItYourself By if
function c33000101.initial_effect(c)
    --special summon1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33000101,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,33000101)
	e1:SetTarget(c33000101.tg)
	e1:SetOperation(c33000101.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33000101,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,35000001)
	e3:SetCost(c33000101.cost)
	e3:SetCondition(c33000101.spcon)
	e3:SetTarget(c33000101.target)
	e3:SetOperation(c33000101.operation)
	c:RegisterEffect(e3)
end
function c33000101.filter(c,e,tp)
	return  c:IsType(TYPE_MONSTER)and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33000101.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33000101.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GetMatchingGroup(c33000101.filter,tp,0,LOCATION_HAND,nil,e,tp)
	if g:GetCount()>0 then
	    local sc=g:RandomSelect(tp,1)
		Duel.HintSelection(sc)
		local tc=sc:GetFirst()
	    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		    local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(33000101,2))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(1,0)
			e1:SetTarget(c33000101.splimit)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(33000101,RESET_EVENT+0x1fe0000,0,1)
			Duel.SpecialSummonComplete()
		end
	end
end
function c33000101.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x402) and c:IsLocation(LOCATION_EXTRA)
end
function c33000101.mfilter(c)
	 return c:GetSummonLocation()==LOCATION_EXTRA 
end
function c33000101.spcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e)and not Duel.IsExistingMatchingCard(c33000101.mfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c33000101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDisCardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDisCardable,1,1,REASON_COST+REASON_DISCARD)
end
function c33000101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		                  and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33000101.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
		c:RegisterFlagEffect(0,RESET_EVENT+0xfe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33000101,3))
	end
end