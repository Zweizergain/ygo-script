--刀舞重铸
function c62800005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetTarget(c62800005.target)
	e1:SetOperation(c62800005.activate)
	c:RegisterEffect(e1)
end
function c62800005.filter(c)
	return c:IsReleasable() and c:IsType(TYPE_EQUIP) and c:IsSetCard(0x620) 
   and not  c:IsSetCard(0x2620)
end
function c62800005.eqfilter(c)
   return  c:IsType(TYPE_MONSTER) and c:IsSetCard(0x620) 
   and not  c:IsSetCard(0x2620) and not c:IsForbidden()
end
function c62800005.target(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=Duel.GetMatchingGroup(c62800005.filter,tp,LOCATION_SZONE,0,nil)
	if chk==0 then
	 return g:GetCount()>0 
	 and Duel.IsExistingMatchingCard(c62800005.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,g:GetCount(),nil)
	 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)  end
	local rg=Duel.Release(g,REASON_COST)
	e:SetLabel(rg)
 Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c62800005.activate(e,tp,eg,ep,ev,re,r,rp)
	 local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<e:GetLabel() then return end
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
   local tc=g:GetFirst()
	local eq=Duel.GetMatchingGroup(c62800005.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	for i=1,e:GetLabel() do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(69933858,1))
		local ec=eq:Select(tp,1,1,nil):GetFirst()
		eq:RemoveCard(ec)
		 Duel.Equip(tp,ec,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(c62800005.eqlimit)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		ec:RegisterEffect(e1)
	end
end
function c62800005.eqlimit(e,c)
	return c==e:GetLabelObject()
end
