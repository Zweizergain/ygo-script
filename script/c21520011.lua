--乱数招来
function c21520011.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520011,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21520011+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c21520011.cost)
	e1:SetTarget(c21520011.target)
	e1:SetOperation(c21520011.activate)
	c:RegisterEffect(e1)
end
function c21520011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,3,nil,TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER):RandomSelect(tp,3)
	Duel.ConfirmCards(1-tp,g)
end
function c21520011.spfilter(c,e,tp)
	if c:IsSetCard(0x493) then 
		return c:IsCanBeSpecialSummoned(e,0,tp,false,true)
	else
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
end
function c21520011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c21520011.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21520011.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21520011.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or g:GetCount()==0 then return end
	local tg=g:RandomSelect(tp,1)
	local tc=tg:GetFirst()
	--not randomly
	if not tc:IsSetCard(0x493) and not Duel.IsExistingMatchingCard(c21520011.chkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		local sum=tc:GetOriginalLevel()
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		Duel.BreakEffect()
		Duel.Damage(tp,sum*500,REASON_RULE)
	end
	Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)
	tc:RegisterFlagEffect(21520011,RESET_EVENT+0x1fe0000,0,1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetDescription(aux.Stringid(21520011,1))
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetLabelObject(tc)
	e2:SetCondition(c21520011.tdcon)
	e2:SetOperation(c21520011.tdop)
	Duel.RegisterEffect(e2,tp)
end
function c21520011.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x493) and c:IsType(TYPE_FIELD)
end
function c21520011.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(21520011)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c21520011.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
