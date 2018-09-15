--极乱数 汇编
function c21520019.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,9,3,nil,nil,99)
	--xyz material
	local se1=Effect.CreateEffect(c)
	se1:SetDescription(aux.Stringid(21520019,2))
	se1:SetType(EFFECT_TYPE_FIELD)
	se1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	se1:SetCode(EFFECT_SPSUMMON_PROC)
	se1:SetRange(LOCATION_EXTRA)
	se1:SetCondition(c21520019.xyzcondition)
	se1:SetOperation(c21520019.xyzoperation)
	se1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(se1)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c21520019.splimit)
	c:RegisterEffect(e0)
	--change attack & defence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520019,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520019.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetOperation(c21520019.defval)
	c:RegisterEffect(e2)
	--summons
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520019,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(c21520019.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetOperation(c21520019.defval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c21520019.defval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetOperation(c21520019.defval)
	c:RegisterEffect(e8)
	--damage
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e9:SetDescription(aux.Stringid(21520019,1))
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCost(c21520019.thcost)
	e9:SetTarget(c21520019.thtg)
	e9:SetOperation(c21520019.thop)
	c:RegisterEffect(e9)
end
function c21520019.MinValue(...)
	local val=...
	return val or 0
end
function c21520019.MaxValue(...)
	local val=...
	local g=Duel.GetMatchingGroup(c21520019.vfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		sum=sum+tc:GetRank()
		tc=g:GetNext()
	end
	if val==nil then val=sum*400 end
	return val
end
function c21520019.vfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c21520019.cfilter(c,xc)
	return c:IsFaceup() and c:IsSetCard(0x493) and c:IsCanBeXyzMaterial(xc)
end
function c21520019.xgoal(c,tp,sg)
	return sg:GetCount()>2 and Duel.GetLocationCountFromEx(tp,tp,sg)>0
end
function c21520019.xselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=c21520019.xgoal(c,tp,sg) or mg:IsExists(c21520019.xselect,1,sg,tp,mg,sg)
	sg:RemoveCard(c)
	return res
end
function c21520019.xyzcondition(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c21520019.cfilter,tp,LOCATION_MZONE,0,nil,e:GetHandler())
	local sg=Group.CreateGroup()
	return mg:IsExists(c21520019.xselect,1,nil,tp,mg,sg)
end
function c21520019.xyzoperation(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mg=Duel.GetMatchingGroup(c21520019.cfilter,tp,LOCATION_MZONE,0,nil,e:GetHandler())
	local sg=Group.CreateGroup()
	local xg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(c21520019.xselect,sg,tp,mg,sg)
		if cg:GetCount()==0
			or (c21520019.xgoal(c,tp,sg) and not Duel.SelectYesNo(tp,210)) then break end
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
function c21520019.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ or se:GetHandler():IsSetCard(0x493)
end
function c21520019.atkval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520019.MinValue()
	local tempmax=c21520019.MaxValue()
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,21520012,RESET_PHASE+PHASE_END,0,1)
	local ct=Duel.GetFlagEffect(tp,21520012)+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+22360
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
function c21520019.defval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520019.MinValue()
	local tempmax=c21520019.MaxValue()
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,21520012,RESET_PHASE+PHASE_END,0,1)
	local ct=Duel.GetFlagEffect(tp,21520012)+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+22360+1
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
function c21520019.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
end
function c21520019.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,554)
	local op=Duel.SelectOption(tp,70,71,72)
--[[
	if op==0 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520019,3))
	elseif op==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520019,4))
	elseif op==2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520019,5))
	end
--]]
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,1-tp,LOCATION_DECK)
end
function c21520019.thfilter(c,ty)
	return c:IsType(ty) and c:IsAbleToHand()
end
function c21520019.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()==0 then return end
	local g1=nil
	local g2=nil
	local rg1=nil
	local rg2=nil
	local v1=0
	local v2=0
	local cf1=false
	local cf2=false
	if e:GetLabel()==0 then
		g1=Duel.GetMatchingGroup(c21520019.thfilter,tp,LOCATION_DECK,0,nil,TYPE_MONSTER)
		g2=Duel.GetMatchingGroup(c21520019.thfilter,1-tp,LOCATION_DECK,0,nil,TYPE_MONSTER)
	elseif e:GetLabel()==1 then
		g1=Duel.GetMatchingGroup(c21520019.thfilter,tp,LOCATION_DECK,0,nil,TYPE_SPELL)
		g2=Duel.GetMatchingGroup(c21520019.thfilter,1-tp,LOCATION_DECK,0,nil,TYPE_SPELL)
	else
		g1=Duel.GetMatchingGroup(c21520019.thfilter,tp,LOCATION_DECK,0,nil,TYPE_TRAP)
		g2=Duel.GetMatchingGroup(c21520019.thfilter,1-tp,LOCATION_DECK,0,nil,TYPE_TRAP)
	end
	Duel.RegisterFlagEffect(tp,21520012,RESET_PHASE+PHASE_END,0,1)
	local ct1=Duel.GetFlagEffect(tp,21520012)+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+22360+2
	local ct2=Duel.GetFlagEffect(tp,21520012)+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+22360+3
	math.randomseed(c:GetFieldID()+ct1*12000)
	v1=math.random(0,1536)
	math.randomseed(c:GetFieldID()+ct2*13000)
	v2=math.random(0,1536)
	if g1:GetCount()~=0 then
		rg1=g1:RandomSelect(tp,1)
		Duel.ConfirmCards(tp,rg1)
		Duel.ConfirmCards(1-tp,rg1)
		cf1=true
	else
		Duel.Damage(tp,v1,REASON_RULE)
	end
	if g2:GetCount()~=0 then
		rg2=g2:RandomSelect(1-tp,1)
		Duel.ConfirmCards(tp,rg2)
		Duel.ConfirmCards(1-tp,rg2)
		cf2=true
	else
		Duel.Damage(1-tp,v2,REASON_RULE)
	end
	local cg1=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local cg2=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0)
	if cf1==true and cf2==false then
		Duel.SendtoHand(rg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,cg2)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
	elseif cf2==true and cf1==false then
		Duel.SendtoHand(rg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,cg1)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
	elseif cf1==true and cf2==true then
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
	else
		Duel.ConfirmCards(tp,cg2)
		Duel.ConfirmCards(1-tp,cg1)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
	end
	Duel.BreakEffect()
	local tempmin=c21520019.MinValue()
	local tempmax=c21520019.MaxValue()
	if c:GetAttack()<tempmax/2 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
