--白魔术吟游诗人
function c34340025.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c34340025.lfilter,2,2)
	c:EnableReviveLimit()   
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34340025,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,34340025)
	e1:SetCondition(c34340025.spcon)
	e1:SetTarget(c34340025.sptg)
	e1:SetOperation(c34340025.spop)
	c:RegisterEffect(e1)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(34340025,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c34340025.target)
	e3:SetOperation(c34340025.operation)
	c:RegisterEffect(e3)
end
c34340025.setname="WhiteMagician"
function c34340025.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c.setname=="WhiteAlbum" and c:IsAbleToHand()
end
function c34340025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c34340025.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c34340025.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c34340025.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c34340025.lfilter(c)
	return c.setname=="WhiteMagician"
end
function c34340025.spcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c34340025.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c.setname=="WhiteMagician" and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c34340025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c34340025.spfilter,tp,0x1,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x1)
end
function c34340025.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c34340025.spfilter,tp,0x1,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
