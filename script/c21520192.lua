--急流精怪-联动型
function c21520192.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c21520192.spcon)
	e1:SetOperation(c21520192.spop)
	c:RegisterEffect(e1)
	--synchro lv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetValue(c21520192.lvval)
	c:RegisterEffect(e2)
	--synchro
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520192,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c21520192.sccon)
	e3:SetTarget(c21520192.sctg)
	e3:SetOperation(c21520192.scop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(21520192,ACTIVITY_SUMMON,c21520192.counterfilter)
	Duel.AddCustomActivityCounter(21520192,ACTIVITY_FLIPSUMMON,c21520192.counterfilter)
	Duel.AddCustomActivityCounter(21520192,ACTIVITY_SPSUMMON,c21520192.counterfilter)
end
function c21520192.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c21520192.spfilter(c)
	return not c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function c21520192.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	if Duel.GetCustomActivityCount(21520192,tp,ACTIVITY_SUMMON)~=0 
		and Duel.GetCustomActivityCount(21520192,tp,ACTIVITY_FLIPSUMMON)~=0 
		and Duel.GetCustomActivityCount(21520192,tp,ACTIVITY_SPSUMMON)~=0 
		then return false end
	return not Duel.IsExistingMatchingCard(c21520192.spfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and not Duel.IsExistingMatchingCard(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP)
end
function c21520192.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local code=e:GetHandler():GetCode()
	local ct=Duel.GetFlagEffect(tp,code)
	Duel.RegisterFlagEffect(tp,code,RESET_PHASE+PHASE_END,0,1)
	Duel.Damage(tp,100*2^ct,REASON_RULE)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c21520192.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c21520192.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c21520192.lvval(e,c)
	local lv=e:GetHandler():GetLevel()
	if not c:IsAttribute(ATTRIBUTE_WATER) then return lv
	else
		return 3*65536+lv
	end
end
function c21520192.sccon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c21520192.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c21520192.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c21520192.scop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetMatchingGroup(c21520192.mfilter,tp,LOCATION_HAND,0,nil)
	if hg:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local mg=hg:Select(tp,1,4,nil)
	Duel.ConfirmCards(1-tp,mg)
	local ct=mg:GetCount()
	mg:AddCard(e:GetHandler())
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	else
		Duel.Damage(tp,ct*1000,REASON_RULE)
	end
end
