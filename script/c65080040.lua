--花札卫-赤青短-
function c65080040.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c65080040.matfilter,3)
	--specialformdeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65080040,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65080040)
	e1:SetCost(c65080040.cost1)
	e1:SetTarget(c65080040.tar1)
	e1:SetOperation(c65080040.ope1)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65080040,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65080040.spcon)
	e2:SetOperation(c65080040.spop)
	c:RegisterEffect(e2)
end

function c65080040.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)
end

function c65080040.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c65080040.filter1(c,e,tp,ft,g)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and c:IsSetCard(0xe6)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup()) and g:IsContains(c)
		and Duel.IsExistingMatchingCard(c65080040.filter2,tp,LOCATION_DECK,0,1,nil,lv,e,tp)
end
function c65080040.filter2(c,lv,e,tp)
	return c:IsSetCard(0xe6) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c65080040.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return ft>-1 and Duel.CheckReleaseGroup(tp,c65080040.filter1,1,nil,e,tp,ft,lg)
	end
	local rg=Duel.SelectReleaseGroup(tp,c65080040.filter1,1,1,nil,e,tp,ft,lg)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65080040.ope1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65080040.filter2,tp,LOCATION_DECK,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end

function c65080040.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65080040.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c65080040.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local g=Duel.SelectMatchingCard(tp,c65080040.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65080040.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end

function c65080040.spfil(c,e,tp)
	return c:IsSetCard(0xe6) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c65080040.splimit(e,c)
	return not c:IsSetCard(0xe6)
end
