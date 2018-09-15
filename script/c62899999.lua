--薙刀 岩融
function c62899999.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c62899999.xyzfilter),4,2)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3405259,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,62800000)
	e1:SetTarget(c62899999.eqtg)
	e1:SetOperation(c62899999.eqop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62899999,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,62899999)
	e2:SetCost(c62899999.cost)
	e2:SetTarget(c62899999.destg)
	e2:SetOperation(c62899999.desop)
	c:RegisterEffect(e2)
	--equip effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c62899999.xyzfilter(c)
	return c:IsSetCard(0x620) and not c:IsSetCard(0x2620) 
and not c:IsSetCard(0x1620)
end
function c62899999.eqfilter(c)
	return c:GetEquipCount()==0 and c:IsFaceup()
end
function c62899999.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c62899999.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c62899999.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
and Duel.GetLocationCount(tp,LOCATION_SZONE)>0  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c62899999.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c62899999.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsLocation(LOCATION_SZONE) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetValue(c62899999.eqlimit)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
function c62899999.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c62899999.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c62899999.filter(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk 
end
function c62899999.filter2(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk 
end
function c62899999.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c62899999.filter,tp,0,LOCATION_MZONE,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c62899999.filter,tp,0,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c62899999.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c62899999.filter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	 local g2=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
   local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		local dg=Duel.GetOperatedGroup()
		local tc=dg:GetFirst()
		local atk=0
		while tc do
			local tatk=tc:GetTextAttack()
			if tatk>0 then atk=atk+tatk end
			tc=dg:GetNext()
		end
		local dam=Duel.Damage(tp,atk/2,REASON_EFFECT)
		if dam>0 then
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	 if  (Duel.GetMatchingGroup(c62899999.filter,tp,0,LOCATION_MZONE,nil,c:GetAttack()) or ct<g:GetCount()) and g2:GetCount()>0  and Duel.SelectYesNo(tp,aux.Stringid(1344018,1)) then
	  Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g2:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	   if Duel.IsExistingMatchingCard(c62899999.filter2,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) then
		 Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		 Duel.Damage(tp,dam,REASON_EFFECT)
	   end
	else
	if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1344018,1)) then
	  Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g2:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	 if Duel.IsExistingMatchingCard(c62899999.filter2,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) then
		 Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		 Duel.Damage(tp,dam,REASON_EFFECT)
	   end
	end
end