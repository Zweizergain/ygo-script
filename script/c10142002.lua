--凶恶龙·狱炎龙
function c10142002.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10142002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10142002)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10142002.spcon)
	e1:SetTarget(c10142002.sptg)
	e1:SetOperation(c10142002.spop)
	c:RegisterEffect(e1)	
end

function c10142002.cfilter(c,tp)
	return c:IsSetCard(0x3333) and c:IsFaceup()
end

function c10142002.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6333) and c:GetSequence()<5
end

function c10142002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10142002.cfilter,1,nil) and Duel.IsExistingMatchingCard(c10142002.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end

function c10142002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c10142002.rfilter(c)
	return c:IsSetCard(0x3333) and c:IsAbleToRemove()
end

function c10142002.spfilter2(c,e,tp)
	return c:IsSetCard(0x5333) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end

function c10142002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10142002.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	local rg=Duel.GetMatchingGroup(c10142002.rfilter,tp,LOCATION_GRAVE,0,nil)
   if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)~=0 and g:GetCount()>0 and rg:GetCount()>=1 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10142002,1)) then
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg2=rg:Select(tp,1,1,nil)
	Duel.Remove(rg2,POS_FACEUP,REASON_EFFECT)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(g2,0,tp,1-tp,false,false,POS_FACEUP)   
   end
end