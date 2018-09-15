--落日之炎
function c10150032.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c10150032.spcon)
	e1:SetTarget(c10150032.sptg)
	e1:SetOperation(c10150032.spop)
	c:RegisterEffect(e1)	
end

function c10150032.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end

function c10150032.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c10150032.filter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c10150032.filter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c10150032.filter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end

function c10150032.filter(c,e,tp)
	return c:IsReason(REASON_DESTROY) and c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER) and c:GetControler()==tp
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10150032.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetCurrentPhase()~=PHASE_END then
	  Duel.BreakEffect()
		local ctp=Duel.GetTurnPlayer()
		Duel.SkipPhase(ctp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(ctp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(ctp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end
