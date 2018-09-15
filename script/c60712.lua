--禁弹「刻着过去的钟表」
function c60712.initial_effect(c)
	--add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(60700)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c60712.handcon)
	e1:SetTarget(c60712.sptg)
	e1:SetOperation(c60712.spop)
	c:RegisterEffect(e1)	
	if not c60712.global_check then
		c60712.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c60712.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60712,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c60712.tdcost)
	e2:SetTarget(c60712.seqtg)
	e2:SetOperation(c60712.seqop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c60712.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c60712.eftg(e,c)
	local g=c:GetOverlayGroup()
	if g:GetCount()==0 then return end 
	return c:IsType(TYPE_XYZ) and g:IsExists(Card.IsCode,1,nil,60700) and c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c60712.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60712.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c60712.seqop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=0
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(c,nseq)
		local sg=e:GetHandler():GetColumnGroup()
		if e:GetHandler():IsRelateToEffect(e) and Duel.Destroy(sg,REASON_EFFECT)<1 then 
			Duel.Damage(1-tp,1000,REASON_EFFECT)			
		end
	end
end
function c60712.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
			tc:RegisterFlagEffect(60712,RESET_EVENT+0x1f20000+RESET_PHASE+PHASE_END,0,1)
		elseif tc:IsLocation(LOCATION_EXTRA) then
			tc:RegisterFlagEffect(60712,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c60712.handcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()>0 and g:FilterCount(Card.IsSetCard,nil,0x813)==g:GetCount() and eg:IsExists(c60712.spcfilter,1,nil,tp)
end
function c60712.spcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c60712.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60700,0,0x813,2000,2000,7,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c60712.thfilter1(c,tp,id)
	return c:IsType(TYPE_MONSTER) and c:GetFlagEffect(60712)~=0
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c60712.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c60712.thfilter2(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c60712.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,60700,0,0x813,2000,2000,7,RACE_FIEND,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		if Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP) then 
			c:AddMonsterAttributeComplete()
			Duel.SpecialSummonComplete()
			local g=Duel.GetMatchingGroup(c60712.thfilter1,tp,0x70,0x70,nil,tp,Duel.GetTurnCount())
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60712,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60712,3))
				local cg=g:Select(tp,1,1,nil)
				Duel.HintSelection(cg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(tp,c60712.thfilter2,tp,LOCATION_DECK,0,1,1,nil,cg:GetFirst():GetCode())
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end 
	end
end