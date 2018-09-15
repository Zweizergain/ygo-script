--原初八文-坎
function c21520206.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c21520206.cfilter,1,1)
	--DESTROY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520206,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c21520206.destg)
	e1:SetOperation(c21520206.desop)
	c:RegisterEffect(e1)
	--RECOVER
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520206,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c21520206.drcost)
	e2:SetTarget(c21520206.drtg)
	e2:SetOperation(c21520206.drop)
	c:RegisterEffect(e2)
end
function c21520206.cfilter(c)
	local g=Duel.GetMatchingGroup(c21520206.ckfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
		return (c:IsLinkAttribute(ATTRIBUTE_WATER) and c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000) or (c:IsSetCard(0x492) and not c:IsCode(21520206))
	else
		return c:IsLinkAttribute(ATTRIBUTE_WATER) and c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000
	end
end
function c21520206.ckfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x492) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:GetOriginalType()&TYPE_SPELL==TYPE_SPELL or c:GetOriginalType()&TYPE_TRAP==TYPE_TRAP)
end
function c21520206.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c21520206.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c21520206.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21520206.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c21520206.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,LOCATION_ONFIELD)
	Duel.SetChainLimit(c21520206.chlimit)
end
function c21520206.chlimit(e,ep,tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return tp==ep or not g:IsContains(e:GetHandler())
end
function c21520206.pfliter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and not c:IsPublic()
end
function c21520206.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local sg=Group.CreateGroup()
	if tc and tc:IsRelateToEffect(e) then 
		sg:AddCard(tc)
		local g=Duel.GetMatchingGroup(c21520206.pfliter,tp,LOCATION_HAND,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(21520206,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local pg=g:Select(tp,1,1,nil)
			Duel.ConfirmCards(1-tp,pg)
			if Duel.SelectYesNo(tp,aux.Stringid(21520206,3)) then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local tg=Duel.SelectMatchingCard(tp,c21520206.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,tc)
				sg:Merge(tg)
			end
		end
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c21520206.drfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToRemoveAsCost()
end
function c21520206.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520206.drfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21520206.drfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:KeepAlive()
	e:SetLabelObject(g)
end
function c21520206.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=e:GetLabelObject()
	local sum=0
	for tc in aux.Next(g) do
		sum=sum+tc:GetAttack()
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(sum)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,sum)
end
function c21520206.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
