--原初八文-艮
function c21520204.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c21520204.cfilter,1,1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520204,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c21520204.destg)
	e1:SetOperation(c21520204.desop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520204,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c21520204.drcost)
	e2:SetTarget(c21520204.drtg)
	e2:SetOperation(c21520204.drop)
	c:RegisterEffect(e2)
end
function c21520204.cfilter(c)
	local g=Duel.GetMatchingGroup(c21520204.ckfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
		return (c:IsLinkAttribute(ATTRIBUTE_EARTH) and c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000) or (c:IsSetCard(0x492) and not c:IsCode(21520204))
	else
		return c:IsLinkAttribute(ATTRIBUTE_EARTH) and c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000
	end
end
function c21520204.ckfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x492) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:GetOriginalType()&TYPE_SPELL==TYPE_SPELL or c:GetOriginalType()&TYPE_TRAP==TYPE_TRAP)
end
function c21520204.desfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup()
end
function c21520204.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFacedown() end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 
		and Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,math.min(2,ct),nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,g:GetCount(),tp,LOCATION_ONFIELD)
end
function c21520204.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct<=0 then return end
	if ct>g:GetCount() then ct=g:GetCount() end
	local sg=Group.CreateGroup()
	for tc in aux.Next(g) do
		if tc:IsRelateToEffect(e) and tc:IsFacedown() then
			sg:AddCard(tc)
		end
	end
	local dg=Duel.GetDecktopGroup(tp,ct)
	if g:GetCount()>0 then 
		Duel.ConfirmDecktop(tp,ct)
		Duel.ShuffleDeck(tp)
		Duel.Destroy(sg,REASON_EFFECT)
		if dg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)==dg:GetCount() then 
			if Duel.IsPlayerCanDraw(tp) and Duel.SelectYesNo(tp,aux.Stringid(21520204,2)) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
function c21520204.drfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToRemoveAsCost()
end
function c21520204.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520204.drfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21520204.drfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21520204.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21520204.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
