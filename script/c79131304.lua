--灵噬领主 克蒂氤
function c79131304.initial_effect(c)
	--XYZ material
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1201),8,3,c79131304.ovfilter,aux.Stringid(79131304,0),3,c79131304.xyzop)
	--to grave and  atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79131304,1))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79131304)
	e1:SetCost(c79131304.tgcost)
	e1:SetTarget(c79131304.tgtg)
	e1:SetOperation(c79131304.tgop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79131304,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79131304.discon)
	e2:SetCost(c79131304.discost)
	e2:SetTarget(c79131304.distg)
	e2:SetOperation(c79131304.disop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79131304,3))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(c79131304.drtg)
	e3:SetOperation(c79131304.drop)
	c:RegisterEffect(e3)
end
function c79131304.ovfilter(c)
	return c:IsFaceup() and c:IsCode(79131305) and Duel.GetFlagEffect(tp,79131304)==0
end
function c79131304.xyzop(e,tp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,79131304,RESET_PHASE+PHASE_END,0,1)
end
function c79131304.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1206,2,REASON_COST) 
		and Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1206)>=3 end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1206,2,REASON_COST)
end
function c79131304.tgfilter(c)
	return c:GetCounter(0x1206)~=0 and c:IsType(TYPE_MONSTER)
end
function c79131304.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then 
		if chkc then return chkc:IsOnField() and c79131304.tgfilter(chkc) end
		return Duel.IsExistingTarget(c79131304.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	if not Duel.IsExistingTarget(c79131304.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c79131304.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,0,math.max(g:GetFirst():GetTextAttack(),0))
end
function c79131304.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then 
		if Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
			local e2=Effect.CreateEffect(c)
			e2:SetCategory(CATEGORY_ATKCHANGE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			e2:SetValue(math.max(tc:GetTextAttack(),0))
			c:RegisterEffect(e2)
		end
	end
end
function c79131304.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c79131304.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79131304.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c79131304.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c79131304.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c79131304.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
