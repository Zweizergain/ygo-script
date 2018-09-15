--绯想天 十六夜咲夜
function c1231100.initial_effect(c)
	--dis
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1231100,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1231100)
	e1:SetCondition(c1231100.sumcon)
	e1:SetTarget(c1231100.target3)
	e1:SetOperation(c1231100.operation3)
	c:RegisterEffect(e1)
	--summon/set with 1 tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1231100,3))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c1231100.otcon)
	e2:SetOperation(c1231100.otop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1231100,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,1231104)
	e4:SetTarget(c1231100.distarget)
	e4:SetOperation(c1231100.disop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(1231100,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c1231100.spcon)
	e6:SetTarget(c1231100.sptg)
	e6:SetOperation(c1231100.spop)
	c:RegisterEffect(e6)
end
function c1231100.otcon(e,c,minc)
	if c==nil then return true end
	return c:GetLevel()>6 and minc<=1 and Duel.CheckTribute(c,1)
end
function c1231100.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Duel.SelectTribute(tp,c,1,1)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c1231100.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return  (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) 
end
function c1231100.filter2(c)
	return c:IsSetCard(0x813) and c:IsAbleToHand()
end
function c1231100.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1231100.filter2,tp,LOCATION_ONFIELD,0,1,nil) 
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1231100.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1231100.filter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	if e:GetHandler():IsRelateToEffect(e) and g:GetCount()>0 then
		if Duel.Destroy(g,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false) then 
				Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)	
		end 
	end 			
end
function c1231100.sfilter(c)
	return c:IsSetCard(0x814) and c:IsSSetable()
end
function c1231100.distarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local flag4=4-e:GetHandler():GetSequence()
	local flag2=e:GetHandler():GetSequence()
	if chk==0 then return Duel.IsExistingMatchingCard(c1231100.sfilter,tp,LOCATION_DECK,0,1,nil) 
		and ((Duel.GetLocationCount(tp,LOCATION_SZONE))*(Duel.GetLocationCount(1-tp,LOCATION_SZONE)))>0
		and (not Duel.GetFieldCard(tp,LOCATION_SZONE,flag4) or not Duel.GetFieldCard(tp,LOCATION_SZONE,flag2)) end
	--e:SetLabel(e:GetHandler():GetSequence())
end
function c1231100.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local flag4=4-e:GetHandler():GetSequence()
	local flag2=e:GetHandler():GetSequence()
	if not e:GetHandler():IsRelateToEffect(e) then return end 
	if not Duel.GetFieldCard(tp,LOCATION_SZONE,flag2) then 
		local g = Duel.SelectMatchingCard(tp,c1231100.sfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
			Duel.MoveSequence(g:GetFirst(),flag2)
		end
	end 
	if not Duel.GetFieldCard(1-tp,LOCATION_SZONE,flag4)
		and (Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or Duel.SelectYesNo(tp,aux.Stringid(1231100,4))) then 
		local g=Duel.SelectMatchingCard(tp,c1231100.sfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(1-tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
			Duel.MoveSequence(g:GetFirst(),flag4)
		end		
	end 
end
function c1231100.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE and c:IsPreviousLocation(LOCATION_MZONE)
end
function c1231100.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1231100.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
	end
end