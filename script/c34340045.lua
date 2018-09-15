--白魔术仿生术
function c34340045.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c34340045.condition)
	e1:SetTarget(c34340045.target)
	e1:SetOperation(c34340045.activate)
	c:RegisterEffect(e1)	
end
c34340045.setname="WhiteMagician"
function c34340045.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsRace(RACE_SPELLCASTER+RACE_FAIRY)
end
function c34340045.spfilter(c,e,tp,race)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(race)
end
function c34340045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	local race=0
	if tc:IsRace(RACE_SPELLCASTER) then race=race+RACE_DRAGON end
	if tc:IsRace(RACE_FAIRY) then race=race+RACE_FIEND end
	if chk==0 then return Duel.GetMZoneCount(tp,tc,tp)>0 and Duel.IsExistingMatchingCard(c34340045.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,race) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c34340045.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local race=0
	if tc:IsRace(RACE_SPELLCASTER) then race=race+RACE_DRAGON end
	if tc:IsRace(RACE_FAIRY) then race=race+RACE_FIEND end
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local sg=Duel.SelectMatchingCard(tp,c34340045.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,race)
	   if sg:GetCount()>0 then
		  Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	   end
	end
end
