--樱火装机神 彼岸樱·六花
function c17020018.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c17020018.ffilter2,2,true)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)  
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17020018,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,17020018)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(c17020018.spcost)
	e1:SetTarget(c17020018.sptg)
	e1:SetOperation(c17020018.spop)
	c:RegisterEffect(e1)  
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c17020018.splimit)
	c:RegisterEffect(e2)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--special summon rule
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(c17020018.sprcon)
	e4:SetOperation(c17020018.sprop)
	c:RegisterEffect(e4)
	--toe
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17020018,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,17020118)
	e5:SetTarget(c17020018.tetg)
	e5:SetOperation(c17020018.teop)
	c:RegisterEffect(e5)
	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(17020018,2))
	e6:SetCategory(CATEGORY_DISABLE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c17020018.discon)
	e6:SetTarget(c17020018.distg)
	e6:SetOperation(c17020018.disop)
	c:RegisterEffect(e6)
	--pendulum
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(17020018,3))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(c17020018.pencon)
	e7:SetTarget(c17020018.pentg)
	e7:SetOperation(c17020018.penop)
	c:RegisterEffect(e7) 
end
function c17020018.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c17020018.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c17020018.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	   Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c17020018.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_SZONE)~=0
		and Duel.IsChainDisablable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c17020018.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c17020018.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c17020018.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17020018.tefilter,tp,LOCATION_REMOVED,0,1,nil) end
end
function c17020018.tefilter(c)
	return c:IsFaceup() and c:IsSetCard(0x702) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17020018.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,c17020018.tefilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if sg:GetCount()>0 then
	   Duel.SendtoExtraP(sg,nil,REASON_EFFECT)
	end
end
function c17020018.matfilter(c)
	return c:IsFusionSetCard(0x702) and c:IsLevelBelow(4)
		and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function c17020018.spfilter1(c,tp,g)
	return g:IsExists(c17020018.spfilter2,1,c,tp,c)
end
function c17020018.spfilter2(c,tp,mc)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c17020018.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c17020018.matfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c17020018.spfilter1,1,nil,tp,g)
end
function c17020018.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c17020018.matfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:FilterSelect(tp,c17020018.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=g:FilterSelect(tp,c17020018.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c17020018.splimit(e,c)
	return not c:IsSetCard(0x702) and not c:IsCode(17020019)
end
function c17020018.ffilter2(c)
	return c:IsFusionSetCard(0x702) and c:IsLevelBelow(4)
end
function c17020018.cfilter(c,tp)
	return c:IsFusionSetCard(0x702) and c:IsLevelAbove(5) and c:IsFaceup() and c:IsAbleToRemoveAsCost() and (c:GetSequence()<5 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c17020018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17020018.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c17020018.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17020018.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c17020018.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end