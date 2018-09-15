--腐朽世界
function c8011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_REPTILE)
	c:RegisterEffect(e2)
	--Summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,8000)
	e3:SetCondition(c8011.discon)
	e3:SetOperation(c8011.op)
	c:RegisterEffect(e3)
	--Recover
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c8011.target)
	e4:SetCountLimit(1,80000)
	e4:SetOperation(c8011.activate)
	c:RegisterEffect(e4)
end
function c8011.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=re:GetHandler()
	return ep==tp and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonCount(1-tp,1)
		and Duel.IsPlayerCanSpecialSummonMonster(1-tp,8100,0x901,0x4011,0,0,2,RACE_REPTILE,ATTRIBUTE_DARK) and re:IsActiveType(TYPE_MONSTER) and re:IsHasType(0x901) 
end
function c8011.op(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(1-tp,8100)
	Duel.SpecialSummon(token,0,1-tp,1-tp,false,false,POS_FACEUP)
end
function c8011.cfilter(c)
	return c:IsCode(8100) and c:IsDestructable()
end
function c8011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c8011.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c8011.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c8011.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Recover(e:GetHandlerPlayer(),1000,REASON_EFFECT)
	end
end