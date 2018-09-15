--レーティアの蟲惑魔
function c6511115.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c6511115.imcon)
	e1:SetValue(c6511115.efilter)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6511115,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,6511115)
	e2:SetCost(c6511115.rkcost1)
	e2:SetTarget(c6511115.mttg1)
	e2:SetOperation(c6511115.mtop1)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6511115,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,6511115)
	e3:SetCost(c6511115.rkcost2)
	e3:SetTarget(c6511115.mttg2)
	e3:SetOperation(c6511115.mtop2)
	c:RegisterEffect(e3)
  	--material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(6511115,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,6511115)
	e4:SetCost(c6511115.rkcost3)
	e4:SetTarget(c6511115.mttg3)
	e4:SetOperation(c6511115.mtop3)
	c:RegisterEffect(e4)
   	--material
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(6511115,3))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,6511115)
	e5:SetCost(c6511115.rkcost4)
	e5:SetTarget(c6511115.mttg4)
	e5:SetOperation(c6511115.mtop4)
	c:RegisterEffect(e5)
   	--material
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(6511115,4))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,6511115)
	e6:SetCost(c6511115.rkcost5)
	e6:SetTarget(c6511115.mttg5)
	e6:SetOperation(c6511115.mtop5)
	c:RegisterEffect(e6)
	    --search
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(6511115,5))
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCost(c6511115.cost)
	e7:SetTarget(c6511115.target)
	e7:SetOperation(c6511115.operation)
	c:RegisterEffect(e7)
end
function c6511115.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c6511115.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c6511115.costfilter(c)
	return c:GetType()==TYPE_TRAP and (c:IsSetCard(0x4c) or c:IsSetCard(0x89)) and c:IsDiscardable()
 
end
function c6511115.rkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6511115.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c6511115.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c6511115.mtfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and  c:IsFaceup()and not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c6511115.mttg1(e,tp,eg,ep,ev,re,r,rp,chk)
      if chk==0 then return Duel.IsExistingMatchingCard(c6511115.mtfilter,tp,0,LOCATION_MZONE,1,nil,e) end
end

function c6511115.mtop1(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end	
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local og=Duel.SelectMatchingCard(tp,c6511115.mtfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if c:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
    if chk==0 then return og:GetFirst():RemoveOverlayCard(tp,1,REASON_RULE) end
	    local g=og:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then  end
		Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,og,REASON_EFFECT)
	end

function c6511115.rkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6511115.costfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,c6511115.costfilter,2,2,REASON_COST+REASON_DISCARD)
end
function c6511115.mttg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6511115.mtfilter,tp,0,LOCATION_MZONE,2,nil,e) end
end
function c6511115.mtop2(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local og=Duel.SelectMatchingCard(tp,c6511115.mtfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if c:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
    if chk==0 then return og:GetFirst():RemoveOverlayCard(tp,1,REASON_RULE) end
	    local g=og:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then  end
		Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,og,REASON_EFFECT)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local og=Duel.SelectMatchingCard(tp,c6511115.mtfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if c:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
    if chk==0 then return og:GetFirst():RemoveOverlayCard(tp,1,REASON_RULE) end
	    local g=og:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then  end
		Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,og,REASON_EFFECT)
end
function c6511115.rkcost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6511115.costfilter,tp,LOCATION_HAND,0,3,nil) end
	Duel.DiscardHand(tp,c6511115.costfilter,3,3,REASON_COST+REASON_DISCARD)
end
function c6511115.mttg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6511115.mtfilter,tp,0,LOCATION_MZONE,3,nil,e) end
end
function c6511115.mtop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local og=Duel.SelectMatchingCard(tp,c6511115.mtfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if c:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
    if chk==0 then return og:GetFirst():RemoveOverlayCard(tp,1,REASON_RULE) end
 	    local g=og:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then  end
		Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,og)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local og=Duel.SelectMatchingCard(tp,c6511115.mtfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if c:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
    if chk==0 then return og:GetFirst():RemoveOverlayCard(tp,1,REASON_RULE) end
	    local g=og:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then  end
		Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,og,REASON_EFFECT)
 	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local og=Duel.SelectMatchingCard(tp,c6511115.mtfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if c:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
    if chk==0 then return og:GetFirst():RemoveOverlayCard(tp,1,REASON_RULE) end
	    local g=og:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then  end
		Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,og,REASON_EFFECT)	
end
function c6511115.rkcost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6511115.costfilter,tp,LOCATION_HAND,0,4,nil) end
	Duel.DiscardHand(tp,c6511115.costfilter,4,4,REASON_COST+REASON_DISCARD)
end
function c6511115.mttg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6511115.mtfilter,tp,0,LOCATION_MZONE,4,nil,e) end
end
function c6511115.mtop4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local og=Duel.SelectMatchingCard(tp,c6511115.mtfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if c:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
    if chk==0 then return og:GetFirst():RemoveOverlayCard(tp,1,REASON_RULE) end
 	    local g=og:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then  end
		Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,og)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local og=Duel.SelectMatchingCard(tp,c6511115.mtfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if c:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
    if chk==0 then return og:GetFirst():RemoveOverlayCard(tp,1,REASON_RULE) end
	    local g=og:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then  end
		Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,og,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local og=Duel.SelectMatchingCard(tp,c6511115.mtfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if c:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
    if chk==0 then return og:GetFirst():RemoveOverlayCard(tp,1,REASON_RULE) end
	    local g=og:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then  end
		Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,og,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local og=Duel.SelectMatchingCard(tp,c6511115.mtfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if c:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
    if chk==0 then return og:GetFirst():RemoveOverlayCard(tp,1,REASON_RULE) end
	    local g=og:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then  end
		Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,og,REASON_EFFECT)
end
function c6511115.rkcost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6511115.costfilter,tp,LOCATION_HAND,0,5,nil) end
	Duel.DiscardHand(tp,c6511115.costfilter,5,5,REASON_COST+REASON_DISCARD)
end
function c6511115.mttg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6511115.mtfilter,tp,0,LOCATION_MZONE,5,nil,e) end
end
function c6511115.mtop5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local og=Duel.SelectMatchingCard(tp,c6511115.mtfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if c:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
    if chk==0 then return og:GetFirst():RemoveOverlayCard(tp,1,REASON_RULE) end
 	    local g=og:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then  end
		Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,og)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local og=Duel.SelectMatchingCard(tp,c6511115.mtfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if c:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
    if chk==0 then return og:GetFirst():RemoveOverlayCard(tp,1,REASON_RULE) end
	    local g=og:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then  end
		Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,og,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local og=Duel.SelectMatchingCard(tp,c6511115.mtfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if c:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
    if chk==0 then return og:GetFirst():RemoveOverlayCard(tp,1,REASON_RULE) end
	    local g=og:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then  end
		Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,og,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local og=Duel.SelectMatchingCard(tp,c6511115.mtfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if c:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
    if chk==0 then return og:GetFirst():RemoveOverlayCard(tp,1,REASON_RULE) end
	    local g=og:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then  end
		Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,og,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local og=Duel.SelectMatchingCard(tp,c6511115.mtfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if c:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
    if chk==0 then return og:GetFirst():RemoveOverlayCard(tp,1,REASON_RULE) end
	    local g=og:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then  end
		Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,og,REASON_EFFECT)
end
function c6511115.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c6511115.filter(c)
	return c:GetType()==TYPE_TRAP and (c:IsSetCard(0x4c) or c:IsSetCard(0x89)) and c:IsAbleToHand()
	and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c6511115.target(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then return Duel.IsExistingMatchingCard(c6511115.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function c6511115.operation(e,tp,eg,ep,ev,re,r,rp)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c6511115.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
