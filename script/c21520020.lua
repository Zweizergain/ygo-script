--极乱数 算法核心
function c21520020.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,21520020)
	--special summon
	local se1=Effect.CreateEffect(c)
	se1:SetDescription(aux.Stringid(21520020,1))
	se1:SetType(EFFECT_TYPE_FIELD)
	se1:SetCode(EFFECT_SPSUMMON_PROC)
	se1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	se1:SetRange(LOCATION_HAND)
	se1:SetCondition(c21520020.spcon)
	se1:SetOperation(c21520020.spop)
	c:RegisterEffect(se1)
	local se2=Effect.CreateEffect(c)
	se2:SetDescription(aux.Stringid(21520020,2))
	se2:SetType(EFFECT_TYPE_FIELD)
	se2:SetCode(EFFECT_SPSUMMON_PROC)
	se2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	se2:SetRange(LOCATION_HAND)
	se2:SetCondition(c21520020.spcon2)
	se2:SetOperation(c21520020.spop2)
	c:RegisterEffect(se2)
--[[	local se0=Effect.CreateEffect(c)
	se0:SetType(EFFECT_TYPE_SINGLE)
	se0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	se0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(se0)--]]
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c21520020.splimit)
	c:RegisterEffect(e0)
	--change attack & defence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520020,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520020.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetOperation(c21520020.defval)
	c:RegisterEffect(e2)
	--summons
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520020,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(c21520020.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetOperation(c21520020.defval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c21520020.defval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetOperation(c21520020.defval)
	c:RegisterEffect(e8)
	--cannot activate
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetTargetRange(1,1)
	e9:SetCondition(c21520020.condition)
	e9:SetValue(c21520020.aclimit)
	c:RegisterEffect(e9)
	--cannot special summon
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e10:SetRange(LOCATION_MZONE)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetTargetRange(1,1)
	e10:SetCondition(c21520020.condition)
	e10:SetTarget(c21520020.spslimit)
	c:RegisterEffect(e10)
end
function c21520020.MinValue(...)
	local val=...
	return val or 0
end
function c21520020.MaxValue(...)
	local val=...
	local g=Duel.GetFieldGroup(0,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if val==nil then val=g:GetCount()*1024 end
	return val
end
function c21520020.spfilter(c,tpe)
	if tpe~=nil then
		return c:IsFaceup() and c:IsReleasable() and c:IsType(tpe)
	else
		return c:IsFaceup() and c:IsReleasable() and c:IsCode(21520020)
	end
end
function c21520020.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return (Duel.IsExistingMatchingCard(c21520020.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_RITUAL)
		and Duel.IsExistingMatchingCard(c21520020.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_FUSION)
		and Duel.IsExistingMatchingCard(c21520020.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_SYNCHRO)
		and Duel.IsExistingMatchingCard(c21520020.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_XYZ))
--		or Duel.IsExistingMatchingCard(c21520020.spfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c21520020.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c21520020.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_RITUAL)
	local tc=g1:GetFirst()
	local sum=0
	if not tc:IsSetCard(0x493) then
		sum=sum+tc:GetOriginalLevel()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c21520020.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_FUSION)
	tc=g2:GetFirst()
	if not tc:IsSetCard(0x493) then
		sum=sum+tc:GetOriginalLevel()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g3=Duel.SelectMatchingCard(tp,c21520020.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_SYNCHRO)
	tc=g3:GetFirst()
	if not tc:IsSetCard(0x493) then
		sum=sum+tc:GetOriginalLevel()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g4=Duel.SelectMatchingCard(tp,c21520020.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_XYZ)
	tc=g4:GetFirst()
	if not tc:IsSetCard(0x493) then
		sum=sum+tc:GetOriginalRank()
	end
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	c:SetMaterial(g1)--]]
	--not randomly
	if sum>0 and not Duel.IsExistingMatchingCard(c21520020.chkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then 
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		Duel.BreakEffect()
		Duel.Damage(tp,sum*500,REASON_RULE)
	end
	Duel.Release(g1,REASON_COST)
end
function c21520020.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x493) and c:IsType(TYPE_FIELD)
end
function c21520020.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c21520020.spfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c21520020.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local rmg=Duel.GetMatchingGroup(c21520020.spfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=rmg:Select(tp,1,1,nil)
	c:SetMaterial(g1)--]]
	Duel.Release(g1,REASON_COST)
end
function c21520020.atkval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520020.MinValue()
	local tempmax=c21520020.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+27182)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520020.defval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520020.MinValue()
	local tempmax=c21520020.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+27182+1)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520020.condition(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520020.MinValue()
	local tempmax=c21520020.MaxValue()
	local c=e:GetHandler()
	return c:GetAttack()>=tempmax/2 and c:GetAttack()>0
end
function c21520020.aclimit(e,te,tp)
	return (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_TRAP)) and not te:GetHandler():IsSetCard(0x493)
end
function c21520020.spslimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x493)
end
function c21520020.splimit(e,se,sp,st)
	return se:GetHandler()==e:GetHandler()
end