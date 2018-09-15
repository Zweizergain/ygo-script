--邪刀 妖刀村正
function c62899990.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c62899990.splimit)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(62899990,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c62899990.atktg)
	e3:SetOperation(c62899990.atkop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(62899990,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c62899990.cost)
	e4:SetTarget(c62899990.tg)
	e4:SetOperation(c62899990.op)
	c:RegisterEffect(e4)
end
function c62899990.splimit(e,se,sp,st)
	return  se:GetHandler():IsCode(62899993)
end
function c62899990.filter(c)
	return  c:IsSetCard(0x620)
end
function c62899990.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c62899990.filter,tp,LOCATION_GRAVE,0,nil)>0 end
end
function c62899990.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local ct=Duel.GetMatchingGroupCount(c62899990.filter,tp,LOCATION_GRAVE,0,nil)
		if ct>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*300)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
		end
	end
end
function c62899990.refilter(c)
	return  c:IsSetCard(0x620) and c:IsAbleToRemoveAsCost()
end
function c62899990.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c62899990.refilter,tp,LOCATION_GRAVE,0,nil)>0 end
   local g=Duel.GetMatchingGroup(c62899990.refilter,tp,LOCATION_GRAVE,0,nil)
   local dg=Duel.Remove(g,POS_FACEUP,REASON_COST)
   e:SetLabel(dg)
end
function c62899990.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
   Duel.SetTargetPlayer(1-tp)
	local dam=e:GetLabel()*200
	Duel.SetTargetParam(dam)  
   Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c62899990.op(e,tp,eg,ep,ev,re,r,rp)
	  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=e:GetLabel()*200
	Duel.Damage(p,dam,REASON_EFFECT)
end