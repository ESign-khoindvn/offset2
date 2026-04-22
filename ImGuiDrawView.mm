#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <Foundation/Foundation.h>
#import "Esp/CaptainHook.h"
#import "Esp/ImGuiDrawView.h"
#import "IMGUI/imgui.h"
#import "IMGUI/imgui_impl_metal.h"
#import "IMGUI/zzz.h"
#import "Esp/MonoString.h"
#include "Esp/dbdef.h"
#include "1110/patch.h"
#include "1110/haizzz.h"
#import "il2cpp.h"
#import "linh_tinh/spam.h"
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScale [UIScreen mainScreen].scale

using namespace IL2CPP;

@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@end

@implementation ImGuiDrawView
#include "1110/hook.h"

uint64_t hackmapoffset;

static bool show_s0 = false;


static bool MenDeal = true;


- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];

    if (!self.device) abort();

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;

    ImGui::StyleColorsClassic();
    
    ImFont* font = io.Fonts->AddFontFromMemoryCompressedTTF((void*)zzz_compressed_data, zzz_compressed_size, 60.0f, NULL, io.Fonts->GetGlyphRangesVietnamese());
    
    ImGui_ImplMetal_Init(_device);

    return self;
}

+ (void)showChange:(BOOL)open
{
    MenDeal = open;
}

- (MTKView *)mtkView
{
    return (MTKView *)self.view;
}

- (void)loadView
{

 

    CGFloat w = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width;
    CGFloat h = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Spam *spam = [[Spam alloc] init];
    [spam startSpam];
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;

    void Il2CppAttachOld();
    Il2CppAttachOld();
    Il2CppMethod& getClass(const char* namespaze, const char* className);
    uint64_t getMethod(const char* methodName, int argsCount);
    
    Il2CppMethod methodAccessSystem("Project_d.dll"); // Project_d.dll - 17655
    Il2CppMethod methodAccessSystem2("Project.Plugins_d.dll"); // Project.Plugins_d.dll - 11363
    Il2CppMethod methodAccessRes("AovTdr.dll"); //AovTdr.dll - 6421


    hackmapoffset = methodAccessSystem2.getClass("NucleusDrive.Logic", "LVActorLinker").getMethod("SetVisible", 3);
    // ── Camera hooks ──────────────────────────────────────────────────────
    HOOK(ENCRYPTOFFSET("0x61E0F48"), _cam, cam);                       // GetCameraHeightRateValue
    HOOK(ENCRYPTOFFSET("0x61DFF50"), _Update, Update);                 // Camera Update
    HOOK(ENCRYPTOFFSET("0x61E1370"), _highrate, highrate);             // OnCameraHeightChanged

    // ── Aim hooks ─────────────────────────────────────────────────────────
    HOOK(ENCRYPTOFFSET("0x59EC6F4"), IsSmartUse, _IsSmartUse);                                         // IsSmartUse
    HOOK(ENCRYPTOFFSET("0x57CC0F4"), get_IsUseCameraMoveWithIndicator, _get_IsUseCameraMoveWithIndicator); // CameraMove indicator
    HOOK(ENCRYPTOFFSET("0x64C773C"), IsDistanceLowerEqualAsAttacker, old_IsDistanceLowerEqualAsAttacker);  // Aim radius
    HOOK(ENCRYPTOFFSET("0x5AD7B84"), IsUseSkillJoystick, _IsUseSkillJoystick);                        // Skill slot tracker

    // ── Misc hooks ────────────────────────────────────────────────────────
    HOOK(ENCRYPTOFFSET("0x5A6A764"), SetPlayerName, old_SetPlayerName); // Ẩn Tên
    HOOK(ENCRYPTOFFSET("0x547FB70"), _Autowin, Autowin);                // Auto Win

    // ── Map hack ──────────────────────────────────────────────────────────
    HOOK(hackmapoffset, LActorRoot_Visible, _LActorRoot_Visible);       // SetVisible (Hack Map)

    // ── FPS unlock — tạm disable, verify signature trước
//    HOOK(ENCRYPTOFFSET("0x4e7b530"), get_Supported90FPSMode, _get_Supported90FPSMode);
//    HOOK(ENCRYPTOFFSET("0x4e7b610"), get_Supported60FPSMode, _get_Supported60FPSMode);

    // ── AnoSDK bypass — tạm disable, [extern] cần check MethodInfo* param
//    HOOK(ENCRYPTOFFSET("0x68ec1ec"), AnoSDKInitEx, _AnoSDKInitEx);
//    HOOK(ENCRYPTOFFSET("0x68ec534"), AnoSDKOnResume, _AnoSDKOnResume);

    // ── Frame sync bypass — tạm disable, verify signature
//    HOOK(ENCRYPTOFFSET("0x47c9a4c"), CalcuBattleHash, _CalcuBattleHash);
//    HOOK(ENCRYPTOFFSET("0x47c9ce8"), SampleAndSendFrameSyncData, _SampleAndSendFrameSyncData);

    // ── Rank patch — tạm disable, verify signature
//    HOOK(ENCRYPTOFFSET("0x5415ef0"), setCurrentRankDetail, _setCurrentRankDetail);
}






#pragma mark - Interaction

- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

#pragma mark - MTKViewDelegate

- (void)drawInMTKView:(MTKView*)view
{
   
    
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;

    CGFloat framebufferScale = view.window.screen.scale ?: UIScreen.mainScreen.scale;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ?: 120);
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    

//Define your bool/function in here
    static bool ctdotech_s1 = true;    
    static bool ctdotech_s2 = true;  
    static bool ctdotech_s3 = true;  
    static bool ctdotech_s4 = true;  
    static bool ctdotech_s5 = true;  
//Define active function
    static bool ctdotech_s1_active = false;
    static bool ctdotech_s2_active = false;
    static bool ctdotech_s3_active = false;
    static bool ctdotech_s4_active = false;
    static bool ctdotech_s5_active = false;
    
        
        if (MenDeal == true) {
            [self.view setUserInteractionEnabled:YES];
        } else if (MenDeal == false) {
            [self.view setUserInteractionEnabled:NO];
        }

        MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
        if (renderPassDescriptor != nil)
        {
            id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
            [renderEncoder pushDebugGroup:@"ImGui Jane"];

            ImGui_ImplMetal_NewFrame(renderPassDescriptor);
            ImGui::NewFrame();
            
            ImFont* font = ImGui::GetFont();
            font->Scale = 15.f / font->FontSize;
            
            CGFloat x = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width) - 360) / 2;
            CGFloat y = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height) - 300) / 2;
            
            ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);
            ImGui::SetNextWindowSize(ImVec2(400, 300), ImGuiCond_FirstUseEver);
            
            if (MenDeal == true)
            {
                // ── Window ────────────────────────────────────────────────────────
                ImGui::SetNextWindowSize(ImVec2(540, 330), ImGuiCond_FirstUseEver);
                ImGui::PushStyleColor(ImGuiCol_WindowBg,        ImVec4(0.07f, 0.07f, 0.11f, 0.97f));
                ImGui::PushStyleColor(ImGuiCol_TitleBg,         ImVec4(0.09f, 0.09f, 0.15f, 1.00f));
                ImGui::PushStyleColor(ImGuiCol_TitleBgActive,   ImVec4(0.13f, 0.13f, 0.22f, 1.00f));
                ImGui::PushStyleColor(ImGuiCol_Border,          ImVec4(0.28f, 0.28f, 0.50f, 0.90f));
                ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 8.0f);
                ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 1.5f);
                ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(8, 7));

                ImGui::Begin("  AOV TOOLS  #1110", &MenDeal,
                    ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoScrollWithMouse);

                ImGui::PopStyleVar(3);
                ImGui::PopStyleColor(4);

                static int selectedMenu = 0; // 0=Visual 1=Camera 2=Aim 3=Misc

                // ── LEFT SIDEBAR ──────────────────────────────────────────────────
                ImGui::PushStyleColor(ImGuiCol_ChildBg,    ImVec4(0.04f, 0.04f, 0.08f, 1.00f));
                ImGui::PushStyleColor(ImGuiCol_Header,     ImVec4(0.12f, 0.22f, 0.38f, 1.00f));
                ImGui::PushStyleColor(ImGuiCol_HeaderHovered, ImVec4(0.18f, 0.32f, 0.52f, 1.00f));
                ImGui::BeginChild("##sidebar", ImVec2(118, -40), true);

                ImGui::Spacing();
                ImGui::TextDisabled("  MENU");
                ImGui::Separator();
                ImGui::Spacing();

                const char* menuItems[4] = { "Visual", "Camera", "Aim", "Misc" };
                for (int i = 0; i < 4; i++) {
                    bool sel = (selectedMenu == i);
                    char label[32];
                    snprintf(label, sizeof(label), "%s %s###m%d", sel ? ">" : " ", menuItems[i], i);
                    if (sel) ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.35f, 0.78f, 1.00f, 1.0f));
                    if (ImGui::Selectable(label, sel, 0, ImVec2(0, 24)))
                        selectedMenu = i;
                    if (sel) ImGui::PopStyleColor();
                    ImGui::Spacing();
                }

                ImGui::EndChild();
                ImGui::PopStyleColor(3);
                ImGui::SameLine();

                // ── RIGHT CONTENT PANEL ───────────────────────────────────────────
                ImGui::PushStyleColor(ImGuiCol_ChildBg,         ImVec4(0.05f, 0.05f, 0.09f, 1.00f));
                ImGui::PushStyleColor(ImGuiCol_FrameBg,         ImVec4(0.12f, 0.12f, 0.20f, 1.00f));
                ImGui::PushStyleColor(ImGuiCol_SliderGrab,      ImVec4(0.30f, 0.60f, 1.00f, 1.00f));
                ImGui::PushStyleColor(ImGuiCol_CheckMark,       ImVec4(0.30f, 0.80f, 0.40f, 1.00f));
                ImGui::PushStyleColor(ImGuiCol_Button,          ImVec4(0.12f, 0.20f, 0.35f, 1.00f));
                ImGui::PushStyleColor(ImGuiCol_ButtonHovered,   ImVec4(0.20f, 0.35f, 0.58f, 1.00f));
                ImGui::BeginChild("##content", ImVec2(0, -40), true);

                const char* sectionTitles[4] = { "VISUAL", "CAMERA", "AIM", "MISC" };
                ImGui::TextColored(ImVec4(0.35f, 0.78f, 1.00f, 1.0f), "  %s", sectionTitles[selectedMenu]);
                ImGui::Separator();
                ImGui::Spacing();

                // ---- VISUAL ----
                if (selectedMenu == 0) {
                    ImGui::Columns(2, "vis_cols", false);
                    ImGui::Checkbox("Hack Map",          &Map);
                    ImGui::Checkbox("Hien Lich Su Dau", &ctdotech_s1);
                    ImGui::Checkbox("Hien Bo Tro",      &ctdotech_s2);
                    ImGui::NextColumn();
                    ImGui::Checkbox("Hien Ulti",        &ctdotech_s3);
                    ImGui::Checkbox("An Ten",           &isPlayerName);
                    ImGui::Checkbox("Hien Rank",        &ctdotech_s4);
                    ImGui::Columns(1);
                    ImGui::Spacing(); ImGui::Separator();
                    bool anyOn = Map||ctdotech_s1||ctdotech_s2||ctdotech_s3||isPlayerName||ctdotech_s4;
                    ImGui::TextColored(anyOn ? ImVec4(0.20f,0.90f,0.20f,1.f) : ImVec4(0.85f,0.20f,0.20f,1.f),
                                       "  Trang thai: %s", anyOn?"ON":"OFF");
                }

                // ---- CAMERA ----
                else if (selectedMenu == 1) {
                    ImGui::Checkbox("Khoa Camera", &lockcam);
                    ImGui::Spacing();
                    ImGui::Text("Do Cao Camera");
                    ImGui::SetNextItemWidth(-1);
                    ImGui::SliderFloat("##cam", &SetFieldOfView, 0.10f, 10.0f, "%.2fx");
                    ImGui::Spacing();
                    ImGui::Text("Preset:"); ImGui::SameLine();
                    if (ImGui::Button("Default")) SetFieldOfView = 1.00f;
                    ImGui::SameLine();
                    if (ImGui::Button("Mid"))     SetFieldOfView = 2.50f;
                    ImGui::SameLine();
                    if (ImGui::Button("High"))    SetFieldOfView = 5.00f;
                    ImGui::Spacing(); ImGui::Separator();
                    ImGui::TextColored(lockcam ? ImVec4(0.20f,0.90f,0.20f,1.f) : ImVec4(0.85f,0.20f,0.20f,1.f),
                                       "  Trang thai: %s", lockcam?"ON":"OFF");
                }

                // ---- AIM ----
                else if (selectedMenu == 2) {
                    ImGui::TextWrapped("Aim Elsu: Bat Aim 2.0, chieu 2. Set tam aim 25 la chuan nhat");
                    ImGui::Spacing();
                    ImGui::Columns(2, "aim_cols", false);
                    ImGui::Checkbox("Aim 2.0",    &AimSkill);
                    ImGui::Checkbox("Auto Aim",   &AutoTrung);
                    ImGui::Checkbox("Aim Skill 1",&aimSkill1);
                    ImGui::NextColumn();
                    ImGui::Checkbox("Aim Skill 2",&aimSkill2);
                    ImGui::Checkbox("Aim Skill 3",&aimSkill3);
                    ImGui::Columns(1);
                    ImGui::Spacing();
                    ImGui::Text("Line Aim");
                    ImGui::SetNextItemWidth(-1);
                    ImGui::SliderInt("##aim_r", &Radius, 0, 100, "%dm");
                    ImGui::Spacing(); ImGui::Separator();
                    bool anyAim = AimSkill||AutoTrung||aimSkill1||aimSkill2||aimSkill3;
                    ImGui::TextColored(anyAim ? ImVec4(0.20f,0.90f,0.20f,1.f) : ImVec4(0.85f,0.20f,0.20f,1.f),
                                       "  Trang thai: %s", anyAim?"ON":"OFF");
                }

                // ---- MISC ----
                else if (selectedMenu == 3) {
                    // Auto Win
                    ImGui::Checkbox("Auto Win", &AutoWinInGame);
                    ImGui::Spacing();
                    ImGui::Separator();

                    // FPS Unlock
                    ImGui::TextColored(ImVec4(0.35f,0.78f,1.0f,1.0f), "  FPS");
                    ImGui::Checkbox("Unlock 90 FPS", &bFPS90);
                    ImGui::Spacing();
                    ImGui::Separator();

                    // AnoSDK bypass
                    ImGui::TextColored(ImVec4(0.35f,0.78f,1.0f,1.0f), "  Anti-cheat");
                    ImGui::Checkbox("AnoSDK Bypass", &bAnoBypass);
                    ImGui::Checkbox("Frame Sync Bypass", &bFrameSyncByp);
                    ImGui::Spacing();
                    ImGui::Separator();

                    // Fake Rank
                    ImGui::TextColored(ImVec4(0.35f,0.78f,1.0f,1.0f), "  Rank");
                    ImGui::SetNextItemWidth(-1);
                    ImGui::SliderInt("##rank", (int*)&fakeRank, 0, 30000, fakeRank == 0 ? "Off" : "%d pts");
                    ImGui::Spacing();
                    ImGui::Separator();

                    bool anyMisc = AutoWinInGame || bFPS90 || bAnoBypass || bFrameSyncByp || fakeRank > 0;
                    ImGui::TextColored(anyMisc ? ImVec4(0.20f,0.90f,0.20f,1.f) : ImVec4(0.85f,0.20f,0.20f,1.f),
                                       "  Trang thai: %s", anyMisc?"ON":"OFF");
                }

                ImGui::EndChild();
                ImGui::PopStyleColor(6);

                // ── BOTTOM BAR ────────────────────────────────────────────────────
                ImGui::Spacing();
                ImGui::PushStyleColor(ImGuiCol_Button,        ImVec4(0.14f, 0.14f, 0.24f, 1.0f));
                ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(0.22f, 0.22f, 0.38f, 1.0f));
                if (ImGui::Button("Hide Menu", ImVec2(100, 26))) {
                    MenDeal = false;
                    [ImGuiDrawView showChange:NO];
                }
                ImGui::PopStyleColor(2);

                ImGui::SameLine(ImGui::GetWindowWidth() - 178);

                ImGui::PushStyleColor(ImGuiCol_Button,        ImVec4(0.08f, 0.32f, 0.14f, 1.0f));
                ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(0.12f, 0.52f, 0.22f, 1.0f));
                ImGui::Button("Apply", ImVec2(80, 26));
                ImGui::PopStyleColor(2);

                ImGui::SameLine();
                ImGui::PushStyleColor(ImGuiCol_Button,        ImVec4(0.38f, 0.08f, 0.08f, 1.0f));
                ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(0.62f, 0.12f, 0.12f, 1.0f));
                if (ImGui::Button("Close", ImVec2(80, 26)))
                    MenDeal = false;
                ImGui::PopStyleColor(2);

                ImGui::End();
            }

            ImDrawList* draw_list = ImGui::GetBackgroundDrawList();



//             if(ctdotech_s1){
//                 if(ctdotech_s1_active == NO){
//                     ActiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework",  0x5CE522C , "0x200080D2C0035FD6");  //Hiện lsđ     
//                     //Patch
//                     Hook1110("Frameworks/UnityFramework.framework/UnityFramework",  0x5CE522C , "0x200080D2C0035FD6");
//                     }
//                 ctdotech_s1_active = YES;
//             }
//             else{ 
//                 if(ctdotech_s1_active == YES){
//                     DeactiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework",  0x5CE522C , "0x200080D2C0035FD6");
//                     }
//                 ctdotech_s1_active = NO;
//             }   

// //Hiện Bổ Trợ
//             if(ctdotech_s2){
//                 if(ctdotech_s2_active == NO){
//                     ActiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework",  0x606BF94 , "0x1F2003D5");          
//                     //Patch
//                     Hook1110("Frameworks/UnityFramework.framework/UnityFramework",  0x606BF94 , "0x1F2003D5");         
//                     }
//                 ctdotech_s2_active = YES;
//             }
//             else{ 
//                 if(ctdotech_s2_active == YES){
//                     DeactiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework",  0x606BF94 , "0x1F2003D5");       
//                     }
//                 ctdotech_s2_active = NO;
//             }  

// //Hiện Ulti 2 & 1
//             if(ctdotech_s3){
//                 if(ctdotech_s3_active == NO){
//                     ActiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework",  0x5EB969C , "0x1F2003D5");         
//                     ActiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework",  0x5EB972C , "0x330080D2");           
//                     //Patch
//                     Hook1110("Frameworks/UnityFramework.framework/UnityFramework",  0x5EB969C , "0x1F2003D5");      
//                     Hook1110("Frameworks/UnityFramework.framework/UnityFramework",  0x5EB972C , "0x330080D2");          
//                     }
//                 ctdotech_s3_active = YES;
//             }
//             else{ 
//                 if(ctdotech_s3_active == YES){
//                     DeactiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework",  0x5EB969C , "0x1F2003D5");         
//                     DeactiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework",  0x5EB972C , "0x330080D2");               
//                     }
//                 ctdotech_s3_active = NO;
//             } 

// //Hiện Rank   
//             if(ctdotech_s4){
//                 if(ctdotech_s4_active == NO){
//                     ActiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework",  0x5F95130 , "0x1F2003D5");              
//                     //Patch
//                     Hook1110("Frameworks/UnityFramework.framework/UnityFramework",  0x5F95130 , "0x1F2003D5");           
//                     }
//                 ctdotech_s4_active = YES;
//             }
//             else{ 
//                 if(ctdotech_s4_active == YES){
//                     DeactiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework",  0x5F95130 , "0x1F2003D5");        
//                     }
//                 ctdotech_s4_active = NO;
//             }  

// //Fix fps  
//             if(ctdotech_s5){
//                 if(ctdotech_s5_active == NO){
//                     ActiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework",  0x5EE95A0 , "0xC0035FD6");                 
//                     //Patch
//                     Hook1110("Frameworks/UnityFramework.framework/UnityFramework",  0x5EE95A0 , "0xC0035FD6");       
//                     }
//                 ctdotech_s5_active = YES;
//             }
//             else{ 
//                 if(ctdotech_s5_active == YES){
//                     DeactiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework",  0x5EE95A0 , "0xC0035FD6");        
//                     }
//                 ctdotech_s5_active = NO;
//             } 

            ImGui::Render();
            ImDrawData* draw_data = ImGui::GetDrawData();
            ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);
          
            [renderEncoder popDebugGroup];
            [renderEncoder endEncoding];

            [commandBuffer presentDrawable:view.currentDrawable];
        }

        [commandBuffer commit];
}

- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size
{
    
}

@end

