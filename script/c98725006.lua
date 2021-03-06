--真龙的继承
function c98725006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98725006,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,98725006)
	e2:SetCondition(c98725006.drcon)
	e2:SetTarget(c98725006.drtg)
	e2:SetOperation(c98725006.drop)
	c:RegisterEffect(e2)
	--tribute summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98725006,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,49430783)
	e3:SetTarget(c98725006.sumtg)
	e3:SetOperation(c98725006.sumop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98725006,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,49430784)
	e4:SetCondition(c98725006.descon)
	e4:SetTarget(c98725006.destg)
	e4:SetOperation(c98725006.desop)
	c:RegisterEffect(e4)
	if c98725006.counter==nil then
		c98725006.counter=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c98725006.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c98725006.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c98725006.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_ONFIELD) and tc:IsSetCard(0xf9) then
			if tc:GetCode()==98725003 then
				if Duel.GetFlagEffect(0,98725106)==0 then
					c98725006.counter=c98725006.counter+1
					Duel.RegisterFlagEffect(0,98725106,RESET_PHASE+PHASE_END,0,1)
				end
				if Duel.GetFlagEffect(0,98725206)==0 then
					c98725006.counter=c98725006.counter+1
					Duel.RegisterFlagEffect(0,98725206,RESET_PHASE+PHASE_END,0,1)
				end
			end
			local typ=bit.band(tc:GetOriginalType(),0x7)
			if (typ==TYPE_MONSTER and Duel.GetFlagEffect(0,98725006)==0)
				or (typ==TYPE_SPELL and Duel.GetFlagEffect(0,98725106)==0)
				or (typ==TYPE_TRAP and Duel.GetFlagEffect(0,98725206)==0) then
				c98725006.counter=c98725006.counter+1
				if typ==TYPE_MONSTER then
					Duel.RegisterFlagEffect(0,98725006,RESET_PHASE+PHASE_END,0,1)
				elseif typ==TYPE_SPELL then
					Duel.RegisterFlagEffect(0,98725106,RESET_PHASE+PHASE_END,0,1)
				else
					Duel.RegisterFlagEffect(0,98725206,RESET_PHASE+PHASE_END,0,1)
				end
			end
		end
		tc=eg:GetNext()
	end
end
function c98725006.clearop(e,tp,eg,ep,ev,re,r,rp)
	c98725006.counter=0
end
function c98725006.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c98725006.counter>0
end
function c98725006.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,c98725006.counter) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c98725006.counter)
end
function c98725006.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,c98725006.counter,REASON_EFFECT)
end
function c98725006.sumfilter(c)
	return c:IsSetCard(0xf9) and c:IsSummonable(true,nil,1)
end
function c98725006.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98725006.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c98725006.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c98725006.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1)
	end
end
function c98725006.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function c98725006.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsType(TYPE_SPELL+TYPE_TRAP) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98725006.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
