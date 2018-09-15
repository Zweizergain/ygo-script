--太古龙·虚梦龙
function c10162007.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,c10162007.fusfilter1,c10162007.fusfilter2,c10162007.fusfilter3)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10162007.spcon)
	e2:SetOperation(c10162007.spop)
	c:RegisterEffect(e2)
	--win
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c10162007.winop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Negate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c10162007.disop)
	c:RegisterEffect(e6)
	--destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c10162007.retg)
	e7:SetOperation(c10162007.reop)
	c:RegisterEffect(e7)
	--cannot attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c10162007.antarget)
	c:RegisterEffect(e8)  
end
function c10162007.fusfilter1(c)
	return c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_FUSION) and c:IsFusionSetCard(0x9333)
end
function c10162007.fusfilter2(c)
	return c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_SYNCHRO) and c:IsFusionSetCard(0x9333)
end
function c10162007.fusfilter3(c)
	return c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_XYZ) and c:IsFusionSetCard(0x9333)
end
function c10162007.antarget(e,c)
	return c~=e:GetHandler()
end
function c10162007.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(10162007,1)) then
		return true
	else return false end
end
function c10162007.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c10162007.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsContains(e:GetHandler()) or not Duel.IsChainDisablable(ev) then return false end
	local rc=re:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if Duel.SelectYesNo(tp,aux.Stringid(10162007,2)) then
	   Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
		Duel.NegateEffect(ev)
		if rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end
function c10162007.winop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)==1 then
	   Duel.Hint(HINT_CARD,0,10162007)
	   Duel.SetLP(1-tp,0)
	end
end
function c10162007.cfilter(c,fc)
	return (c:IsFusionType(TYPE_FUSION) or c:IsFusionType(TYPE_XYZ) or c:IsFusionType(TYPE_SYNCHRO)) and c:IsFusionSetCard(0x9333) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc) and not c:IsHasEffect(6205579)
end
function c10162007.fcheck(c,sg,g,ftype,...)
	if not c:IsFusionType(ftype) then return false end
	if ... then
		g:AddCard(c)
		local res=sg:IsExists(c10162007.fcheck,1,g,sg,g,...)
		g:RemoveCard(c)
		return res
	else return true end
end
function c10162007.fselect(c,tp,mg,sg,...)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<3 then
		res=mg:IsExists(c10162007.fselect,1,sg,tp,mg,sg,...)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		local g=Group.CreateGroup()
		res=sg:IsExists(c10162007.fcheck,1,nil,sg,g,...)
	end
	sg:RemoveCard(c)
	return res
end
function c10162007.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c10162007.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	local sg=Group.CreateGroup()
	return mg:IsExists(c10162007.fselect,1,nil,tp,mg,sg,TYPE_XYZ,TYPE_SYNCHRO,TYPE_FUSION)
end
function c10162007.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c10162007.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	local sg=Group.CreateGroup()
	while sg:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=mg:FilterSelect(tp,c10162007.fselect,1,1,sg,tp,mg,sg,TYPE_XYZ,TYPE_SYNCHRO,TYPE_FUSION)
		sg:Merge(g)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end