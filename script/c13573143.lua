local m=13573143
local tg={13573101,13573121}
local cm=_G["c"..m]
cm.name="海盗激情！"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk Up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--Indes
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Effect Add
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCondition(cm.effcon)
	e4:SetOperation(cm.effop)
	c:RegisterEffect(e4)
end
cm.card_code_list={tg[1]}
--Atk Up
function cm.condition(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
		and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function cm.target(e,c)
	return c:IsFaceup() and aux.IsCodeListed(c,tg[1])
end
--Effect Add
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)~=0 then return end
	Duel.RegisterFlagEffect(tp,m,0,0,0)
	--Append Effect
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetDescription(aux.Stringid(m,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(cm.efilter)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.eftg)
	e1:SetLabelObject(e0)
	Duel.RegisterEffect(e1,tp)
end
function cm.eftg(e,c)
	return c:IsFaceup() and c:IsCode(tg[2])
end
--Append Effect
function cm.efilter(e,te)
	return Duel.GetTurnPlayer()==e:GetOwnerPlayer()
		and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
		and e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end