--远古恶魔的屏障
function c35310021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c35310021.indcon)
	e2:SetTargetRange(0,LOCATION_DECK)
	c:RegisterEffect(e2)	
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c35310021.reptg)
	e4:SetValue(c35310021.repval)
	e4:SetOperation(c35310021.repop)
	--c:RegisterEffect(e4)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c35310021.splimcon)
	e3:SetTarget(c35310021.splimit)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e5)
end
c35310021.setname="acfiend"
function c35310021.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c35310021.splimit(e,c)
	return not c:IsSetCard(0x3656)
end
function c35310021.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3656)
end
function c35310021.indcon(e)
	return Duel.IsExistingMatchingCard(c35310021.indfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c35310021.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x3656) and not c:IsReason(REASON_REPLACE)
end
function c35310021.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c35310021.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c35310021.repval(e,c)
	return c35310021.repfilter(c,e:GetHandlerPlayer())
end
function c35310021.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end