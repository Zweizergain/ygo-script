--原初八文-巽
function c21520208.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c21520208.cfilter,1,1)
	--TODECK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520208,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c21520208.tdttg)
	e1:SetOperation(c21520208.tdtop)
	c:RegisterEffect(e1)
	--TOHAND
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520208,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c21520208.drcost)
	e2:SetTarget(c21520208.drtg)
	e2:SetOperation(c21520208.drop)
	c:RegisterEffect(e2)
end
function c21520208.cfilter(c)
	local g=Duel.GetMatchingGroup(c21520208.ckfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
		return (c:IsLinkAttribute(ATTRIBUTE_WIND) and c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000) or (c:IsSetCard(0x492) and not c:IsCode(21520208))
	else
		return c:IsLinkAttribute(ATTRIBUTE_WIND) and c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000
	end
end
function c21520208.ckfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x492) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:GetOriginalType()&TYPE_SPELL==TYPE_SPELL or c:GetOriginalType()&TYPE_TRAP==TYPE_TRAP)
end
function c21520208.tdttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c21520208.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21520208.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c21520208.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local hg=Duel.GetMatchingGroup(c21520208.pfliter,tp,LOCATION_HAND,0,nil)
	local nc=false
	if hg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(21520208,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local pg=hg:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,pg)
		nc=true
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
	if nc then
--		Duel.SetChainLimit(c21520208.chlimit)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(aux.TRUE)
		e1:SetReset(RESET_CHAIN,1)
		Duel.RegisterEffect(e1,tp)
	end
end
function c21520208.tdtop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then 
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end
function c21520208.pfliter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and not c:IsPublic()
end
function c21520208.drfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToRemoveAsCost()
end
function c21520208.thfilter(c,check)
	if not check then
		return c:IsAbleToHand()
	else
		return c:IsAbleToHand() and Duel.IsExistingMatchingCard(c21520208.drfilter,tp,LOCATION_GRAVE,0,check,c)
	end
end
function c21520208.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520208.thfilter,tp,LOCATION_GRAVE,0,1,nil,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21520208.drfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21520208.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520208.thfilter,tp,LOCATION_GRAVE,0,1,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c21520208.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21520208.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--[[
function c21520208.tdtfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
--]]