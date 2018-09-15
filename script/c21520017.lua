--乱数号召
function c21520017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520017,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21520017)
	e1:SetTarget(c21520017.target)
	e1:SetOperation(c21520017.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520017,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c21520017.thcon)
	e2:SetCost(c21520017.thcost)
	e2:SetTarget(c21520017.thtg)
	e2:SetOperation(c21520017.thop)
	c:RegisterEffect(e2)
end
function c21520017.filter(c,e,tp,m)
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	if c:IsLocation(LOCATION_DECK) then
		return m:GetCount()>=c:GetOriginalLevel() and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and c:IsAttribute(ATTRIBUTE_WIND)
	else
		return m:GetCount()>=c:GetOriginalLevel() and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)
	end
end
function c21520017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(c21520017.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c21520017.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_DECK,0,nil)
	local tg=Group.CreateGroup()
	local sfd=false
	local ds=Duel.IsExistingMatchingCard(c21520017.filter,tp,LOCATION_DECK,0,1,nil,e,tp,mg)
	local hgs=Duel.IsExistingMatchingCard(c21520017.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
	if ds and hgs and Duel.SelectYesNo(tp,aux.Stringid(21520017,3)) then
--		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		tg=Duel.GetMatchingGroup(c21520017.filter,tp,LOCATION_DECK,0,nil,e,tp,mg):RandomSelect(tp,1)
		Duel.ConfirmCards(1-tp,tg)
		sfd=true
	elseif ds and not hgs then
		tg=Duel.GetMatchingGroup(c21520017.filter,tp,LOCATION_DECK,0,nil,e,tp,mg):RandomSelect(tp,1)
		Duel.ConfirmCards(1-tp,tg)
		sfd=true
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		tg=Duel.SelectMatchingCard(tp,c21520017.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	end
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		local sum=tc:GetOriginalLevel()
		--not randomly
		if not tc:IsSetCard(0x493) and not Duel.IsExistingMatchingCard(c21520017.chkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
			Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
			Duel.BreakEffect()
			Duel.Damage(tp,sum*500,REASON_RULE)
		end
		local rg=mg:RandomSelect(tp,sum)
		Duel.SendtoGrave(rg,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		if sfd and Duel.SelectYesNo(1-tp,aux.Stringid(21520017,4)) then 
			local rsg=Duel.GetMatchingGroup(Card.IsAbleToHand,1-tp,LOCATION_DECK,0,nil)
			if rsg:GetCount()<math.ceil(sum/3) then sum=rsg:GetCount() 
			else sum=math.ceil(sum/3) end
			local thg=rsg:RandomSelect(1-tp,sum)
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
			Duel.ConfirmCards(tp,thg)
		end
		Duel.SpecialSummonComplete()
		tc:SetMaterial(rg)
		Duel.BreakEffect()
		tc:CompleteProcedure()
	end
end
function c21520017.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x493) and c:IsType(TYPE_FIELD)
end
function c21520017.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c21520017.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c21520017.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520017.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520017.cfilter,tp,LOCATION_GRAVE,0,nil)
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+10)
	local ct=math.random(1,g:GetCount())
	local rg=g:RandomSelect(tp,ct)
	Duel.ConfirmCards(1-tp,rg)
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
end
function c21520017.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c21520017.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
