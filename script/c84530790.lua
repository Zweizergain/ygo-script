--幻灭神话 妖精公主·阿丽雅
function c84530790.initial_effect(c)
	c:SetSPSummonOnce(84530790)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,c84530790.ffilter2,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),1,99,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c84530790.tgtg)
	e1:SetValue(c84530790.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c84530790.tgtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(84530790,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c84530790.hdcon)
	e4:SetOperation(c84530790.hdreg)
	c:RegisterEffect(e4)
end
function c84530790.ffilter2(c)
	return c:IsSetCard(0x8351) and c:GetLevel()==1
end
function c84530790.atkval(e,c)
	return e:GetHandler():GetMaterialCount()*250
end
function c84530790.tgtg(e,c)
	return (c:GetLevel()==1 or c:GetRank()==1 or c:GetLink()==1) and c:IsSetCard(0x8351)
end
function c84530790.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c84530790.hdreg(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	e1:SetOperation(c84530790.hdop)
	Duel.RegisterEffect(e1,tp)
end
function c84530790.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_DISCARD+REASON_EFFECT)
	end
end