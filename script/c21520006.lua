--乱数原符-M
function c21520006.initial_effect(c)
	--change attack & defence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520006,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520006.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetOperation(c21520006.defval)
	c:RegisterEffect(e2)
	--summons
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520006,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(c21520006.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetOperation(c21520006.defval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c21520006.defval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetOperation(c21520006.defval)
	c:RegisterEffect(e8)
	--to grave
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(21520006,1))
	e9:SetCategory(CATEGORY_TOGRAVE)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1,21520006)
	e9:SetCondition(c21520006.condition)
	e9:SetTarget(c21520006.target)
	e9:SetOperation(c21520006.operation)
	c:RegisterEffect(e9)
	--game
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(21520006,2))
	e10:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_HAND)
	e10:SetCountLimit(1,21520006)
	e10:SetCost(c21520006.cost2)
	e10:SetTarget(c21520006.target2)
	e10:SetOperation(c21520006.operation2)
	c:RegisterEffect(e10)
end
function c21520006.MinValue(...)
	local val=...
	return val or 0
end
function c21520006.MaxValue(...)
	local val=...
	return val or 2688
end
function c21520006.atkval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520006.MinValue()
	local tempmax=c21520006.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+2688)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520006.defval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520006.MinValue()
	local tempmax=c21520006.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+2688+1)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520006.condition(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520006.MinValue()
	local tempmax=c21520006.MaxValue()
	return e:GetHandler():GetAttack()>=tempmax/2
end
function c21520006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
end
function c21520006.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
	local rg2=Duel.GetMatchingGroup(Card.IsAbleToDeck,1-tp,LOCATION_REMOVED,0,nil)
	local count1=6
	local count2=6
	if count1>rg1:GetCount() then count1=rg1:GetCount() end
	if count2>rg2:GetCount() then count2=rg2:GetCount() end
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+2688+5)
	local ct1,ct2=0,0
	if count1~=0 then ct1=math.random(1,count1) end
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+2688+6)
	if count2~=0 then ct2=math.random(1,count2) end
	local bg1=rg1:RandomSelect(tp,ct1)
	local bg2=rg2:RandomSelect(1-tp,ct2)
	Duel.ConfirmCards(tp,bg2)
	Duel.ConfirmCards(1-tp,bg1)
	Duel.SendtoDeck(bg1,nil,2,REASON_EFFECT)
	Duel.SendtoDeck(bg2,nil,2,REASON_EFFECT)
	Duel.BreakEffect()
	local sg1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,nil)
	local sg2=Duel.GetMatchingGroup(Card.IsAbleToGrave,1-tp,LOCATION_ONFIELD,0,nil)
	if sg1:GetCount()==0 or sg2:GetCount()==0 then return end
	local ct=math.abs(ct1-ct2)
	if ct1>ct2 then 
		if sg2:GetCount()<ct then ct=sg2:GetCount() end
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(21520006,8))
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(21520006,9))
		Duel.Hint(HINT_NUMBER,1-tp,ct)
		local dg2=sg2:Select(1-tp,ct,ct,nil)
		Duel.SendtoGrave(dg2,REASON_RULE)
	elseif ct2>ct1 then 
		if sg1:GetCount()<ct then ct=sg1:GetCount() end
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(21520006,9))
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(21520006,8))
		Duel.Hint(HINT_NUMBER,tp,ct)
		local dg1=sg1:Select(tp,ct,ct,nil)
		Duel.SendtoGrave(dg1,REASON_RULE)
	else
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(21520006,10))
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(21520006,10))
		local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,LOCATION_REMOVED)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c21520006.dfilter(c,tp)
	return c:GetOwner()==tp
end
function c21520006.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c21520006.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,LOCATION_DECK,nil)>0 end
--[[
	local yn=0
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,LOCATION_DECK,nil)>=12 then
		if Duel.SelectYesNo(1-tp,aux.Stringid(21520006,3)) then
			yn=1
			Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(21520006,4))
		end
	end
	e:SetLabel(yn)
--]]
end
function c21520006.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
--	local yn=e:GetLabel()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,LOCATION_DECK,nil)
--[[
	local ct=0
	if yn==1 then
		ct=12
		if g:GetCount()<12 then ct=g:GetCount() end
	else
		ct=6
		if g:GetCount()<6 then ct=g:GetCount() end
	end
-]]
	local ct=6
	if g:GetCount()<6 then ct=g:GetCount() end
	local rg=g:RandomSelect(tp,ct)
	Duel.BreakEffect()
	local tc=rg:GetFirst()
	local player=e:GetHandlerPlayer()
	local tct=0
	while tc do
		Duel.Hint(HINT_SELECTMSG,player,HINTMSG_CARDTYPE)
		local op=Duel.SelectOption(player,aux.Stringid(21520006,5),aux.Stringid(21520006,6),aux.Stringid(21520006,7))
--[[		if op==0 then
			Duel.Hint(HINT_OPSELECTED,1-player,aux.Stringid(21520006,5))
		elseif op==1 then
			Duel.Hint(HINT_OPSELECTED,1-player,aux.Stringid(21520006,6))
		elseif op==2 then
			Duel.Hint(HINT_OPSELECTED,1-player,aux.Stringid(21520006,7))
		end--]]
		Duel.ConfirmCards(player,tc)
		Duel.ConfirmCards(1-player,tc)
		if (op==0 and tc:IsType(TYPE_MONSTER)) or (op==1 and tc:IsType(TYPE_SPELL)) or (op==2 and tc:IsType(TYPE_TRAP)) then
			math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+2688+3+tct)
			local val=math.random(1,1024)
			Duel.Recover(player,val,REASON_EFFECT)
		else
			math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+2688+4+tct+10)
			local val=math.random(1,1024)
			Duel.Damage(player,val,REASON_EFFECT)
		end
		player=1-player
		tct=tct+1
		Duel.BreakEffect()
		tc=rg:GetNext()
	end
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
end
