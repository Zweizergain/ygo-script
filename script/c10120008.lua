--天选圣女 神圣之奥特琳德
function c10120008.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_FAIRY),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10120008,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10120008.rmcon)
	e1:SetTarget(c10120008.rmtg)
	e1:SetOperation(c10120008.rmop)
	c:RegisterEffect(e1)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10120008,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c10120008.sptg)
	e4:SetOperation(c10120008.spop)
	c:RegisterEffect(e4)
		--dissummon
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON)
		ge1:SetOperation(c10120008.snop)
		ge1:SetLabelObject(e4)
		Duel.RegisterEffect(ge1,0) 
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SUMMON_SUCCESS) 
		ge2:SetOperation(c10120008.ssop)
		ge2:SetLabelObject(e4)
		Duel.RegisterEffect(ge2,0) 
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON)
		ge3:SetLabelObject(e4)
		Duel.RegisterEffect(ge3,0) 
		local ge4=ge2:Clone()
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge4:SetLabelObject(e4)
		Duel.RegisterEffect(ge4,0)  
	--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10120008,3))
	e5:SetCategory(CATEGORY_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
	e5:SetCountLimit(1)
	e5:SetCondition(c10120008.smcon)
	e5:SetTarget(c10120008.smtg)
	e5:SetOperation(c10120008.smop)
	c:RegisterEffect(e5)
end

function c10120008.smfilter(c)
	return c:IsSetCard(0x9331) and c:IsSummonable(true,nil)
end

function c10120008.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10120008.smfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end

function c10120008.smop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10120008.smfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end

function c10120008.smcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 
end

function c10120008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetHandler():GetFlagEffect(10120008)==0 then return false end  
		   e:GetHandler():ResetFlagEffect(10120008)
	return e:GetHandler():IsAbleToExtra() 
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end

function c10120008.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c10120008.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10120008,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c10120008.spfilter(c,e,tp)
	return c:IsSetCard(0x9331) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10120008.desfilter2(c)
	return not c:IsRace(RACE_FAIRY) and c:IsFaceup() and c:IsDestructable()
end

function c10120008.snop(e,tp,eg,ep,ev,re,r,rp)
   if eg:IsContains(e:GetOwner()) then
	e:GetOwner():RegisterFlagEffect(10120008,RESET_EVENT+RESET_OVERLAY+0x00102000,0,0)
   end
end

function c10120008.ssop(e,tp,eg,ep,ev,re,r,rp)
   if eg:IsContains(e:GetOwner()) and e:GetOwner():GetSummonType()==SUMMON_TYPE_SYNCHRO then
	e:GetOwner():ResetFlagEffect(10120008)
   end
end

function c10120008.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end

function c10120008.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE+LOCATION_HAND)
end

function c10120008.rmop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK)
	if sg:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,562)
	local rc=Duel.AnnounceRace(tp,1,0xffffff)
	local g=sg:Filter(Card.IsRace,nil,rc)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local rg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_RULE)
	else
		Duel.ConfirmCards(tp,sg)
		Duel.ShuffleHand(1-tp)
	end
end

