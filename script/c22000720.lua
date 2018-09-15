--从者AlterGO 溶解莉莉丝
function c22000720.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,21000030,aux.FilterBoolFunction(Card.IsFusionSetCard,0xfff),1,true,false)
	c:EnableReviveLimit()
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c22000720.condition)
	e1:SetValue(c22000720.aclimit)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22000720,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MUST_ATTACK)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c22000720.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c22000720.condition(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c22000720.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c22000720.eftg(e,c)
	return c:IsFaceup()
end