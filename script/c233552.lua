--远野之空
function c233552.initial_effect(c)
    --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c233552.target)
	e1:SetOperation(c233552.activate)
	c:RegisterEffect(e1)
end	
function c233552.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0x4,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,0xc,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,0xc,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c233552.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(Card.IsDestructable,tp,0,0xc,nil)
	local rg=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,0x4,0,1,ct1,e:GetHandler())
	Duel.Release(rg,REASON_EFFECT)
	Duel.BreakEffect()
	local ct2=rg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,0xc,ct2,ct2,nil)
	Duel.HintSelection(dg)
	Duel.Destroy(dg,REASON_EFFECT)
end