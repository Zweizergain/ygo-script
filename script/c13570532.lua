local m=13570532
local cm=_G["c"..m]
cm.name="歪秤魔王 塞路贝鲁古"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz
	aux.AddXyzProcedureLevelFree(c,cm.xfilter,cm.xyzcheck,2,2)
	--Atk & Def Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(cm.defval)
	c:RegisterEffect(e2)
	--Xyz Material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
--Xyz
function cm.xfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
--Atk & Def Up
function cm.atkfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttackAbove(0)
end
function cm.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function cm.deffilter(c)
	return c:IsRace(RACE_FIEND) and c:IsDefenseAbove(0)
end
function cm.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
--Xyz Material
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(e:GetHandler(),tc)
	end
end