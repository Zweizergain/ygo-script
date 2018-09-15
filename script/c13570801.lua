local m=13570801
local cm=_G["c"..m]
cm.name="歪秤 陨石坠落"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	e1:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e1)
end
--Activate
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetHandler():GetColumnGroup()
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetColumnGroup()
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end