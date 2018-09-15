--乱数原符-Y
function c21520008.initial_effect(c)
	--change attack & defence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520008,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520008.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetOperation(c21520008.defval)
	c:RegisterEffect(e2)
	--summons
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520008,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(c21520008.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetOperation(c21520008.defval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c21520008.defval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetOperation(c21520008.defval)
	c:RegisterEffect(e8)
	--skip
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(21520008,5))
	e9:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1,21520008)
	e9:SetCondition(c21520008.condition)
--	e9:SetCost(c21520008.cost)
	e9:SetTarget(c21520008.target)
	e9:SetOperation(c21520008.operation)
	c:RegisterEffect(e9)
	--disable
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(21520008,2))
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_HAND)
	e10:SetCountLimit(1,21520008)
	e10:SetCost(c21520008.cost2)
	e10:SetTarget(c21520008.target2)
	e10:SetOperation(c21520008.operation2)
	c:RegisterEffect(e10)
end
function c21520008.MinValue(...)
	local val=...
	return val or 0
end
function c21520008.MaxValue(...)
	local val=...
	return val or 3584
end
function c21520008.atkval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520008.MinValue()
	local tempmax=c21520008.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+3584)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520008.defval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520008.MinValue()
	local tempmax=c21520008.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+3584+1)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520008.condition(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520008.MinValue()
	local tempmax=c21520008.MaxValue()
	return e:GetHandler():GetAttack()>=tempmax/2 and ep==tp
end
--[[
function c21520008.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x493)
end
function c21520008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c21520008[0] end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c21520008.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
--]]
function c21520008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,LOCATION_DECK,1,nil) end
end
function c21520008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_DECK,nil)
	local c1,c2=8,8
	local ct1,ct2=1,1
	if g1:GetCount()<8 then c1=g1:GetCount() end
	if g2:GetCount()<8 then c2=g2:GetCount() end
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+3584+2)
	if c1==0 then ct1=0 
	else ct1=math.random(1,c1) end
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+3584+3)
	if c2==0 then ct2=0 
	else ct2=math.random(1,c2) end
	local rg1=g1:RandomSelect(tp,ct1)
	local rg2=g2:RandomSelect(tp,ct2)
	local rg=Group.CreateGroup()
	rg:Merge(rg1)
	rg:Merge(rg2)
	Duel.ConfirmCards(tp,rg)
	Duel.ConfirmCards(1-tp,rg)
	Duel.SendtoGrave(rg,REASON_EFFECT)
	local d1=rg:FilterCount(c21520008.dfilter,nil,tp)
	local d2=rg:FilterCount(c21520008.dfilter,nil,1-tp)
	if d1>d2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520008,1))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		Duel.RegisterEffect(e1,tp)
	elseif d2>d1 then
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(21520008,1))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		Duel.RegisterEffect(e1,tp)
	else
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(21520008,3))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520008,3))
		local tdg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		Duel.SendtoDeck(tdg,nil,2,REASON_EFFECT)
	end
end
function c21520008.dfilter(c,tp)
	return c:GetOwner()==tp
end
function c21520008.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c21520008.target2(e,tp,eg,ep,ev,re,r,rp,chk)
--	if chk==0 then return Duel.IsExistingMatchingCard(c21520008.nfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	if chk==0 then return true end
end
function c21520008.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetRange(0xff)
	e11:SetCode(EVENT_CHAIN_ACTIVATING)
	e11:SetCondition(c21520008.discon)
	e11:SetOperation(c21520008.disop)
	e11:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e11)
end
function c21520008.nfilter(c)
	return c:IsOnField() and not c:IsSetCard(0x493)
		and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c21520008.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return c21520008.nfilter(rc)
end
function c21520008.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local player=rc:GetControler()
	if Duel.SelectYesNo(player,aux.Stringid(21520008,4)) then
		Duel.PayLPCost(player,math.floor(Duel.GetLP(player)/8))
	else
		Duel.Hint(HINT_CARD,player,21520008)
		Duel.NegateEffect(ev)
		rc:CancelToGrave()
		Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
	end
end
--[[
function c21520008.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
--	if not c:IsRelateToEffect(e) or Duel.GetCurrentChain()~=ev+1 then return end
	local g=Duel.GetMatchingGroup(c21520008.nfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local selfg=g:Filter(Card.IsControler,nil,tp)
	local oppog=g:Filter(Card.IsControler,nil,1-tp)
	if selfg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(21520008,4)) then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/4))
		g:Sub(selfg)
	end
	if oppog:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(21520008,4)) then
		Duel.PayLPCost(1-tp,math.floor(Duel.GetLP(1-tp)/4))
		g:Sub(oppog)
	end
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c21520008.nfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x493)
		and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
--]]
--[[
function c21520008.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil)
	local ct,ac=3,0
	if g:GetCount()<3 then ct=g:GetCount() end
	if ct==1 then 
		ac=1
		Duel.Hint(HINT_NUMBER,1-tp,ac)
	elseif ct==2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(85087012,5))
		ac=Duel.AnnounceNumber(tp,2,1)
	end
	local rg=g:RandomSelect(tp,ac)
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	local tc=rg:GetFirst()
	local nm,ns,nt = 0,0,0
	while tc do
		if tc:IsType(TYPE_MONSTER) then
			nm=nm+1
		elseif tc:IsType(TYPE_SPELL) then
			ns=ns+1
		elseif tc:IsType(TYPE_TRAP) then
			nt=nt+1
		end
		tc=rg:GetNext()
	end
	local ctp=re:GetActiveType()
	local rc=re:GetHandler()
	local player=rc:GetControler()
	local lp=Duel.GetLP(player)
	if ctp==TYPE_MONSTER and nm~=0 then
		if Duel.SelectYesNo(player,aux.Stringid(21520008,4)) then
			Duel.PayLPCost(player,math.floor(lp/4))
		else
			Duel.Hint(HINT_CARD,player,21520008)
			Duel.NegateEffect(ev)
			rc:CancelToGrave()
			Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
		end
	elseif ctp==TYPE_SPELL and c21520008[2]~=0 then
		if Duel.SelectYesNo(player,aux.Stringid(21520008,4)) then
			Duel.PayLPCost(player,math.floor(lp/4))
		else
			Duel.Hint(HINT_CARD,player,21520008)
			Duel.NegateEffect(ev)
			rc:CancelToGrave()
			Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
		end
	elseif ctp==TYPE_TRAP and c21520008[3]~=0 then
		if Duel.CheckLPCost(player,1024) and Duel.SelectYesNo(player,aux.Stringid(21520008,4)) then
			Duel.PayLPCost(player,math.floor(lp/4))
		else
			Duel.Hint(HINT_CARD,player,21520008)
			Duel.NegateEffect(ev)
			rc:CancelToGrave()
			Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
		end
	end
	
	c21520008[4] = nm*100 + ns*10 +nt
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetRange(0xff)
	e11:SetCode(EVENT_CHAIN_ACTIVATING)
	e11:SetCondition(c21520008.discon)
	e11:SetOperation(c21520008.disop)
	c:RegisterEffect(e11)
end

function c21520008.discon(e,tp,eg,ep,ev,re,r,rp)
	local negate = c21520008[4]
	local nm = math.floor(negate/100)
	local ns = math.floor((negate % 100)/10)
	local nt = negate - nm - ns
	return nm>0 or ns>0 or nt>0
end
function c21520008.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local player=rc:GetControler()
	local negate=c21520008[4]
	local nm = math.floor(negate/100)
	local ns = math.floor((negate % 100)/10)
	local nt = negate - nm - ns
	if rc:IsType(TYPE_MONSTER) and nm~=0 then
		math.randomseed(tonumber(tostring(os.time()+4):reverse():sub(1,6))+c:GetFieldID())
		if Duel.CheckLPCost(player,1024) and Duel.SelectYesNo(player,aux.Stringid(21520008,4)) then
			local life=math.random(1,1024)
			Duel.PayLPCost(player,life)
		else
			Duel.Hint(HINT_CARD,player,21520008)
			Duel.NegateEffect(ev)
			rc:CancelToGrave()
			Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
		end
		if c21520008[4]<0 then c21520008[4]=0 end
		c21520008[4]=c21520008[4]-100
	elseif rc:IsType(TYPE_SPELL) and c21520008[2]~=0 then
		if Duel.CheckLPCost(player,1024) and Duel.SelectYesNo(player,aux.Stringid(21520008,4)) then
			Duel.PayLPCost(player,1024)
		else
			Duel.Hint(HINT_CARD,player,21520008)
			Duel.NegateEffect(ev)
			rc:CancelToGrave()
			Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
		end
		if c21520008[4]%100 < 0 then c21520008[4]=0
		else c21520008[4]=c21520008[4]-10 end
	elseif rc:IsType(TYPE_TRAP) and c21520008[3]~=0 then
		if Duel.CheckLPCost(player,1024) and Duel.SelectYesNo(player,aux.Stringid(21520008,4)) then
			Duel.PayLPCost(player,1024)
		else
			Duel.Hint(HINT_CARD,player,21520008)
			Duel.NegateEffect(ev)
			rc:CancelToGrave()
			Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
		end
		if c21520008[4]%10 <0 then c21520008[4]=0
		else c21520008[4]=c21520008[4]-1 end
	end
end
function c21520008.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local player=rc:GetControler()
	if rc:IsType(TYPE_MONSTER) and c21520008[1]~=0 then
		math.randomseed(tonumber(tostring(os.time()+4):reverse():sub(1,6))+c:GetFieldID())
		if Duel.CheckLPCost(player,1024) and Duel.SelectYesNo(player,aux.Stringid(21520008,4)) then
			local life=math.random(1,1024)
			Duel.PayLPCost(player,life)
		else
			Duel.Hint(HINT_CARD,player,21520008)
			Duel.NegateEffect(ev)
			rc:CancelToGrave()
			Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
		end
		c21520008[1]=c21520008[1]-1
	elseif rc:IsType(TYPE_SPELL) and c21520008[2]~=0 then
		if Duel.CheckLPCost(player,1024) and Duel.SelectYesNo(player,aux.Stringid(21520008,4)) then
			Duel.PayLPCost(player,1024)
		else
			Duel.Hint(HINT_CARD,player,21520008)
			Duel.NegateEffect(ev)
			rc:CancelToGrave()
			Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
		end
		c21520008[2]=c21520008[2]-1
	elseif rc:IsType(TYPE_TRAP) and c21520008[3]~=0 then
		if Duel.CheckLPCost(player,1024) and Duel.SelectYesNo(player,aux.Stringid(21520008,4)) then
			Duel.PayLPCost(player,1024)
		else
			Duel.Hint(HINT_CARD,player,21520008)
			Duel.NegateEffect(ev)
			rc:CancelToGrave()
			Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
		end
		c21520008[3]=c21520008[3]-1
	end
end
--]]