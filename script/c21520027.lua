--乱数主唱
function c21520027.initial_effect(c)
	--change level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520027,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
--	e1:SetCondition(c21520027.con)
	e1:SetOperation(c21520027.rlevel)
	c:RegisterEffect(e1)
	--summons
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520027,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0xbf,0xbf)
--	e2:SetCondition(c21520027.con)
	e2:SetOperation(c21520027.rlevel)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e4)
	--synchro
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(21520027,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,21520027)
	e5:SetCondition(c21520027.condition)
	e5:SetTarget(c21520027.target)
	e5:SetOperation(c21520027.operation)
	c:RegisterEffect(e5)
--	c21520027[0]=true
end
function c21520027.rlevel(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+17320+3)
	local val=math.random(1,800)
	val=math.fmod(val,8)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520027.synfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and (c:IsAbleToGrave() or c:IsAbleToHand())
end
function c21520027.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING)	and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c21520027.filter(c,e,tp,lv,mg)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==lv and c:IsAttribute(ATTRIBUTE_WIND)
end
function c21520027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21520027.synfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsPlayerCanSpecialSummon(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,c21520027.synfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
--	c21520027[0]=false
end
function c21520027.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsImmuneToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local lv1=c:GetLevel()
	local lv2=tc:GetLevel()
	local lv=lv1+lv2
	local mg=Group.CreateGroup()
	mg:AddCard(c)
	mg:AddCard(tc)
--[[
	--synchro custom
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetLabelObject(c)
	e1:SetTarget(c21520027.hstg)
	e1:SetValue(1)
	e1:SetOperation(c21520027.hsop)
	tc:RegisterEffect(e1)
	c:RegisterFlagEffect(21520027,0,0,0)--]]
	local sg=Duel.GetMatchingGroup(c21520027.filter,tp,LOCATION_EXTRA,0,nil,e,tp,lv)
	local op=2
	if sg:GetCount()>0 and (tc:IsAbleToHand() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then
		op=Duel.SelectOption(tp,aux.Stringid(21520027,1),aux.Stringid(21520027,2))
	elseif sg:GetCount()>0 then
		op=0
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520027,1))
	elseif (tc:IsAbleToHand() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then
		op=1
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520027,2))
	end
	if op==0 then
		if tc:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local syn=sg:Select(tp,1,1,nil)
			local sc=syn:GetFirst()
			Duel.SendtoGrave(mg,REASON_EFFECT+REASON_MATERIAL)
			sc:SetMaterial(mg)
			Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetValue(c21520027.efilter)
			e1:SetReset(RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e1)
			if not sc:IsSetCard(0x493) then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_TRIGGER)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				sc:RegisterEffect(e2)
			end
			Duel.SpecialSummonComplete()
		end
	elseif op==1 then
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			local atk=tc:GetTextAttack()
			local def=tc:GetTextDefense()
			if atk<0 then atk=0 end
			if def<0 then def=0 end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetReset(RESET_EVENT+0xdfc0000)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(atk)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue(def)
			c:RegisterEffect(e2)
		end
	end
--[[	c21520027[0]=true
end
function c21520027.con(e,tp,eg,ep,ev,re,r,rp)
	return c21520027[0]
end
function c21520027.hsfilter(c,f)
	return c:GetFlagEffect()~=0 and c:IsCanBeSynchroMaterial() and (f==nil or f(c))
end
function c21520027.hstg(e,syncard,f,minc,maxc)
	return Duel.IsExistingMatchingCard(c21520027.hsfilter,syncard:GetControler(),LOCATION_HAND,0,1,nil,f)
end
function c21520027.hsop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetLabelObject()
--	local g=Group.CreateGroup()
--	g:AddCard(c)
	local g=Duel.SelectMatchingCard(tp,c21520027.filter,tp,LOCATION_HAND,0,1,1,nil,f)
	Duel.SetSynchroMaterial(g)
	c:ResetFlagEffect(21520027)--]]
end
function c21520027.efilter(e,te)
	return  te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
