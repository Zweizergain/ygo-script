
function c1231000.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(1231000,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,1231000)
	e0:SetCost(c1231000.cost2)
	e0:SetTarget(c1231000.tg2)
	e0:SetOperation(c1231000.op2)
	c:RegisterEffect(e0)
	--dis
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1231000,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1231000)
	e1:SetCondition(c1231000.sumcon)
	e1:SetTarget(c1231000.target3)
	e1:SetOperation(c1231000.operation3)
	c:RegisterEffect(e1)
	--summon/set with 1 tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1231000,1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c1231000.otcon)
	e2:SetOperation(c1231000.otop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e3)
	--forbidden
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EFFECT_FORBIDDEN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetTarget(c1231000.bantg)
	c:RegisterEffect(e4)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c1231000.spcon)
	e6:SetTarget(c1231000.sptg)
	e6:SetOperation(c1231000.spop)
	c:RegisterEffect(e6)
end
function c1231000.cfilter(c)
	return c:IsAbleToDeckAsCost() and c:IsType(TYPE_MONSTER)
end
function c1231000.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1231000.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1231000.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c1231000.filter(c)
	return c:IsSetCard(0x813) and c:IsAbleToHand()
end
function c1231000.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1231000.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1231000.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end 
	if Duel.IsExistingMatchingCard(c1231000.filter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1231000.filter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-- function c1231000.GetColumnGroup(c)
	-- local tp=c:GetControler()
	-- local function f1(c1,c2)
		-- if c1:GetControler()==c2:GetControler() then 
			-- if c1:GetSequence()>4 and not c1:IsLocation(LOCATION_SZONE) then 
				-- return (c2:GetSequence()==1 and c1:GetSequence()==5)
					-- or (c2:GetSequence()==3 and c1:GetSequence()==6)
			-- end 
			-- return c1:GetSequence()==c2:GetSequence()
		-- else
			-- if c1:GetSequence()>4 and not c1:IsLocation(LOCATION_SZONE) then 
				-- return (c2:GetSequence()==1 and c1:GetSequence()==6)
					-- or (c2:GetSequence()==3 and c1:GetSequence()==5)
			-- end 
			-- return c1:GetSequence()+c2:GetSequence()==4
		-- end 
	-- end 
	-- local g1=Duel.GetMatchingGroup(f1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,c)
	-- return g1
-- end 
function c1231000.otcon(e,c,minc)
	if c==nil then return true end
	return c:GetLevel()>6 and minc<=1 and Duel.CheckTribute(c,1)
end
function c1231000.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Duel.SelectTribute(tp,c,1,1)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c1231000.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return  (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) 
end
function c1231000.filter2(c)
	return c:IsSetCard(0x813) and c:IsFaceup()
end
function c1231000.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1231000.filter2,tp,LOCATION_ONFIELD,0,1,nil) 
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1231000.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1231000.filter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.Destroy(g,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false) then 
				Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)	
		end 
	end 			
end
function c1231000.bantg(e,c)
	local sg=e:GetHandler():GetColumnGroup()
	return sg:IsContains(c)
end

function c1231000.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE and c:IsPreviousLocation(LOCATION_MZONE)
end
function c1231000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
end
function c1231000.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end