--白色魔术舞台
function c34340035.initial_effect(c)
	c:EnableCounterPermit(0x1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c34340035.ctcon)
	e2:SetOperation(c34340035.ctop)
	c:RegisterEffect(e2)	
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(34340035,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c34340035.spcon)
	e3:SetTarget(c34340035.sptg)
	e3:SetOperation(c34340035.spop)
	c:RegisterEffect(e3)
	--change effect
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(34340035,1))
	e21:SetType(EFFECT_TYPE_QUICK_O)
	e21:SetCode(EVENT_CHAINING)
	e21:SetRange(LOCATION_FZONE)
	e21:SetCountLimit(1)
	e21:SetCondition(c34340035.chcon)
	e21:SetCost(c34340035.chcost)
	e21:SetTarget(c34340035.chtg)
	e21:SetOperation(c34340035.chop)
	c:RegisterEffect(e21)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(c34340035.desreptg)
	e5:SetOperation(c34340035.desrepop)
	c:RegisterEffect(e5)
end
function c34340035.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0x1)>0 end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c34340035.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x1,1,REASON_EFFECT)
end
function c34340035.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1,1,REASON_COST)
end
function c34340035.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c34340035.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,rp,0,LOCATION_MZONE,1,nil) end
end
function c34340035.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c34340035.repop)
end
function c34340035.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP then
		c:CancelToGrave(false)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
	   Duel.Destroy(g,REASON_EFFECT)
	end
end
function c34340035.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2 
end
function c34340035.filter(c,e,tp)
	return c.setname=="WhiteMagician" and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c34340035.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c34340035.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c34340035.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c34340035.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c34340035.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp
end
function c34340035.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c34340035.ctfilter,1,nil,tp)
end
function c34340035.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1,1)
end
