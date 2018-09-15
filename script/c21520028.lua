--极乱数 乐团
function c21520028.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),2)
	c:EnableReviveLimit()
	--change level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520028,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520028.rlevel)
	c:RegisterEffect(e1)
	--summons
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520028,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0xbf,0xbf)
	e2:SetOperation(c21520028.rlevel)
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
	e6:SetOperation(c21520028.valoperation)
	c:RegisterEffect(e6)
	--disable
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(21520028,1))
	e7:SetCategory(CATEGORY_NEGATE)
	e7:SetType(EFFECT_TYPE_QUICK_F)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c21520028.condition)
	e7:SetTarget(c21520028.target)
	e7:SetOperation(c21520028.operation)
	c:RegisterEffect(e7)
end
function c21520028.rlevel(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+17320+4)
	local val=math.random(1,900)
	val=math.fmod(val,9)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(val)
	c:RegisterEffect(e1)
end
function c21520028.valoperation(e,tp,eg,ep,ev,re,r,rp)
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
function c21520028.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and not re:GetHandler():IsSetCard(0x493)
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c21520028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c21520028.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or c:GetAttack()< 1024 or c:GetDefense()<1024 or not c:IsRelateToEffect(e) 
		or c:IsStatus(STATUS_BATTLE_DESTROYED) or Duel.GetCurrentChain()~=ev+1 then
		return
	end
	if Duel.NegateActivation(ev) then
		Duel.BreakEffect()
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
