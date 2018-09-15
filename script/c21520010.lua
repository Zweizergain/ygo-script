--乱数命运
function c21520010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,21520010+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
--	e1:SetCost(c21520010.cost)
	e1:SetTarget(c21520010.target)
	e1:SetOperation(c21520010.activate)
	c:RegisterEffect(e1)
end
function c21520010.filter(c,e,tp)
	if c:IsSetCard(0x493) then
		return (c:IsLevelAbove(9) or c:IsRankAbove(9)) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
	else
		return (c:IsLevelAbove(9) or c:IsRankAbove(9)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
end
--[[
function c21520010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local mg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil)
		local gt=9
		if gt>mg:GetCount() then gt=mg:GetCount() end
		if gt==0 then return false end
		math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))+c:GetFieldID())
		local ct=math.random(1,gt)
		local res=Duel.IsExistingMatchingCard(c21520010.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,ct)
		return res
	end
end
--]]
function c21520010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local mg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil)
		if mg:GetCount()==0 or ft<=0 then return false end
		local res=Duel.GetMatchingGroup(c21520010.filter,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e,tp)
		local g=c21520010.check_removecard(res,mg:GetCount())
		return g:GetCount()>2 --and mg:GetCount()>=9
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function c21520010.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c21520010.filter,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e,tp)
	local mg1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil)
	local res=c21520010.check_removecard(g,mg1:GetCount())
	if res:GetCount()<=2 then return end
	local rg=res:RandomSelect(tp,3)
	Duel.ConfirmCards(1-tp,rg)
	local tg=rg:RandomSelect(tp,1)
	local tc=tg:GetFirst()
--	Duel.ConfirmCards(tp,tc)
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsLocation(LOCATION_EXTRA) then ft=Duel.GetLocationCountFromEx(tp) end
	if ft<=0 then return end
	local mg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,tc)
	local sum=0
	if tc:IsType(TYPE_XYZ) then 
		sum=tc:GetOriginalRank()
	else
		sum=tc:GetOriginalLevel()
	end
	if sum==0 then return end
	--not randomly
	if not tc:IsSetCard(0x493) and not Duel.IsExistingMatchingCard(c21520010.chkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		Duel.BreakEffect()
		Duel.Damage(tp,sum*500,REASON_RULE)
	end
	local g=mg:RandomSelect(tp,sum)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	if Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)~=0 then
--		math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))+c:GetFieldID())
--		local cid=math.random(1,10000)
		tc:RegisterFlagEffect(21520010,0,0,0)
		local e6=Effect.CreateEffect(c)
		e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e6:SetCode(EVENT_LEAVE_FIELD)
		e6:SetCountLimit(1)
		e6:SetRange(0xff)
		e6:SetLabelObject(tc)
		e6:SetCondition(c21520010.con)
		e6:SetTarget(c21520010.tg)
		e6:SetOperation(c21520010.op)
		c:RegisterEffect(e6,true)
	end
end
function c21520010.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x493) and c:IsType(TYPE_FIELD)
end
function c21520010.tdfilter(c)
	return c:GetFlagEffect(21520010)~=0 
end
function c21520010.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21520010.tdfilter,1,nil)
end
function c21520010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	local tc=e:GetLabelObject()
	tc:ResetFlagEffect(21520010)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c21520010.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local ct=0
	if tc:IsType(TYPE_XYZ) then 
		ct=tc:GetOriginalRank()
	else
		ct=tc:GetOriginalLevel()
	end
	local mg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if ct>mg:GetCount() then ct=mg:GetCount() end
	if ct==0 then return end
	Duel.RegisterFlagEffect(tp,21520012,RESET_PHASE+PHASE_END,0,1)
	local ctr=Duel.GetFlagEffect(tp,21520012)+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()
	math.randomseed(c:GetFieldID()+ct*10000)
	local gt=math.random(1,ct)
	local g=mg:RandomSelect(tp,gt)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(Card.IsAbleToHand,1-tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(21520010,1)) then
		local dg=Duel.GetMatchingGroup(Card.IsAbleToHand,1-tp,LOCATION_DECK,0,nil)
		local rg=dg:RandomSelect(1-tp,1)
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,rg)
	end
	local ng=Group.CreateGroup()
	e:SetLabelObject(ng)
end
function c21520010.check_removecard(g,ct)
	local rg=g
	local tc=rg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_DECK) and ct<tc:GetOriginalLevel()+1 then
			rg:RemoveCard(tc)
		elseif tc:IsLocation(LOCATION_EXTRA) then
			if tc:IsType(TYPE_XYZ) then 
				if ct<tc:GetOriginalRank() then rg:RemoveCard(tc) end
			else
				if ct<tc:GetOriginalLevel() then rg:RemoveCard(tc) end
			end
		end
		tc=rg:GetNext()
	end
	return rg
end
