local m=13570947
local cm=_G["c"..m]
cm.name="歪秤 MSC702"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Link
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	--Damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.damcon)
	e1:SetOperation(cm.damop)
	c:RegisterEffect(e1)
	--Duel Status
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DUAL_STATUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.dueltg)
	c:RegisterEffect(e2)
end
--Link
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_DUAL)
end
--Damage
function cm.cfilter(c,tp)
	return c:IsType(TYPE_TRAP) and c:IsControler(tp)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Damage(1-tp,300,REASON_EFFECT)
end
--Duel Status
function cm.dueltg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end