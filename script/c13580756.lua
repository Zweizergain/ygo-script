local m=13580756
local tg={13580300,13580399,13580100,13580799}
local cm=_G["c"..m]
cm.name="虹迹 怨冥毒蛛"
function cm.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--Release
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_RELEASE)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.isset(c)
	return (c:GetCode()>tg[1] and c:GetCode()<tg[2])
		or (c:GetCode()>tg[3] and c:GetCode()<tg[4] and c:GetCode()%100>50)
end
--Special Summon Self
function cm.spfilter(c,ft)
	return (c:IsFaceup() or (ft>0 and c:IsLocation(LOCATION_HAND))) and cm.isset(c) and c:IsReleasable()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c,ft)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c,ft)
	Duel.Release(g,REASON_COST)
end
--Release
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-800)
end