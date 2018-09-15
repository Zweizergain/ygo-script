local m=13580201
local tg={13580200,13580299}
local cm=_G["c"..m]
cm.name="灵血狐 传令"
function cm.initial_effect(c)
	--Pendulum Set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Pendulum Set
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.filter1(c,tp)
	return c:GetCode()>tg[1] and c:GetCode()<tg[2] and c:IsType(TYPE_PENDULUM)
		and not c:IsForbidden() and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,c,c)
end
function cm.filter2(c,tc)
	return tc and c:IsCode(tc:GetCode()) and c:GetCode()>tg[1] and c:GetCode()<tg[2]
		and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0)
		and Duel.CheckLocation(tp,LOCATION_PZONE,1)
		and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil,tp) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil,tp)
		local tc1=g:GetFirst()
		local tc2=Duel.GetFirstMatchingCard(cm.filter2,tp,LOCATION_DECK,0,tc1,tc1)
		if tc1 and tc2 then
			Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end