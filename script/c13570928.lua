local m=13570928
local cm=_G["c"..m]
cm.name="歪秤 邪音鸟人"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion
	aux.AddFusionProcFun2(c,cm.ffilter1,cm.ffilter2,true)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.sprcon)
	e1:SetOperation(cm.sprop)
	c:RegisterEffect(e1)
	--Extra Attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(cm.atk)
	c:RegisterEffect(e2)
	--Cannot Attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetCondition(cm.con)
	c:RegisterEffect(e3)
end
--Fusion
function cm.ffilter1(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.ffilter2(c)
	return c:IsRace(RACE_WINDBEAST)
end
--Special Summon
function cm.cfilter(c,fc)
	return (cm.ffilter1(c) or cm.ffilter2(c)) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
end
function cm.spfilter1(c,tp,g)
	return g:IsExists(cm.spfilter2,1,c,tp,c)
end
function cm.spfilter2(c,tp,mc)
	return ((cm.ffilter1(c) and cm.ffilter2(mc)) or (cm.ffilter2(c) and cm.ffilter1(mc)))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil,c)
	return mg:IsExists(cm.spfilter1,1,nil,tp,mg)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=mg:FilterSelect(tp,cm.spfilter1,1,1,nil,tp,mg)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=mg:FilterSelect(tp,cm.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_COST)
end
--Extra Attack
function cm.atk(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)-1
end
--Cannot Attack
function cm.con(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==0
end