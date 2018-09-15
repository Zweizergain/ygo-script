--光炎双爆裂
function c10150051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10150051.cost)
	e1:SetTarget(c10150051.target)
	e1:SetOperation(c10150051.activate)
	c:RegisterEffect(e1)	   
end

function c10150051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c10150051.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   local g=Duel.GetMatchingGroup(c10150051.cfilter,tp,LOCATION_MZONE,0,nil)
	   return g:GetCount()>0 and g:GetClassCount(Card.GetAttribute)>=2 and Duel.IsExistingMatchingCard(c10150051.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local dg=Duel.GetMatchingGroup(c10150051.desfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end

function c10150051.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c10150051.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(dg,REASON_EFFECT)
end

function c10150051.desfilter(c)
	return c:IsDestructable() and (c:IsFacedown() or (c:IsFaceup() and not (c:IsLevelAbove(7) and c:IsRace(RACE_DRAGON))))
end

function c10150051.cfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(7) and c:IsRace(RACE_DRAGON)
end