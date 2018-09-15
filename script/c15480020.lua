--颜艺的神返
function c15480020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c15480020.condition)
	e1:SetTarget(c15480020.target)
	e1:SetOperation(c15480020.activate)
	c:RegisterEffect(e1)
end
function c15480020.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff)
end
function c15480020.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c15480020.cfilter,tp,LOCATION_MZONE,0,3,nil) 
		and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>=10
		   and Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>=10
end
function c15480020.filter(c)
	return c:IsFaceup()
end
function c15480020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c15480020.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c15480020.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(15480020,0))
	local g=Duel.SelectTarget(tp,c15480020.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c15480020.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,tp,2,REASON_EFFECT+REASON_RETURN)
	end
end
