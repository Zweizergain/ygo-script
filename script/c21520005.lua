--乱数原符-O
function c21520005.initial_effect(c)
	--change attack & defence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520005,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520005.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetOperation(c21520005.defval)
	c:RegisterEffect(e2)
	--summons
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520005,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(c21520005.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetOperation(c21520005.defval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c21520005.defval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetOperation(c21520005.defval)
	c:RegisterEffect(e8)
	e8:SetOperation(c21520005.defval)
	c:RegisterEffect(e8)
	--life adjust
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(21520005,1))
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1,21520005)
	e9:SetCondition(c21520005.condition)
	e9:SetOperation(c21520005.operation)
	c:RegisterEffect(e9)
	--LP back
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(21520005,2))
	e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_HAND)
	e10:SetCountLimit(1,21520005)
	e10:SetCost(c21520005.chcost)
	e10:SetOperation(c21520005.chop)
	c:RegisterEffect(e10)
	if not c21520005.global_check then
		c21520005.global_check=true
		c21520005.lp1=Duel.GetLP(0)
		c21520005.lp2=Duel.GetLP(1)
	end
end
function c21520005.MinValue(...)
	local val=...
	return val or 0
end
function c21520005.MaxValue(...)
	local val=...
	return val or 2240
end
function c21520005.atkval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520005.MinValue()
	local tempmax=c21520005.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+2240)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520005.defval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520005.MinValue()
	local tempmax=c21520005.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+2240+1)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520005.condition(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520005.MinValue()
	local tempmax=c21520005.MaxValue()
	return e:GetHandler():GetAttack()>=tempmax/2
end
function c21520005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+2240+2)
	local lp=Duel.GetLP(tp)+Duel.GetLP(1-tp)
	local lp1=math.random(math.ceil(lp/4),math.ceil(lp*3/4))
	local lp2=lp-lp1
	Duel.SetLP(tp,lp1)
	Duel.SetLP(1-tp,lp2)
end
function c21520005.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
--[[
function c21520005.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c21520005.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_REMOVED)
end
--]]
function c21520005.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lp1=Duel.GetLP(0)
	local lp2=Duel.GetLP(1)
	local v1=0
	local v2=0
	if lp1>c21520005.lp1 then v1=lp1-c21520005.lp1 else v1=c21520005.lp1-lp1 end
	if lp2>c21520005.lp2 then v2=lp2-c21520005.lp2 else v2=c21520005.lp2-lp2 end
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+2240+3)
	local rv1=math.random(0,v1)
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+2240+4)
	local rv2=math.random(0,v2)
	Duel.Hint(HINT_NUMBER,0,rv1)
	Duel.Hint(HINT_NUMBER,0,rv2)
	Duel.Hint(HINT_NUMBER,1,rv2)
	Duel.Hint(HINT_NUMBER,1,rv1)
	if lp1>c21520005.lp1 then
		Duel.SetLP(0,lp1-rv1)
	else
		Duel.SetLP(0,lp1+rv1)
	end
	if lp2>c21520005.lp2 then
		Duel.SetLP(1,lp2-rv2)
	else
		Duel.SetLP(1,lp2+rv2)
	end
	local c1=math.floor(rv1/1024)
	local c2=math.floor(rv2/1024)
	if lp1>lp2 and rv1>=1024 and Duel.SelectYesNo(0,aux.Stringid(21520005,3)) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,0,LOCATION_DECK,0,c1,nil) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,0,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_NUMBER,0,c1)
		Duel.Hint(HINT_NUMBER,1,c1)
		local rg=g:RandomSelect(0,c1)
		Duel.SendtoHand(rg,0,REASON_EFFECT)
		Duel.ConfirmCards(1,rg)
	elseif lp2>lp1 and rv2>=1024 and Duel.SelectYesNo(1,aux.Stringid(21520005,3)) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,1,LOCATION_DECK,0,c2,nil) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,1,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_NUMBER,1,c2)
		Duel.Hint(HINT_NUMBER,0,c2)
		local rg=g:RandomSelect(1,c2)
		Duel.SendtoHand(rg,1,REASON_EFFECT)
		Duel.ConfirmCards(0,rg)
	end
end
