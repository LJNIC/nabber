---@class PrefabEditorState : EditorState
local PrefabEditorState = geometer.EditorState:extend "PrefabEditorState"

function PrefabEditorState:__new(display)
   geometer.EditorState.__new(self, display.attachable, display)
end

function PrefabEditorState:update(dt)
   self.editor.active = true
   self.editor:update(dt)
end

return PrefabEditorState
