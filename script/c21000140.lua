--我已经没有钱拯救人理了
function c21000140.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21000140+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21000140.target)
	e1:SetOperation(c21000140.activate)
	c:RegisterEffect(e1)
end
function c21000140.ddfilter(c)
	return c:IsFaceup() and c:IsCode(21000100)
end
function c21000140.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c21000140.ddfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3)
		and Duel.IsExistingTarget(c21000140.ddfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c21000140.ddfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c21000140.activate(e,tp,eg,ep,ev,re,r,rp)
	local g,p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.GetControl(g,1-tp)>0 then
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
