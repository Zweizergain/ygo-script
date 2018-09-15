--先天原初八文图
function c21520209.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520209,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c21520209.sptg)
	e1:SetOperation(c21520209.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520209,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21520209)
	e2:SetCondition(c21520209.thcon)
	e2:SetTarget(c21520209.thtg)
	e2:SetOperation(c21520209.thop)
	c:RegisterEffect(e2)
	--life to 0
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetOperation(c21520209.tzop)
	c:RegisterEffect(e3)
end
function c21520209.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x492) and c:IsType(TYPE_MONSTER)
end
function c21520209.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ((Duel.IsExistingMatchingCard(c21520209.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0) 
		or (Duel.IsExistingMatchingCard(c21520209.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0))
		or (Duel.IsExistingMatchingCard(c21520209.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) and Duel.GetMZoneCount(1-tp)>0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c21520209.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21520209.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if g:GetCount()<=0 then return end
	local gex=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
	local ggr=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local b1=gex:GetCount()>0
	local b2=ggr:GetCount()>0
	local b3=Duel.GetLocationCountFromEx(tp)>0
	local b4=Duel.GetMZoneCount(tp)>0
--	local b5=Duel.GetLocationCountFromEx(1-tp)>0
	local b6=Duel.GetMZoneCount(1-tp)>0
	if not b1 and not b2 then return end
	if not (b3 or b4) and not b6 then return end
	local ops=2
	local player=tp
	if (b1 and b2) then 
		if (b3 or b4) and b6 then 
			ops=Duel.SelectOption(tp,aux.Stringid(21520209,2),aux.Stringid(21520209,3))
		elseif (b3 or b4) and not b6 then 
			ops=0
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(21520209,2))
		elseif not (b3 or b4) and b6 then 
			ops=1
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(21520209,3))
		end
	elseif (b1 and not b2) then 
		ops=0
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(21520209,2))
	elseif (not b1 and b2) then 
		if b4 and b6 then 
			ops=Duel.SelectOption(tp,aux.Stringid(21520209,2),aux.Stringid(21520209,3))
		elseif b4 and not b6 then 
			ops=0
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(21520209,2))
		elseif not b4 and b6 then 
			ops=1
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(21520209,3))
		end
	end
	local sg=Group.CreateGroup()
	local ct=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if ops==0 then 
		if (b1 and b2) then 
			if (b3 and b4) then 
				sg=g:Select(tp,1,1,nil)
			elseif (b3 and not b4) then 
				sg=gex:Select(tp,1,1,nil)
			elseif (not b3 and b4) then 
				sg=ggr:Select(tp,1,1,nil)
			end
		elseif (b1 and not b2) then 
			if b3 then sg=gex:Select(tp,1,1,nil) end
		elseif (not b1 and b2) then 
			if b4 then sg=ggr:Select(tp,1,1,nil) end
		end
	elseif ops==1 then 
		player=1-tp
		sg=ggr:Select(tp,1,1,nil)
	end
	ct=Duel.SpecialSummon(sg,0,tp,player,false,false,POS_FACEUP)
	if ct>0 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		sg:GetFirst():RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		sg:GetFirst():RegisterEffect(e3)
	end
end
function c21520209.thfilter(c)
	return c:IsSetCard(0x492) and c:IsFaceup()
end
function c21520209.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21520209.thfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c21520209.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c21520209.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
function c21520209.tzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21520209.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetClassCount(Card.GetCode)>=8 and e:GetHandler():IsLocation(LOCATION_SZONE) then
		local player=e:GetHandlerPlayer()
		local g1=Duel.GetMatchingGroup(c21520209.thfilter,tp,LOCATION_MZONE,0,nil)
		local g2=Duel.GetMatchingGroup(c21520209.thfilter,tp,0,LOCATION_MZONE,nil)
		if g1:GetClassCount(Card.GetCode)>g2:GetClassCount(Card.GetCode) then 
			Duel.SetLP(1-player,0)
		elseif g1:GetClassCount(Card.GetCode)<g2:GetClassCount(Card.GetCode) then
			Duel.SetLP(player,0)
		end
	end
end
