--离散之茧
function c10150012.initial_effect(c)
	--change code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(40024595)
	c:RegisterEffect(e1)  
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10150012,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE)
	e1:SetTarget(c10150012.eqtg)
	e1:SetOperation(c10150012.eqop)
	c:RegisterEffect(e1)  
end

function c10150012.filter(c)
	return c:IsFaceup() and c:IsCode(58192742)
end

function c10150012.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10150012.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c10150012.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c10150012.filter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c10150012.eqlimit(e,c)
	return c:IsCode(58192742)
end

function c10150012.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	c:SetTurnCounter(0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetValue(c10150012.eqlimit)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(c10150012.checkcon)
	e2:SetOperation(c10150012.checkop)
	e2:SetCountLimit(1)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
	c10150012[e:GetHandler()]=e2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c10150012.efilter)
	e3:SetOwnerPlayer(tp)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	tc:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e5:SetCountLimit(2)
	e5:SetReset(RESET_EVENT+0x1fe0000)
	e5:SetValue(c10150012.valcon)
	tc:RegisterEffect(e5)
	--turn count
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10150012,1))
	e6:SetCategory(CATEGORY_COIN)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetReset(RESET_EVENT+0x1fe0000)
	e6:SetOperation(c10150012.coop)
	c:RegisterEffect(e6)
end

function c10150012.coop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local c1,c2,c3=Duel.TossCoin(tp,3)
	local ct=c1+c2+c3
	if ct<=0 then return end
	--local turne=c[c]
	--local op=turne:GetOperation()
	--local n=1
	--while n<=ct do
	 --op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
	 --n=n+1
	 c:SetTurnCounter(c:GetTurnCounter()+ct)
	--end
end

function c10150012.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end

function c10150012.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function c10150012.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function c10150012.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
end