--沙耶之歌
function c8021.initial_effect(c)
	 c:SetUniqueOnField(1,0,8021)
	--fusion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(c8021.smfilter),4,true)
	c:EnableReviveLimit()
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c8021.splimit)
	c:RegisterEffect(e3)
	--special summon rule
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(c8021.sprcon)
	e4:SetOperation(c8021.sprop)
	c:RegisterEffect(e4)
	--cannot disable
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e10)
	--1
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(8021,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetCondition(c8021.condition)
	e5:SetOperation(c8021.activate)
	c:RegisterEffect(e5)
	--2
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(8021,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c8021.condition1)
	e6:SetOperation(c8021.activate1)
	c:RegisterEffect(e6)
	--3
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(8021,2))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCondition(c8021.condition2)
	e7:SetOperation(c8021.activate2)
	c:RegisterEffect(e7)
end
function c8021.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c8021.smfilter(c)
	return c:IsSetCard(0x901) and c:IsType(TYPE_MONSTER)
end
function c8021.spfilter1(c)
	return c:IsSetCard(0x901) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER)
end
function c8021.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-4
		and Duel.IsExistingMatchingCard(c8021.spfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,4,nil,tp)
end
function c8021.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(8021,0))
	local g1=Duel.SelectMatchingCard(tp,c8021.spfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,4,4,nil,tp)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,REASON_COST)
end
function c8021.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>=Duel.GetLP(1-tp)+20000
end
function c8021.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SelectOption(1-tp,aux.Stringid(8021,3))
	Duel.SelectOption(tp,aux.Stringid(8021,3))
	Duel.SetLP(tp,0)
	Duel.SetLP(1-tp,0)
end
function c8021.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c8021.activate1(e,tp,eg,ep,ev,re,r,rp)
		Duel.SelectOption(1-tp,aux.Stringid(8021,4))
		Duel.SelectOption(tp,aux.Stringid(8021,4))
		local lp1=Duel.GetLP(tp)
		local lp2=Duel.GetLP(1-tp)
		Duel.SetLP(tp,lp2)
		Duel.SetLP(1-tp,lp1)
end
function c8021.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>=Duel.GetLP(1-tp)*10
end
function c8021.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SelectOption(1-tp,aux.Stringid(8021,5))
	Duel.SelectOption(tp,aux.Stringid(8021,5))
	local WIN_REASON_CREATORGOD = 0x13
	Duel.Win(tp,WIN_REASON_CREATORGOD)
end