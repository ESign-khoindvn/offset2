
// ── Globals ────────────────────────────────────────────────────────────────
bool AimSkill       = false;
int  Radius         = 0;
bool AutoTrung      = false;
int  skillSlot      = 0;
bool aimSkill1      = false;
bool aimSkill2      = false;
bool aimSkill3      = false;
float SetFieldOfView = 2.0f;
static bool lockcam        = false;
static bool AutoWinInGame  = false;
static bool isPlayerName   = false;
static bool Map            = false;

// NEW globals
static bool bFPS90         = false;   // Unlock 90 FPS
static bool bAnoBypass     = true;    // AnoSDK bypass (default ON)
static bool bFrameSyncByp  = false;   // Frame sync / hash bypass
static uint32_t fakeRank   = 0;       // 0 = disabled

// ── AimBot ─────────────────────────────────────────────────────────────────

bool (*_IsSmartUse)(void *instance);
bool (*_get_IsUseCameraMoveWithIndicator)(void *instance);

static inline bool aimSlotActive() {
    return (skillSlot == 1 && aimSkill1) ||
           (skillSlot == 2 && aimSkill2) ||
           (skillSlot == 3 && aimSkill3);
}

bool IsSmartUse(void *instance) {
    if (AutoTrung && aimSlotActive()) return true;
    return _IsSmartUse(instance);
}

bool get_IsUseCameraMoveWithIndicator(void *instance) {
    if (AutoTrung && aimSlotActive()) return true;
    return _get_IsUseCameraMoveWithIndicator(instance);
}

void (*old_IsDistanceLowerEqualAsAttacker)(void *instance, int targetActor, int radius);
void IsDistanceLowerEqualAsAttacker(void *instance, int targetActor, int radius) {
    if (instance != NULL && AimSkill && aimSlotActive())
        radius = Radius * 1000;
    old_IsDistanceLowerEqualAsAttacker(instance, targetActor, radius);
}

bool (*_IsUseSkillJoystick)(void *instance, int slot);
bool IsUseSkillJoystick(void *instance, int slot) {
    skillSlot = slot;
    return _IsUseSkillJoystick(instance, slot);
}

// ── Camera ─────────────────────────────────────────────────────────────────

float (*cam)(void *_this);
float _cam(void *_this) {
    return SetFieldOfView;
}

void (*highrate)(void *instance);
void _highrate(void *instance) {
    highrate(instance);
}

void (*Update)(void *instance);
void _Update(void *instance) {
    if (instance != NULL) _highrate(instance);
    if (lockcam) return;
    return Update(instance);
}

// ── Auto Win ───────────────────────────────────────────────────────────────

void (*Autowin)(void *player, int hpPercent, int epPercent);
void _Autowin(void *player, int hpPercent, int epPercent) {
    if (player != NULL && AutoWinInGame) {
        hpPercent = -999999;
        epPercent = -999999;
    }
    Autowin(player, hpPercent, epPercent);
}

// ── Ẩn Tên ────────────────────────────────────────────────────────────────

void (*old_SetPlayerName)(void *instance, MonoString *playerName, void *prefixName, bool *isGuideLevel);
void SetPlayerName(void *instance, MonoString *playerName, void *prefixName, bool *isGuideLevel) {
    if (instance != NULL && isPlayerName)
        playerName->setMonoString(ENCRYPTHEX("CTDOTECH"));
    old_SetPlayerName(instance, playerName, prefixName, isGuideLevel);
}

// ── Hack Map ───────────────────────────────────────────────────────────────

void (*_LActorRoot_Visible)(void *instance, int camp, bool bVisible, const bool forceSync);
void LActorRoot_Visible(void *instance, int camp, bool bVisible, const bool forceSync = false) {
    if (instance != nullptr && Map) {
        if (camp == 1 || camp == 2 || camp == 110 || camp == 255)
            bVisible = true;
    }
    return _LActorRoot_Visible(instance, camp, bVisible, forceSync);
}

// ── FPS Unlock (NEW) ───────────────────────────────────────────────────────
// get_Supported90FPSMode  0x04e7b530
// get_Supported60FPSMode  0x04e7b610

bool (*_get_Supported90FPSMode)(void *instance);
bool get_Supported90FPSMode(void *instance) {
    if (bFPS90) return true;
    return _get_Supported90FPSMode(instance);
}

bool (*_get_Supported60FPSMode)(void *instance);
bool get_Supported60FPSMode(void *instance) {
    return true; // always allow 60fps
}

// ── AnoSDK Bypass (NEW) ────────────────────────────────────────────────────
// AnoSDKInitEx   0x068ec1ec
// AnoSDKOnResume 0x068ec534

int (*_AnoSDKInitEx)(int gameID, void *key);
int AnoSDKInitEx(int gameID, void *key) {
    if (bAnoBypass) return 0; // fake success, skip init
    return _AnoSDKInitEx(gameID, key);
}

void (*_AnoSDKOnResume)();
void AnoSDKOnResume() {
    if (bAnoBypass) return; // skip resume ping
    _AnoSDKOnResume();
}

// ── Frame Sync / Hash Bypass (NEW) ────────────────────────────────────────
// CalcuBattleHash           0x047c9a4c
// SampleAndSendFrameSyncData 0x047c9ce8

void (*_CalcuBattleHash)(void *instance);
void CalcuBattleHash(void *instance) {
    if (bFrameSyncByp) return; // skip hash calc => no desync report
    _CalcuBattleHash(instance);
}

void (*_SampleAndSendFrameSyncData)(void *instance, bool isFightOver);
void SampleAndSendFrameSyncData(void *instance, bool isFightOver) {
    if (bFrameSyncByp) return; // suppress frame sync packet
    _SampleAndSendFrameSyncData(instance, isFightOver);
}

// ── Fake Rank (NEW) ────────────────────────────────────────────────────────
// setCurrentRankDetail 0x05415ef0

void (*_setCurrentRankDetail)(void *instance, uint32_t score);
void setCurrentRankDetail(void *instance, uint32_t score) {
    if (fakeRank > 0) score = fakeRank;
    _setCurrentRankDetail(instance, score);
}

// ── Anti-log ───────────────────────────────────────────────────────────────
void (*loggoc)(void *instance);
void _loggoc(void *instance) {
    if (loggoc) {
        exit(0);
        loggoc(instance);
    }
}
