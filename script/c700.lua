--金辉の宝札
function c700.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,700+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c700.cost)
	e1:SetTarget(c700.target)
	e1:SetOperation(c700.activate)
	c:RegisterEffect(e1)
	--redirect
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e12:SetCondition(c700.recon)
	e12:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e12)
end
function c700.filter(c)
	return c:IsType(TYPE_QUICKPLAY) and c:IsAbleToRemoveAsCost()
end
function c700.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c700.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c700.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c700.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) 
	and Duel.GetTurnPlayer()~=tp end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c700.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c700.recon(e)
  	return e:GetHandler():IsFaceup()
end