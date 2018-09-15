--天使长 希望之奥瑞尔
function c10121012.initial_effect(c)
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
	e2:SetCondition(c10121012.spcon)
	e2:SetOperation(c10121012.spop)
	c:RegisterEffect(e2) 
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10121012,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c10121012.destg)
	e3:SetOperation(c10121012.desop)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c10121012.efilter)
	c:RegisterEffect(e4)
end
function c10121012.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_MZONE,0,nil,RACE_FIEND)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),tp,LOCATION_MZONE)
end
function c10121012.thfilter(c)
	return c:GetLevel()==10 and c:IsRace(RACE_FAIRY) and c:IsAbleToHand()
end
function c10121012.dfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsFaceup()
end
function c10121012.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10121012.dfilter,tp,LOCATION_MZONE,0,nil)
		  Duel.Destroy(g,REASON_EFFECT)
	local sg=Duel.GetMatchingGroup(c10121012.thfilter,tp,LOCATION_DECK,0,nil)
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10121012,1)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local tg=sg:Select(tp,1,1,nil)
			 Duel.SendtoHand(tg,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,tg)
	end
end
function c10121012.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsCanRemoveCounter(c:GetControler(),1,1,0x1333,3,REASON_COST)
end
function c10121012.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,1,0x1333,3,REASON_RULE)
end
function c10121012.efilter(e,re)
	return re:IsActiveType(TYPE_EFFECT) and re:GetHandler():IsRace(RACE_FIEND)
end
