--米德兰之木灵
function c233681.initial_effect(c)
    --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,0x1),4,2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(233681,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c233681.cost)
	e1:SetOperation(c233681.operation)
	c:RegisterEffect(e1)
end
function c233681.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,0x80) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,0x80)
end	
function c233681.operation(e,tp,eg,ep,ev,re,r,rp)
     local c=e:GetHandler()
     Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(233681,0))
	 sel=Duel.SelectOption(tp,aux.Stringid(233681,1),aux.Stringid(233681,2))+1
	 if sel==1 then
        local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_FIELD)
	    e1:SetTargetRange(0x4,0)
	    e1:SetCode(EFFECT_IMMUNE_EFFECT)
	    e1:SetValue(c233681.imfilter)
	    e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,0x400))
	    e1:SetReset(RESET_PHASE+PHASE_END)
	    Duel.RegisterEffect(e1,tp)
	else
         local e1=Effect.CreateEffect(c)
	     e1:SetType(EFFECT_TYPE_FIELD)
	     e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	     e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,0x400))
	     e1:SetTargetRange(0x4,0)
	     e1:SetReset(RESET_PHASE+PHASE_END)
		 e1:SetValue(1)
	     Duel.RegisterEffect(e1,tp)	
	end	 
end	
function c233681.imfilter(e,te)
	return not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
