--乱数议程
function c21520021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c21520021.cost)
	e1:SetTarget(c21520021.target)
	e1:SetOperation(c21520021.operation)
	c:RegisterEffect(e1)
	--Random to hand replace draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520021,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c21520021.rthcon)
	e2:SetTarget(c21520021.rthtg)
	e2:SetOperation(c21520021.rthop)
	c:RegisterEffect(e2)
	--immue
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(c21520021.econ)
	e3:SetValue(c21520021.efilter)
	c:RegisterEffect(e3)
end
function c21520021.filter(c)
	return c:IsSetCard(0x5493) and c:IsAbleToGraveAsCost()
end
function c21520021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Group.GetClassCount(Duel.GetMatchingGroup(c21520021.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil),Card.GetCode)>=8 end
	local g=Duel.GetMatchingGroup(c21520021.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	local sg=c21520021.group_unique_choose(g,tp)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c21520021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c21520021.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetTargetRange(0xff,0xff)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,1)
	Duel.RegisterEffect(e2,tp)
end
function c21520021.group_unique_choose(g,tp)
	local check={}
	local sg=Group.CreateGroup()
	local rg=Group.CreateGroup()
	local tc=nil
	for i=1,8 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		tc=g:Select(tp,1,1,nil):GetFirst()
		sg:AddCard(tc)
		rg=g:Filter(Card.IsCode,tc,tc:GetCode())
		g:Sub(rg)
		g:RemoveCard(tc)
	end
	return sg
end
function c21520021.rthcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(Duel.GetTurnPlayer(),LOCATION_DECK,0)>0 and Duel.GetDrawCount(Duel.GetTurnPlayer())>0
end
function c21520021.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	local player=Duel.GetTurnPlayer()
	local dt=Duel.GetDrawCount(player)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,player)
	end
	e:SetLabel(dt)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
--	Duel.SetChainLimit(aux.FALSE)
end
function c21520021.rthop(e,tp,eg,ep,ev,re,r,rp)
	_replace_count=_replace_count+1
	local player=Duel.GetTurnPlayer()
	local dt=e:GetLabel()
	if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
--	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	if Duel.GetFieldGroupCount(player,LOCATION_DECK,0)<dt then dt=Duel.GetFieldGroupCount(player,LOCATION_DECK,0) end
	Duel.Hint(HINT_SELECTMSG,player,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,player,LOCATION_DECK,0,nil):RandomSelect(player,dt)
	if g:GetCount()~=0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-player,g)
	end
end
function c21520021.rfilter(c)
	return c:IsSetCard(0x5493) and c:IsFaceup()
end
function c21520021.econ(e)
	local ct=Group.GetClassCount(Duel.GetMatchingGroup(c21520021.rfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil),Card.GetOriginalCode)
	return ct>=8
end
function c21520021.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
