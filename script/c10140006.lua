--复苏的宝物
function c10140006.initial_effect(c)
	--active
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10140006,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,10140006)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10140006.target)
	e2:SetOperation(c10140006.operation)
	c:RegisterEffect(e2)  
	--spsummn 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10140006,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,10140006)
	e3:SetCondition(c10140006.spcon)
	e3:SetCost(c10140006.spcost)
	e3:SetTarget(c10140006.sptg)
	e3:SetOperation(c10140006.spop)
	c:RegisterEffect(e3) 
end

function c10140006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function c10140006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10140006.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end

function c10140006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10140006.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c10140006.tdfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

function c10140006.spop(e,tp,eg,ep,ev,re,r,rp)
   local sg=Duel.GetMatchingGroup(c10140006.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
   if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		 local tc=sg:Select(tp,1,1,nil)
		 Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
   end  
end

function c10140006.spfilter(c,e,tp)
	return (c:IsSetCard(0x3333) or c:IsSetCard(0x5333)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10140006.tdfilter(c)
	return c:IsType(TYPE_XYZ+TYPE_FUSION+TYPE_SYNCHRO) and c:IsAbleToExtra()
end

function c10140006.filter(c,e,tp)
	return c:IsSetCard(0x3333) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10140006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10140006.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10140006.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10140006.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c10140006.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
   if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end