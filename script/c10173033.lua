--辣鸡嘿白
function c10173033.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173033,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.SynCondition(nil,aux.NonTuner(nil),1,99))
	e1:SetTarget(aux.SynTarget(nil,aux.NonTuner(nil),1,99))
	e1:SetOperation(aux.SynOperation(nil,aux.NonTuner(nil),1,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(10173033,1))
	e2:SetCondition(c10173033.syncon)
	e2:SetTarget(c10173033.syntg)
	e2:SetOperation(c10173033.synop)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e2)
	--cannot release
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_RELEASE)
	e3:SetTargetRange(0,1)
	e3:SetTarget(c10173033.rtg)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e4)
	--directattack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCondition(c10173033.rcon)
	c:RegisterEffect(e5)
	--toekn
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10173033,2))
	e6:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c10173033.spcon)
	e6:SetTarget(c10173033.sptg)
	e6:SetOperation(c10173033.spop)
	c:RegisterEffect(e6)
end
function c10173033.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c10173033.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,73915052,0,0x4011,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,73915052,0,0x4011,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c10173033.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local ft1,ft2,tf1,tf2=Duel.GetLocationCount(tp,LOCATION_MZONE),Duel.GetLocationCount(1-tp,LOCATION_MZONE),Duel.IsPlayerCanSpecialSummonMonster(tp,73915052,0,0x4011,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE),Duel.IsPlayerCanSpecialSummonMonster(tp,73915052,0,0x4011,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE,1-tp)
	if ft1<=0 or ft2<=0 or not tf1 or not tf2 then return end
	local ct,t,i,p,y,token=math.min(ft1,ft2),{},1,1,1
	for i=1,ct do 
		t[p]=i p=p+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10173033,3))
	local ct2,ct3=Duel.AnnounceNumber(tp,table.unpack(t))
	for i=1,ct2 do
		y=i
		if i==5 then y=math.random(1,4) end
		token=Duel.CreateToken(tp,73915051+y)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		token=Duel.CreateToken(tp,73915051+y)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
end
function c10173033.matfilter1(c,syncard)
	return c:IsType(TYPE_TOKEN) and (c:IsNotTuner() or c:GetLevel()>=2) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
		and Duel.IsExistingMatchingCard(c10173033.matfilter2,0,LOCATION_MZONE,LOCATION_MZONE,1,c,syncard)
end
function c10173033.matfilter2(c,syncard)
	return c:IsNotTuner() and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c10173033.synfilter(c,syncard,lv,g2,minc)
	if lv-1<=0 then return false end
	local g=g2:Clone()
	g:RemoveCard(c)
	return g:CheckWithSumEqual(Card.GetSynchroLevel,lv-1,minc-1,99,syncard)
end
function c10173033.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local ct=-Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=2
	if minc<ct then minc=ct end
	local g1=nil
	local g2=nil
	if mg then
		g1=mg:Filter(c10173033.matfilter1,nil,c)
		g2=mg:Filter(c10173033.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c10173033.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c10173033.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		return c10173033.synfilter(tuner,c,lv,g2,minc)
	end
	if not pe then
		return g1:IsExists(c10173033.synfilter,1,nil,c,lv,g2,minc)
	else
		return c10173033.synfilter(pe:GetOwner(),c,lv,g2,minc)
	end
end
function c10173033.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	if mg then
		g1=mg:Filter(c10173033.matfilter1,nil,c)
		g2=mg:Filter(c10173033.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c10173033.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c10173033.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	end
	local ct=-Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=2
	if minc<ct then minc=ct end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		g2:RemoveCard(tuner)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m2=g2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv-1,minc-1,63,c)
		g:Merge(m2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner=nil
		if not pe then
			tuner=g1:FilterSelect(tp,c10173033.synfilter,1,1,nil,c,lv,g2,minc):GetFirst()
		else
			tuner=pe:GetOwner()
			Group.FromCards(tuner):Select(tp,1,1,nil)
		end
		tuner:RegisterFlagEffect(10173033,RESET_EVENT+0x1fe0000,0,1)
		g:AddCard(tuner)
		g2:RemoveCard(tuner)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m2=g2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv-1,minc-1,63,c)
		g:Merge(m2)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c10173033.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function c10173033.rcon(e)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil,TYPE_TOKEN)
	return ct>0 and ct==Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)
end
function c10173033.rtg(e,c)
	return c:IsType(TYPE_TOKEN)
end