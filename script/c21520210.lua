--后天原初八文图
function c21520210.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520210,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c21520210.drzcost)
	e1:SetTarget(c21520210.drztg)
	e1:SetOperation(c21520210.drzop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520210,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21520210)
	e2:SetCondition(c21520210.thcon)
	e2:SetTarget(c21520210.thtg)
	e2:SetOperation(c21520210.thop)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c21520210.handcon)
	c:RegisterEffect(e3)
end
function c21520210.drzfilter1(c,lv,g)
	if lv>0 then
		if g~=nil then
			return c:GetLevel()==lv and c:IsAbleToRemoveAsCost() and g:IsExists(c21520210.drzfilter1,1,nil,lv-1,g)
		else return c:GetLevel()==lv and c:IsAbleToRemoveAsCost() end
	else
		return true
	end
end
function c21520210.drzfilter2(c)
	return c:IsSetCard(0x492) and c:IsAbleToDeckOrExtraAsCost() and c:IsFaceup()
end
function c21520210.drzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local gg=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0)
		local mg=Duel.GetMatchingGroup(c21520210.drzfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
		return gg:IsExists(c21520210.drzfilter1,1,nil,9,gg) or mg:GetClassCount(Card.GetCode)>=8 and Duel.GetFlagEffect(tp,21520210)==0 end
	local gg=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0)
	local mg=Duel.GetMatchingGroup(c21520210.drzfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	local b1=gg:IsExists(c21520210.drzfilter1,1,nil,9,gg)
	local b2=mg:GetClassCount(Card.GetCode)>=8
	local opsl=2
	if b1 and b2 then 
		opsl=Duel.SelectOption(tp,aux.Stringid(21520210,2),aux.Stringid(21520210,3))
	elseif b1 and not b2 then 
		opsl=0
	elseif not b1 and b2 then
		opsl=1
	end
	if opsl==0 then 
		local rg=Group.CreateGroup()
		for i=1,9 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=gg:FilterSelect(tp,c21520210.drzfilter1,1,1,nil,i)
			rg:Merge(tg)
		end
		Duel.Remove(rg,POS_FACEUP,REASON_COST)
	elseif opsl==1 then 
		local tdg=Group.CreateGroup()
		for j=1,8 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local dg=mg:FilterSelect(tp,c21520210.drzfilter2,1,1,nil)
			tdg:Merge(dg)
			mg:Remove(Card.IsCode,nil,dg:GetFirst():GetCode())
		end
		Duel.SendtoDeck(tdg,nil,2,REASON_COST)
	end
	Duel.RegisterFlagEffect(tp,21520210,RESET_CHAIN,0,1)
end
function c21520210.drztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,9) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(9)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,9)
end
function c21520210.drzop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local og=Duel.GetDecktopGroup(p,d)
	if og:GetCount()==9 then
		Duel.Draw(p,d,REASON_EFFECT)
		Duel.ConfirmCards(1-p,og)
		local one2nine=true
		for lv=1,9 do
			if og:FilterCount(c21520210.drzfilter1,nil,lv)==1 and one2nine then one2nine=true 
			else one2nine=false end
		end
		if one2nine==true then 
			Duel.SetLP(1-p,0) 
		else 
			local hg=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
			if hg:GetCount()==0 then return end
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local sg=hg:Select(p,8,8,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end 
	end
end
function c21520210.thfilter(c)
	return c:IsSetCard(0x492) and c:IsFaceup()
end
function c21520210.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21520210.thfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c21520210.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c21520210.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
function c21520210.hcfilter(c)
	return c:IsSetCard(0x492) and c:IsFaceup()
end
function c21520210.handcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c21520210.hcfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()==Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
end
