--乱数原符-L
function c21520007.initial_effect(c)
	--change attack & defence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520007,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520007.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetOperation(c21520007.defval)
	c:RegisterEffect(e2)
	--summons
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520007,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(c21520007.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetOperation(c21520007.defval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c21520007.defval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetOperation(c21520007.defval)
	c:RegisterEffect(e8)
	--
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(21520007,1))
	e9:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_SEARCH)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1,21520007)
	e9:SetCondition(c21520007.condition)
--	e9:SetCost(c21520007.cost)
	e9:SetTarget(c21520007.target)
	e9:SetOperation(c21520007.operation)
	c:RegisterEffect(e9)
	--to deck
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_SEARCH)
	e10:SetDescription(aux.Stringid(21520007,2))
	e10:SetType(EFFECT_TYPE_QUICK_O)
--	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_HAND)
	e10:SetCountLimit(1,21520007)
	e10:SetCost(c21520007.tdcost)
	e10:SetTarget(c21520007.tdtg)
	e10:SetOperation(c21520007.tdop)
	c:RegisterEffect(e10)
end
function c21520007.MinValue(...)
	local val=...
	return val or 0
end
function c21520007.MaxValue(...)
	local val=...
	return val or 3136
end
function c21520007.atkval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520007.MinValue()
	local tempmax=c21520007.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+3136)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520007.defval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520007.MinValue()
	local tempmax=c21520007.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+3136+1)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520007.condition(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520007.MinValue()
	local tempmax=c21520007.MaxValue()
	return e:GetHandler():GetAttack()>=tempmax/2
end
function c21520007.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x493)
end
function c21520007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c21520007[0] end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c21520007.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c21520007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,LOCATION_DECK,1,nil) end
end
function c21520007.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,LOCATION_DECK,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.BreakEffect()
	local hc1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local hc2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local ca,cb=7,7
	if hc1:GetCount()<7 then ca=hc1:GetCount() end
	if hc2:GetCount()<7 then cb=hc2:GetCount() end
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+3136+2)
	local ct1=math.random(1,ca)
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+3136+3)
	local ct2=math.random(1,cb)
	local dg1=hc1:RandomSelect(tp,ct1)
	local dg2=hc2:RandomSelect(1-tp,ct2)
	local rg=Group.CreateGroup()
	rg:Merge(hc1)
	rg:Merge(hc2)
	rg:Sub(dg1)
	rg:Sub(dg2)
--	local d1=rg:FilterCount(c21520007.dfilter,nil,tp)
--	local d2=rg:FilterCount(c21520007.dfilter,nil,1-tp)
	local d1=dg1:GetCount()
	local d2=dg2:GetCount()
	Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
	if d1>d2 then
		Duel.Damage(tp,(d1-d2)*512,REASON_RULE)
	elseif d2>d1 then
		Duel.Damage(1-tp,(d2-d1)*512,REASON_RULE)
	else
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(21520007,3))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520007,3))
		local lp1=(Duel.GetLP(tp))*2
		local lp2=(Duel.GetLP(1-tp))*2
		Duel.SetLP(tp,lp1)
		Duel.SetLP(1-tp,lp2)
	end
end
function c21520007.dfilter(c,tp)
	return c:GetOwner()==tp
end
function c21520007.tdfilter(c,e)
	return not c:IsImmuneToEffect(e) and c:IsAbleToDeck() --and not c:IsCode(21520007) 
end
function c21520007.nrfilter(c)
	return not c:IsSetCard(0x493)
end
function c21520007.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c21520007.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520007.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e) 
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,nil,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21520007.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg2=Duel.GetMatchingGroup(c21520007.tdfilter,tp,LOCATION_GRAVE,0,nil,e)
	if not mg2 or mg2:GetCount()==0 then return end
	local rct=7
	if rct>mg2:GetCount() then rct=mg2:GetCount() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=mg2:Select(tp,1,rct,nil)
	Duel.ConfirmCards(1-tp,g)
	--not randomly
	if g:IsExists(c21520007.nrfilter,1,nil) and not Duel.IsExistingMatchingCard(c21520007.chkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		local ng=g:Filter(c21520007.nrfilter,nil)
		local tc=ng:GetFirst()
		local sum=0
		while tc do
			if tc:IsType(TYPE_MONSTER) then
				if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetOriginalRank()
				else sum=sum+tc:GetOriginalLevel() end
			else 
				math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+3136+10)
				local val=math.random(1,10)
				sum=sum+val
			end
			tc=ng:GetNext()
		end
		Duel.Hint(HINT_NUMBER,tp,sum)
		Duel.Hint(HINT_NUMBER,1-tp,sum)
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		Duel.BreakEffect()
		Duel.Damage(tp,sum*500,REASON_RULE)
	end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	local dg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	if dg:GetCount()==0 then return end
	if ct~=0 then
		Duel.BreakEffect()
		local tg=dg:RandomSelect(tp,1)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c21520007.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x493) and c:IsType(TYPE_FIELD)
end
--[[
function c21520007.group_unique_code(g)
	local check={}
	local tg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		for i,code in ipairs({tc:GetCode()}) do
			if not check[code] then
				check[code]=true
				tg:AddCard(tc)
			end
		end
		tc=g:GetNext()
	end
	return tg
end--]]
