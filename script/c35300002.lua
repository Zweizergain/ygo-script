--天魔领域
function c35300002.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c35300002.indcon)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35300002,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCountLimit(1)
	e2:SetCondition(c35300002.ntcon)
	e2:SetTarget(c35300002.nttg)
	e2:SetOperation(c35300002.ntop)
	c:RegisterEffect(e2) 
	--effect indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c35300002.indcon)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	--e4:SetTarget(c35300002.disable)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
end
c35300002.setname="skydemon"
function c35300002.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c35300002.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c35300002.cfilter(c)
	return c:IsSetCard(0x1656) and c:IsFaceup()
end
function c35300002.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c35300002.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x1656)
end
function c35300002.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	return
end
