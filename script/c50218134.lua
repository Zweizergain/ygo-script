--炎之数码兽LV9 凤凰兽
function c50218134.initial_effect(c) 
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
    e2:SetCondition(c50218134.scon)
    e2:SetOperation(c50218134.sop)
    c:RegisterEffect(e2)
    --token
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50218134,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,50218134)
    e3:SetCost(c50218134.spcost)
    e3:SetTarget(c50218134.sptg)
    e3:SetOperation(c50218134.spop)
    c:RegisterEffect(e3)
    --atkup
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetValue(c50218134.atkup)
    c:RegisterEffect(e4)
    --attack all
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_ATTACK_ALL)
    e5:SetValue(1)
    c:RegisterEffect(e5)
end
c50218134.lvupcount=1
c50218134.lvup={50218112}
c50218134.lvdncount=3
c50218134.lvdn={50218110,50218111,50218112}
function c50218134.spfilter(c,ft,tp)
    return c:IsCode(50218112)
        and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c50218134.scon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    return ft>-1 and Duel.CheckReleaseGroup(tp,c50218134.spfilter,1,nil,ft,tp)
end
function c50218134.sop(e,tp,eg,ep,ev,re,r,rp,c)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.SelectReleaseGroup(tp,c50218134.spfilter,1,1,nil,ft,tp)
    Duel.Release(g,REASON_COST)
end
function c50218134.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c50218134.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,50218144,0,0x4011,800,200,1,RACE_WINDBEAST,ATTRIBUTE_FIRE) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c50218134.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,50218144,0,0x4011,800,200,1,RACE_WINDBEAST,ATTRIBUTE_FIRE) then
        local token=Duel.CreateToken(tp,50218144)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c50218134.atkfilter(c)
    return c:IsSetCard(0xcb1)
end
function c50218134.atkup(e,c)
    return Duel.GetMatchingGroupCount(c50218134.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*200
end