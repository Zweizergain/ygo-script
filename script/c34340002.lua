--白魔术旅者 影
function c34340002.initial_effect(c)
	--Attribute Dark
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)   
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34340002,0))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c34340002.drtg)
	e2:SetOperation(c34340002.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)  
	--search2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(34340002,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c34340002.thcon)
	e4:SetTarget(c34340002.thtg)
	e4:SetOperation(c34340002.thop)
	c:RegisterEffect(e4)
end
c34340002.setname="WhiteMagician"
function c34340002.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsLocation(LOCATION_DECK)
end
function c34340002.thfilter(c)
	return not c:IsCode(34340002) and c:IsAbleToHand() and c.setname=="WhiteMagician"
end
function c34340002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c34340002.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c34340002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c34340002.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c34340002.costfilter2(c)
	return c.setname=="WhiteMagician" and c:IsDiscardable()
end
function c34340002.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c34340002.costfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c34340002.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c34340002.costfilter,tp,LOCATION_HAND,0,1,nil) and Duel.DiscardHand(tp,c34340002.costfilter,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
	   local tc=Duel.GetOperatedGroup():GetFirst()
	   if tc:IsLocation(LOCATION_GRAVE) then
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_CANNOT_TRIGGER)
		  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		  tc:RegisterEffect(e1)
	   end
	   Duel.Draw(tp,2,REASON_EFFECT)
	end
end


