--绯想天 蕾米莉亚·斯卡雷特
function c1231300.initial_effect(c)
	--dis
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1231300,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1231300)
	e1:SetCondition(c1231300.sumcon)
	e1:SetTarget(c1231300.target3)
	e1:SetOperation(c1231300.operation3)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1231100,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c1231300.distarget)
	e4:SetOperation(c1231300.disop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c1231300.spcon)
	e6:SetTarget(c1231300.sptg)
	e6:SetOperation(c1231300.spop)
	c:RegisterEffect(e6)
end
-- function c1231300.GetColumnGroup(c)
	-- local tp=c:GetControler()
	-- local function f1(c1,c2)
		-- if c1:GetControler()==c2:GetControler() then 
			-- if c1:GetSequence()>4 and not c1:IsLocation(LOCATION_SZONE) then 
				-- return (c2:GetSequence()==1 and c1:GetSequence()>=5)
					-- or (c2:GetSequence()==3 and c1:GetSequence()>=6)
			-- end 
			-- return c1:GetSequence()==c2:GetSequence()
		-- else
			-- if c1:GetSequence()>4 and not c1:IsLocation(LOCATION_SZONE) then 
				-- return (c2:GetSequence()==1 and c1:GetSequence()>=6)
					-- or (c2:GetSequence()==3 and c1:GetSequence()>=5)
			-- end 
			-- return c1:GetSequence()+c2:GetSequence()==4
		-- end 
	-- end 
	-- local g1=Duel.GetMatchingGroup(f1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,c)
	-- return 0 --c:GetColumnGroup()
-- end 
function c1231300.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return  (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) 
end
function c1231300.filter2(c)
	return c:IsSetCard(0x813) and c:IsFaceup()
end
function c1231300.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1231300.filter2,tp,LOCATION_ONFIELD,0,2,nil) 
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1231300.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1231300.filter2,tp,LOCATION_ONFIELD,0,2,2,nil)
	if g:GetCount()>0 then
		if Duel.Destroy(g,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false) then 
				Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)	
		end 
	end 			
end
function c1231300.distarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local c=e:GetHandler()
		local g=c:GetColumnGroup()
		return g:GetCount()>0
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1231300.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local c=e:GetHandler()
	local g=c:GetColumnGroup()
	if e:GetHandler():IsRelateToEffect(e) and g:GetCount()>0 then
		local rc=g:Select(tp,1,1,nil):GetFirst()
		if Duel.Destroy(rc,REASON_EFFECT)~=0 and rc:IsLocation(LOCATION_GRAVE)
			and not rc:IsHasEffect(EFFECT_NECRO_VALLEY) then
			if rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and (not rc:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp)>0)
				and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
				and Duel.SelectYesNo(tp,aux.Stringid(1231300,3)) then
				Duel.BreakEffect()
				Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,rc)
			elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
				and rc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(1231300,3)) then
				Duel.BreakEffect()
				Duel.SSet(tp,rc)
				Duel.ConfirmCards(1-tp,rc)
			end
		end 
	end
end

function c1231300.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE and c:IsPreviousLocation(LOCATION_MZONE)
end
function c1231300.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
end
function c1231300.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end