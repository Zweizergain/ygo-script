--月光鹰
function c72826392.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xdf),2,2)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,72826392)
	e1:SetTarget(c72826392.sptg)
	e1:SetOperation(c72826392.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,72826393)
	e2:SetCondition(c72826392.thcon)
	e2:SetTarget(c72826392.thtg)
	e2:SetOperation(c72826392.thop)
	c:RegisterEffect(e2)
end

function c72826392.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)
end

function c72826392.thfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xdf) and c:IsAbleToHand()
end

function c72826392.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c72826392.spdfil(chkc) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c72826392.thfil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c72826392.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,LOCATION_GRAVE)
end

function c72826392.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end

function c72826392.spdfil(c,lg)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xdf) and lg:IsContains(c)
end

function c72826392.spfil(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xdf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c72826392.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return c72826392.spdfil(chkc,lg) end
	if chk==0 then return Duel.IsExistingTarget(c72826392.spdfil,tp,LOCATION_MZONE,0,1,nil,lg) and Duel.IsExistingMatchingCard(c72826392.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c72826392.spdfil,tp,LOCATION_MZONE,0,1,1,nil,lg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function c72826392.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.SelectMatchingCard(tp,c72826392.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			local sc=g:GetFirst()
			Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	end
end
