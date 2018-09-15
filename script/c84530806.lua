--幻灭神话 妖精龙
function c84530806.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon
	aux.AddSynchroProcedure(c,c84530806.synfilter,c84530806.matfilter,1)
	--spsummon condition
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	--c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c84530806.sprcon)
	e2:SetOperation(c84530806.sprop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c84530806.targt)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	e4:SetCondition(c84530806.bpcon)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c84530806.bpcon)
	e5:SetValue(c84530806.efilter)
	c:RegisterEffect(e5)
	--def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c84530806.apcon)
	e6:SetValue(0)
	c:RegisterEffect(e6)
	local e8=e6:Clone()
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetValue(-500)
	c:RegisterEffect(e8)
	--shuffle
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(c84530806.target)
	e7:SetOperation(c84530806.operation)
	c:RegisterEffect(e7)
end
function c84530806.targt(e,c)
	return c~=e:GetHandler() and (c:GetLevel()==1 or c:GetRank()==1 or c:GetLink()==1) and c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x8351)
end
function c84530806.apcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c84530806.bpcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function c84530806.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c84530806.synfilter(c)
	return c:IsFaceup() and c:GetLevel()==1 and c:IsSetCard(0x8351) and c:IsType(TYPE_TUNER)
end
c84530806.material_setcode=0x8351
function c84530806.matfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
end
function c84530806.cfilter(c)
	return ((c:IsSetCard(0x8351) and c:GetLevel()==1 and c:IsType(TYPE_TUNER)) or (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK)))
		and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function c84530806.spfilter1(c,tp,g)
	return g:IsExists(c84530806.spfilter2,1,c,tp,c)
end
function c84530806.spfilter2(c,tp,mc)
	return (c:IsSetCard(0x8351) and c:GetLevel()==1 and c:IsType(TYPE_TUNER) and (mc:IsType(TYPE_XYZ) or mc:IsType(TYPE_LINK))
		or (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK)) and mc:IsSetCard(0x8351) and mc:GetLevel()==1 and mc:IsType(TYPE_TUNER))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c84530806.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c84530806.cfilter,tp,LOCATION_MZONE,0,nil,c)
	return mg:IsExists(c84530806.spfilter1,1,nil,tp,mg)
end
function c84530806.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c84530806.cfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=mg:FilterSelect(tp,c84530806.spfilter1,1,1,nil,tp,mg)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=mg:FilterSelect(tp,c84530806.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c84530806.filter(c)
	return (c:GetLevel()==1 or c:GetRank()==1 or c:GetLink()==1) and c:IsSetCard(0x8351) and c:IsAbleToDeck()
end
function c84530806.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c84530806.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c84530806.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c84530806.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c84530806.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=1 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
end