--素星曜兽-毕月乌
function c21520119.initial_effect(c)
	--special summon in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c21520119.spcon)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCondition(c21520119.dcon)
	e2:SetTarget(c21520119.dtg)
	e2:SetOperation(c21520119.dop)
	c:RegisterEffect(e2)
end
function c21520119.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_MZONE,0,nil,TYPE_MONSTER)==0
end
function c21520119.dcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_SUMMON) and c:GetReasonCard():IsSetCard(0x491)
end
function c21520119.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c21520119.dop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Draw(tp,2,REASON_EFFECT)
	if ct==0 then return end
end
