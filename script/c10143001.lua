--夺宝奇兵·凶恶龙骑士
function c10143001.initial_effect(c)
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
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(SUMMON_TYPE_FUSION)
	e2:SetCondition(c10143001.sprcon)
	e2:SetOperation(c10143001.sprop)
	c:RegisterEffect(e2) 
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c10143001.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10143001,0))
	e5:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_START)
	e5:SetCountLimit(1,10143001)
	e5:SetTarget(c10143001.target)
	e5:SetOperation(c10143001.operation)
	c:RegisterEffect(e5)
end

function c10143001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetAttackTarget()==c or (Duel.GetAttacker()==c and Duel.GetAttackTarget()~=nil) and Duel.IsPlayerCanDraw(tp,1) end
	local g=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c10143001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
	if ct<=0 then return end
	local dc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,dc)
	 if dc:IsSetCard(0x6333) and bc:IsRelateToBattle() then 
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	 end
	 if dc:IsSetCard(0x3333) then
		Duel.Damage(1-tp,800,REASON_EFFECT)
	 end
	 if dc:IsSetCard(0x5333) and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500)
		c:RegisterEffect(e1)
	 end
	Duel.ShuffleDeck(tp)
end

function c10143001.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10143001.indfilter,tp,LOCATION_SZONE,0,1,nil)
end

function c10143001.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6333) and c:GetSequence()<5
end

function c10143001.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c10143001.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,ft)
end

function c10143001.spfilter1(c,tp,ft)
	if c:IsFusionSetCard(0x3333) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup()) then
		if ft>0 or c:IsControler(tp) then
			return Duel.IsExistingMatchingCard(c10143001.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp)
		else
			return Duel.IsExistingMatchingCard(c10143001.spfilter2,tp,LOCATION_MZONE,0,1,c,tp)
		end
	else return false end
end

function c10143001.spfilter2(c,tp)
	return c:IsFusionSetCard(0x5333) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup())
end

function c10143001.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c10143001.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp,ft)
	local g2=Duel.GetMatchingGroup(c10143001.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
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
