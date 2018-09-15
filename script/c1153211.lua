--灯符『萤光现象』
function c1153211.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1153211.tg1)
	e1:SetOperation(c1153211.op1)
	c:RegisterEffect(e1)
--  
	if not c1153211.echeck then
		c1153211.echeck=true
		local e0=Effect.GlobalEffect()
		e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e0:SetCode(EVENT_CHANGE_POS)
		e0:SetOperation(c1153211.op0)
		Duel.RegisterEffect(e0,0)
	end
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1153211,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1)
	e2:SetTarget(c1153211.tg2)
	e2:SetOperation(c1153211.op2)
	c:RegisterEffect(e2)
--
end
--
function c1153211.op0(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) then
			tc:RegisterFlagEffect(1153211,RESET_EVENT+0x1fe0000,0,0)
		end
		tc=eg:GetNext()
	end
end
--
function c1153211.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local turnp=Duel.GetTurnPlayer()
	local tph=Duel.GetCurrentPhase()
	if tph==PHASE_DRAW then
		Duel.SkipPhase(turnp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	elseif tph==PHASE_STANDBY then
		Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	elseif tph==PHASE_MAIN1 then 
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	elseif tph>PHASE_MAIN1 and tph<PHASE_MAIN2 then 
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	else
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end
--
function c1153211.ofilter1_1(c)
	return c:IsFacedown()
end
function c1153211.ofilter1_2(c)
	return c:GetFlagEffect(1153211)==0 and c:IsFacedown()
end
function c1153211.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1153211.ofilter1_1,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
	end
	local gn=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if gn:GetCount()>0 then
		Duel.ConfirmCards(1-tp,gn)
		Duel.ShuffleHand(1-tp)
	end
	local sg=Duel.GetMatchingGroup(c1153211.ofilter1_2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
	end
end
--
function c1153211.tfilter2_1(c)
	return c:IsRace(RACE_INSECT) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1153211.tfilter2_2_1(c,e,tp)
	return c:GetBaseDefense()==900 and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c1153211.tfilter2_2_2(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c1153211.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local con1=0
	local con2=0
	if chk==0 then 
		if Duel.IsExistingMatchingCard(c1153211.tfilter2_1,tp,LOCATION_DECK,0,1,nil) then
			con1=1
		end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingTarget(c1153211.tfilter2_2_1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c1153211.tfilter2_2_2,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
			con2=1
		end
		if con1==1 or con2==1 then
			return true
		else
			return false
		end
	end
	local num=0
	if Duel.IsExistingMatchingCard(c1153211.tfilter2_1,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingTarget(c1153211.tfilter2_2_1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c1153211.tfilter2_2_2,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		num=Duel.SelectOption(tp,aux.Stringid(1153211,0),aux.Stringid(1153211,1))
	elseif Duel.IsExistingMatchingCard(c1153211.tfilter2_1,tp,LOCATION_DECK,0,1,nil) and not (Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingTarget(c1153211.tfilter2_2_1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c1153211.tfilter2_2_2,tp,LOCATION_EXTRA,0,1,nil,e,tp)) then
		num=0
	else
		num=1
	end
	e:SetLabel(num)
	if num==0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
--
function c1153211.op2(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetLabel()
	if num==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1153211.tfilter2_1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		local g=Duel.SelectMatchingCard(tp,c1153211.tfilter2_2_1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local gn=Duel.SelectMatchingCard(tp,c1153211.tfilter2_2_2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if gn:GetCount()>0 then
				local sc=gn:GetFirst()
				local mg=tc:GetOverlayGroup()
				if mg:GetCount()~=0 then
					Duel.Overlay(sc,mg)
				end
				Duel.Overlay(sc,Group.FromCards(tc))
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
--