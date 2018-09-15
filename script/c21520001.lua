--乱数原符-R
function c21520001.initial_effect(c)
	--change attack & defence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520001,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520001.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetOperation(c21520001.defval)
	c:RegisterEffect(e2)
	--summons
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520001,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(c21520001.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetOperation(c21520001.defval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c21520001.defval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetOperation(c21520001.defval)
	c:RegisterEffect(e8)
	--copy
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(21520001,1))
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1,21520001)
	e9:SetCondition(c21520001.condition)
	e9:SetTarget(c21520001.target)
	e9:SetOperation(c21520001.operation)
	c:RegisterEffect(e9)
	--unaffect
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(21520001,2))
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetRange(LOCATION_HAND)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetCountLimit(1,21520001)
	e11:SetCost(c21520001.ecost)
	e11:SetTarget(c21520001.etg)
	e11:SetOperation(c21520001.eop)
	c:RegisterEffect(e11)
end
function c21520001.MinValue(...)
	local val=...
	return val or 0
end
function c21520001.MaxValue(...)
	local val=...
	return val or 448
end
function c21520001.atkval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520001.MinValue()
	local tempmax=c21520001.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+448)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520001.defval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520001.MinValue()
	local tempmax=c21520001.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+448+1)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520001.condition(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520001.MinValue()
	local tempmax=c21520001.MaxValue()
	local c=e:GetHandler()
	return c:GetAttack()>=tempmax/2
end
function c21520001.cfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c21520001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c21520001.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21520001.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c21520001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520001.cfilter,tp,LOCATION_GRAVE,0,nil)
	local rg=g:RandomSelect(tp,1)
	Duel.SetTargetCard(rg)
	local tc=rg:GetFirst()
	if c:IsRelateToEffect(e) and c:IsFaceup() then --
		local code=tc:GetOriginalCode()
		local reset_flag = RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(reset_flag)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code,reset_flag)
	end
end
function c21520001.ecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c21520001.filter(e,c)
	return c:IsFaceup()
end
function c21520001.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c21520001.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c21520001.efilter)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	
	--not randomly
	local ng=Duel.GetMatchingGroup(c21520001.nrfilter,tp,LOCATION_MZONE,0,nil)
	if ng:GetCount()>0 and not Duel.IsExistingMatchingCard(c21520001.chkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		tc=ng:GetFirst()
		local sum=0
		while tc do
			if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetOriginalRank()
			else sum=sum+tc:GetOriginalLevel() end
			tc=ng:GetNext()
		end
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		Duel.BreakEffect()
		Duel.Damage(tp,sum*500,REASON_RULE)
	end
--[[	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c21520001.filter)
	e1:SetValue(c21520001.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,21520001,RESET_PHASE+PHASE_END,0,1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetDescription(aux.Stringid(21520001,1))
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabelObject(tc)
	e2:SetCondition(c21520001.con)
	e2:SetOperation(c21520001.op)
	Duel.RegisterEffect(e2,tp)--]]
end
function c21520001.nrfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x493)
end
function c21520001.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.GetFlagEffect(tp,21520011)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c21520001.op(e,tp,eg,ep,ev,re,r,rp)
	local ng=Duel.GetMatchingGroup(c21520001.nrfilter,tp,LOCATION_MZONE,0,nil)
	if ng:GetCount()>0 then
		local tc=ng:GetFirst()
		local sum=0
		while tc do
			if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetOriginalRank()
			else sum=sum+tc:GetOriginalLevel() end
			tc=ng:GetNext()
		end
		Duel.Damage(tp,sum*500,REASON_RULE)
	end
end
function c21520001.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x493) and c:IsType(TYPE_FIELD)
end
function c21520001.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

--math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
--math.random(0,3200)