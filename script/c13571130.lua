local m=13571130
local cm=_G["c"..m]
cm.name="漆黑战士 吉鲁库"
function cm.initial_effect(c)
	--Position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.dmcon)
	e2:SetOperation(cm.dmop)
	c:RegisterEffect(e2)
end
--Position
function cm.confilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetControler()==1-tp
end
function cm.filter(c)
	return c:IsFaceup() and c:IsCanChangePosition()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.confilter,1,nil,tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
--Damage
function cm.dmfilter(c)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return (pp==POS_FACEUP_ATTACK and np==POS_FACEUP_DEFENSE)
		or (pp==POS_FACEUP_DEFENSE and np==POS_FACEUP_ATTACK)
		or (pp==POS_FACEUP_ATTACK and np==POS_FACEDOWN_DEFENSE)
end
function cm.dmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.dmfilter,1,nil)
end
function cm.dmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end