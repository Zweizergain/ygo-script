--稀有宝藏
function c121000004.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c121000004.cost)
	e1:SetTarget(c121000004.target)
	e1:SetOperation(c121000004.activate)
	c:RegisterEffect(e1)
end
function c121000004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c121000004.filter1(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave()
end
function c121000004.filter2(c)
    return not c:IsSummonableCard() and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c121000004.filter3(c,e,tp)
    return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c121000004.filter4(c)
    return c:IsCode(23310014) and c:IsFaceup()
end
function c121000004.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.IsExistingMatchingCard(c121000004.filter1,tp,LOCATION_DECK,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(c121000004.filter2,tp,LOCATION_GRAVE,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c121000004.filter3,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b4=Duel.IsExistingMatchingCard(c121000004.filter4,tp,LOCATION_ONFIELD,0,1,nil) 
    if chk==0 then return b1 or b2 or b3 end
     local off=0
	 local t=2
	 local sel=0
	  repeat
        local ops={}
        local opval={}
        off=1
	if b1 then
	 ops[off]=aux.Stringid(23310009,5)
            opval[off-1]=1
            off=off+1
        end
      if b2 then
	 ops[off]=aux.Stringid(23310009,6)
            opval[off-1]=2
            off=off+1
        end
     if b3 then
	 ops[off]=aux.Stringid(23310009,7)
            opval[off-1]=3
            off=off+1
        end
		   local op=Duel.SelectOption(tp,table.unpack(ops))
        if opval[op]==1 then
            sel=sel+1
            b1=false
        elseif opval[op]==2 then
            sel=sel+2
            b2=false
        else
            sel=sel+4
            b3=false
        end
        if  b4 then
		t=t-1
		else
		t=0
		end
		until  t==0 or off<3 or not Duel.SelectYesNo(tp,aux.Stringid(23310009,8))
     e:SetLabel(sel)
   if bit.band(sel,1)~=0 then
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    end
	 if bit.band(sel,2)~=0 then
       Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
    end
	 if bit.band(sel,4)~=0 then
     Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    end
end
function c121000004.activate(e,tp,eg,ep,ev,re,r,rp)
   local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sel=e:GetLabel()
    if bit.band(sel,1)~=0  then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c121000004.filter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
	end
	if bit.band(sel,2)~=0 then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=Duel.SelectMatchingCard(tp,c121000004.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if  sg:GetCount()>0 then
	 Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
	end
	 if bit.band(sel,4)~=0 and ft>0 then
     if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c121000004.filter3,tp,LOCATION_HAND,0,1,ft,nil,e,tp)
    if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
end