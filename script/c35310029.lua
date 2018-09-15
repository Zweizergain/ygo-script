--远古恶魔原型-初阶逆臣
function c35310029.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35310029,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,35310029)
	e1:SetCondition(c35310029.condition)
	e1:SetTarget(c35310029.sptg)
	e1:SetOperation(c35310029.spop)
	c:RegisterEffect(e1)   
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(35310029)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2) 
	--Atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3656))
	e4:SetValue(c35310029.val)
	--c:RegisterEffect(e4)
end
function c35310029.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_MONSTER)*200
end
function c35310029.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3656) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousSetCard(0x3656) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c35310029.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c35310029.cfilter,1,nil)
end
function c35310029.filter(c,e,tp)
	return c:IsSetCard(0x3656) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c35310029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c35310029.filter,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function c35310029.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c35310029.filter,tp,LOCATION_HAND,0,1,1,c,e,tp)
	if g:GetCount()>0 then
	   g:AddCard(c)
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

