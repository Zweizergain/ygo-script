--水中的技师✿河城荷取
function c100800.initial_effect(c)
	--summon with X tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100800,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c100800.otcon)
	e1:SetOperation(c100800.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)	
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100800,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c100800.atkcost)
	e2:SetTarget(c100800.eqtg)
	e2:SetOperation(c100800.eqop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c100800.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetValue(c100800.defval)
	c:RegisterEffect(e4)	
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100800,2))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetHintTiming(0,0x1e0)
	e5:SetCost(c100800.descost)
	e5:SetTarget(c100800.destg)
	e5:SetOperation(c100800.desop)
	c:RegisterEffect(e5)
end
function c100800.atkval(e,c)
	local rg=c:GetEquipGroup()
	return rg:GetSum(Card.GetAttack)
end
function c100800.defval(e,c)
	local rg=c:GetEquipGroup()
	return rg:GetSum(Card.GetDefense)
end
function c100800.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:GetLevel()>6 and minc<=2
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckTribute(c,2))
		or c:GetLevel()>=1 and c:GetLevel()<=6 and minc<=1
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckTribute(c,1)
end
function c100800.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if ct<=1 then ct=1 end 
	if c:GetLevel()>6 and ct<2 then ct=2 end 
	local g=Duel.SelectTribute(tp,c,ct,99)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end

function c100800.mgfilter(c,e,tp,fusc)
	return c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x12)==0x12 and c:GetReasonCard()==fusc
		and c:IsAbleToDeckAsCost() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c100800.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ag=c:GetMaterial()
	if chk==0 then return ag and ag:GetCount()>0 and ag:IsExists(c100800.mgfilter,1,nil,e,tp,c) end
	local dc=ag:FilterSelect(tp,c100800.mgfilter,1,1,nil,e,tp,c)
	Duel.SendtoDeck(dc,nil,2,REASON_COST)
end
function c100800.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToChangeControler() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c100800.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c100800.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100800.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c100800.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c100800.eqlimit(e,c)
	return e:GetOwner()==c
end
function c100800.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,tc,c,false)
		local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c100800.eqlimit)
			tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(1)
		tc:RegisterEffect(e2)		
	else Duel.SendtoGrave(tc,REASON_RULE) end
end

function c100800.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=c:GetEquipGroup()
	if chk==0 then return rg and rg:GetCount()>0 and rg:IsExists(Card.IsReleasable,1,nil) end
	local ac=rg:FilterSelect(tp,Card.IsReleasable,1,1,nil)
	Duel.Release(ac,REASON_COST)
end
function c100800.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100800.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
