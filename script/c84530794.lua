--幻灭神话 妖精的残念
function c84530794.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c84530794.condition)
	e1:SetOperation(c84530794.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,84530794)
	e2:SetCondition(c84530794.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c84530794.thtg)
	e2:SetOperation(c84530794.thop)
	c:RegisterEffect(e2)
end
function c84530794.cfilter(c,tp)
	return (c:GetLevel()==1 or c:GetRank()==1 or c:GetLink()==1) and c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x8351) and c:GetPreviousControler()==tp
end
function c84530794.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c84530794.cfilter,1,nil,tp)
end
function c84530794.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c84530794.indtg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	Duel.RegisterEffect(e2,tp)
		if Duel.IsExistingMatchingCard(c84530794.filter,tp,0,LOCATION_MZONE,1,nil)
			then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(c84530794.filter,tp,0,LOCATION_MZONE,nil)
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c84530794.splimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_SELF_TURN+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c84530794.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x8351)
end
function c84530794.filter(c)
	return c:IsFaceup() and c:IsAttackPos()
end
function c84530794.indtg(e,c)
	return (c:GetLevel()==1 or c:GetRank()==1 or c:GetLink()==1) and c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x8351)
end
function c84530794.cfilter2(c,tp)
	return (c:GetLevel()==1 or c:GetRank()==1 or c:GetLink()==1) and c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x8351) and c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
end
function c84530794.thcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetHandler()) then return false end
	return eg:IsExists(c84530794.cfilter2,1,nil,tp)
end
function c84530794.thfilter(c)
	return (c:GetLevel()==1 or c:GetRank()==1 or c:GetLink()==1) and c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x8351) and c:IsAbleToHand()
end
function c84530794.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84530794.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c84530794.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c84530794.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.Recover(tp,500,REASON_EFFECT)
	end
end