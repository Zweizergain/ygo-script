local m=13571120
local cm=_G["c"..m]
cm.name="兽人公主 奈奈加"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Link
	aux.AddLinkProcedure(c,cm.lfilter,2,99,cm.lcheck)
	--Indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e3)
	--Effect Gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.reptg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(cm.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
--Link
function cm.lfilter(c)
	return c:IsLinkType(TYPE_EFFECT)
end
function cm.lcheckfilter(c)
	return not c:IsDefenseAbove(0)
end
function cm.lcheck(g)
	return g:GetClassCount(Card.GetAttack)==1
		or (not g:IsExists(cm.lcheckfilter,1,nil) and g:GetClassCount(Card.GetDefense)==1)
end
--Effect Gain
function cm.eftg(e,c)
	return c:IsFaceup() and c:IsAttackPos()
end
--Destroy Replace
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAttackPos() and c:IsCanChangePosition() end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
		return true
	else return false end
end