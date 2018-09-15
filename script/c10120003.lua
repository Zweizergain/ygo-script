--天选圣女 圣马罗丝薇瑟
function c10120003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10120003)
	e1:SetCondition(c10120003.spcon)
	c:RegisterEffect(e1)  
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10120003,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c10120003.netg)
	e2:SetOperation(c10120003.neop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)   
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10120003,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c10120003.thtg)
	e4:SetOperation(c10120003.thop)
	c:RegisterEffect(e4)
		--dissummon
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON)
		ge1:SetOperation(c10120003.snop)
		ge1:SetLabelObject(e4)
		Duel.RegisterEffect(ge1,0) 
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SUMMON_SUCCESS) 
		ge2:SetOperation(c10120003.ssop)
		ge2:SetLabelObject(e4)
		Duel.RegisterEffect(ge2,0) 
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON)
		ge3:SetLabelObject(e4)
		Duel.RegisterEffect(ge3,0) 
		local ge4=ge2:Clone()
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge4:SetLabelObject(e4)
		Duel.RegisterEffect(ge4,0)   
end

function c10120003.thfilter(c,tid)
	return c:IsSetCard(0x9331) and c:IsAbleToHand() and c:GetTurnID()==tid
end

function c10120003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetHandler():GetFlagEffect(10120003)==0 then return false end  
		   e:GetHandler():ResetFlagEffect(10120003)
		return Duel.IsExistingMatchingCard(c10120003.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),Duel.GetTurnCount()) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end

function c10120003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10120003.thfilter,tp,LOCATION_GRAVE,0,1,2,e:GetHandler(),Duel.GetTurnCount())
	local sg=g:Filter(c10120003.thfilter2,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function c10120003.thfilter2(c)
	return not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end

function c10120003.snop(e,tp,eg,ep,ev,re,r,rp)
   if eg:IsContains(e:GetOwner()) then
	e:GetOwner():RegisterFlagEffect(10120003,RESET_EVENT+RESET_OVERLAY+0x00102000,0,0)
   end
end

function c10120003.ssop(e,tp,eg,ep,ev,re,r,rp)
   if eg:IsContains(e:GetOwner()) then
	e:GetOwner():ResetFlagEffect(10120003)
   end
end

function c10120003.nefilter(c,atk)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled() and c:IsAttackAbove(atk)
end

function c10120003.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10120003.nefilter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack()) end
end

function c10120003.neop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10120003.nefilter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end

function c10120003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,3,nil,RACE_FAIRY)
end