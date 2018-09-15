--猛毒性 格缤
function c24562470.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,2,c24562470.lcheck)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24562470,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,24562470)
	e1:SetCondition(c24562470.bcon)
	e1:SetTarget(c24562470.btg)
	e1:SetOperation(c24562470.bop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24562470,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c24562470.mcost)
	e2:SetOperation(c24562470.mop)
	c:RegisterEffect(e2)
end
function c24562470.fil3(c,e,tp,zone)
	return c:IsSetCard(0x1390) and c:IsAbleToRemoveAsCost()
end
function c24562470.mcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24562470.fil3,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24562470.fil3,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c24562470.mop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
end
function c24562470.fil2(c,e,tp,zone)
	return c:IsSetCard(0x1390) and c:IsSummonable(true,nil,nil,zone) and c:IsType(TYPE_MONSTER)
end
function c24562470.btg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(c24562470.fil2,tp,LOCATION_HAND,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c24562470.bop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c24562470.fil2,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil,nil,zone)
	if g:GetFirst():IsType(TYPE_DUAL) and not g:GetFirst():IsDualState() then
		g:GetFirst():EnableDualState()
	end
	end
end
function c24562470.bcon(e)
	local c=e:GetHandler()
	local gc=c:GetLinkedGroup():FilterCount(c24562470.fil1,nil)
	return gc==0
end
function c24562470.fil1(c)
	return not c:IsSetCard(0x1390) and c:IsFaceup()
end
function c24562470.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x1390)
end