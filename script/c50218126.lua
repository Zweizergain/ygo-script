--数码兽进化-神圣计划
function c50218126.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --level up
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50218126,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,50218126)
    e2:SetCost(c50218126.cost)
    e2:SetTarget(c50218126.target)
    e2:SetOperation(c50218126.activate)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetDescription(aux.Stringid(50218126,0))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c50218126.spcon)
    e3:SetTarget(c50218126.sptg)
    e3:SetOperation(c50218126.spop)
    c:RegisterEffect(e3)
end
function c50218126.costfilter(c,e,tp)
    if not c:IsSetCard(0xcb1) or not c:IsAbleToGraveAsCost() or not c:IsFaceup() then return false end
    local code=c:GetCode()
    local class=_G["c"..code]
    if class==nil or class.lvupcount==nil then return false end
    return Duel.IsExistingMatchingCard(c50218126.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,class,e,tp)
end
function c50218126.spfilter(c,class,e,tp)
    local code=c:GetCode()
    for i=1,class.lvupcount do
        if code==class.lvup[i] then return c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
    end
    return false
end
function c50218126.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50218126.costfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c50218126.costfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SendtoGrave(g,REASON_COST)
    e:SetLabel(g:GetFirst():GetCode())
end
function c50218126.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c50218126.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local code=e:GetLabel()
    local class=_G["c"..code]
    if class==nil or class.lvupcount==nil then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c50218126.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,class,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
        if tc:GetPreviousLocation()==LOCATION_DECK then Duel.ShuffleDeck(tp) end
    end
end
function c50218126.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
end
function c50218126.filter(c,e,tp)
    return c:IsSetCard(0xcb1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50218126.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c50218126.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c50218126.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c50218126.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        Duel.ShuffleDeck(tp)
    end
end