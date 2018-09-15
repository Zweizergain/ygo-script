--凶恶龙·夺宝奇兵杀手
function c10143007.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3333),aux.FilterBoolFunction(Card.IsFusionSetCard,0x5333),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)  
	--special summon rule
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetValue(SUMMON_TYPE_FUSION)
	e4:SetCondition(c10143007.sprcon)
	e4:SetOperation(c10143007.sprop)
	c:RegisterEffect(e4) 
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10143007,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c10143007.target)
	e2:SetOperation(c10143007.operation)
	c:RegisterEffect(e2) 
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10143007,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10143007.negcon)
	e3:SetCost(c10143007.negcost)
	e3:SetTarget(c10143007.negtg)
	e3:SetOperation(c10143007.negop)
	c:RegisterEffect(e3)
end

function c10143007.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:GetHandler()~=e:GetHandler()
end

function c10143007.costfilter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsFaceup() and c:IsSetCard(0x3333) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end

function c10143007.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(c10143007.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10143007.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,e:GetHandler())
	Duel.Release(e:GetHandler(),REASON_COST+REASON_TEMPORARY)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c10143007.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function c10143007.negop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re)then
		Duel.Destroy(eg,REASON_EFFECT)
	end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCountLimit(1)
		if Duel.GetTurnPlayer()==tp then
			if Duel.GetCurrentPhase()==PHASE_DRAW then
				e1:SetLabel(Duel.GetTurnCount())
			else
				e1:SetLabel(Duel.GetTurnCount()+2)
			end
		else
			e1:SetLabel(Duel.GetTurnCount()+1)
		end
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c10143007.retcon)
		e1:SetOperation(c10143007.retop)
		c:RegisterEffect(e1)
end

function c10143007.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()
end

function c10143007.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetHandler())
	e:Reset()
end

function c10143007.filter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsFaceup() and c:IsSetCard(0x3333) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end

function c10143007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c10143007.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10143007.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.SelectTarget(tp,c10143007.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

function c10143007.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		--atk up
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(400)
		c:RegisterEffect(e1)
	end
end

function c10143007.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c10143007.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,ft)
end

function c10143007.spfilter1(c,tp,ft)
	if c:IsFusionSetCard(0x3333) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup()) then
		if ft>0 or c:IsControler(tp) then
			return Duel.IsExistingMatchingCard(c10143007.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp)
		else
			return Duel.IsExistingMatchingCard(c10143007.spfilter2,tp,LOCATION_MZONE,0,1,c,tp)
		end
	else return false end
end

function c10143007.spfilter2(c,tp)
	return c:IsFusionSetCard(0x5333) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup())
end

function c10143007.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c10143007.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp,ft)
	local g2=Duel.GetMatchingGroup(c10143007.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	g1:Merge(g2)
	local g=Group.CreateGroup()
	local tc=nil
		for i=1,2 do
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		   if ft<=0 then
			tc=g1:FilterSelect(tp,Card.IsControler,1,1,nil,tp):GetFirst()
		   else
			tc=g1:Select(tp,1,1,nil):GetFirst()
		   end
		   g:AddCard(tc)
		   if tc:IsFusionSetCard(0x3333) and not tc:IsFusionSetCard(0x5333) then
			g1:Remove(Card.IsFusionSetCard,nil,0x3333)
		   elseif tc:IsFusionSetCard(0x5333) and not tc:IsFusionSetCard(0x3333) then
			g1:Remove(Card.IsFusionSetCard,nil,0x5333)
		   elseif tc:IsFusionSetCard(0x3333) and tc:IsFusionSetCard(0x5333) then
			g1:RemoveCard(tc)
		   end
		 ft=ft+1
		end
	 Duel.Remove(g,POS_FACEUP,REASON_COST)
end
