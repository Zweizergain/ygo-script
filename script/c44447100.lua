--百夜·白龙
function c44447100.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44447100,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c44447100.sprcon)
	e1:SetOperation(c44447100.sprop)
	c:RegisterEffect(e1)
	--Normal monster
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_ADD_TYPE)
	e11:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e11:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e11)
	--Equip
	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(44447001,0))
	e22:SetCategory(CATEGORY_EQUIP)
	e22:SetRange(LOCATION_MZONE)
	e22:SetType(EFFECT_TYPE_QUICK_O)
	e22:SetCode(EVENT_FREE_CHAIN)
	e22:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e22:SetHintTiming(0,TIMING_END_PHASE)
	e22:SetCountLimit(1)
	e22:SetCondition(c44447001.eqcon)
	e22:SetTarget(c44447001.eqtg)
	e22:SetOperation(c44447001.eqop)
	c:RegisterEffect(e22)
end
function c44447100.sprfilter(c)
	return (c:IsSummonType(SUMMON_TYPE_RITUAL) or bit.band(c:GetSummonType(),SUMMON_TYPE_NORMAL)==SUMMON_TYPE_NORMAL)
	and c:IsFaceup() and c:IsReleasable() and c:IsSetCard(0x644)
end
function c44447100.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c44447100.sprfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c44447100.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c44447100.sprfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
--Equip
function c44447001.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c44447001.eqfilter(c)
	return not c:IsForbidden() and c:IsSetCard(0x644)
end
function c44447001.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(c44447001.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c44447001.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,c44447001.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,true) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c44447001.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c44447001.eqlimit(e,c)
	return e:GetOwner()==c
end