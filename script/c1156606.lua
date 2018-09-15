--色彩艳丽的门卫
function c1156606.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c1156606.lkcon)
	e0:SetOperation(c1156606.lkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
--
	if not c1156606.check then
		c1156606.check=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(c1156606.con1)
		e1:SetOperation(c1156606.op1)
		Duel.RegisterEffect(e1,0)
	end
--  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c1156606.val2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c1156606.tg3)
	e3:SetValue(1)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1156606,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetTarget(c1156606.tg4)
	e4:SetOperation(c1156606.op4)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1156606,0))
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c1156606.con5)
	e5:SetTarget(c1156606.tg5)
	e5:SetOperation(c1156606.op4)
	c:RegisterEffect(e5)
--
end
--
function c1156606.con1(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_MZONE 
end
--
function c1156606.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	tc:RegisterFlagEffect(1156606,RESET_EVENT+0x1fe0000,0,0)
end
--
function c1156606.lkfilter(c,lc,tp)
	local flag=c:IsCanBeLinkMaterial(lc)
	return flag and ((c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH)) or (c:GetFlagEffect(1156606)<1))
end
function c1156606.lvfilter(c)
	if c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:GetLink()>1 then return 1+0x10000*c:GetLink()
	else return 1 
	end
end
--
function c1156606.lcheck(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(c1156606.lvfilter,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function c1156606.lkchenk(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=c1156606.lcheck(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(c1156606.lkchenk,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
--
function c1156606.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c1156606.lkfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=2
	local maxc=3
	if ct>maxc then return false end
	return c1156606.lcheck(tp,sg,c,minc,ct) or mg:IsExists(c1156606.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc)
end
--
function c1156606.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c1156606.lkfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		sg:AddCard(pe:GetHandler())
	end
	local ct=sg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	sg:Select(tp,ct,ct,nil)
	local minc=2
	local maxc=3
	for i=ct,maxc-1 do
		local cg=mg:Filter(c1156606.lkchenk,sg,tp,sg,mg,c,i,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c1156606.lcheck(tp,sg,c,minc,i) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g=cg:Select(tp,minct,1,nil)
		if g:GetCount()==0 then break end
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	local sc=sg:GetFirst()
	local hg=Group.CreateGroup()
	local tg=Group.CreateGroup()
	while sc do
		if sc:GetFlagEffect(1156606)<1 and (sc:IsAbleToDeckAsCost() or sc:IsAbleToExtraAsCost()) then
			hg:AddCard(sc)
			Duel.HintSelection(hg)
			if Duel.SelectYesNo(tp,aux.Stringid(1156606,0)) then
				tg:AddCard(sc)
			end
			hg:RemoveCard(sc)
		end
		sc=sg:GetNext()
	end
	if tg:GetCount()>0 then 
		Duel.SendtoDeck(tg,nil,2,REASON_COST)
		Duel.ShuffleDeck(tp)
		sg:Sub(tg)
	end
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end
--
function c1156606.val2(e,c)
	return c~=e:GetHandler()
end
--
function c1156606.tg3(e,c)
	return c~=e:GetHandler()
end
--
function c1156606.tfilter4(c)
	return c:IsSpecialSummonable(SUMMON_TYPE_LINK)
end
function c1156606.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	if chk==0 then 
		if ((t==c and t:IsAbleToExtra()) or (a==c and t~=nil and a:IsAbleToExtra())) then
			local e4_1=Effect.CreateEffect(c)
			e4_1:SetType(EFFECT_TYPE_SINGLE)
			e4_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e4_1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e4_1:SetValue(1)
			c:RegisterEffect(e4_1,true)
			if Duel.IsExistingMatchingCard(c1156606.tfilter4,tp,LOCATION_EXTRA,0,1,nil) then
				e4_1:Reset()
				return true
			else
				e4_1:Reset()
				return false
			end
		else
			return false
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
--
function c1156606.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1156606.tfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.BreakEffect()
		Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK)
	end
end
--
function c1156606.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
--
function c1156606.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local e4_1=Effect.CreateEffect(c)
	e4_1:SetType(EFFECT_TYPE_SINGLE)
	e4_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4_1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e4_1:SetValue(1)
	c:RegisterEffect(e4_1,true)
	if chk==0 then 
		if Duel.IsExistingMatchingCard(c1156606.tfilter4,tp,LOCATION_EXTRA,0,1,nil) then
			e4_1:Reset()
			return true
		else
			e4_1:Reset()
			return false
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
--
