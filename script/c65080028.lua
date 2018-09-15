--恶魔的不退
function c65080028.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c65080028.mtop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c65080028.destg)
	e3:SetValue(c65080028.value)
	e3:SetOperation(c65080028.desop)
	c:RegisterEffect(e3)
	--GRAVE AND SPSUM
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,65080028)
	e4:SetTarget(c65080028.sptg)
	e4:SetOperation(c65080028.spop)
	c:RegisterEffect(e4)
end
function c65080028.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,500) then
		Duel.PayLPCost(tp,500)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end

function c65080028.dfilter(c,tp,rp)
	return c:IsControler(tp) and c:IsSetCard(0x45) and c:IsLocation(LOCATION_MZONE) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and rp~=tp)) and not c:IsReason(REASON_REPLACE)
end

function c65080028.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c65080028.dfilter,1,nil,tp,rp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c65080028.value(e,c,rp)
	return c:IsControler(e:GetHandlerPlayer()) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and rp~=e:GetHandlerPlayer())) and not c:IsReason(REASON_REPLACE) and c:IsSetCard(0x45) and c:IsLocation(LOCATION_MZONE)
end
function c65080028.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,1000,REASON_EFFECT)
end

function c65080028.grfil(c)
	return c:IsSetCard(0x45) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and (c:GetAttack()<=500 or c:GetDefense()<=500)
end

function c65080028.spfil(c,e,tp)
	return c:IsSetCard(0x45) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:GetAttack()<=500 or c:GetDefense()<=500)
end

function c65080028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65080028.grfil,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65080028.grfil,tp,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end

function c65080028.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c65080028.grfil,tp,LOCATION_DECK,0,1,1,nil)
	local g3=Duel.SelectMatchingCard(tp,c65080028.grfil,tp,LOCATION_HAND,0,1,1,nil)
	g1:Merge(g3)
	if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_EFFECT)
		if Duel.IsExistingMatchingCard(c65080028.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(65080028,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,c65080028.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g2:GetCount()>0 then
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end