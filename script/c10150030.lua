--同调之门
function c10150030.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10150030+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10150030.target)
	e1:SetOperation(c10150030.operation)
	c:RegisterEffect(e1)	   
end

function c10150030.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c10150030.filter1,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c10150030.filter1(c,e,tp)
	return c:IsReleasableByEffect(e) and c:GetLevel()>0 and c:IsLocation(LOCATION_MZONE)
		and Duel.CheckReleaseGroup(tp,c10150030.filter2,1,c,e,tp,c:GetOriginalLevel())
end

function c10150030.filter2(c,e,tp,lv)
	return c:IsReleasableByEffect(e) and c:GetLevel()>0 and c:IsLocation(LOCATION_MZONE)
		and Duel.IsExistingMatchingCard(c10150030.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+c:GetOriginalLevel())
end

function c10150030.filter3(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end

function c10150030.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.CheckReleaseGroup(tp,c10150030.filter1,1,nil,e,tp) then return end
	local g1=Duel.SelectReleaseGroup(tp,c10150030.filter1,1,1,nil,e,tp)
	local g2=Duel.SelectReleaseGroup(tp,c10150030.filter2,1,1,nil,e,tp,g1:GetFirst():GetOriginalLevel())
	  g1:Merge(g2)
		if Duel.Release(g1,REASON_EFFECT)==2 and g1:GetFirst():GetOriginalLevel()>0 and g2:GetFirst():GetOriginalLevel()>0 then
		local lv=g1:GetFirst():GetOriginalLevel()+g2:GetFirst():GetOriginalLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c10150030.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_SUMMON)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetTargetRange(1,0)
				Duel.RegisterEffect(e1,tp)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CANNOT_MSET)
				Duel.RegisterEffect(e2,tp)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				Duel.RegisterEffect(e3,tp)
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_FIELD)
				e4:SetCode(EFFECT_CHANGE_DAMAGE)
				e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e4:SetTargetRange(0,1)
				e4:SetValue(0)
				e4:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e4,tp)
				local e5=e4:Clone()
				e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
				e5:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e5,tp)
		end
	end
end


