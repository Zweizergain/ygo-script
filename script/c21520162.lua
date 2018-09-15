--形魔-瑞克坦
function c21520162.initial_effect(c)
	--Attribute Light
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c21520162.ccon)
	e2:SetOperation(c21520162.ccost)
	c:RegisterEffect(e2)
	--base atk & def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c21520162.adval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(21520162,3))
	e5:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
--	e5:SetCost(c21520162.cost)
	e5:SetTarget(c21520162.target)
	e5:SetOperation(c21520162.activate)
	c:RegisterEffect(e5)
	local e5_1=e5:Clone()
	e5_1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5_1)
end
function c21520162.cfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsPublic()
end
function c21520162.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c21520162.ccost(e,tp)
	if tp~=Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c21520162.cfilter1,tp,LOCATION_HAND,0,nil)
	local opselect=2
	if g1:GetCount()>0 then
		opselect=Duel.SelectOption(tp,aux.Stringid(21520162,0),aux.Stringid(21520162,1),aux.Stringid(21520162,2))
	else 
		opselect=Duel.SelectOption(tp,aux.Stringid(21520162,1),aux.Stringid(21520162,2))
		opselect=opselect+1
	end
	if opselect==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=g1:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	elseif opselect==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(-c:GetAttack())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCategory(CATEGORY_DEFCHANGE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-c:GetDefense())
		c:RegisterEffect(e2)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
function c21520162.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*200
end
function c21520162.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0
		and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 
		end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BP)
	Duel.RegisterEffect(e2,tp)
end
function c21520162.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21520162.smfilter(c,e,tp)
	return c:IsSetCard(0x490) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsAbleToGrave())
end
function c21520162.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDraw(tp) then return end
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.BreakEffect()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(21520162,6)) then 
		local g=Duel.GetDecktopGroup(tp,1)
		Duel.ConfirmDecktop(tp,1)
		local tc=g:GetFirst()
		local ops=2
		if tc:IsSetCard(0x490) and (tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or tc:IsAbleToGrave()) then 
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then ops=Duel.SelectOption(tp,aux.Stringid(21520162,4),aux.Stringid(21520162,5)) 
			else 
				ops=1 
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520162,5))
			end
			if ops==0 then 
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			elseif ops==1 then 
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		else
			Duel.MoveSequence(tc,1)
		end
	end
end
