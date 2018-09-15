--崇光之宣告者
function c98710007.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98710007,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98710007.negcon)
	e2:SetCost(c98710007.cost)
	e2:SetTarget(c98710007.negtg)
	e2:SetOperation(c98710007.negop)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98710007,1))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCondition(c98710007.discon)
	e3:SetCost(c98710007.cost)
	e3:SetTarget(c98710007.distg)
	e3:SetOperation(c98710007.disop)
	c:RegisterEffect(e3)
end
c98710007.herald=1
function c98710007.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c98710007.costfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToGraveAsCost()
end
function c98710007.dcostfilter(c)
	return c:GetCode()==98710001 and c:IsAbleToGraveAsCost()
end
function c98710007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetFirstMatchingCard(c98710007.dcostfilter,tp,LOCATION_DECK,0,nil)
	local flag=Duel.GetFlagEffect(tp,98710001)
	if chk==0 then return Duel.IsExistingMatchingCard(c98710007.costfilter,tp,LOCATION_HAND,0,1,nil) or (dg and flag==0) end
	local g=Group.CreateGroup()
	if dg and flag==0 and Duel.SelectYesNo(tp,aux.Stringid(98710001,5)) then
		g=Group.FromCards(dg)
		Duel.RegisterFlagEffect(tp,98710001,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=Duel.SelectMatchingCard(tp,c98710007.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	end
	Duel.SendtoGrave(g,REASON_COST)
end
function c98710007.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98710007.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c98710007.filter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c98710007.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(c98710007.filter,1,nil,1-tp)
end
function c98710007.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c98710007.filter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98710007.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c98710007.filter,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end
