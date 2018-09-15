--背水•刀舞之决意！
function c62800015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
   e1:SetCountLimit(1,62800015)
	e1:SetCondition(c62800015.con)
	e1:SetTarget(c62800015.target)
	e1:SetOperation(c62800015.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
     e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	 e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	 e2:SetCountLimit(1,62800015)
	e2:SetCondition(c62800015.con)
	e2:SetTarget(c62800015.target)
	e2:SetOperation(c62800015.activate)
	c:RegisterEffect(e2)
   local e3=e2:Clone()
	 e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
function c62800015.filter(c,e,tp)
	return c:IsSetCard(0x620) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
   and Duel.IsExistingMatchingCard(c62800015.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c) 
end
function c62800015.filter2(c)
	return c:IsSetCard(0x620) and not c:IsSetCard(0x2620) and c:IsType(TYPE_MONSTER) and
	not c:IsForbidden()
end
function c62800015.filter3(c)
	return c:IsSetCard(0x620) and not c:IsSetCard(0x2620) and not c:IsSetCard(0x1620)
end
function c62800015.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<3000 and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil)
end
function c62800015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and 
   Duel.IsExistingMatchingCard(c62800015.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	if Duel.GetMatchingGroupCount(c62800015.filter3,tp,LOCATION_GRAVE,0,nil)>4 then
  Duel.SetChainLimit(c62800015.chlimit)   
end
end
function c62800015.chlimit(e,ep,tp)
	return tp==ep
end
function c62800015.activate(e,tp,eg,ep,ev,re,r,rp)
	 local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 and  Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	 local tg=Duel.SelectMatchingCard(tp,c62800015.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if tg:GetCount()>0 and Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)>0 and   ft>0 then
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(69933858,1))   
   local eq=Duel.SelectMatchingCard(tp,c62800015.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil)
	   local tc=eq:GetFirst()
	 while tc do
		 Duel.Equip(tp,tc,tg:GetFirst())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(c62800015.eqlimit)
		e1:SetLabelObject(tg:GetFirst())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	  tc=eq:GetNext()
	end
end
end
end
function c62800015.eqlimit(e,c)
	return e:GetOwner()==c
	
end
