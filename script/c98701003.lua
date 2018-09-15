--DIY灵魂3
function c98701003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk&def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPIRIT))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98701003,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c98701003.drtg)
	e4:SetOperation(c98701003.drop)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98701003,1))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_HAND)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,98701003)
	e5:SetCondition(c98701003.condition)
	e5:SetTarget(c98701003.target)
	e5:SetOperation(c98701003.operation)
	c:RegisterEffect(e5)
end
function c98701003.drfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToDeck()
end
function c98701003.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c98701003.drfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c98701003.sfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
function c98701003.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c98701003.drfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,63,nil)
	if g:GetCount()<1 then return end
	local cg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	Duel.ConfirmCards(1-tp,cg)
	local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	if Duel.Draw(tp,ct,REASON_EFFECT) and Duel.IsExistingMatchingCard(c98701003.sfilter,tp,LOCATION_HAND,0,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(98701003,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local g=Duel.SelectMatchingCard(tp,c98701003.sfilter,tp,LOCATION_HAND,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				local s1=tc:IsSummonable(true,nil)
				local s2=tc:IsMSetable(true,nil)
				if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK)
					or not s2 then
					Duel.Summon(tp,tc,true,nil)
				else
					Duel.MSet(tp,tc,true,nil)
				end
			end
		end
	end
end
function c98701003.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
		and c:IsControler(tp) and c:IsType(TYPE_SPIRIT)
end
function c98701003.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98701003.filter,1,nil,tp)
end
function c98701003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c98701003.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
