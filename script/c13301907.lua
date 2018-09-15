--MONSTER Gakuma α
function c13301907.initial_effect(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(EFFECT_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c13301907.distg)
	e1:SetOperation(c13301907.disop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c13301907.atkcon)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c13301907.spcon)
	e3:SetTarget(c13301907.sptg)
	e3:SetOperation(c13301907.spop)
	c:RegisterEffect(e3)
end
function c13301907.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c13301907.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13301907.disfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c13301907.disfilter2(c,e,atk)
	local atk=e:GetHandler():GetAttack()
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e) and c:GetAttack()<atk
end
function c13301907.disop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c13301907.disfilter2,tp,0,LOCATION_MZONE,nil,e)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		  Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_DISABLE)
		  e1:SetReset(RESET_EVENT+0x1fe0000)
		  tc:RegisterEffect(e1)
		  tc=sg:GetNext()
	end
end
function c13301907.atkcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,13301908)
end
function c13301907.cfilter(c)
	return c:IsFaceup() and c:IsCode(13301908)
end
function c13301907.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	return not Duel.IsExistingMatchingCard(c13301907.cfilter,tp,LOCATION_MZONE,0,1,nil) and 
		   c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c13301907.filter(c,e,tp)
	return c:IsCode(13301908) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c13301907.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c13301907.filter1,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c13301907.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13301907.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end