
#pragma once
#include "imgui_internal.h"

namespace ImGui {

struct ArrowBtnState { ImRect bb; ImGuiID id; ImGuiDir dir; bool hovered; bool held; bool pressed; };

struct ScrollbarArrowState
{
    bool used;
    ArrowBtnState dec;
    ArrowBtnState inc;
};

IMGUI_API void ScrollbarAddArrows_Pre(ImRect& bb, ImGuiAxis axis, ImS64* p_scroll_v, ImS64 size_visible_v, ImS64 size_contents_v, ScrollbarArrowState* out_state);

IMGUI_API void ScrollbarAddArrows_Post(const ScrollbarArrowState& state, ImGuiAxis axis);

} 
