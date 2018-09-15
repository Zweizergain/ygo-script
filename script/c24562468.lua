--猛毒性 球糸
function c24562468.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24562468,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,24562468)
	e1:SetCondition(c24562468.e1con)
	e1:SetTarget(c24562468.e1tg)
	e1:SetOperation(c24562468.e1op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCountLimit(1)
	e2:SetValue(c24562468.ind2)
	c:RegisterEffect(e2)
end
function c24562468.ind2(e,c)
	return c:IsType(TYPE_MONSTER) and (c:GetLevel()==0 or c:IsLevelBelow(7))
end
function c24562468.e1con(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(c24562468.e1fil,tp,0,LOCATION_ONFIELD,nil)<=0 then return false end
	return tp~=Duel.GetTurnPlayer()
end
function c24562468.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttacker()
	local c=e:GetHandler()
	if chkc then return chkc==at end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and at:IsControler(1-tp) and at:IsRelateToBattle() and at:IsCanBeEffectTarget(e)
	end
	Duel.SetTargetCard(at)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c24562468.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.NegateAttack() then
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end
function c24562468.e1fil(c)
	return c:IsSetCard(0x1390) and c:IsFaceup()
end