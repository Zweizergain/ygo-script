--雷暴
function c24662479.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCost(c24662479.e1cost)
	e1:SetCondition(c24662479.reccon)
	e1:SetTarget(c24662479.e1tg)
	e1:SetOperation(c24662479.e1op)
	c:RegisterEffect(e1)
	if not c24662479.global_check then
		c24662479.global_check=true
		c24662479[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c24662479.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c24662479.clear)
		Duel.RegisterEffect(ge2,0)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,24662479)
	e3:SetCondition(c24662479.con3)
	e3:SetTarget(c24662479.e3tg)
	e3:SetOperation(c24662479.e3op)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c24662479.handcon)
	c:RegisterEffect(e2)
end
function c24662479.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1019,c24662479[0],REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1019,c24662479[0],REASON_COST)
end
function c24662479.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c24662479[0]~=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(c24662479[0]*300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,c24662479[0]*300)
end
function c24662479.e1op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,c24662479[0]*300,REASON_EFFECT)
end
function c24662479.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
			local p=tc:GetControler()
	if p==1-tp then
	c24662479[0]=c24662479[0]+1
	end
		tc=eg:GetNext()
	end
end
function c24662479.clear(e,tp,eg,ep,ev,re,r,rp)
	c24662479[0]=0
end
function c24662479.reccon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c24662479.c3fil(c)
	return c:IsCode(24662479)
end
function c24662479.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c24662479.cfilter,tp,LOCATION_SZONE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c24662479.e3op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c24662479.cfilter,tp,LOCATION_SZONE,0,nil)
	if g1:GetCount()==0 then return false end
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g2,REASON_EFFECT)
	local g3=Duel.GetOperatedGroup()
	local g4=g3:GetCount()
	if g4>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g5=Duel.SelectMatchingCard(tp,c24662479.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
		if g5:GetCount()>0 then
		local tc=g5:GetFirst()
		tc:AddCounter(0x1019,g4)
		end
	end
end
function c24662479.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24662479.cfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(c24662479.c3fil,tp,LOCATION_GRAVE,0,3,nil)
end
function c24662479.cfilter(c)
	return c:IsFaceup() and c:IsCode(90135989)
end
function c24662479.handcon(e)
	return Duel.IsExistingMatchingCard(c24662479.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end