--绯想天 永江衣玖
require "nef/thcz"
function c1230700.initial_effect(c)
	--星球改造！
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetDescription(aux.Stringid(1230700,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,1230700)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c1230700.target)
	e4:SetOperation(c1230700.operation)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetDescription(aux.Stringid(100511,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12307001)
	e2:SetCondition(c1230700.matcon)
	e2:SetTarget(c1230700.stg)
	e2:SetOperation(c1230700.sop)
	c:RegisterEffect(e2)
end
function c1230700.filter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c1230700.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1230700.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1230700.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1230700.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end	
function c1230700.cfilter(c,tp)
	return c:IsControler(tp) and not c:IsReason(REASON_DRAW) and c:IsSetCard(0xae6) and c:IsType(TYPE_MONSTER)
end
function c1230700.cfilter2(c,e,tp)
	return c:IsControler(tp) and not c:IsReason(REASON_DRAW) and c:IsSetCard(0xae6) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end

function c1230700.matcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1230700.cfilter2,1,nil,e,tp)
end
function c1230700.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=eg:Filter(c1230700.cfilter2,nil,e,tp)
	if chk==0 then return eg:IsExists(c1230700.cfilter,1,nil,tp) --and Duel.IsExistingMatchingCard(c1230700.cfilter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=sg:GetCount() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),tp,nil)
	local tc9=sg:GetFirst()
	while tc9 do
		tc9:CreateEffectRelation(e)
		tc9=sg:GetNext()
	end 
end

function c1230700.sop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local sg=eg:Filter(c1230700.cfilter2,nil,e,tp)
	sg=sg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(sg,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)	
end