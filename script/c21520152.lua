--星曜成像-幻影魔龙
function c21520152.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c21520152.spcon)
	c:RegisterEffect(e1)
	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	--atk & def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c21520152.aval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_BASE_DEFENSE)
	e4:SetValue(c21520152.dval)
	c:RegisterEffect(e4)
	--self tograve
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SELF_TOGRAVE)
	e5:SetCondition(c21520152.sdcon)
	c:RegisterEffect(e5)
	--add name
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_ADD_CODE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(21520133)
	c:RegisterEffect(e6)
	--negate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(21520152,0))
	e7:SetCategory(CATEGORY_NEGATE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_CHAINING)
	e7:SetCondition(c21520152.discon)
	e7:SetCost(c21520152.discost)
	e7:SetTarget(c21520152.distg)
	e7:SetOperation(c21520152.disop)
	c:RegisterEffect(e7)
end
function c21520152.spfilter1(c)
	return (c:IsSetCard(0x491) and not c:IsSetCard(0x5491)) and (not c:IsOnField() or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
end
function c21520152.spfilter2(c)
	return c:IsSetCard(0x5491) and (not c:IsOnField() or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
end
function c21520152.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g1=Duel.GetMatchingGroup(c21520152.spfilter1,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c21520152.spfilter2,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local ct1=g1:GetClassCount(Card.GetCode)
	local ct2=g2:GetClassCount(Card.GetCode)
	return ct1>6 and ct2>0
end
function c21520152.aval(e,c)
	local g=Duel.GetMatchingGroup(c21520152.spfilter1,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		sum=sum+tc:GetAttack()
		tc=g:GetNext()
	end
	return sum
end
function c21520152.dval(e,c)
	local g=Duel.GetMatchingGroup(c21520152.spfilter1,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		sum=sum+tc:GetDefense()
		tc=g:GetNext()
	end
	return sum
end
function c21520152.sdfilter(c)
	return (not c:IsSetCard(0x491) or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
end
function c21520152.sdcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c21520152.sdfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
--	local rg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,0x492)
--	g:Sub(rg)
	return g:GetCount()>0
end
function c21520152.rpfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c21520152.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev)
end
function c21520152.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520152.rpfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21520152.rpfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21520152.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c21520152.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	Duel.NegateActivation(ev)
end
