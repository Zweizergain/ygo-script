--邪魂之源·彼岸 魔王帕姆
function c17020019.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,c17020019.fusfilter1,c17020019.fusfilter2,c17020019.fusfilter3,c17020019.fusfilter4,c17020019.fusfilter5)
	aux.EnablePendulumAttribute(c,false)  
	Duel.EnableGlobalFlag(GLOBALFLAG_SPSUMMON_COUNT)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c17020019.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c17020019.spcon2)
	e2:SetOperation(c17020019.spop2)
	c:RegisterEffect(e2)
	--spfrom P
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17020019,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(c17020019.spcost)
	e3:SetTarget(c17020019.sptg)
	e3:SetOperation(c17020019.spop)
	c:RegisterEffect(e3)
	--spsummon count limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e4:SetRange(LOCATION_PZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetValue(1)
	c:RegisterEffect(e4) 
	--cannot target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.indoval)
	c:RegisterEffect(e5) 
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c17020019.efilter)
	c:RegisterEffect(e7)
	--atk
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SET_ATTACK_FINAL)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c17020019.atkcon)
	e8:SetValue(c17020019.atkval)
	c:RegisterEffect(e8)
	--pendulum
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(17020019,1))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_LEAVE_FIELD)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCondition(c17020019.pencon)
	e8:SetTarget(c17020019.pentg)
	e8:SetOperation(c17020019.penop)
	c:RegisterEffect(e8)
	if not c17020019.global_flag then
		c17020019.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c17020019.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c17020019.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c17020019.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c17020019.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c17020019.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()
end
function c17020019.atkval(e,c)
	local atk=Duel.GetAttackTarget():GetAttack()
	local def=Duel.GetAttackTarget():GetDefense()
	local ct=math.max(atk,def)
	return ct+e:GetHandler():GetBaseAttack()
end
function c17020019.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c17020019.cfilter(c,tp)
	return c17020019.cfilter2(c) and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c17020019.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,3,c)
end
function c17020019.cfilter2(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsAbleToRemoveAsCost()
end
function c17020019.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17020019.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c17020019.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c17020019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17020019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c17020019.cfilterx(c)
	return c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial() and c:IsFaceup() and (c:IsFusionType(TYPE_FUSION) or c:IsFusionType(TYPE_SYNCHRO) or c:IsFusionType(TYPE_XYZ) or c:IsFusionType(TYPE_PENDULUM) or c:IsFusionType(TYPE_LINK))
end
function c17020019.fcheck(c,sg,g,ctype,...)
	if not c:IsFusionType(ctype) then return false end
	if ... then
		g:AddCard(c)
		local res=sg:IsExists(c17020019.fcheck,1,g,sg,g,...)
		g:RemoveCard(c)
		return res
	else return true end
end
function c17020019.fselect(c,tp,mg,sg,...)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<5 then
		res=mg:IsExists(c17020019.fselect,1,sg,tp,mg,sg,...)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		local g=Group.CreateGroup()
		res=sg:IsExists(c17020019.fcheck,1,nil,sg,g,...)
	end
	sg:RemoveCard(c)
	return res
end
function c17020019.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c17020019.cfilterx,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(c17020019.fselect,1,nil,tp,mg,sg,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK) and Duel.GetFlagEffect(tp,17020019)>0 and Duel.GetFlagEffect(tp,17020020)>0 and Duel.GetFlagEffect(tp,17020021)>0 and Duel.GetFlagEffect(tp,17020022)>0 and Duel.GetFlagEffect(tp,17020023)>0
end
function c17020019.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c17020019.cfilterx,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=mg:FilterSelect(tp,c17020019.fselect,1,1,sg,tp,mg,sg,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK)
		sg:Merge(g)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c17020019.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c17020019.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsType(TYPE_FUSION) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),17020019,0,0,0)
		end
		if tc:IsType(TYPE_SYNCHRO) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),17020020,0,0,0)
		end
		if tc:IsType(TYPE_PENDULUM) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),17020021,0,0,0)
		end
		if tc:IsType(TYPE_XYZ) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),17020022,0,0,0)
		end
		if tc:IsType(TYPE_LINK) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),17020023,0,0,0)
		end
	end
end
function c17020019.fusfilter1(c)
	return c:IsFusionType(TYPE_FUSION)
end
function c17020019.fusfilter2(c)
	return c:IsFusionType(TYPE_SYNCHRO)
end
function c17020019.fusfilter3(c)
	return c:IsFusionType(TYPE_XYZ)
end
function c17020019.fusfilter4(c)
	return c:IsFusionType(TYPE_PENDULUM)
end
function c17020019.fusfilter5(c)
	return c:IsFusionType(TYPE_LINK)
end