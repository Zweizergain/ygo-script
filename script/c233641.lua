--晶渊城
function c233641.initial_effect(c)
    --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--indes1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0x4,0x4)
	e1:SetTarget(function(e,c) return c:GetLevel()==9 end)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88307361,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c233641.sumcost)
	e3:SetTarget(c233641.sumtg)
	e3:SetOperation(c233641.sumop)
	c:RegisterEffect(e3)
end	
function c233641.rfilter(c)
	return c:GetLevel()==9  and c:IsAbleToRemoveAsCost()
end
function c233641.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c233641.rfilter,tp,0x1e,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c233641.rfilter,tp,0x1e,0,1,1,e:GetHandler())
	Duel.Remove(g,0x5,0x80)
end
function c233641.filter(c,e,tp)
	return c:IsType(0x1000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c233641.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>0
		and Duel.IsExistingMatchingCard(c233641.filter,tp,0x1,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0x1)
end
function c233641.sumop(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.SelectMatchingCard(tp,c233641.filter,tp,0x1,0,1,1,nil,e,tp)
   if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,0x5) 
      Duel.BreakEffect() 
	    local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-g:GetFirst():GetLevel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e1)
   end
end   
