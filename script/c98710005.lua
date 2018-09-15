--神光之宣告者
function c98710005.initial_effect(c)
	c:EnableReviveLimit()
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98710005,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c98710005.discon)
	e1:SetCost(c98710005.discost)
	e1:SetTarget(c98710005.distg)
	e1:SetOperation(c98710005.disop)
	c:RegisterEffect(e1)
end
c98710005.herald=1
function c98710005.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c98710005.costfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToGraveAsCost()
end
function c98710005.dcostfilter(c)
	return c:GetCode()==98710001 and c:IsAbleToGraveAsCost()
end
function c98710005.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetFirstMatchingCard(c98710005.dcostfilter,tp,LOCATION_DECK,0,nil)
	local flag=Duel.GetFlagEffect(tp,98710001)
	if chk==0 then return Duel.IsExistingMatchingCard(c98710005.costfilter,tp,LOCATION_HAND,0,1,nil) or (dg and flag==0) end
	local g=Group.CreateGroup()
	if dg and flag==0 and Duel.SelectYesNo(tp,aux.Stringid(98710001,5)) then
		g=Group.FromCards(dg)
		Duel.RegisterFlagEffect(tp,98710001,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=Duel.SelectMatchingCard(tp,c98710005.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	end
	Duel.SendtoGrave(g,REASON_COST)
end
function c98710005.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98710005.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
