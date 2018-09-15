--娘化 逆回十六夜
function c5040.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x900),aux.NonTuner(nil),1)
	c:EnableReviveLimit()   
	--Atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c5040.atkval)
	c:RegisterEffect(e1)
	--return	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetCost(c5040.decost)
	e3:SetOperation(c5040.activate)
	c:RegisterEffect(e3)
	--rmove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c5040.spcost)
	e2:SetOperation(c5040.deactivate)
	c:RegisterEffect(e2)
	--Change name
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_CODE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e4:SetTarget(c5040.target)
	e4:SetValue(5099)
	c:RegisterEffect(e4)
end
function c5040.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil,0x900)*160
end
function c5040.filter(c)	
	return c:IsType(TYPE_MONSTER)
end
function c5040.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c5040.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c5040.filter,tp,LOCATION_REMOVED,0,1,nil) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c5040.filter,tp,LOCATION_REMOVED,0,1,5,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	Duel.SelectOption(1-tp,aux.Stringid(5040,0))
	Duel.SelectOption(tp,aux.Stringid(5040,0))
	Duel.SelectOption(1-tp,aux.Stringid(5040,1))
	Duel.SelectOption(tp,aux.Stringid(5040,1))
end
function c5040.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c5040.deactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)  then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end
function c5040.target(e,c)
	return c:IsFaceup()
end