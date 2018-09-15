--咸鱼一击
function c19000018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(c19000018.cost)
	e1:SetTarget(c19000018.target)
	e1:SetOperation(c19000018.activate)
	c:RegisterEffect(e1)	
end
function c19000018.costfilter(c)
	return c:IsSetCard(0x1750) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c19000018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19000018.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c19000018.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c19000018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>1 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
end
function c19000018.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>1 then
	   Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
	   local sg=g:Select(1-p,2,2,nil)
	   Duel.SendtoGrave(sg,REASON_EFFECT)
	   Duel.ShuffleHand(1-p)
	end
end--
