--蓝贵士-吸血鬼·格蕾丝·改
function c98711012.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),6,2,c98711012.ovfilter,aux.Stringid(98711012,0))
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c98711012.atkcon)
	e1:SetValue(c98711012.atkval)
	c:RegisterEffect(e1)
	--deckdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c98711012.tgcon1)
	e2:SetTarget(c98711012.tgtg)
	e2:SetOperation(c98711012.tgop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c98711012.tgcon2)
	e3:SetTarget(c98711012.tgtg)
	e3:SetOperation(c98711012.tgop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--equip
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(98711012,1))
	e10:SetCategory(CATEGORY_EQUIP)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1)
	e10:SetCost(c98711012.eqcost)
	e10:SetTarget(c98711012.eqtg)
	e10:SetOperation(c98711012.eqop)
	c:RegisterEffect(e10)
	--spsummon
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_LEAVE_FIELD_P)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetOperation(c98711012.checkop)
	c:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(98711012,2))
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e12:SetCode(EVENT_TO_GRAVE)
	e12:SetCondition(c98711012.spcon)
	e12:SetTarget(c98711012.sptg)
	e12:SetOperation(c98711012.spop)
	c:RegisterEffect(e12)
	e11:SetLabelObject(e12)
end
function c98711012.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_XYZ) and c:GetRank()==5 and c:GetOverlayCount()==0
end
function c98711012.atkval(e,c)
	return c:GetOverlayCount()*500
end
function c98711012.atkcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c98711012.tgfilter1(c,tp)
	return c:IsControler(tp) and (c:IsPreviousLocation(LOCATION_DECK) or c:IsPreviousLocation(LOCATION_GRAVE))
end
function c98711012.tgcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98711012.tgfilter1,1,nil,1-tp) and e:GetHandler():GetOverlayCount()>0
end
function c98711012.tgfilter2(c,sp)
	return c:GetSummonPlayer()==sp
end
function c98711012.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98711012.tgfilter2,1,nil,1-tp) and e:GetHandler():GetOverlayCount()>0
end
function c98711012.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,2)
end
function c98711012.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,98711012)
	Duel.DiscardDeck(1-tp,2,REASON_EFFECT)
end
function c98711012.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98711012.eqfilter(c,atk)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c98711012.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c98711012.eqfilter(chkc,e:GetHandler():GetAttack()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c98711012.eqfilter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c98711012.eqfilter,tp,0,LOCATION_MZONE,1,1,nil,e:GetHandler():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c98711012.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c98711012.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsType(TYPE_MONSTER) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if Duel.Equip(tp,tc,c)==0 then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_OATH)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c98711012.ftarget)
		e1:SetLabel(e:GetHandler():GetFieldID())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(c98711012.eqlimit)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(98711012,RESET_EVENT+0x1fe0000,0,1)
	else Duel.SendtoGrave(tc,REASON_EFFECT) end
end
function c98711012.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end
function c98711012.spfilter(c)
	return c:GetFlagEffect(98711012)~=0
end
function c98711012.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetEquipGroup():IsExists(c98711012.spfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c98711012.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c98711012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98711012.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
