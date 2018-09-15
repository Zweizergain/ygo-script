--大怪兽的幼体 盖达拉
function c10150060.initial_effect(c)
	c:SetUniqueOnField(1,0,20000000,LOCATION_MZONE)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10150060,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_ATTACK,1)
	e1:SetCondition(c10150060.spcon)
	e1:SetOperation(c10150060.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetDescription(aux.Stringid(10150060,2))
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetTargetRange(POS_FACEUP_ATTACK,0)
	e2:SetCondition(c10150060.spcon2)
	e2:SetValue(SUMMON_TYPE_SPECIAL+1)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10150060,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetTarget(c10150060.tgtg)
	e3:SetOperation(c10150060.tgop)
	c:RegisterEffect(e3)	  
end

function c10150060.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0,LOCATION_MZONE,1,nil)
		and not Duel.IsExistingMatchingCard(c10150060.cfilter,tp,0,LOCATION_MZONE,1,nil)
end

function c10150060.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function c10150060.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10150060.cfilter,tp,0,LOCATION_MZONE,1,nil)
		and not Duel.IsExistingMatchingCard(c10150060.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c10150060.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd3)
end

function c10150060.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,e:GetOwnerPlayer(),LOCATION_DECK)
end

function c10150060.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetOwner()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and Duel.GetLocationCount(c:GetPreviousControler(),LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(p,c10150060.spfilter,p,LOCATION_DECK,0,1,1,nil,e,p,c:GetPreviousControler())
		if g:GetCount()>0 then
		  Duel.SpecialSummon(g,0,p,c:GetPreviousControler(),false,false,POS_FACEUP_ATTACK)
		end
	end
end

function c10150060.spfilter(c,e,p,pp)
	return c:IsSetCard(0xd3)
		and c:IsCanBeSpecialSummoned(e,0,p,false,false,POS_FACEUP_ATTACK,pp)
end

