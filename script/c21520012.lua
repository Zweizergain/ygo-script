--乱数雕像
function c21520012.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(21520012,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x493))
	e2:SetValue(0x1)
	c:RegisterEffect(e2)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,LOCATION_HAND+LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x493))
	c:RegisterEffect(e1)
	--random to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21520012,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetCode(EVENT_LEAVE_FIELD)
--	e4:SetCountLimit(1,21520012)
	e4:SetCondition(c21520012.thcon2)
	e4:SetTarget(c21520012.thtg2)
	e4:SetOperation(c21520012.thop2)
	c:RegisterEffect(e4)
--[[
	--change minrandom
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520012,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1,21520012)
	e3:SetCondition(c21520012.thcon)
	e3:SetTarget(c21520012.thtg)
	e3:SetOperation(c21520012.thop)
	c:RegisterEffect(e3)
	if not c21520012.global_check then
		c21520012.global_check=true
		c21520012[0]=0
		local ge1=Effect.GlobalEffect()
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c21520012.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c21520012.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c21520012.afilter(c)
	return c:IsSetCard(0x493) and c:IsType(TYPE_MONSETER)
end
function c21520012.checkop(e,tp,eg,ep,ev,re,r,rp)
	local fg=eg:Filter(c21520012.afilter,nil)
	local tc=fg:GetFirst()
	while tc do
		c21520012[0]=c21520012[0]+1
		tc=fg:GetNext()
	end
end
function c21520012.clear(e,tp,eg,ep,ev,re,r,rp)
	c21520012[0]=0
end
function c21520012.thcon(e,tp,eg,ep,ev,re,r,rp)
	return c21520012[0]>0
end
function c21520012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,c21520012[0],tp,LOCATION_DECK)
end
function c21520012.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	local ct=g:GetCount()
	if ct>c21520012[0] then
		ct=c21520012[0]
	end
	local thg=g:RandomSelect(tp,ct)
	Duel.SendtoHand(thg,nil,REASON_EFFECT)
	local hg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	local tdg=hg:RandomSelect(tp,ct)
	Duel.SendtoDeck(tdg,nil,2,REASON_EFFECT)
--]]
end
function c21520012.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_SZONE
end
function c21520012.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c21520012.thop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,e:GetHandler())
	local thg=g:RandomSelect(tp,1)
	Duel.SendtoHand(thg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,thg)
end
