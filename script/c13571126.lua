local m=13571126
local cm=_G["c"..m]
cm.name="森林守护者 玫玫"
function cm.initial_effect(c)
	--Cannot Be Link Material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Synchro Custom
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_CHECK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(cm.syncheck)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(cm.spcon)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
--Synchro Custom
function cm.syncheck(e,c)
	if c~=e:GetHandler() then
		c:AssumeProperty(ASSUME_LEVEL,1)
	end
end
--Special Summon
function cm.spfilter(c,ft,tp)
	return c:IsType(TYPE_LINK) and c:IsLinkBelow(2) and c:IsAbleToGraveAsCost()
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5))
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ft,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ft,tp)
	Duel.SendtoGrave(g,REASON_COST)
end