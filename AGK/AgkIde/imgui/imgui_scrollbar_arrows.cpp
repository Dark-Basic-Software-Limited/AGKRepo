#include "imgui.h"
#include "imgui_internal.h"
#include "imgui_scrollbar_arrows.h"

extern "C" bool GetScrollbarArrowsEnabled();
extern "C" float GetScrollbarArrowStep();

namespace ImGui {

IMGUI_API void ScrollbarAddArrows_Pre(ImRect& bb, ImGuiAxis axis, ImS64* p_scroll_v, ImS64 size_visible_v, ImS64 size_contents_v, ScrollbarArrowState* out_state)
{
    IM_UNUSED(axis);
    IM_ASSERT(out_state);
    out_state->used = false;
    out_state->dec = {};
    out_state->inc = {};

    ImGuiContext& g = *GImGui;
    const ImGuiStyle& style = g.Style;
    if (!GetScrollbarArrowsEnabled())
        return;

    const float arrow_inner_extent = style.ScrollbarSize;
    const float arrow_box_extra = 0.0f;
    const float arrow_total_extent = arrow_inner_extent + arrow_box_extra;
    const ImS64 scroll_max_clamp = ImMax((ImS64)0, size_contents_v - size_visible_v);

    const float track_len = (axis == ImGuiAxis_X) ? bb.GetWidth() : bb.GetHeight();
    if (track_len < arrow_total_extent * 2.0f + 1.0f)
        return;

    ImGuiWindow* window = g.CurrentWindow;
    const ImGuiID dec_id = window->GetID(axis == ImGuiAxis_X ? "#SCROLLX_DEC" : "#SCROLLY_DEC");
    const ImGuiID inc_id = window->GetID(axis == ImGuiAxis_X ? "#SCROLLX_INC" : "#SCROLLY_INC");
    ImRect dec_bb, inc_bb;
    if (axis == ImGuiAxis_X)
    {
        dec_bb = ImRect(bb.Min, ImVec2(bb.Min.x + arrow_total_extent, bb.Max.y));
        inc_bb = ImRect(ImVec2(bb.Max.x - arrow_total_extent, bb.Min.y), bb.Max);
    }
    else
    {
        dec_bb = ImRect(bb.Min, ImVec2(bb.Max.x, bb.Min.y + arrow_total_extent));
        inc_bb = ImRect(ImVec2(bb.Min.x, bb.Max.y - arrow_total_extent), bb.Max);
    }

    auto ArrowButtonLogic = [&](const ImRect& bb_btn, ImGuiID id_btn, ImGuiDir dir, ArrowBtnState& out_state)
    {
        out_state.bb = bb_btn;
        out_state.id = id_btn;
        out_state.dir = dir;
        out_state.hovered = out_state.held = false;
        out_state.pressed = false;
      
        ItemAdd(bb_btn, id_btn, NULL, ImGuiItemFlags_NoNav);
       
        out_state.pressed = ButtonBehavior(bb_btn, id_btn, &out_state.hovered, &out_state.held,
            ImGuiButtonFlags_NoNavFocus | ImGuiButtonFlags_PressedOnClick);
    };

    float scroll_step = g.FontSize * ImClamp(GetScrollbarArrowStep(), 0.1f, 50.0f);
    ArrowButtonLogic(dec_bb, dec_id, axis == ImGuiAxis_X ? ImGuiDir_Left : ImGuiDir_Up, out_state->dec);
    ArrowButtonLogic(inc_bb, inc_id, axis == ImGuiAxis_X ? ImGuiDir_Right : ImGuiDir_Down, out_state->inc);

    if (out_state->dec.pressed)
        *p_scroll_v = ImClamp(*p_scroll_v - (ImS64)scroll_step, (ImS64)0, scroll_max_clamp);
    if (out_state->inc.pressed)
        *p_scroll_v = ImClamp(*p_scroll_v + (ImS64)scroll_step, (ImS64)0, scroll_max_clamp);

  
    if (g.ActiveId == out_state->dec.id || g.ActiveId == out_state->inc.id)
    {
        float t = g.ActiveIdTimer;
        const float hold_start_delay = 0.18f;
        if (t > hold_start_delay && g.IO.MouseDown[0])
        {
            const float accel_duration = 0.55f;
            float accel_t = ImSaturate((t - hold_start_delay) / accel_duration);
            float ease = accel_t * accel_t * (3.0f - 2.0f * accel_t);
            const float base_vel = scroll_step * 10.0f;
            const float max_vel  = scroll_step * 40.0f;
            float velocity = base_vel + (max_vel - base_vel) * ease; // units/second
            float delta = velocity * g.IO.DeltaTime;
            if (g.ActiveId == out_state->dec.id)
                *p_scroll_v = ImClamp(*p_scroll_v - (ImS64)delta, (ImS64)0, scroll_max_clamp);
            else
                *p_scroll_v = ImClamp(*p_scroll_v + (ImS64)delta, (ImS64)0, scroll_max_clamp);
        }
    }

    if (axis == ImGuiAxis_X)
    {
        bb.Min.x += arrow_total_extent;
        bb.Max.x -= arrow_total_extent;
    }
    else
    {
        bb.Min.y += arrow_total_extent;
        bb.Max.y -= arrow_total_extent;
    }

    out_state->used = true;
}

IMGUI_API void ScrollbarAddArrows_Post(const ScrollbarArrowState& state, ImGuiAxis axis)
{
    if (!state.used)
        return;
    ImGuiContext& g = *GImGui;
    ImGuiWindow* window = g.CurrentWindow;
    const ImGuiStyle& style = g.Style;

    auto RenderArrowButton = [&](const ArrowBtnState& s)
    {
        if (s.id == 0)
            return;
        const ImU32 bg_col_btn = GetColorU32((s.held && s.hovered) ? ImGuiCol_ButtonActive : s.hovered ? ImGuiCol_ButtonHovered : ImGuiCol_Button);
        const ImU32 text_col_btn = GetColorU32(ImGuiCol_Text);
        RenderFrame(s.bb.Min, s.bb.Max, bg_col_btn, true, style.FrameRounding);

        const float edge = (axis == ImGuiAxis_X) ? s.bb.GetHeight() : s.bb.GetWidth();
        const float padding = 0.0f;
        const float arrow_edge = ImMax(0.0f, edge - padding * 2.0f);
        const float base = (g.FontSize > 0.0f) ? g.FontSize : arrow_edge;
        float scale = (base > 0.0f) ? (arrow_edge / base) : 1.0f;
        ImVec2 center = s.bb.GetCenter();
        ImVec2 p_min = center - ImVec2(base * 0.5f, base * 0.5f * scale);
        if (p_min.x < s.bb.Min.x + padding || p_min.y < s.bb.Min.y + padding ||
            (p_min.x + base * scale) > s.bb.Max.x - padding || (p_min.y + base * scale) > s.bb.Max.y - padding)
        {
            const float avail_w = s.bb.GetWidth() - padding * 2.0f;
            const float avail_h = s.bb.GetHeight() - padding * 2.0f;
            const float max_edge = ImMax(0.0f, ImMin(avail_w, avail_h));
            if (base > 0.0f && max_edge > 0.0f)
            {
                scale = ImMin(scale, max_edge / base);
                p_min = center - ImVec2(base * 0.5f, base * 0.5f * scale);
            }
        }
        RenderArrow(window->DrawList, p_min, text_col_btn, s.dir, scale);
    };

    RenderArrowButton(state.dec);
    RenderArrowButton(state.inc);
}

} 
