--半分虚幻的庭师 魂魄妖梦
require "nef/thcz"
function c1230401.initial_effect(c)
	--synchro summon
	Thcz.TheSynchroSummonOfPaysageONLY(c,Thcz.Tfilter,Thcz.NTfilter,true,nil)
	--aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--无敌，真的是无敌，这卡强到没法解
	--迟早变龟
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1230401,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c1230401.condition)
	e1:SetTarget(c1230401.target)
	e1:SetOperation(c1230401.operation)
	c:RegisterEffect(e1)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsRelateToBattle()
	end)
	e7:SetOperation(c1230401.atkop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return bit.band(r,REASON_EFFECT)~=0 and re:GetHandler()==e:GetHandler()
	end)
	e8:SetOperation(c1230401.atkop2)
	c:RegisterEffect(e8)
end
function c1230401.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
		and bit.band(rc:GetSummonType(),SUMMON_TYPE_SPECIAL)>0
end
function c1230401.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c1230401.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:GetAttack()>=1600 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-1600)
		c:RegisterEffect(e1)
		local rc=re:GetHandler()
		if Duel.NegateActivation(ev) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end 
end
function c1230401.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local q=math.min(bc:GetBaseAttack()/2,4000)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(q)
	c:RegisterEffect(e1)
end
function c1230401.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=eg:GetFirst()
	local q=math.min(bc:GetBaseAttack()/2,4000)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(q)
	c:RegisterEffect(e1)
end
