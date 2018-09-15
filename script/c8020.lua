--沙耶
function c8020.initial_effect(c)
	--xyz Summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x901),2,2)
	c:EnableReviveLimit()
	 --battle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8020,1))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c8020.target)
	e1:SetOperation(c8020.operation)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8020,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c8020.spcost)
	e2:SetTarget(c8020.sptg)
	e2:SetOperation(c8020.spop)
	c:RegisterEffect(e2)   
end
function c8020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c8020.operation(e,tp,eg,ep,ev,re,r,rp)
	local rt=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)*400
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rt,REASON_EFFECT)
end
function c8020.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c8020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		--and Duel.IsPlayerCanSpecialSummonMonster(1-tp,8100,0x901,0x4011,0,0,2,RACE_REPTILE,ATTRIBUTE_DARK) end
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end
end
function c8020.spop(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.IsPlayerCanSpecialSummonMonster(1-tp,8100,0x901,0x4011,0,0,2,RACE_REPTILE,ATTRIBUTE_DARK) then
		local token1=Duel.CreateToken(1-tp,8100)
		Duel.SpecialSummon(token1,0,1-tp,1-tp,false,false,POS_FACEUP)
	--end
end