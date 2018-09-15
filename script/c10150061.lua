--前驱的共鸣者
function c10150061.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150061,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,10150061)
	e2:SetTarget(c10150061.target)
	e2:SetOperation(c10150061.operation)
	c:RegisterEffect(e2)	
end

function c10150061.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c10150061.spfilter(chkc,e,tp,eg) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10150061.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10150061.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end

function c10150061.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c10150061.confilter(c,tp)
	return c:GetSummonType()==SUMMON_TYPE_SYNCHRO and c:IsPreviousLocation(LOCATION_EXTRA) and c:GetSummonPlayer()==tp 
end

function c10150061.spfilter(c,e,tp,eg)
	local tg=eg:Filter(c10150061.confilter,nil,tp)
	if tg:GetCount()~=1 then return false end
	local mg=tg:GetFirst():GetMaterial()
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x80008)==0x80008 and c:GetReasonCard()==tg:GetFirst()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:IsCanBeEffectTarget(e) and c:IsSetCard(0x57) and mg:IsContains(c)
end
