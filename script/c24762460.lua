--猛毒性 交翼
function c24762460.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c24762460.lcheck)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24762460,0))
	e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(c24762460.seqtg)
	e2:SetOperation(c24762460.seqop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c24762460.dircon)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,24762460)
	e3:SetCost(c24762460.spcost)
	e3:SetTarget(c24762460.sptg)
	e3:SetOperation(c24762460.spop)
	c:RegisterEffect(e3)
end
function c24762460.e1cosfil(c)
	return c:IsSetCard(0x1390) and c:IsFaceup() and c:IsReleasable()
end
function c24762460.mmzfil(c)
	return c:IsSetCard(0x1390) and c:IsFaceup() and c:IsReleasable() and c:GetSequence()<5
end
function c24762460.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and (ft>0 or Duel.IsExistingMatchingCard(c24762460.mmzfil,tp,LOCATION_MZONE,0,1,nil)) and Duel.IsExistingMatchingCard(c24762460.e1cosfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,nil)
	end
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=Duel.SelectMatchingCard(tp,c24762460.e1cosfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,3,nil)
	elseif ft>-2 then
		local ct=-ft+1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=Duel.SelectMatchingCard(tp,c24762460.mmzfil,tp,LOCATION_MZONE,LOCATION_MZONE,ct,ct,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=Duel.SelectMatchingCard(tp,c24762460.e1cosfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3-ct,3-ct,g)
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=Duel.SelectMatchingCard(tp,c24762460.mmzfil,tp,LOCATION_MZONE,LOCATION_MZONE,3,3,nil)
	end
	Duel.Release(g,REASON_COST)
end
function c24762460.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c24762460.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c24762460.dircon(e)
	local tp=e:GetHandlerPlayer()
	local gc=e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,1-tp):FilterCount(Card.IsType,nil,TYPE_MONSTER)
	if gc==0 then return true end
end
function c24762460.filter(c,ggc)
	local p=ggc:GetControler()
	local zone=bit.band(ggc:GetLinkedZone(),0x1f)
	return Duel.GetLocationCount(p,LOCATION_MZONE,p,LOCATION_REASON_CONTROL,zone)>0
end
function c24762460.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ggc=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c24762460.filter,tp,LOCATION_MZONE,0,1,nil,ggc) end
end
function c24762460.seqop(e,tp,eg,ep,ev,re,r,rp)
	local ggc=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local p=ggc:GetControler()
	local zone=bit.band(ggc:GetLinkedZone(),0x1f)
	if Duel.GetLocationCount(p,LOCATION_MZONE,p,LOCATION_REASON_CONTROL,zone)>0 then
		local s=0
		if ggc:IsControler(tp) then
			local flag=bit.bxor(zone,0xff)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
		end
		local nseq=0
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(ggc,nseq)
	end
end
function c24762460.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x1390)
end