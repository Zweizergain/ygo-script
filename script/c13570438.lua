local m=13570438
local tg={13570438,13570444}
local mark=1082946
local cm=_G["c"..m]
cm.name="歪秤主天使 诺鲁瓦扎"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(cm.ntfilter),1)
	--Count
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.recon)
	e2:SetTarget(cm.retg)
	e2:SetOperation(cm.reop)
	c:RegisterEffect(e2)
end
--Synchro
function cm.ntfilter(c)
	return c:IsType(TYPE_SYNCHRO)
end
--Count
function cm.filter(c)
	return c:GetCode()>tg[1] and c:GetCode()<tg[2] and c:GetFlagEffect(mark)~=0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0x3f,0x3f,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,0x3f,0x3f,nil)
	local tc=g:GetFirst()
	local elist={}
	while tc do
		if tc.effectlist then
			for i=1,#tc.effectlist do
				local te=tc.effectlist[i]
				if te:GetOwner()==tc then
					table.insert(elist,te)
				end
			end
		end
		tc=g:GetNext()
	end
	for i=1,#elist do
		local op=elist[i]:GetOperation()
		op(elist[i],elist[i]:GetOwnerPlayer(),nil,0,0,0,0,0)
	end
end
--Recover
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	return tc:IsControler(tp) and tc:IsOnField() and tc:IsRace(RACE_FAIRY)
end
function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=Duel.GetAttacker():GetAttack()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end