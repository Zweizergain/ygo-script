--乱数乱流
function c21520014.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520014,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
--	e1:SetCountLimit(1,21520014+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c21520014.condition1)
	e1:SetTarget(c21520014.target1)
	e1:SetOperation(c21520014.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--Activate(effect)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21520014,0))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
--	e4:SetCountLimit(1,21520014+EFFECT_COUNT_CODE_OATH)
	e4:SetCondition(c21520014.condition2)
	e4:SetTarget(c21520014.target2)
	e4:SetOperation(c21520014.activate2)
	c:RegisterEffect(e4)
end
function c21520014.filter(c)
	return c:IsSetCard(0x493) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c21520014.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c21520014.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c21520014.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(c21520014.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local rg=g:RandomSelect(tp,1)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	else
		math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+4000)
		local lp=math.random(1,math.ceil(Duel.GetLP(tp)/2))
		Duel.SetLP(tp,lp)
	end
end
function c21520014.condition2(e,tp,eg,ep,ev,re,r,rp)
	return not re:GetHandler():IsType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c21520014.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c21520014.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(c21520014.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local rg=g:RandomSelect(tp,1)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	else
		math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+4000)
		local lp=math.random(1,math.ceil(Duel.GetLP(tp)/2))
		Duel.SetLP(tp,lp)
	end
end
