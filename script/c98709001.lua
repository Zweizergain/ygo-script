--PSY
function c98709001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c98709001.target)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98709001,0))
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c98709001.shtg)
	e2:SetOperation(c98709001.shop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98709001,1))
	e3:SetCategory(CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetTarget(c98709001.sptg)
	e3:SetOperation(c98709001.spop)
	c:RegisterEffect(e3)
	--to field
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98709001,2))
	e4:SetCategory(CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCountLimit(1)
	e4:SetTarget(c98709001.tftg)
	e4:SetOperation(c98709001.tfop)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98709001,3))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCondition(aux.exccon)
	e5:SetCost(c98709001.thcost)
	e5:SetTarget(c98709001.thtg)
	e5:SetOperation(c98709001.thop)
	c:RegisterEffect(e5)
	--act in hand
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e6:SetCondition(c98709001.handcon)
	c:RegisterEffect(e6)
end
function c98709001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local op=0
	local off=1
	local ops={}
	local opval={}
	if c98709001.shtg(e,tp,eg,ep,ev,re,r,rp,0) then
		ops[off]=aux.Stringid(98709001,0)
		opval[off-1]=1
		off=off+1
	end
	if c98709001.sptg(e,tp,eg,ep,ev,re,r,rp,0) then
		ops[off]=aux.Stringid(98709001,1)
		opval[off-1]=2
		off=off+1
	end
	if c98709001.tftg(e,tp,eg,ep,ev,re,r,rp,0) then
		ops[off]=aux.Stringid(98709001,2)
		opval[off-1]=3
		off=off+1
	end
	if off~=1 and Duel.SelectYesNo(tp,94) then
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
			e:SetOperation(c98709001.shop)
			c98709001.shtg(e,tp,eg,ep,ev,re,r,rp,1)
		elseif opval[op]==2 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetOperation(c98709001.spop)
			c98709001.sptg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			e:SetOperation(c98709001.tfop)
			c98709001.tftg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end
function c98709001.shfilter(c)
	return c:IsSetCard(0xc1) and not c:IsCode(98709001) and c:IsAbleToHand()
end
function c98709001.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c98709001.shfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and c:GetFlagEffect(98709001)==0 end
	c:RegisterFlagEffect(98709001,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98709001.shop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if sg:GetFirst():IsImmuneToEffect(e) then return end
	Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98709001.shfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98709001.spfilter(c,e,tp)
	return c:IsSetCard(0xc1) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_DECK))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98709001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(98709101)==0
		and Duel.IsExistingMatchingCard(c98709001.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp) end
	c:RegisterFlagEffect(98709101,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c98709001.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if sg:GetFirst():IsImmuneToEffect(e) then return end
	Duel.SendtoGrave(sg,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98709001.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98709001.tffilter(c,tp)
	return c:IsSetCard(0xc1) and (c:GetType()==0x20004 or c:IsType(TYPE_FIELD)) and not c:IsCode(98709001)
		and c:GetActivateEffect():IsActivatable(tp)
end
function c98709001.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c98709001.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
		and c:GetFlagEffect(98709201)==0 end
	c:RegisterFlagEffect(98709201,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c98709001.tfop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if sg:GetFirst():IsImmuneToEffect(e) then return end
	Duel.SendtoGrave(sg,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c98709001.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then
		g=g:Filter(Card.IsType,nil,TYPE_FIELD)
	end
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
	end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local te=tc:GetActivateEffect()
	local tep=tc:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	Duel.RaiseEvent(tc,98709001,te,0,tp,tp,Duel.GetCurrentChain())
end
function c98709001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c98709001.thfilter(c)
	return c:IsSetCard(0xc1) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToHand()
end
function c98709001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(c98709001.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98709001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98709001.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98709001.cfilter(c)
	return c:IsSetCard(0xc1) and c:IsFaceup()
end
function c98709001.handcon(e)
	return Duel.IsExistingMatchingCard(c98709001.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
