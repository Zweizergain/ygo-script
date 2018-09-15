--异次元之刀还 
function c62800013.initial_effect(c)
	   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TODECK)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,62800013)
	e1:SetCondition(c62800013.condition)
	e1:SetTarget(c62800013.target)
	e1:SetOperation(c62800013.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_CANNOT_DISABLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c62800013.handcon)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c62800013.con)
	e3:SetCountLimit(1,62800013)
	e3:SetCost(c62800013.cost)
	e3:SetTarget(c62800013.tg)
	e3:SetOperation(c62800013.op)
	c:RegisterEffect(e3)
end
function c62800013.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1620) or c:IsSetCard(0x2620))
end
function c62800013.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c62800013.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if Duel.IsChainDisablable(i) then
			return true
		end
	end
	return false
end
function c62800013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if  Duel.IsChainDisablable(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if TGP==1-tp and  tc:IsOnField() and tc:IsRelateToEffect(te) and not tc:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(tp,tc) then
				dg:AddCard(tc)
			end
		end
	end
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,ng,ng:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,dg,dg:GetCount(),0,0)
end
function c62800013.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if  Duel.NegateEffect(i) then
			local tc=te:GetHandler()
			if tgp==1-tp and tc:IsOnField() and  tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) and not tc:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(tp,tc) then
				tc:CancelToGrave()
				dg:AddCard(tc)
			end
		end
	end
	Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
end
function c62800013.handcon(e)
	return Duel.IsExistingMatchingCard(c62800013.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
function c62800013.con(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end
function c62800013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() end
	Duel.SendtoGrave(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c62800013.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c62800013.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_REMOVED,0,1,3,nil)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end