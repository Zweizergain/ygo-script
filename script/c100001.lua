--明日之盛✿昨日之俗
function c100001.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(1231610,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,100001+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c100001.retcost)
	e2:SetTarget(c100001.sumtg)
	e2:SetOperation(c100001.sumop)
	c:RegisterEffect(e2)		
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100001,1))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100001.sumcon)
	e3:SetCost(c100001.descost)
	e3:SetTarget(c100001.target)
	e3:SetOperation(c100001.operation)
	c:RegisterEffect(e3)
end

function c100001.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return  aux.exccon(e)
end
function c100001.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0xccc,1)
end
function c100001.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g and g:GetCount()>0 then 
		local tc=g:GetFirst()
		if tc:IsFaceup() then
			tc:AddCounter(0xccc,2)
		end
	end 
end

function c100001.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTarget(c100001.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c100001.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:GetFlagEffect(100001)>0)
end
function c100001.sumfilter(c)
	local a=c:GetTributeRequirement()
	if a==0 then a=1 end 
	if c:IsCode(100600) then a=3 end 
	return c:IsAttribute(ATTRIBUTE_WIND) and c:GetAttack()==2*c:GetDefense() and c:IsSummonable(true,nil,1) and Duel.CheckTribute(c,a)
end
function c100001.spfilter(c)
	return c:IsSummonable(false,nil,1)
end
function c100001.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100001.sumfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c100001.sumop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100001.sumfilter,tp,LOCATION_DECK,0,nil)
	if g and g:GetCount()>0 then 
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(100001,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc2=g:FilterSelect(tp,c100001.spfilter,1,1,nil)
		if tc2 then
			tc2=tc2:GetFirst()
			Duel.Summon(tp,tc2,false,nil,1) 
		end
		tc=g:GetFirst()
		while tc do
			tc:ResetFlagEffect(100001)
			tc=g:GetNext()	
		end 
	end 
end
function c100001.efilter(e,te)
	return te:IsActiveType(e:GetLabel()) 
end