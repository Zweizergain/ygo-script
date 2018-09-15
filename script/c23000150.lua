--宝具 绚烂魔界日轮城
function c23000150.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23000150,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,23000150)
	e2:SetTarget(c23000150.sptg)
	e2:SetOperation(c23000150.spop)
	c:RegisterEffect(e2)
	--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23000150,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c23000150.atkcon)
	e3:SetCost(c23000150.atkcost)
	e3:SetOperation(c23000150.atkop)
	c:RegisterEffect(e3)
end
function c23000150.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,23000151,0,0x4011,1000,1000,4,RACE_ZOMBIE,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c23000150.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e)
		or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,23000151,0,0x4011,1000,1000,4,RACE_ZOMBIE,ATTRIBUTE_FIRE) then return end
	local token=Duel.CreateToken(tp,23000151)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c23000150.atkfilter(c)
	return c:IsFaceup() and c:IsCode(22000580)
end
function c23000150.atkcon(e)
	return Duel.GetMatchingGroupCount(c23000150.atkfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)>=1
end
function c23000150.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,23000151) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,23000151)
	Duel.Release(g,REASON_COST)
end
function c23000150.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c23000150.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c23000150.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
