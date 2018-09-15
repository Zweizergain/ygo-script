--平青眼之哀刀客 冲田总司
function c62899995.initial_effect(c)
	  --xyz summon
	aux.AddXyzProcedure(c,c62899995.matfilter,8,2,nil,5)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c62899995.cost)
	e1:SetTarget(c62899995.eqtg)
	e1:SetOperation(c62899995.eqop)
	c:RegisterEffect(e1) 
   --equip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(62899995,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c62899995.eqcon)
	e2:SetCost(c62899995.cost)
	e2:SetTarget(c62899995.eqtg2)
	e2:SetOperation(c62899995.eqop2)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c62899995.reptg)
	e3:SetOperation(c62899995.repop)
	c:RegisterEffect(e3)
end
function c62899995.matfilter(c)
	return  c:IsSetCard(0x620) and not c:IsSetCard(0x2620) 
end
function c62899995.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c62899995.filter(c)
	return c:IsSetCard(0x620)  and not c:IsSetCard(0x2620) and c:IsType(TYPE_MONSTER)  and not c:IsForbidden()
end
function c62899995.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c62899995.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c62899995.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local c=e:GetHandler()
	if ft<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
   local eq=Duel.GetMatchingGroup(c62899995.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
   local tt=ft
   if ft>3 then
   tt=3
  end
   for i=1,tt do
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=eq:Select(tp,1,1,nil)
	eq:RemoveCard(g:GetFirst())
	if not (g and Duel.Equip(tp,g,c,true)) then return end
	--Add Equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetLabelObject(c)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c62899995.eqlimit)
	g:RegisterEffect(e1)
end
end
function c62899995.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c62899995.xyzf(c)
	return c:IsSetCard(0x1620) and c:IsType(TYPE_MONSTER) 
end
function c62899995.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c62899995.xyzf,1,nil)
   and e:GetHandler():GetEquipCount()<3
end
function c62899995.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c62899995.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c62899995.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local c=e:GetHandler()
	if ft<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
   local eq=Duel.GetMatchingGroup(c62899995.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=eq:Select(tp,1,1,nil):GetFirst()
	if not (g and Duel.Equip(tp,g,c,true)) then return end
	--Add Equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetLabelObject(c)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c62899995.eqlimit)
	g:RegisterEffect(e1)
end
function c62899995.repfilter(c,g)
	return  not c:IsStatus(STATUS_DESTROY_CONFIRMED) and g:GetEquipGroup():IsContains(c)
end
function c62899995.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	  local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c62899995.repfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(62899995,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c62899995.repfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,c)
		Duel.SetTargetCard(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c62899995.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end