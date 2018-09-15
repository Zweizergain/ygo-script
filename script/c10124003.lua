--拟兽 牙狼
function c10124003.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(10131002,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c10124003.spcon)
	e1:SetCost(c10124003.spcost)
	e1:SetTarget(c10124003.sptg)
	e1:SetOperation(c10124003.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10124003,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10124003)
	e3:SetTarget(c10124003.sptg2)
	e3:SetOperation(c10124003.spop2)
	c:RegisterEffect(e3)  
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10124003,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCountLimit(1,10124003)
	e4:SetCondition(c10124003.thcon)
	e4:SetTarget(c10124003.thtg)
	e4:SetOperation(c10124003.thop)
	c:RegisterEffect(e4) 
end

function c10124003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(c10124003.tdfilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function c10124003.tdfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x6334) and c:IsAbleToExtra() and (((c:GetSequence()==6 or c:GetSequence()==7) and c:IsLocation(LOCATION_SZONE)) or c:IsLocation(LOCATION_MZONE)) and not c:IsCode(10124003)
end

function c10124003.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,c)
		local g=Duel.GetMatchingGroup(c10124003.tdfilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,nil)
		if g:GetCount()>0 then
		   Duel.BreakEffect()
		   local tc=g:Select(tp,1,1,nil):GetFirst()
		   Duel.SendtoExtraP(tc,nil,REASON_EFFECT) 
		end
	end
end

function c10124003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_EXTRA) 
end

function c10124003.spfilter(c,e,tp)
	return c:IsSetCard(0x6334) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:GetSequence()==6 or c:GetSequence()==7) and not c:IsCode(10124003)
end

function c10124003.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10124003.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_SZONE)
end

function c10124003.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10124003.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and e:GetHandler():IsRelateToEffect(e) then
		   Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end

function c10124003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c10124003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end

function c10124003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x6334) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x6334)
	Duel.Release(g,REASON_COST)
end

function c10124003.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6334) and c:GetSummonPlayer()==tp
end

function c10124003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10124003.cfilter,1,nil,tp)
end