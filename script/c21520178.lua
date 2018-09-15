--折合拆分
function c21520178.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520178,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21520178.target)
	e1:SetOperation(c21520178.activate)
	c:RegisterEffect(e1)
end
function c21520178.thfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsAbleToHand() and c:IsSetCard(0x490) 
		and Duel.IsExistingMatchingCard(c21520178.spfilter,tp,LOCATION_DECK,0,1,nil,lv,e,tp,c)
end
function c21520178.spfilter(c,lv,e,tp,tc)
	if tc:IsSetCard(0x5490) then 
		return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x490) and not c:IsSetCard(0x5490)
	else 
		return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x5490)
	end
end
function c21520178.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c21520178.thfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingTarget(c21520178.thfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c21520178.thfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21520178.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21520178.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel(),e,tp,tc)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
