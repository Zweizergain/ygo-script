--天使长 命运之伊瑟瑞尔
function c10121013.initial_effect(c)
	c:EnableReviveLimit() 
	c:SetSPSummonOnce(10121011)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)   
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c10121013.spcon)
	c:RegisterEffect(e2) 
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10121013,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c10121013.destg)
	e3:SetOperation(c10121013.desop)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(c10121013.efilter)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)
	--count
	if not c10121013.global_check then
		c10121013.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c10121013.checkop)
		Duel.RegisterEffect(ge1,0)
	end   
end
function c10121013.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(c10121013.dfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),tp,LOCATION_MZONE)
end
function c10121013.dfilter(c)
	return c:IsDestructable() and c:IsRace(RACE_FIEND)
end
function c10121013.tdfilter(c)
	return c:IsRace(RACE_FAIRY+RACE_FIEND) and c:IsAbleToDeck()
end
function c10121013.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10121013.dfilter,tp,LOCATION_MZONE,0,nil)
		  Duel.Destroy(g,REASON_EFFECT)
	local sg=Duel.GetMatchingGroup(c10121013.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if sg:GetCount()>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(10121013,1)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	   local tg=sg:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
		   if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)~=0 then
			  Duel.ShuffleDeck(tp)
			  Duel.Draw(tp,1,REASON_EFFECT)
		   end
	end
end
function c10121013.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,10121013)>=2
end
function c10121013.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsRace(RACE_FIEND) then
		   Duel.RegisterFlagEffect(tc:GetSummonPlayer(),10121013,RESET_PHASE+PHASE_END,0,1)
		end
	tc=eg:GetNext()
	end
end
function c10121013.efilter(e,re)
	return re:IsActiveType(TYPE_EFFECT) and re:GetHandler():IsRace(RACE_FIEND)
end