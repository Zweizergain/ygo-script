--原初八文-兑
function c21520207.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c21520207.cfilter,1,1)
	--DESTROY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520207,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c21520207.rdtg)
	e1:SetOperation(c21520207.rdop)
	c:RegisterEffect(e1)
	--RECOVER
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520207,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c21520207.drtg)
	e2:SetOperation(c21520207.drop)
	c:RegisterEffect(e2)
end
function c21520207.cfilter(c)
	local g=Duel.GetMatchingGroup(c21520207.ckfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
		return (c:IsLinkAttribute(ATTRIBUTE_DARK) and c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000) or (c:IsSetCard(0x492) and not c:IsCode(21520207))
	else
		return c:IsLinkAttribute(ATTRIBUTE_DARK) and c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000
	end
end
function c21520207.ckfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x492) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:GetOriginalType()&TYPE_SPELL==TYPE_SPELL or c:GetOriginalType()&TYPE_TRAP==TYPE_TRAP)
end
function c21520207.rdfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c21520207.rdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,LOCATION_ONFIELD)
end
function c21520207.rdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then 
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		if tc:IsType(TYPE_MONSTER) and tc:IsAttribute(ATTRIBUTE_DARK) then
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end
function c21520207.pfliter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and not c:IsPublic()
end
function c21520207.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_REMOVED)
end
function c21520207.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c21520207.pfliter,tp,LOCATION_HAND,0,nil)
		if g:GetCount()>0 and Duel.IsPlayerCanDraw(tp) and Duel.SelectYesNo(tp,aux.Stringid(21520207,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local pg=g:Select(tp,1,1,nil)
			Duel.ConfirmCards(1-tp,pg)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
	end
end
