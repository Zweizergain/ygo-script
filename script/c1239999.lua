--红萌馆全员出击！
function c1239999.initial_effect(c)
	if not c1239999.global_check then 
		c1239999.global_check=true
		--adjust
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		e4:SetOperation(c1239999.adjustop)
		Duel.RegisterEffect(e4,0)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		e4:SetOperation(c1239999.adjustop2)
		Duel.RegisterEffect(e4,1)
	end 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1239999,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c1239999.matcon)
	e2:SetTarget(c1239999.sptg)
	e2:SetOperation(c1239999.spop)
	c:RegisterEffect(e2)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetTarget(c1239999.sptg2)
	e5:SetOperation(c1239999.spop2)
	c:RegisterEffect(e5)
end
function c1239999.spfilter(c,e,tp)
	return c:IsSetCard(0x813) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
end
function c1239999.filter(c,tp)
	return c:GetPreviousLocation()==LOCATION_EXTRA and c:GetControler()==tp
end
function c1239999.matcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,1239999)==0
end
function c1239999.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c1239999.filter,1,nil,0) then Duel.RegisterFlagEffect(0,1239999,RESET_PHASE+PHASE_END,0,1) end 
end
function c1239999.adjustop2(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c1239999.filter,1,nil,1) then Duel.RegisterFlagEffect(1,1239999,RESET_PHASE+PHASE_END,0,1) end 
end
function c1239999.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then 
		local seq=e:GetHandler():GetSequence()
		if Duel.GetFieldCard(tp,LOCATION_MZONE,seq) then return false end 
		return Duel.IsExistingMatchingCard(c1239999.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)  
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,e:GetLabel(),0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c1239999.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c1239999.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.MoveSequence(g:GetFirst(),e:GetHandler():GetSequence())
	end
end
function c1239999.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,true) and c:IsSetCard(0x813)
end
function c1239999.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1239999.filter2,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c1239999.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c1239999.filter2,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)
	end
end