--非想天则 红美铃
function c1230900.initial_effect(c)
	--dis
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1230900,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1230900)
	e1:SetCondition(c1230900.sumcon)
	e1:SetTarget(c1230900.target3)
	e1:SetOperation(c1230900.operation3)
	c:RegisterEffect(e1)
	--summon/set with 1 tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1230900,3))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c1230900.otcon)
	e2:SetOperation(c1230900.otop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1230900,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c1230900.distarget)
	e4:SetOperation(c1230900.disop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(1230900,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c1230900.spcon)
	e6:SetTarget(c1230900.sptg)
	e6:SetOperation(c1230900.spop)
	c:RegisterEffect(e6)
end
-- function c1230900.GetColumnGroup(c)
	-- local tp=c:GetControler()
	-- local function f1(c1,c2)
		-- if c1:GetControler()==c2:GetControler()  then 
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
	-- return g1 --e:GetHandler():GetColumnGroup()
-- end 
function c1230900.otcon(e,c,minc)
	if c==nil then return true end
	return c:GetLevel()>6 and minc<=1 and Duel.CheckTribute(c,1)
end
function c1230900.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Duel.SelectTribute(tp,c,1,1)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c1230900.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return  (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) 
end
function c1230900.filter2(c)
	return c:IsSetCard(0x813) and c:IsFaceup()
end
function c1230900.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1230900.filter2,tp,LOCATION_ONFIELD,0,1,nil) 
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1230900.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1230900.filter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.Destroy(g,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false) then 
				Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)	
		end 
	end 			
end
function c1230900.distarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():GetColumnGroup():GetCount()>0 then	
		local sg=e:GetHandler():GetColumnGroup()
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)	
	else
		e:SetCategory(CATEGORY_RECOVER)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1000)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	end 
end
function c1230900.disop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetHandler():GetColumnGroup()
	if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoHand(sg,nil,REASON_EFFECT)<1 then 
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if d<1 then 
			Duel.Recover(tp,1000,REASON_EFFECT)			
		else
			Duel.Recover(p,d,REASON_EFFECT)				
		end 
	end
end
function c1230900.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE and c:IsPreviousLocation(LOCATION_MZONE)
end
function c1230900.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1230900.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
	end
end