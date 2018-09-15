--极乱数 舞步
function c21520016.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),2)
	c:EnableReviveLimit()
	--change level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520016,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520016.rlevel)
	c:RegisterEffect(e1)
	--summons
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520016,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0xbf,0xbf)
	e2:SetOperation(c21520016.rlevel)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e4)
	--atk & def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c21520016.valoperation)
	c:RegisterEffect(e6)
	--to hand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(21520016,1))
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_BATTLE_DAMAGE)
	e7:SetCondition(c21520016.condition)
	e7:SetTarget(c21520016.target)
	e7:SetOperation(c21520016.operation)
	c:RegisterEffect(e7)
end
function c21520016.rlevel(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+17320+1)
	local val=math.random(1,900)
	val=math.fmod(val,9)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(val)
	c:RegisterEffect(e1)
end
function c21520016.valoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local val=0
	while tc do
		if not tc:IsType(TYPE_XYZ) then
			val=val+tc:GetLevel()*360
		end
		tc=g:GetNext()
	end
	if c:GetSummonType()~=SUMMON_TYPE_SYNCHRO then
		val=math.ceil(val/2)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
end
function c21520016.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c21520016.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c21520016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c21520016.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520016.filter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and c:GetAttack()>= 1024 and c:GetDefense()>=1024 then
		local rg=g:RandomSelect(tp,1)
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,rg)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0xdfc0000)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1024)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
