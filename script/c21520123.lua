--朱星曜兽-鬼金羊
function c21520123.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520123,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(c21520123.condition)
	e1:SetOperation(c21520123.operation)
	c:RegisterEffect(e1)
end
function c21520123.filter(c)
	return c:IsFaceup() and c:IsCode(21520133) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c21520123.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.IsExistingMatchingCard(c21520123.filter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(21520133)) 
		and ev>=1800 and Duel.IsPlayerCanSpecialSummon(tp) and ep==tp and r&REASON_BATTLE~=0 and r&REASON_EFFECT~=0
end
function c21520123.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if c:IsPreviousLocation(LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	end
end
