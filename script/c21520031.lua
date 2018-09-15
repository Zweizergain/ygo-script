--极乱数 脚本
function c21520031.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,9,3,nil,nil,99)
	--xyz material
	local se1=Effect.CreateEffect(c)
	se1:SetDescription(aux.Stringid(21520031,2))
	se1:SetType(EFFECT_TYPE_FIELD)
	se1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	se1:SetCode(EFFECT_SPSUMMON_PROC)
	se1:SetRange(LOCATION_EXTRA)
	se1:SetCondition(c21520031.xyzcondition)
	se1:SetOperation(c21520031.xyzoperation)
	se1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(se1)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c21520031.splimit)
	c:RegisterEffect(e0)
	--change attack & defence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520031,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520031.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetOperation(c21520031.defval)
	c:RegisterEffect(e2)
	--summons
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520031,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(c21520031.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetOperation(c21520031.defval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c21520031.defval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetOperation(c21520031.defval)
	c:RegisterEffect(e8)
	--change effect
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_DISABLE)
	e9:SetDescription(aux.Stringid(21520031,1))
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e9:SetCode(EVENT_CHAINING)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(c21520031.chcon)
	e9:SetCost(c21520031.chcost)
	e9:SetTarget(c21520031.chtg)
	e9:SetOperation(c21520031.chop)
	c:RegisterEffect(e9)
end
function c21520031.MinValue(...)
	local val=...
	return val or 0
end
function c21520031.MaxValue(...)
	local val=...
	local g=Duel.GetMatchingGroup(c21520031.vfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		sum=sum+tc:GetRank()
		tc=g:GetNext()
	end
	if val==nil then val=sum*400 end
	return val
end
function c21520031.vfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c21520031.cfilter(c,xc)
	return c:IsFaceup() and c:IsSetCard(0x493) and c:IsCanBeXyzMaterial(xc)
end
function c21520031.xgoal(c,tp,sg)
	return sg:GetCount()>2 and Duel.GetLocationCountFromEx(tp,tp,sg)>0
end
function c21520031.xselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=c21520031.xgoal(c,tp,sg) or mg:IsExists(c21520031.xselect,1,sg,tp,mg,sg)
	sg:RemoveCard(c)
	return res
end
function c21520031.xyzcondition(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c21520031.cfilter,tp,LOCATION_MZONE,0,nil,e:GetHandler())
	local sg=Group.CreateGroup()
	return mg:IsExists(c21520031.xselect,1,nil,tp,mg,sg)
end
function c21520031.xyzoperation(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mg=Duel.GetMatchingGroup(c21520031.cfilter,tp,LOCATION_MZONE,0,nil,e:GetHandler())
	local sg=Group.CreateGroup()
	local xg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(c21520031.xselect,sg,tp,mg,sg)
		if cg:GetCount()==0
			or (c21520031.xgoal(c,tp,sg) and not Duel.SelectYesNo(tp,210)) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=cg:Select(tp,1,1,nil)
		local tc=g:GetFirst()
		if tc:IsType(TYPE_XYZ) then
			local xyg=tc:GetOverlayGroup()
			if xyg:GetCount()>0 then
				xg:Merge(xyg)
			end
		end
		sg:Merge(g)
	end
	if xg:GetCount()>0 then Duel.SendtoGrave(xg,REASON_RULE) end
	c:SetMaterial(sg)
	Duel.Overlay(c,sg)
end
function c21520031.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsSetCard(0x493)
end
function c21520031.atkval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520031.MinValue()
	local tempmax=c21520031.MaxValue()
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,21520012,RESET_PHASE+PHASE_END,0,1)
	local ct=Duel.GetFlagEffect(tp,21520012)+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+22360+6
	math.randomseed(c:GetFieldID()+ct*16000)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520031.defval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520031.MinValue()
	local tempmax=c21520031.MaxValue()
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,21520012,RESET_PHASE+PHASE_END,0,1)
	local ct=Duel.GetFlagEffect(tp,21520012)+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+22360+7
	math.randomseed(c:GetFieldID()+ct*17000)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520031.chcon(e,tp,eg,ep,ev,re,r,rp)
	return not re:GetHandler():IsCode(21520031) and e:GetHandler():GetFlagEffect(21520031) < e:GetHandler():GetOverlayCount()
end
function c21520031.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	e:GetHandler():RegisterFlagEffect(21520031,RESET_CHAIN,0,1)
end
function c21520031.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c21520031.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local player=re:GetHandler():GetControler()
	local tg=Duel.GetFieldGroup(player,LOCATION_DECK,0)
	if c:GetOverlayCount()==0 or tg:GetCount()==0 then return end
	local rg=tg:RandomSelect(player,1)
	local tc=rg:GetFirst()

	Duel.Hint(HINT_SELECTMSG,player,554)
	local op=Duel.SelectOption(player,70,71,72)
	if op==0 then
		Duel.Hint(HINT_OPSELECTED,1-player,aux.Stringid(21520031,3))
	elseif op==1 then
		Duel.Hint(HINT_OPSELECTED,1-player,aux.Stringid(21520031,4))
	elseif op==2 then
		Duel.Hint(HINT_OPSELECTED,1-player,aux.Stringid(21520031,5))
	end
	Duel.ConfirmCards(player,tc)
	Duel.ConfirmCards(1-player,tc)
	if not ((op==0 and tc:IsType(TYPE_MONSTER)) or (op==1 and tc:IsType(TYPE_SPELL)) or (op==2 and tc:IsType(TYPE_TRAP))) then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c21520031.repop)
	end
	Duel.BreakEffect()
	local tempmin=c21520031.MinValue()
	local tempmax=c21520031.MaxValue()
	if c:GetAttack()<tempmax/2 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
function c21520031.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local player=c:GetControler()
	local v1,v2=0,0
	Duel.RegisterFlagEffect(tp,21520012,RESET_PHASE+PHASE_END,0,1)
	local ct1=Duel.GetFlagEffect(tp,21520012)+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+22360+10
	local ct2=Duel.GetFlagEffect(tp,21520012)+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+22360+20
	math.randomseed(c:GetFieldID()+ct1*18000)
	v1=math.random(0,1024)
	math.randomseed(c:GetFieldID()+ct2*19000)
	v2=math.random(0,1024)
	Duel.Recover(player,v1,REASON_EFFECT)
	Duel.Recover(1-player,v2,REASON_EFFECT)
end
--[[
function c21520031.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x493)
end
function c21520031.xyzcondition(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c21520031.xyzfilter,tp,LOCATION_MZONE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and mg:GetCount()>=3
end
function c21520031.xyzoperation(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mg=Duel.GetMatchingGroup(c21520031.xyzfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=mg:Select(tp,3,99,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsType(TYPE_XYZ) then
			local sg=tc:GetOverlayGroup()
			if sg:GetCount()>0 then
				Duel.SendtoGrave(sg,REASON_RULE)
			end
		end
		tc=g:GetNext()
	end
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end--]]