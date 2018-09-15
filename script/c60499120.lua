--决斗者联盟 传说丶馆主
function c60499120.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c60499120.sptg1)
	e0:SetOperation(c60499120.spop)
	c:RegisterEffect(e0)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60499120,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,60499120)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c60499120.thcost)
	e1:SetTarget(c60499120.tgtg)
	e1:SetOperation(c60499120.tgop)
	c:RegisterEffect(e1)   
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60499120,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,60499179)
	e2:SetCondition(c60499120.econ)
	e2:SetCost(c60499120.cost)
	e2:SetOperation(c60499120.operation1)
	c:RegisterEffect(e2) 
end
function c60499120.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c60499120.tgfilter(c)
	return c:IsSetCard(0xf707) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c60499120.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60499120.tgfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c60499120.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60499120.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,2,2,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c60499120.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,aux.TRUE,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c60499120.operation1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c60499120.indtg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(3000)
	Duel.RegisterEffect(e1,tp)
end
function c60499120.indtg(e,c)
	return c:IsCode(60499101)
end
function c60499120.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60499101,0,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_LIGHT)
		and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(1)
		e:GetHandler():RegisterFlagEffect(60499120,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60499120,3))
	else
		e:SetCategory(0)
		e:SetLabel(0)
	end
end
function c60499120.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,60499101,0,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,60499101)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60499120.filter11(c)
	return c:IsFaceup() and c:IsCode(60499105)
end
function c60499120.econ(e)
	return Duel.IsExistingMatchingCard(c60499120.filter11,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(60499105)
end