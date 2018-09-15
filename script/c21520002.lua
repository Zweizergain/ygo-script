--乱数原符-A
function c21520002.initial_effect(c)
	--change attack & defence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520002,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520002.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetOperation(c21520002.defval)
	c:RegisterEffect(e2)
	--summons
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520002,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(c21520002.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetOperation(c21520002.defval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c21520002.defval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetOperation(c21520002.defval)
	c:RegisterEffect(e8)
	--random to hand
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(21520002,1))
	e9:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1,21520002)
	e9:SetCondition(c21520002.con)
	e9:SetTarget(c21520002.tg)
	e9:SetOperation(c21520002.op)
	c:RegisterEffect(e9)
	--search
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e10:SetDescription(aux.Stringid(21520002,13))
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetRange(LOCATION_HAND)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetCountLimit(1,21520002)
	e10:SetCost(c21520002.thcost)
	e10:SetTarget(c21520002.thtg)
	e10:SetOperation(c21520002.thop)
	c:RegisterEffect(e10)
end
function c21520002.MinValue(...)
	local val=...
	return val or 0
end
function c21520002.MaxValue(...)
	local val=...
	return val or 896
end
function c21520002.atkval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520002.MinValue()
	local tempmax=c21520002.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+896)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520002.defval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520002.MinValue()
	local tempmax=c21520002.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+896+1)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520002.con(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520002.MinValue()
	local tempmax=c21520002.MaxValue()
	return e:GetHandler():GetAttack()>=tempmax/2
end
function c21520002.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c21520002.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	local thg=g1:RandomSelect(tp,2)
	Duel.SendtoHand(thg,tp,REASON_EFFECT)
	Duel.BreakEffect()
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	local tdg=g2:RandomSelect(tp,1)
	Duel.SendtoDeck(tdg,nil,2,REASON_EFFECT)
end
function c21520002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c21520002.ffilter(c)
	return c:IsSetCard(0x493) and c:IsAbleToHand()
end
function c21520002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21520002.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	if not g1 or g1:GetCount()==0 then return end
	local g2=g1:RandomSelect(tp,1)
	Duel.SetTargetCard(g2)
	if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
		--not randomly
		if not g2:GetFirst():IsSetCard(0x493) and not Duel.IsExistingMatchingCard(c21520002.chkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
			local sum=0
			if g2:GetFirst():IsType(TYPE_MONSTER) then
				sum=g2:GetFirst():GetOriginalLevel()
			else 
				math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+896+10)
				sum=math.random(1,10)
				Duel.Hint(HINT_NUMBER,tp,sum)
				Duel.Hint(HINT_NUMBER,1-tp,sum)
			end
			Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
			Duel.BreakEffect()
			Duel.Damage(tp,sum*500,REASON_RULE)
		end
	end
	Duel.BreakEffect()
	if Duel.SelectYesNo(tp,aux.Stringid(21520002,12)) then
		local cg = Duel.GetDecktopGroup(tp,3)
		local tg = cg:Filter(Card.IsAbleToHand,nil)
		if tg:GetCount()~=cg:GetCount() then return end
		local tc=cg:GetFirst()
		local tf=0
		while tc do
			if not tc:IsSetCard(0x493) then tf=tf+1 end
			tc=cg:GetNext()
		end
		local choose = Duel.SelectOption(tp,aux.Stringid(21520002,2),aux.Stringid(21520002,3),aux.Stringid(21520002,4),aux.Stringid(21520002,5),aux.Stringid(21520002,6),aux.Stringid(21520002,7),aux.Stringid(21520002,8),aux.Stringid(21520002,9),aux.Stringid(21520002,10),aux.Stringid(21520002,11))
		Duel.ConfirmDecktop(tp,3)
		if choose == 0 and c21520002.thfilter(cg,TYPE_MONSTER,TYPE_MONSTER,TYPE_MONSTER) then 
			Duel.SendtoHand(cg,nil,REASON_EFFECT)
		elseif choose == 1 and c21520002.thfilter(cg,TYPE_SPELL,TYPE_SPELL,TYPE_SPELL) then 
			Duel.SendtoHand(cg,nil,REASON_EFFECT)
		elseif choose == 2 and c21520002.thfilter(cg,TYPE_TRAP,TYPE_TRAP,TYPE_TRAP) then 
			Duel.SendtoHand(cg,nil,REASON_EFFECT)
		elseif choose == 3 and c21520002.thfilter(cg,TYPE_MONSTER,TYPE_MONSTER,TYPE_SPELL) then 
			Duel.SendtoHand(cg,nil,REASON_EFFECT)
		elseif choose == 4 and c21520002.thfilter(cg,TYPE_MONSTER,TYPE_MONSTER,TYPE_TRAP) then 
			Duel.SendtoHand(cg,nil,REASON_EFFECT)
		elseif choose == 5 and c21520002.thfilter(cg,TYPE_SPELL,TYPE_SPELL,TYPE_MONSTER) then 
			Duel.SendtoHand(cg,nil,REASON_EFFECT)
		elseif choose == 6 and c21520002.thfilter(cg,TYPE_SPELL,TYPE_SPELL,TYPE_TRAP) then 
			Duel.SendtoHand(cg,nil,REASON_EFFECT)
		elseif choose == 7 and c21520002.thfilter(cg,TYPE_TRAP,TYPE_TRAP,TYPE_MONSTER) then 
			Duel.SendtoHand(cg,nil,REASON_EFFECT)
		elseif choose == 8 and c21520002.thfilter(cg,TYPE_TRAP,TYPE_TRAP,TYPE_SPELL) then 
			Duel.SendtoHand(cg,nil,REASON_EFFECT)
		elseif choose == 9 and c21520002.thfilter(cg,TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP) then 
			Duel.SendtoHand(cg,nil,REASON_EFFECT)
		else 
			Duel.Remove(cg,POS_FACEUP,REASON_EFFECT)
		 	tf=0
		end
		if tf~=0 and Duel.SelectYesNo(1-tp,aux.Stringid(21520002,14)) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,1-tp,LOCATION_DECK,0,tf,nil) then
			local thg = Duel.GetMatchingGroup(Card.IsAbleToHand,1-tp,LOCATION_DECK,0,nil):RandomSelect(1-tp,tf)
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
			Duel.ConfirmCards(tp,thg)
		end
	end
end
function c21520002.thfilter(g,t1,t2,t3)
	local tc=g:GetFirst()
	local tm=0
	local ts=0
	local tt=0
	local c1=0
	local c2=0
	local c3=0
	if t1==TYPE_MONSTER then tm=tm+1 
	elseif t1==TYPE_SPELL then ts=ts+1 
	elseif t1==TYPE_TRAP then tt=tt+1 end
	if t2==TYPE_MONSTER then tm=tm+1 
	elseif t2==TYPE_SPELL then ts=ts+1 
	elseif t2==TYPE_TRAP then tt=tt+1 end
	if t3==TYPE_MONSTER then tm=tm+1 
	elseif t3==TYPE_SPELL then ts=ts+1 
	elseif t3==TYPE_TRAP then tt=tt+1 end
	while tc do
		if tc:IsType(TYPE_MONSTER) then c1=c1+1 
		elseif tc:IsType(TYPE_SPELL) then c2=c2+1 
		elseif tc:IsType(TYPE_TRAP) then c3=c3+1 end
		tc=g:GetNext()
	end
	return (tm==c1 and ts==c2 and tt==c3)
end
function c21520002.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x493) and c:IsType(TYPE_FIELD)
end
