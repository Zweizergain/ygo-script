--乱数汇聚
function c21520033.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520033,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21520033+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21520033.target)
	e1:SetOperation(c21520033.activate)
	c:RegisterEffect(e1)
	--to hand or set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520033,5))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c21520033.thcon)
	e2:SetCost(c21520033.thcost)
	e2:SetTarget(c21520033.thtg)
	e2:SetOperation(c21520033.thop)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c21520033.handcon)
	c:RegisterEffect(e3)
end
function c21520033.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c21520033.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,true) and c:CheckFusionMaterial(m,nil,chkf)
end
function c21520033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,nil)
		local res=Duel.IsExistingMatchingCard(c21520033.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c21520033.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c21520033.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c21520033.filter1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c21520033.filter2,tp,LOCATION_GRAVE,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c21520033.filter2,tp,LOCATION_GRAVE,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,true,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		--not randomly
		if not tc:IsSetCard(0x493) and not Duel.IsExistingMatchingCard(c21520033.chkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
			local sum=0
			sum=tc:GetOriginalLevel()
			Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
			Duel.BreakEffect()
			Duel.Damage(tp,sum*500,REASON_RULE)
		end
		tc:CompleteProcedure()
	else
		local cg1=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0)
		local cg2=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
		if cg1:GetCount()>1 and cg2:IsExists(Card.IsFacedown,1,nil)
			and Duel.IsPlayerCanSpecialSummon(tp) and not Duel.IsPlayerAffectedByEffect(tp,27581098) then
			Duel.ConfirmCards(1-tp,cg1)
			Duel.ConfirmCards(1-tp,cg2)
			Duel.ShuffleHand(tp)
		end
	end
end
function c21520033.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x493) and c:IsType(TYPE_FIELD)
end
function c21520033.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c21520033.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c21520033.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520033.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520033.cfilter,tp,LOCATION_GRAVE,0,nil)
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+20)
	local ct=math.random(1,g:GetCount())
	local rg=g:RandomSelect(tp,ct)
	Duel.ConfirmCards(1-tp,rg)
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
end
function c21520033.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsSSetable()) or e:GetHandler():IsAbleToHand() end
	local op=2
	if (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsSSetable()) or e:GetHandler():IsAbleToHand() then
		op=Duel.SelectOption(tp,aux.Stringid(21520033,2),aux.Stringid(21520033,4))
	elseif Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsSSetable() then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520033,2))
		op=0
	elseif e:GetHandler():IsAbleToHand() then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520033,4))
		op=1
	end
	if op==1 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE) end
	e:SetLabel(op)
end
function c21520033.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not e:GetHandler():IsLocation(LOCATION_GRAVE) then return end
	local op=e:GetLabel()
	if op==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then 
		Duel.SSet(tp,e:GetHandler())
		Duel.ConfirmCards(1-tp,e:GetHandler())
	elseif op==1 and e:GetHandler():IsAbleToHand() then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
function c21520033.hafilter(c)
	return c:IsSetCard(0x493) and c:IsFaceup()
end
function c21520033.handcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c21520033.hafilter,tp,LOCATION_MZONE,0,nil)
	local rg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return g:GetCount() == rg:GetCount() and g:GetCount()>0
end
