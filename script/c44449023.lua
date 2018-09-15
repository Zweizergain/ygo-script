--百夜·神思追忆
function c44449023.initial_effect(c)
    --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c44449023.cost)
	e1:SetTarget(c44449023.target)
	e1:SetOperation(c44449023.activate)
	c:RegisterEffect(e1)
end	
function c44449023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_ATTACK)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c44449023.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c44449023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44449023.cfilter,tp,0xc,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c44449023.cfilter,tp,0,0xc,1,nil) end
	local g=Duel.GetMatchingGroup(c44449023.cfilter,tp,0,0xc,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if g:GetCount()>=3 then
	   Duel.SetChainLimit(c44449023.chainlimit)
	end
end
function c44449023.chainlimit(e,rp,tp)
	return not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c44449023.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(c44449023.cfilter,tp,0,0xc,nil)
	local rg=Duel.SelectMatchingCard(tp,c44449023.cfilter,tp,0xc,0,1,ct1,e:GetHandler())
	Duel.SendtoHand(rg,nil,REASON_EFFECT)
	Duel.BreakEffect()
	local ct2=rg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,c44449023.cfilter,tp,0,0xc,ct2,ct2,nil)
	Duel.HintSelection(dg)
	Duel.SendtoHand(dg,nil,REASON_EFFECT)
end