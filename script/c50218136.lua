--风之数码兽LV9 力神比多兽
function c50218136.initial_effect(c) 
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c50218136.scon)
    e2:SetOperation(c50218136.sop)
    c:RegisterEffect(e2)
    --token
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50218136,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,50218136)
    e3:SetCost(c50218136.spcost)
    e3:SetTarget(c50218136.sptg)
    e3:SetOperation(c50218136.spop)
    c:RegisterEffect(e3)
     --aclimit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCode(EFFECT_CANNOT_ACTIVATE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(1,1)
    e4:SetValue(c50218136.aclimit)
    c:RegisterEffect(e4)
    --handes
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(50218136,0))
    e5:SetCategory(CATEGORY_REMOVE)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_TO_HAND)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,50218136)
    e5:SetCondition(c50218136.hdcon)
    e5:SetTarget(c50218136.hdtg)
    e5:SetOperation(c50218136.hdop)
    c:RegisterEffect(e5)
end
c50218136.lvupcount=1
c50218136.lvup={50218118}
c50218136.lvdncount=3
c50218136.lvdn={50218116,50218117,50218118}
function c50218136.spfilter(c,ft,tp)
    return c:IsCode(50218118)
        and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c50218136.scon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    return ft>-1 and Duel.CheckReleaseGroup(tp,c50218136.spfilter,1,nil,ft,tp)
end
function c50218136.sop(e,tp,eg,ep,ev,re,r,rp,c)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.SelectReleaseGroup(tp,c50218136.spfilter,1,1,nil,ft,tp)
    Duel.Release(g,REASON_COST)
end
function c50218136.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c50218136.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,50218146,0,0x4011,600,400,1,RACE_INSECT,ATTRIBUTE_WIND) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c50218136.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,50218146,0,0x4011,600,400,1,RACE_INSECT,ATTRIBUTE_WIND) then
        local token=Duel.CreateToken(tp,50218146)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c50218136.aclimit(e,re,tp)
    local loc=re:GetActivateLocation()
    return (loc==LOCATION_GRAVE or loc==LOCATION_REMOVED) and not re:GetHandler():IsImmuneToEffect(e)
end
function c50218136.cfilter(c,tp)
    return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c50218136.hdcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c50218136.cfilter,1,nil,1-tp)
end
function c50218136.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c50218136.hdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    if g:GetCount()>0 then
        local sg=g:RandomSelect(tp,1)
        Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
    end
end