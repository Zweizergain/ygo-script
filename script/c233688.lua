--池姬 达佛涅
function c233688.initial_effect(c)
    --xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
    --atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(0x4)
	e1:SetTargetRange(0,0x4)
	e1:SetCondition(c233688.atkcon)
	e1:SetValue(c233688.val)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(233688,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c)
	e2:SetCost(c233688.spcost)
	e2:SetTarget(c233688.sptg)
	e2:SetOperation(c233688.spop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(233688,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c233688.sptg2)
	e3:SetOperation(c233688.spop2)
	c:RegisterEffect(e3)
end	
function c233688.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():FilterCount(Card.IsRace,nil,0x400)>0
end
function c233688.val(e)         
    return -Duel.GetMatchingGroupCount(Card.IsRace,e:GetHandlerPlayer(),0x1c,0,nil,0x400)*100 
end	
function c233688.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,0x80) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,0x80)
end
function c233688.spfilter(c,e,tp)
	return c:IsType(0x1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsType(0x6) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c233688.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
	local p=Duel.GetTurnPlayer() 
	if chk==0 then 
	if p~=tp then 
	   local ph=Duel.GetCurrentPhase()
	   if ph<0x4 or ph==0x30 or ph==0x80 then return false end
	end   
	   return Duel.GetLocationCount(tp,0x4)>0 and c:GetOverlayGroup():Filter(c233688.spfilter,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c233688.spop(e,tp,eg,ep,ev,re,r,rp)	
      local c=e:GetHandler()
	  local g=c:GetOverlayGroup()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	    local tc=g:FilterSelect(tp,c233688.spfilter,1,1,nil,e,tp):GetFirst()
	    if not tc then return end 
		 if tc:IsType(0x1) then Duel.SpecialSummon(tc,0,tp,tp,false,false,0x5)  
	else
		 if Duel.SpecialSummon(tc,0,tp,tp,true,true,0x5)~=0 then
		 local e1=Effect.CreateEffect(c)
	     e1:SetCode(EFFECT_CHANGE_TYPE)
	     e1:SetType(EFFECT_TYPE_SINGLE)
	     e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	     e1:SetReset(RESET_EVENT+0x1fc0000)
	     e1:SetValue(0x1)
	     tc:RegisterEffect(e1)
		 end
	 end	 
	c:SetCardTarget(tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_INITIAL+EFFECT_FLAG_REPEAT)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(0x4)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c233688.retcon)
	e1:SetOperation(c233688.retop)
	c:RegisterEffect(e1)
end	
function c233688.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetCardTarget()
	return tc:GetCount()>0
end
function c233688.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetCardTarget()
	local tc=g:GetFirst()
	while tc do
		if tc:IsLocation(0x4) then
			Duel.Overlay(c,tc)
		end
		tc=g:GetNext()
	end
end
function c233688.spfilter2(c,e,tp)
	return c:GetLevel()==8 and c:IsRace(0x400) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c233688.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x10) and chkc:IsControler(tp) and c233688.spfilter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>0
		and Duel.IsExistingTarget(c233688.spfilter2,tp,0x10,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c233688.spfilter2,tp,0x10,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c233688.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	  Duel.SpecialSummon(tc,0,tp,tp,false,false,0x5) 	
	end
end