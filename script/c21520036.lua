--极乱数 多态
function c21520036.initial_effect(c)
--[[--tribute limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRIBUTE_LIMIT)
	e1:SetValue(c21520036.tlimit)
	c:RegisterEffect(e1)--]]
	--cannot disable summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--CANNOT_DISABLE_SUMMON
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	c:RegisterEffect(e1)
	--summon with 3 tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e2:SetCondition(c21520036.ttcon)
	e2:SetOperation(c21520036.ttop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_LIMIT_SET_PROC)
	e3:SetCondition(c21520036.setcon)
	c:RegisterEffect(e3)
	--atk def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c21520036.valoperation)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--negate summon effect
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCondition(c21520036.condition)
	e6:SetCost(c21520036.cost)
	e6:SetTarget(c21520036.target)
	e6:SetOperation(c21520036.activate)
	c:RegisterEffect(e6)
end
function c21520036.tlimit(e,c)
	return not c:IsSetCard(0x493)
end
function c21520036.ttcon(e,c)
	if c==nil then return true end
	local mg=Duel.GetFieldGroup(c:GetControler(),LOCATION_MZONE,LOCATION_MZONE)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3 and Duel.CheckTribute(c,3,3,mg)
end
function c21520036.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetFieldGroup(c:GetControler(),LOCATION_MZONE,LOCATION_MZONE)
	local g=Duel.SelectTribute(tp,c,3,3,mg,true)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		--not randomly
		if not tc:IsSetCard(0x493) then
			if tc:IsType(TYPE_XYZ) then 
				sum=sum+tc:GetOriginalRank()
			else
				sum=sum+tc:GetOriginalLevel()
			end
		end
		tc=g:GetNext()
	end
	if sum>0 and not Duel.IsExistingMatchingCard(c21520036.chkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		Duel.BreakEffect()
		Duel.Damage(tp,sum*500,REASON_RULE)
	end
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c21520036.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x493) and c:IsType(TYPE_FIELD)
end
function c21520036.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c21520036.valoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	local tc=g:GetFirst()
	local atk=0
	local def=0
	while tc do
		atk=atk+tc:GetAttack()
		def=def+tc:GetDefense()
		tc=g:GetNext()
	end
	if c:GetSummonType()==SUMMON_TYPE_SPECIAL then
		atk=math.ceil(atk/2)
		def=math.ceil(def/2)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(def)
	c:RegisterEffect(e2)
end
function c21520036.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and not e:GetHandler():IsHasEffect(EFFECT_REVERSE_UPDATE)
end
function c21520036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttack()>=2048 and e:GetHandler():GetDefense()>=2048 and not e:GetHandler():IsHasEffect(EFFECT_REVERSE_UPDATE) end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-2048)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
function c21520036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c21520036.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local rc=re:GetHandler()
	local player=rc:GetControler()
	rc:CancelToGrave()
	if rc:IsRelateToEffect(re) then
		Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		local dg=Duel.GetMatchingGroup(Card.IsAbleToHand,player,LOCATION_DECK,0,nil)
		if dg:GetCount()==0 then return end
		if ct~=0 then
			Duel.ShuffleDeck(player)
			Duel.BreakEffect()
			local tg=dg:RandomSelect(player,1)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-player,tg)
		end
	end
end
