--银河急战·防卫部·O型
function c10100015.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100015,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetTarget(c10100015.eqtg)
	e1:SetOperation(c10100015.eqop)
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100015,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c10100015.con)
	e2:SetTarget(c10100015.sptg)
	e2:SetOperation(c10100015.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e3)
	--effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(10100015)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c10100015.eftg)
	c:RegisterEffect(e4)
end
function c10100015.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if not tc then return false end
	if bit.band(e:GetType(),0x100)==0x100 then return tc:IsHasEffect(10100015)
	else return not tc:IsHasEffect(10100015)
	end
end
function c10100015.eftg(e,tc)
	local g1,g2,c=tc:GetLinkedGroup(),tc:GetEquipGroup(),e:GetHandler()
	return (tc:IsHasEffect(10100029) and g1 and g1:IsContains(c)) or (g2 and g2:IsContains(c))
end
function c10100015.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(10100015)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10100015.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(10100015,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100015.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x339)
end
function c10100015.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or (c:IsOnField() and c:IsFacedown()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c10100015.eqfilter,tp,LOCATION_MZONE,0,1,1,c)
	if g:GetCount()<=0 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if not Duel.Equip(tp,c,tc,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c10100015.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end
function c10100015.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c10100015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(10100015)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(10100015,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end