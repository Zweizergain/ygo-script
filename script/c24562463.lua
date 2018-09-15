--猛毒性 安可
function c24562463.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(c24562463.e1cost)
	e1:SetTarget(c24562463.e1tg)
	e1:SetOperation(c24562463.e1op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,24562463)
	e2:SetTarget(c24562463.e2tg)
	e2:SetOperation(c24562463.e2op)
	c:RegisterEffect(e2)
end
function c24562463.e2op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c24562463.e2fil,tp,LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c24562463.e2fil(c)
	return c:IsSetCard(0x1390) and c:IsType(TYPE_SPELL) and c:IsSSetable() and c:IsFaceup()
end
function c24562463.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c24562463.e2fil,tp,LOCATION_REMOVED,0,1,nil) end
end
function c24562463.e1op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if not Duel.IsPlayerCanDraw(p) then return end
	local ct=Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
	local ac=0
	if ct==0 then ac=1 end
	if ct>1 then
		Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(24562463,0))
		if ct==2 then ac=Duel.AnnounceNumber(p,1,2)
		else ac=Duel.AnnounceNumber(p,1,2,3) end
	end
	local dr=Duel.Draw(p,ac,REASON_EFFECT)
	if p~=tp and dr~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,dr*1000,REASON_EFFECT)
	end
end
function c24562463.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c24562463.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24562463.e1cfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c24562463.e1cfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c24562463.e1cfil(c)
	return c:IsSetCard(0x1390) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end