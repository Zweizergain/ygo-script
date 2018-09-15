--猛毒性 音切
function c24562469.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetDescription(aux.Stringid(24562469,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,24562469)
	e1:SetTarget(c24562469.damtg)
	e1:SetOperation(c24562469.damop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(c24562469.damcon)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,24562470)
	e3:SetCondition(c24562469.e3con)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c24562469.damtg)
	e3:SetOperation(c24562469.damop)
	c:RegisterEffect(e3)
end
function c24562469.e3confil(c)
	return c:IsSetCard(0x1390) and c:IsType(TYPE_MONSTER)
end
function c24562469.e3con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24562469.e3confil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and aux.damcon1(e,1-tp,eg,ep,ev,re,r,rp)
end
function c24562469.damcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x1390)
end
function c24562469.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400)
end
function c24562469.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end