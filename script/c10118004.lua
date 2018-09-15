--季雨 甜蜜紫绀
function c10118004.initial_effect(c)
	c:EnableReviveLimit() 
	--spsummon 
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),2,2)
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),2,false)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10118004,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCountLimit(1)
	e1:SetCondition(c10118004.descon)
	e1:SetCost(c10118004.descost)
	e1:SetTarget(c10118004.destg)
	e1:SetOperation(c10118004.desop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetOperation(c10118004.rmop)
	c:RegisterEffect(e2) 
	--instead
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetTarget(c10118004.reptg)
	e3:SetValue(c10118004.repval)
	e3:SetOperation(c10118004.repop)
	e3:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e3)
end
function c10118004.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsSetCard(0x5331) and (c:GetDestination()==LOCATION_REMOVED or c:IsReason(REASON_DESTROY) or c:IsReason(REASON_RELEASE))
end
function c10118004.repval(e,c)
	return c10118004.repfilter(c,e:GetHandlerPlayer())
end
function c10118004.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and eg:IsExists(c10118004.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler())
end
function c10118004.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c10118004.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsSummonType(SUMMON_TYPE_LINK) and bc then
	   Duel.Hint(HINT_CARD,0,10118004)
	   Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end
function c10118004.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsRelateToBattle() and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c10118004.cfilter(c)
	return c:IsSetCard(0x5331) and c:IsAbleToGraveAsCost()
end
function c10118004.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10118004.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10118004.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10118004.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c10118004.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
	   Duel.Destroy(bc,REASON_EFFECT)
	end
end