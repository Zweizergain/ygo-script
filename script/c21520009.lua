--极乱数 寂寞
function c21520009.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c21520009.ffilter,3,99,true)
--[[	--fusion material
	local se1=Effect.CreateEffect(c)
	se1:SetType(EFFECT_TYPE_SINGLE)
	se1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	se1:SetCode(EFFECT_FUSION_MATERIAL)
	se1:SetCondition(c21520009.fscondition)
	se1:SetOperation(c21520009.fsoperation)
	c:RegisterEffect(se1)--]]
	--special summon rule
	local se2=Effect.CreateEffect(c)
	se2:SetType(EFFECT_TYPE_FIELD)
	se2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	se2:SetCode(EFFECT_SPSUMMON_PROC)
	se2:SetRange(LOCATION_EXTRA)
	se2:SetCondition(c21520009.spcondition)
	se2:SetOperation(c21520009.spoperation)
	se2:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(se2)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c21520009.splimit)
	c:RegisterEffect(e0)
	--change attack & defence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520009,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520009.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetOperation(c21520009.defval)
	c:RegisterEffect(e2)
	--summons
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520009,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(c21520009.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetOperation(c21520009.defval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c21520009.defval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetOperation(c21520009.defval)
	c:RegisterEffect(e8)
	--negate
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EVENT_CHAIN_ACTIVATING)
	e9:SetOperation(c21520009.disop)
	c:RegisterEffect(e9)
end
function c21520009.MinValue(...)
	local val=...
	return val or 0
end
function c21520009.MaxValue(...)
	local val=...
	local g=Duel.GetMatchingGroup(c21520009.vfilter,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if val==nil then val=g:GetCount()*400 end
	return val
end
function c21520009.vfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c21520009.ffilter(c,fc)
	return c:IsFusionSetCard(0x493) and c:IsType(TYPE_MONSTER)
end
function c21520009.cfilter(c)
	return c:IsSetCard(0x493) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c21520009.fgoal(c,tp,sg)
	return sg:GetCount()>2 and Duel.GetLocationCountFromEx(tp,tp,sg)>0
end
function c21520009.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=c21520009.fgoal(c,tp,sg) or mg:IsExists(c21520009.fselect,1,sg,tp,mg,sg)
	sg:RemoveCard(c)
	return res
end
function c21520009.spcondition(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c21520009.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(c21520009.fselect,1,nil,tp,mg,sg)
end
function c21520009.spoperation(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c21520009.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local sg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(c21520009.fselect,sg,tp,mg,sg)
		if cg:GetCount()==0
			or (c21520009.fgoal(c,tp,sg) and not Duel.SelectYesNo(tp,210)) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=cg:Select(tp,1,1,nil)
		sg:Merge(g)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function c21520009.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsSetCard(0x493)
end
function c21520009.atkval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520009.MinValue()
	local tempmax=c21520009.MaxValue()
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,21520012,RESET_PHASE+PHASE_END,0,1)
	local ct=Duel.GetFlagEffect(tp,21520012)+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+14142
	math.randomseed(c:GetFieldID()+ct*10000)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520009.defval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520009.MinValue()
	local tempmax=c21520009.MaxValue()
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,21520012,RESET_PHASE+PHASE_END,0,1)
	local ct=Duel.GetFlagEffect(tp,21520012)+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+14142+1
	math.randomseed(c:GetFieldID()+ct*11000)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520009.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local tempmin=c21520009.MinValue()
	local tempmax=c21520009.MaxValue()
	local c=e:GetHandler()
	local player=rc:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
	if c:GetAttack()>=tempmax/2 and c:GetAttack()>0 and Duel.IsPlayerCanRemove(tp,rc) and not rc:IsLocation(LOCATION_REMOVED) then
		if rg:GetCount()<3 or rc:IsSetCard(0x493) then return end
		Duel.Hint(HINT_CARD,player,21520009)
		local rdg=rg:RandomSelect(tp,3)
		Duel.SendtoDeck(rdg,nil,2,REASON_EFFECT)
		Duel.NegateEffect(ev)
		if rc:IsRelateToEffect(re) or rc:IsAbleToRemove() then
			Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
			if Duel.IsExistingMatchingCard(Card.IsAbleToHand,player,LOCATION_REMOVED,0,1,rc) 
				and Duel.SelectYesNo(player,aux.Stringid(21520009,1)) then
				local g=Duel.GetMatchingGroup(Card.IsAbleToHand,player,LOCATION_REMOVED,0,rc)
				local tg=g:RandomSelect(player,1)
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-player,tg)
			end
		end
	end
end
--[[
function c21520009.fscondition(e,g,gc,chkf)
	if g==nil then return false end
	if gc then return c21520009.ffilter(gc) and g:IsExists(c21520009.ffilter,1,gc) end
	local g1=g:Filter(c21520009.ffilter,nil)
	if chkf~=PLAYER_NONE then
		return g1:FilterCount(Card.IsOnField,nil)~=0 and g1:GetCount()>=2
	else return g1:GetCount()>=2 end
end
function c21520009.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if gc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=eg:FilterSelect(tp,c21520009.ffilter,1,100,gc)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=eg:Filter(c21520009.ffilter,nil)
	if chkf==PLAYER_NONE or sg:GetCount()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,2,100,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,100,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function c21520009.fscondition(e,g,gc,chkf)
	if g==nil then return false end
	if gc then return false end
	return g:IsExists(c21520009.ffilter,3,nil,e:GetHandler())
end
function c21520009.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	Duel.SetFusionMaterial(eg:FilterSelect(tp,c21520009.ffilter,3,100,nil,e:GetHandler()))
end
function c21520009.spcondition(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mg=Duel.GetMatchingGroup(c21520009.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	if ft>0 then 
		return mg:GetCount()>=3
	else
		return mg:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) and mg:GetCount()>=3
	end
end
function c21520009.spoperation(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mg=Duel.GetMatchingGroup(c21520009.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local g=Group.CreateGroup()
	if ft>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=mg:Select(tp,3,mg:GetCount(),nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=mg:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=mg:Select(tp,2,mg:GetCount()-1,sg1:GetFirst())
		g:Merge(sg1)
		g:Merge(sg2)
	end
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
-]]