--银河急战·翼部·J型
function c10100010.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100010,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetTarget(c10100010.eqtg)
	e1:SetOperation(c10100010.eqop)
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100010,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c10100010.con)
	e2:SetTarget(c10100010.sptg)
	e2:SetOperation(c10100010.spop)
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e3)   
	--ATK
	local e4=Effect.CreateEffect(c)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetValue(500)
	e4:SetTarget(c10100010.tg)
	c:RegisterEffect(e4)
	--tograve
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10100010,2))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_ONFIELD)
	e5:SetCondition(c10100010.tgcon)
	e5:SetTarget(c10100010.tgtg)
	e5:SetOperation(c10100010.tgop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e6) 
end
function c10100010.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if not tc then return false end
	if bit.band(e:GetType(),0x100)==0x100 then return tc:IsHasEffect(10100015)
	else return not tc:IsHasEffect(10100015)
	end
end
function c10100010.tg(e,tc)
	local ct=e:GetType()
	local quick=tc:IsHasEffect(10100015)
	local g1,g2,c=tc:GetLinkedGroup(),tc:GetEquipGroup(),e:GetHandler()
	local equip=(g2 and g2:IsContains(c))
	local linkg=(tc:IsHasEffect(10100029) and g1 and g1:IsContains(c))
	if not equip and not linkg then return false end
	if bit.band(ct,0x40)==0x40 then return not quick 
	elseif bit.band(ct,0x100)==0x100 then return quick
	else return true
	end
end
function c10100010.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10100010.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e)
end
function c10100010.cfilter(tc,e)
	return c10100010.tg(e,tc)
end
function c10100010.tgfilter(c)
	return c:IsSetCard(0x339) and c:IsAbleToGrave()
end
function c10100010.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return e:GetHandler():GetFlagEffect(10100110)==0 and Duel.IsExistingTarget(c10100010.tgfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c10100010.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,2,0,0)
	e:GetHandler():RegisterFlagEffect(10100110,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100010.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c10100010.dcfilter(c)
	return c:IsSetCard(0x339) and c:IsReleasable()
end
function c10100010.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100010.dcfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c10100010.dcfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c10100010.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(10100010)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10100010.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(10100010,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100010.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x339)
end
function c10100010.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or (c:IsOnField() and c:IsFacedown()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c10100010.eqfilter,tp,LOCATION_MZONE,0,1,1,c)
	if g:GetCount()<=0 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if not Duel.Equip(tp,c,tc,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c10100010.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end
function c10100010.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c10100010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(10100010)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetEquipTarget() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	c:RegisterFlagEffect(10100010,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end