local m=13570534
local cm=_G["c"..m]
cm.name="歪秤歪魔 厄伦斯托"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Pendulum
	aux.EnablePendulumAttribute(c,false)
	--Fusion Material
	aux.AddFusionProcFun2(c,cm.ffilter1,cm.ffilter2,true)
	--Disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_PZONE,0)
	e1:SetTarget(cm.distarget)
	c:RegisterEffect(e1)
	--Disable Effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	--Pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
--Fusion Material
function cm.ffilter1(c)
	return c:IsRace(RACE_FAIRY) and c:IsFusionType(TYPE_PENDULUM)
end
function cm.ffilter2(c)
	return c:IsRace(RACE_FIEND) and c:IsFusionType(TYPE_PENDULUM)
end
--Disable
function cm.distarget(e,c)
	return c~=e:GetHandler()
end
--Disable Effect
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	if re:GetHandler()~=e:GetHandler() and re:GetActiveType()==TYPE_PENDULUM+TYPE_SPELL
		and p==tp and bit.band(loc,LOCATION_PZONE)~=0 then
		Duel.NegateEffect(ev)
	end
end
--Pendulum set
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end