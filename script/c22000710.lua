--从者MoonCancer BB
function c22000710.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	--fusion summon
	aux.AddFusionProcMix(c,true,true,c22000710.fusfilter1,c22000710.fusfilter2,c22000710.fusfilter3)
	c:EnableReviveLimit()
	--activate cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c22000710.thcon)
	e1:SetCost(c22000710.costchk)
	e1:SetOperation(c22000710.costop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22000710,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22000710.discon)
	e2:SetOperation(c22000710.desop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c22000710.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22000710,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCountLimit(1,22000710)
	e4:SetCost(c22000710.spcost)
	e4:SetTarget(c22000710.sptg)
	e4:SetOperation(c22000710.spop)
	c:RegisterEffect(e4)
end
function c22000710.fusfilter1(c)
	return c:IsCode(21000030)
end
function c22000710.fusfilter2(c)
	return c:IsSetCard(0xfff)
end
function c22000710.fusfilter3(c)
	return c:IsRace(RACE_CYBERSE)
end
function c22000710.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c22000710.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,22000710)
	local g=Duel.GetDecktopGroup(tp,1)
	return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==1
end
function c22000710.costop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c22000710.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c22000710.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
function c22000710.eftg(e,c)
	return c:IsFaceup()
end
function c22000710.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfff) and c:IsAbleToRemoveAsCost()
end
function c22000710.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22000710.costfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22000710.costfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c22000710.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22000710.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end