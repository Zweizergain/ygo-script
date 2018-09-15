--凶恶龙·恐惧龙
function c10142001.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10142001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10142001)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10142001.spcon)
	e1:SetTarget(c10142001.sptg)
	e1:SetOperation(c10142001.spop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c10142001.efcon)
	e2:SetOperation(c10142001.efop)
	c:RegisterEffect(e2)   
end

function c10142001.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end

function c10142001.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetDescription(aux.Stringid(10142001,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c10142001.distg)
	rc:RegisterEffect(e1)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end

function c10142001.distg(e,c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:GetAttack()<=e:GetHandler():GetAttack() and c~=e:GetHandler()
end

function c10142001.cfilter(c,tp)
	return c:IsSetCard(0x3333) and c:IsFaceup()
end

function c10142001.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6333) and c:GetSequence()<5
end

function c10142001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10142001.cfilter,1,nil) and Duel.IsExistingMatchingCard(c10142001.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end

function c10142001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c10142001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
	end
end