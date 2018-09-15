--朱星曜兽-张月鹿
function c21520126.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520126,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,21520126)
	e1:SetCost(c21520126.cost)
	e1:SetTarget(c21520126.target)
	e1:SetOperation(c21520126.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--[[
	Duel.AddCustomActivityCounter(21520126,ACTIVITY_SUMMON,c21520126.spfilter)
	Duel.AddCustomActivityCounter(21520126,ACTIVITY_SPSUMMON,c21520126.spfilter)
	Duel.AddCustomActivityCounter(21520126,ACTIVITY_FLIPSUMMON,c21520126.spfilter)--]]
end
function c21520126.spfilter(c)
	return c:IsSetCard(0xc491)
end
function c21520126.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	--[[
	if chk==0 then return Duel.GetCustomActivityCount(21520126,tp,ACTIVITY_SUMMON)==0 
		and Duel.GetCustomActivityCount(21520126,tp,ACTIVITY_FLIPSUMMON)==0 
		and Duel.GetCustomActivityCount(21520126,tp,ACTIVITY_SPSUMMON)==0 end
	--]]
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c21520126.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c21520126.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x491)
end
function c21520126.actfilter(c)
	return (c:IsSetCard(0x491) and not c:IsSetCard(0x5491))
end
function c21520126.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520126.actfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) 
		and Duel.GetMatchingGroupCount(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)>=1 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21520126.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
