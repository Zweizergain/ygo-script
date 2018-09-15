local m=13580213
local tg={13580200,13580299}
local cm=_G["c"..m]
cm.name="灵血狐姬 稻光"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Link
	aux.AddLinkProcedure(c,cm.lfilter,3,3,cm.lcheck)
	--Act Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetValue(cm.aclimit)
	c:RegisterEffect(e1)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.negcon)
	e3:SetTarget(cm.negtg)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
end
--Link
function cm.lfilter(c)
	return c:IsLinkType(TYPE_NORMAL)
end
function cm.lcheckfilter(c)
	return c:GetCode()>tg[1] and c:GetCode()<tg[2]
end
function cm.lcheck(g,lc)
	return g:IsExists(cm.lcheckfilter,1,nil)
end
--Act Limit
function cm.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and tc:IsDefenseBelow(1000) and not tc:IsImmuneToEffect(e)
end
--Negate
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsDefenseAbove(1000)
		and Duel.IsChainNegatable(ev)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,re:GetHandler(),1,tp,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	if rc:IsRelateToEffect(re) and rc:IsAbleToRemove() then
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
end