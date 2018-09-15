--樱火装机 河津樱
function c17020004.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c17020004.splimit)
	c:RegisterEffect(e1)  
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17020004,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,17020004)
	e2:SetTarget(c17020004.destg)
	e2:SetOperation(c17020004.desop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17020004,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,17020104)
	e3:SetCondition(c17020004.thcon)
	e3:SetTarget(c17020004.thtg)
	e3:SetOperation(c17020004.thop)
	c:RegisterEffect(e3)
	--p set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17020004,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,17020104)
	e4:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e4:SetCost(c17020004.cost)
	e4:SetTarget(c17020004.target)
	e4:SetOperation(c17020004.operation)
	c:RegisterEffect(e4)
end
function c17020004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c17020004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c17020004.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c17020004.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c17020004.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c17020004.pcfilter(c)
	return c:IsSetCard(0x702) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and not c:IsCode(17020004)
end
function c17020004.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and not e:GetHandler():IsLocation(LOCATION_DECK)
end
function c17020004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17020004.rfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c17020004.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c17020004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c17020004.rfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g1:GetCount()<=0 or Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c17020004.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if sg:GetCount()<=0 or Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	sg:GetFirst():RegisterEffect(e1)
end
function c17020004.thfilter(c,e,tp)
	return c:IsCode(17020006) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17020004.rfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToRemove() and ((c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x702)) or c:IsAttribute(ATTRIBUTE_FIRE))
end
function c17020004.splimit(e,c)
	return not c:IsSetCard(0x702) and not c:IsCode(17020019)
end
function c17020004.desfilter(c)
	return c:IsSetCard(0x702)
end
function c17020004.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17020004.desfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
		and e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c17020004.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end