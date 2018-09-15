--二天一流之豪刀客 宫本武藏
function c62899993.initial_effect(c)
	  --xyz summon
	aux.AddXyzProcedure(c,c62899993.matfilter,8,2,nil,5)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c62899993.cost)
	e1:SetTarget(c62899993.eqtg)
	e1:SetOperation(c62899993.eqop)
	c:RegisterEffect(e1)
	--cnbt
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c62899993.tgcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetValue(1)
	e3:SetCondition(c62899993.tgcon)
	c:RegisterEffect(e3)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e7)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(35952884,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c62899993.sumcon)
	e4:SetTarget(c62899993.sumtg)
	e4:SetOperation(c62899993.sumop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)
   --remove
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(62899993,0))
	e9:SetCategory(CATEGORY_REMOVE)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCost(c62899993.recost)
	e9:SetTarget(c62899993.retg)
	e9:SetOperation(c62899993.reop)
	c:RegisterEffect(e9)
end
function c62899993.matfilter(c)
	return  c:IsSetCard(0x620) and not c:IsSetCard(0x2620) 
end
function c62899993.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c62899993.filter(c)
	return c:IsSetCard(0x620)  and not c:IsSetCard(0x2620) and c:IsType(TYPE_MONSTER)  and not c:IsForbidden()
end
function c62899993.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(c62899993.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c62899993.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=1 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
   local eq=Duel.GetMatchingGroup(aux.NecroValleyFilter(c62899993.filter),tp,LOCATION_GRAVE,0,nil)
   for i=1,2 do
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=eq:Select(tp,1,1,nil):GetFirst()
	eq:RemoveCard(g)
	if not (g and Duel.Equip(tp,g,c,true)) then return end
	--Add Equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetLabelObject(c)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c62899993.eqlimit)
	g:RegisterEffect(e1)
end
end
function c62899993.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c62899993.tgcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c62899993.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c62899993.sufilter(c,e,tp)
	return c:IsCode(62899990) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c62899993.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c62899993.sufilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c62899993.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c62899993.sufilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if tg then
		Duel.SpecialSummon(tg,0,tp,tp,false,true,POS_FACEUP)
	end
end
function c62899993.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,0,1,1,nil)
   Duel.Release(g,REASON_COST)
end
function c62899993.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c62899993.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
   Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
end