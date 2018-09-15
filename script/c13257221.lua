--宇宙战争兵器 主炮 电浆炮
function c13257221.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(c13257221.eqlimit)
	c:RegisterEffect(e11)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(c13257221.econ)
	e12:SetValue(c13257221.efilter)
	c:RegisterEffect(e12)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(700)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c13257221.damcon)
	e3:SetOperation(c13257221.damop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c13257221.damcon1)
	e4:SetOperation(c13257221.damop1)
	c:RegisterEffect(e4)
	--Mk-4 Laser
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(13257221,0))
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c13257221.econ)
	e8:SetTarget(c13257221.destg)
	e8:SetOperation(c13257221.desop)
	c:RegisterEffect(e8)
	c:RegisterFlagEffect(13257201,0,0,0,4)
	
end
function c13257221.eqlimit(e,c)
	local eg=c:GetEquipGroup()
	local lv=c:GetOriginalLevel()
	if lv==nil then lv=0 end
	if not eg:IsContains(e:GetHandler()) then
		eg:AddCard(e:GetHandler())
	end
	local cl=c:GetFlagEffectLabel(13257200)
	if cl==nil then
		cl=0
	end
	local er=e:GetHandler():GetFlagEffectLabel(13257201)
	if er==nil then
		er=0
	end
	return not (er>cl) and not (eg:Filter(Card.IsSetCard,nil,0x354):GetSum(Card.GetLevel)>lv) and not c:GetEquipGroup():IsExists(Card.IsCode,1,e:GetHandler(),e:GetHandler():GetCode())
end
function c13257221.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function c13257221.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c13257221.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetEquipTarget() and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c13257221.damop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
	if ec then
		local ct1=ec:GetFlagEffectLabel(13257200)*100
		if ct>0 and ct1>0 then
			Duel.Hint(HINT_CARD,1,13257221)
			Duel.Damage(1-tp,ct*ct1,REASON_EFFECT)
		end
	end
end
function c13257221.damfilter(c,tp)
	return c:GetPreviousControler()==tp
end
function c13257221.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetEquipTarget() and eg:IsExists(c13257221.damfilter,1,nil,1-tp)
end
function c13257221.damop1(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local ct=eg:FilterCount(c13257221.damfilter,nil,1-tp)
	if ec then
		local ct1=ec:GetFlagEffectLabel(13257200)*100
		if ct>0 and ct1>0 then
			Duel.Hint(HINT_CARD,1,13257221)
			Duel.Damage(1-tp,ct*ct1,REASON_EFFECT)
		end
	end
end
function c13257221.desfilter(c)
	return c:GetSequence()==0 or c:GetSequence()==4
end
function c13257221.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c13257221.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c13257221.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c13257221.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13257221.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
