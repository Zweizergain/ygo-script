--颜艺帝-贝库塔
function c145077.initial_effect(c)
   --xyz summon
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(145077,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c145077.spcon)
	e1:SetCost(c145077.spcost)
	e1:SetTarget(c145077.sptg)
	c:RegisterEffect(e1)
end
function c145077.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xff)
end
function c145077.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c145077.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,145078,0xff,0x4011,0,1500,4,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	local token=Duel.CreateToken(tp,145078)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	Duel.SpecialSummonComplete()
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
