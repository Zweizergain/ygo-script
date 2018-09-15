--恶灵「Misfortune's Wheel（厄运之轮）」
function c100410.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100410,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100410.condition)
	e1:SetOperation(c100410.activate)
	c:RegisterEffect(e1)
	--1 level
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(100410,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCost(c100410.cost)
    e2:SetTarget(c100410.thtg)
    e2:SetOperation(c100410.thop)
    c:RegisterEffect(e2)   	
	--to gravee
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100410,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c100410.negcon)
	e3:SetCost(c100410.thcost)
	e3:SetOperation(c100410.activate2)
	c:RegisterEffect(e3)
end
function c100410.cost(e,tp,eg,ep,ev,re,r,rp,chk)    
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c100410.filter(c)
	return c:IsCode(100400) and c:IsAbleToHand()
end
function c100410.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100410.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100410.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100410.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c100410.negcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) 
end
function c100410.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c100410.activate(e,tp,eg,ep,ev,re,r,rp)
		--Atk
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SET_ATTACK)
		--e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetTarget(c100410.tg)
		e2:SetValue(0)
		Duel.RegisterEffect(e2,tp)
end
function c100410.tg(e,c)
	local lv=c:GetLevel()
	return c:GetPosition()==POS_FACEUP_ATTACK
end

function c100410.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c100410.activate2(e,tp,eg,ep,ev,re,r,rp)
		--Atk
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SET_ATTACK)
		--e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetTarget(c100410.tg)
		e2:SetValue(0)
		Duel.RegisterEffect(e2,tp)
end