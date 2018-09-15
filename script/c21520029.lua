--极乱数 亢奋
function c21520029.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c21520029.ffilter,3,99,true)
	--special summon rule
	local se2=Effect.CreateEffect(c)
	se2:SetType(EFFECT_TYPE_FIELD)
	se2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	se2:SetCode(EFFECT_SPSUMMON_PROC)
	se2:SetRange(LOCATION_EXTRA)
	se2:SetCondition(c21520029.spcondition)
	se2:SetOperation(c21520029.spoperation)
	se2:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(se2)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c21520029.splimit)
	c:RegisterEffect(e0)
	--change attack & defence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520029,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520029.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetOperation(c21520029.defval)
	c:RegisterEffect(e2)
	--summons
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520029,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(c21520029.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetOperation(c21520029.defval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c21520029.defval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetOperation(c21520029.defval)
	c:RegisterEffect(e8)
	--rest
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_TRIGGER)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e9:SetCondition(c21520029.restcon)
	e9:SetTarget(c21520029.resttg)
--	e9:SetOperation(c21520029.restop)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e10)
end
function c21520029.MinValue(...)
	local val=...
	return val or 0
end
function c21520029.MaxValue(...)
	local val=...
	local g=Duel.GetMatchingGroup(c21520029.vfilter,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if val==nil then val=g:GetCount()*400 end
	return val
end
function c21520029.vfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c21520029.ffilter(c,fc)
	return c:IsFusionSetCard(0x493) and c:IsType(TYPE_MONSTER)
end
function c21520029.cfilter(c)
	return c:IsFusionSetCard(0x493) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c21520029.fgoal(c,tp,sg)
	return sg:GetCount()>2 and Duel.GetLocationCountFromEx(tp,tp,sg)>0
end
function c21520029.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=c21520029.fgoal(c,tp,sg) or mg:IsExists(c21520029.fselect,1,sg,tp,mg,sg)
	sg:RemoveCard(c)
	return res
end
function c21520029.spcondition(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c21520029.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(c21520029.fselect,1,nil,tp,mg,sg)
end
function c21520029.spoperation(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c21520029.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local sg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(c21520029.fselect,sg,tp,mg,sg)
		if cg:GetCount()==0
			or (c21520029.fgoal(c,tp,sg) and not Duel.SelectYesNo(tp,210)) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=cg:Select(tp,1,1,nil)
		sg:Merge(g)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function c21520029.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsSetCard(0x493)
end
function c21520029.atkval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520029.MinValue()
	local tempmax=c21520029.MaxValue()
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,21520012,RESET_PHASE+PHASE_END,0,1)
	local ct=Duel.GetFlagEffect(tp,21520012)+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+14142+4
	math.randomseed(c:GetFieldID()+ct*14000)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520029.defval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520029.MinValue()
	local tempmax=c21520029.MaxValue()
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,21520012,RESET_PHASE+PHASE_END,0,1)
	local ct=Duel.GetFlagEffect(tp,21520012)+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+14142+5
	math.randomseed(c:GetFieldID()+ct*15000)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520029.restcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tempmin=c21520029.MinValue()
	local tempmax=c21520029.MaxValue()
	return c:GetAttack()>=tempmax/2 and c:GetAttack()>0
end
function c21520029.resttg(e,c)
	return not c:IsSetCard(0x493) and c:IsStatus(STATUS_SUMMON_TURN+STATUS_FLIP_SUMMON_TURN+STATUS_SPSUMMON_TURN) 
end
--[[
function c21520029.restfilter(c)
	return not c:IsSetCard(0x493)
end
function c21520029.resttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c21520029.restfilter,1,nil) end
	local g=eg:Filter(c21520029.restfilter,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c21520029.restop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tempmin=c21520029.MinValue()
	local tempmax=c21520029.MaxValue()
	if c:GetAttack()>=tempmax/2 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		local tc=g:GetFirst()
		local g1=Group.CreateGroup()
		local g2=Group.CreateGroup()
		local p1=0
		local p2=0
		while tc do
			local player=tc:GetControler()
			if player==tp and Duel.IsExistingMatchingCard(Card.IsDiscardable,player,LOCATION_HAND,0,1,nil) then
				p1=p1+1
				g1:AddCard(tc)
			else
				p2=p2+1
				g2:AddCard(tc)
			end
			tc=g:GetNext()
		end
		if p1~=0 and Duel.SelectYesNo(tp,aux.Stringid(21520029,1)) then
			Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		else
			local tc1=g1:GetFirst()
			while tc1 do
				Duel.ChangePosition(tc1,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetRange(LOCATION_MZONE)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc1:RegisterEffect(e1)
				tc1=g1:GetNext()
			end
		end
		if p2~=0 and Duel.SelectYesNo(1-tp,aux.Stringid(21520029,1)) then
			Duel.DiscardHand(1-tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		else
			local tc2=g2:GetFirst()
			while tc2 do
				Duel.ChangePosition(tc2,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetRange(LOCATION_MZONE)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc2:RegisterEffect(e1)
				tc2=g2:GetNext()
			end
		end
	end
end
--]]