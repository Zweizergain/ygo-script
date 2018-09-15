--能力抽取乱数
function c21520037.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(21520037,1))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,21520037+EFFECT_COUNT_CODE_OATH)
	e0:SetCost(c21520037.actcost)
	e0:SetTarget(c21520037.acttg)
	e0:SetOperation(c21520037.actop)
	c:RegisterEffect(e0)
	--disable effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c21520037.distg)
	c:RegisterEffect(e1)
	--cannot disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISABLE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c21520037.effectfilter2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(c21520037.effectfilter)
	c:RegisterEffect(e3)
	--to hand or set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21520037,2))
	e4:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,21520037+EFFECT_COUNT_CODE_OATH)
	e4:SetCost(c21520037.tscost)
	e4:SetTarget(c21520037.tstg)
	e4:SetOperation(c21520037.tsop)
	c:RegisterEffect(e4)
	--act in hand
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e5:SetCondition(c21520037.handcon)
	c:RegisterEffect(e5)
end
function c21520037.filter(c)
	return c:IsSetCard(0x5493) and c:IsAbleToGraveAsCost()
end
function c21520037.group_unique_choose(g,tp,hnt)
	local check={}
	local sg=Group.CreateGroup()
	local rg=Group.CreateGroup()
	local tc=nil
	for i=1,8 do
		Duel.Hint(HINT_SELECTMSG,tp,hnt)
		tc=g:Select(tp,1,1,nil):GetFirst()
		sg:AddCard(tc)
		rg=g:Filter(Card.IsCode,tc,tc:GetCode())
		g:Sub(rg)
		g:RemoveCard(tc)
	end
	return sg
end
function c21520037.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Group.GetClassCount(Duel.GetMatchingGroup(c21520037.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil),Card.GetCode)>=8 end
	local g=Duel.GetMatchingGroup(c21520037.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	local sg=c21520037.group_unique_choose(g,tp,HINTMSG_TOGRAVE)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c21520037.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(c21520037.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c21520037.actop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local thg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(thg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,thg)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tdg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(tdg,nil,2,REASON_EFFECT)
	end
end
function c21520037.distg(e,c)
	return c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT and not c:IsSetCard(0x493)
end
function c21520037.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return bit.band(loc,LOCATION_ONFIELD)~=0 and tc:IsSetCard(0x493) and tc:IsType(TYPE_MONSTER)
end
function c21520037.effectfilter2(e,c)
	return c:IsSetCard(0x493) and c:IsType(TYPE_MONSTER)
end
function c21520037.cfilter(c)
	return c:IsSetCard(0x5493) and c:IsAbleToDeckAsCost()
end
function c21520037.tscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Group.GetClassCount(Duel.GetMatchingGroup(c21520037.cfilter,tp,LOCATION_GRAVE,0,nil),Card.GetCode)>=8 end
	local g=Duel.GetMatchingGroup(c21520037.cfilter,tp,LOCATION_GRAVE,0,nil)
	local sg=c21520037.group_unique_choose(g,tp,HINTMSG_TODECK)
	Duel.ConfirmCards(1-tp,sg)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function c21520037.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsSSetable()) or e:GetHandler():IsAbleToHand() end
	local op=2
	if (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsSSetable()) or e:GetHandler():IsAbleToHand() then
		op=Duel.SelectOption(tp,aux.Stringid(21520037,3),aux.Stringid(21520037,4))
	elseif Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsSSetable() then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520037,3))
		op=0
	elseif e:GetHandler():IsAbleToHand() then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520037,4))
		op=1
	end
	if op==1 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE) end
	e:SetLabel(op)
end
function c21520037.tsop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not e:GetHandler():IsLocation(LOCATION_GRAVE) then return end
	local op=e:GetLabel()
	if op==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then 
		Duel.SSet(tp,e:GetHandler())
		Duel.ConfirmCards(1-tp,e:GetHandler())
	elseif op==1 and e:GetHandler():IsAbleToHand() then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
function c21520037.handcon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
