--暗灵术-「欲」
function c98703012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c98703012.cost)
	e1:SetTarget(c98703012.target)
	e1:SetOperation(c98703012.activate)
	c:RegisterEffect(e1)
end
function c98703012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,nil,ATTRIBUTE_DARK) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_DARK)
	Duel.Release(g,REASON_COST)
end
function c98703012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c98703012.cfilter(c)
	return not c:IsPublic() and c:IsType(TYPE_SPELL)
end
function c98703012.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(c98703012.cfilter,p,0,LOCATION_HAND,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(1-p,aux.Stringid(98703012,0)) then
		Duel.Hint(HINT_SELECTMSG,1-p,HINTMSG_CONFIRM)
		local sg=g:Select(1-p,1,1,nil)
		Duel.ConfirmCards(p,sg)
		Duel.ShuffleHand(1-p)
		if Duel.IsChainDisablable(0) then
			Duel.NegateEffect(0)
			return
		end
	end
	Duel.Draw(p,d,REASON_EFFECT)
end
