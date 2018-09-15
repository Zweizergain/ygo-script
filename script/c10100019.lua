--银河急战·弹射加农炮
function c10100019.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c10100019.matfilter,c10100019.xyzcheck,2,2)   
	c:EnableReviveLimit()  
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100019,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c10100019.eqtg)
	e1:SetOperation(c10100019.eqop)
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100019,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c10100019.con)
	e2:SetTarget(c10100019.sptg)
	e2:SetOperation(c10100019.spop)
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
	e4:SetValue(1000)
	e4:SetTarget(c10100019.tg)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10100019,2))
	e5:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,0x1e0)
	e5:SetRange(LOCATION_ONFIELD)
	e5:SetCondition(c10100019.descon)
	e5:SetCost(c10100019.descost)
	e5:SetTarget(c10100019.destg)
	e5:SetOperation(c10100019.desop)
	c:RegisterEffect(e5)
end
function c10100019.matfilter(c,xyzc)
	return c:IsSetCard(0x339) and c:GetLevel()>0
end
function c10100019.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function c10100019.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if not tc then return false end
	if bit.band(e:GetType(),0x100)==0x100 then return tc:IsHasEffect(10100015)
	else return not tc:IsHasEffect(10100015)
	end
end
function c10100019.tg(e,tc)
	local g1,g2,c=tc:GetLinkedGroup(),tc:GetEquipGroup(),e:GetHandler()
	return (tc:IsHasEffect(10100029) and g1 and g1:IsContains(c)) or (g2 and g2:IsContains(c))
end
function c10100019.cfilter(tc,e)
	return c10100019.tg(e,tc)
end
function c10100019.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10100019.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e)
end
function c10100019.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c10100019.tgfilter(c,rc)
	local ec=c:GetEquipTarget()
	local ec2=rc:GetEquipTarget()
	return aux.disfilter1(c) and (not rc or ((not ec or ec~=rc) and (not ec2 or ec2~=c)))
end
function c10100019.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and aux.disfilter1(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then
	   local c=nil
	   if e:GetLabel()~=1 then c=e:GetHandler() end
	   e:SetLabel(0)
	   return Duel.IsExistingTarget(c10100011.tgfilter,tp,0,LOCATION_ONFIELD,1,nil,c)
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		Duel.Release(e:GetHandler(),REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10100019.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.disfilter1(tc) then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_DISABLE)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   tc:RegisterEffect(e1)
	   Duel.AdjustInstantly()
	   Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	   Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c10100019.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(10100019)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10100019.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(10100019,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100019.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x339)
end
function c10100019.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or (c:IsOnField() and c:IsFacedown()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c10100019.eqfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	if g:GetCount()<=0 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if not Duel.Equip(tp,c,tc,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c10100019.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end
function c10100019.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c10100019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(10100019)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(10100019,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end