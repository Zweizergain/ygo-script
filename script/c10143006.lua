--夺宝奇兵·克尔苏加德
function c10143006.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCondition(c10143006.indcon)
	e1:SetCountLimit(1)
	e1:SetValue(c10143006.valcon)
	c:RegisterEffect(e1)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c10143006.aclimit)
	e3:SetCondition(c10143006.actcon)
	c:RegisterEffect(e3)  
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c10143006.atkval)
	c:RegisterEffect(e4)
end

function c10143006.atkval(e,c)
	return Duel.GetMatchingGroupCount(c10143006.indfilter,c:GetControler(),LOCATION_SZONE,LOCATION_SZONE,nil)*600
end

function c10143006.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

function c10143006.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

function c10143006.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10143006.indfilter,tp,LOCATION_SZONE,0,1,nil)
end

function c10143006.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6333) and c:GetSequence()<5
end

function c10143006.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end