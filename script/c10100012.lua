--银河急战·翼部·L型
function c10100012.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100012,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetTarget(c10100012.eqtg)
	e1:SetOperation(c10100012.eqop)
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100012,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c10100012.con)
	e2:SetTarget(c10100012.sptg)
	e2:SetOperation(c10100012.spop)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e3)  
	--ATK
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetValue(1200)
	e4:SetTarget(c10100012.tg)
	e4:SetLabel(1000)
	c:RegisterEffect(e4)
	--Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10100012,2))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_ONFIELD)
	e5:SetCost(c10100012.descost)
	e5:SetCondition(c10100012.descon)
	e5:SetTarget(c10100012.destg)
	e5:SetOperation(c10100012.desop)
	e5:SetLabel(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,0x1e0)
	e6:SetLabel(100)
	c:RegisterEffect(e6) 
end
function c10100012.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if not tc then return false end
	if bit.band(e:GetType(),0x100)==0x100 then return tc:IsHasEffect(10100015)
	else return not tc:IsHasEffect(10100015)
	end
end
function c10100012.tg(e,tc)
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
function c10100012.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c10100012.desfilter(c,dg)
	if not c:IsSetCard(0x339) then return false end
	if c:GetEquipCount()==0 then return dg:GetCount()>0 end
	local a=0
	local eg=c:GetEquipGroup()
	for tc in aux.Next(eg) do
		if dg:IsContains(tc) then a=a+1 end
		tc=eg:GetNext()
	end
	return dg:GetCount()-a>0
end
function c10100012.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetHandler():GetFlagEffect(10100112)~=0 then return false end
		if e:GetLabel()==1 then
			e:SetLabel(0)
			local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_ONFIELD,0,nil)
			local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
			return rg:IsExists(c10100012.desfilter,1,nil,dg)
		else
			return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_ONFIELD,0,nil)
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil,e)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=rg:FilterSelect(tp,c10100012.desfilter,1,1,nil,dg)
		Duel.Release(sg,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
	e:GetHandler():RegisterFlagEffect(10100112,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100012.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c10100012.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10100012.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e)
end
function c10100012.cfilter(tc,e)
	return c10100012.tg(e,tc)
end
function c10100012.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(10100012)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10100012.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(10100012,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100012.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x339)
end
function c10100012.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or (c:IsOnField() and c:IsFacedown()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c10100012.eqfilter,tp,LOCATION_MZONE,0,1,1,c)
	if g:GetCount()<=0 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if not Duel.Equip(tp,c,tc,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c10100012.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end
function c10100012.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c10100012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(10100012)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetEquipTarget() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	c:RegisterFlagEffect(10100012,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end