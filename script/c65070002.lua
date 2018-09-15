--锈蚀之壶
function c65070002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,96598015+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65070002.cost)
	e1:SetTarget(c65070002.target)
	e1:SetOperation(c65070002.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(65070002,ACTIVITY_SPSUMMON,c65070002.counterfilter)
	--act qp in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c65070002.hdcon)
	c:RegisterEffect(e2)
end
function c65070002.counterfilter(c)
	return not c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c65070002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(65070002,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65070002.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c65070002.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c65070002.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToDeck()
end
function c65070002.sfilter(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function c65070002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c65070002.filter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c65070002.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65070002.filter,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,5,nil)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:IsExists(c65070002.sfilter,1,nil,tp) then Duel.ShuffleDeck(tp) end
	if og:IsExists(c65070002.sfilter,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end

function c65070002.filterx(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end

function c65070002.hdcon(c,e,tp)
	return not Duel.IsExistingMatchingCard(c65070002.filterx,tp,LOCATION_EXTRA,0,1,nil)
end