--畅叙幽情 碧玉
function c10920406.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)  
	e1:SetCountLimit(1,10920406)
	e1:SetCost(c10920406.cost)
	e1:SetTarget(c10920406.target)
	e1:SetOperation(c10920406.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10920407)
	e2:SetTarget(c10920406.thtg)
	e2:SetOperation(c10920406.thop)
	c:RegisterEffect(e2)
end
function c10920406.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c10920406.filter(c)
	return c:IsAbleToDeck() 
end
function c10920406.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then		
			  local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
			  if e:GetHandler():IsLocation(LOCATION_HAND) then h1=h1-1 end
			  local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
			  return (Duel.IsExistingMatchingCard(c10920406.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or 
					 ((h1+h2>0) and (Duel.IsPlayerCanDraw(tp,h1) or h1==0) and (Duel.IsPlayerCanDraw(1-tp) or h2==0)) or 
					  Duel.IsExistingMatchingCard(c10920406.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,aux.Stringid(10920406,0),aux.Stringid(10920406,1),aux.Stringid(10920406,2))
	e:SetLabel(op)
	if op==0 then
	   e:SetCategory(CATEGORY_TODECK)
	   local g=Duel.GetMatchingGroup(c10920406.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	   Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	elseif op==1 then
		   e:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
		   Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
		   Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
	elseif op==2 then
		   e:SetCategory(CATEGORY_TODECK)
		   local g=Duel.GetMatchingGroup(c10920406.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		   Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	end
end
function c10920406.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if e:GetLabel()==0 then
	   local g=Duel.GetMatchingGroup(c10920406.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	   Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	elseif e:GetLabel()==1 then
		   local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		   local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		   local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
		   Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		   Duel.BreakEffect()
		   Duel.Draw(tp,h1,REASON_EFFECT)
		   Duel.Draw(1-tp,h2,REASON_EFFECT)
	elseif e:GetLabel()==2 then 
		   local g=Duel.GetMatchingGroup(c10920406.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		   Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c10920406.thfilter(c)
	return c:IsType(TYPE_FLIP) and c:IsAbleToHand() and not c:IsCode(10920406)
end
function c10920406.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10920406.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10920406.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10920406.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,g)
	   Duel.BreakEffect()
	   if c:IsFaceup() then
		  Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	   end
	end
end