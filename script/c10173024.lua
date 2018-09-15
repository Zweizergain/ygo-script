--雷闪幻狮
function c10173024.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10173024.adcon)
	e1:SetValue(c10173024.adval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--immue
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c10173024.efilter)
	c:RegisterEffect(e2)
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_FLIP)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c10173024.flipop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c10173024.adcon(e)
	return e:GetHandler():GetFlagEffect(10173024)~=0
end
function c10173024.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(10173024,RESET_EVENT+0x1fe0000,0,1)
end
function c10173024.efilter(e,te)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil)
	if g:GetCount()<=0 then return false end
	local mg,ct=g:GetMaxGroup(Card.GetAttack)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and mg:GetCount()>0 and mg:IsContains(te:GetOwner())
end
function c10173024.adval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil)
	local ct=g:GetSum(c10173024.adfilter)
	return ct*400
end
function c10173024.adfilter(c)
	if c:IsType(TYPE_XYZ) then
	   return c:GetRank()
	else 
	   return c:GetLevel()
	end
end