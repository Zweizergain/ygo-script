--名刀 数珠丸恒次
function c62899998.initial_effect(c)
	   --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c62899998.xyzfilter),aux.NonTuner(c62899998.xyzfilter),1)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62899998,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c62899998.eqtg)
	e1:SetOperation(c62899998.eqop)
	c:RegisterEffect(e1) 
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetRange(LOCATION_MZONE)
	e2:SetDescription(aux.Stringid(62899998,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,62899998)
	e2:SetCondition(c62899998.condition)
	e2:SetTarget(c62899998.target)
	e2:SetOperation(c62899998.operation)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(62899998,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c62899998.discon)
	e3:SetCost(c62899998.discost)
	e3:SetTarget(c62899998.distg)
	e3:SetOperation(c62899998.disop)
	c:RegisterEffect(e3)
	--equip effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(1100)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetRange(LOCATION_SZONE)
	e5:SetDescription(aux.Stringid(62899998,1))
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetCountLimit(1,62899997)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c62899998.condition2)
	e5:SetTarget(c62899998.target)
	e5:SetOperation(c62899998.operation2)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(62899998,2))
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCountLimit(1)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c62899998.discon2)
	e6:SetCost(c62899998.discost)
	e6:SetTarget(c62899998.distg)
	e6:SetOperation(c62899998.disop2)
	c:RegisterEffect(e6)
end
function c62899998.xyzfilter(c)
	return c:IsSetCard(0x620) and not c:IsSetCard(0x1620) and not c:IsSetCard(0x2620)
end
function c62899998.eqfilter(c,tc)
	return c:GetEquipCount()==0 and c:IsFaceup() and c~=tc
end
function c62899998.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c62899998.eqfilter(chkc,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingTarget(c62899998.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler()) 
	 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c62899997.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e:GetHandler())
end
function c62899998.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsLocation(LOCATION_SZONE) or c:IsFacedown() then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetValue(c62899998.eqlimit)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
function c62899998.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c62899998.cfilter(c,tp)
	return  c:GetSequence()<5 and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp 
end
function c62899998.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c62899998.cfilter,1,nil,tp)
end
function c62899998.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c62899998.cfilter,1,nil,tp) and e:GetHandler():GetEquipTarget()~=nil
end
function c62899998.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c62899998.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c62899998.operation2(e,tp,eg,ep,ev,re,r,rp)
	 if not e:GetHandler():IsRelateToEffect(e) then return end 
   local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c62899998.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c62899998.filter(c)
	return  c:GetSequence()<5 and c:IsFaceup() and c:IsReleasable()
end
function c62899998.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c62899998.filter,tp,LOCATION_SZONE,0,1,nil) end
   local g=Duel.SelectMatchingCard(tp,c62899998.filter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c62899998.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c62899998.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c62899998.discon2(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetEquipTarget()~=nil and Duel.IsChainNegatable(ev)
end
function c62899998.disop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
   if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
