local m=13570421
local cm=_G["c"..m]
cm.name="歪秤 认真熊天使"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	--Return
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.retcon)
	e1:SetOperation(cm.retop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
--Material
function cm.mfilter(c)
	return c:IsType(TYPE_SYNCHRO)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(cm.mfilter,nil)
	e:GetLabelObject():SetLabel(ct)
end
--Return
function cm.retfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(cm.retfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if ct>0 then
		local lp=Duel.GetLP(1-tp)
		Duel.SetLP(1-tp,lp-ct*500)
	end
end