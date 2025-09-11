--- === CenterFocus ===
---
--- Centers the focused window to a configurable middle width (default 2/3) while the mode is ON.
--- When focus switches, the previously focused window is restored to its original frame.
--- Turning the mode OFF restores all affected windows.
---
--- Usage (in your init.lua):
---     hs.loadSpoon("CenterFocus")
---     spoon.CenterFocus.widthFraction = 2/3
---     spoon.CenterFocus:bindHotkeys({ toggle = {{"ctrl","alt"}, "s"} })
---     -- or call spoon.CenterFocus:toggle() from skhd via `hs -c 'spoon.CenterFocus:toggle()'`

local obj = {}
obj.__index = obj

obj.name = "CenterFocus"
obj.version = "1.0.0"
obj.author = "Loren Johnson"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- CONFIG
obj.widthFraction = 2/3    -- middle width as fraction of screen width
obj.showAlerts    = true   -- show little ON/OFF toasts

-- INTERNAL STATE
obj._active = false
obj._saved  = {}           -- [winId] = hs.geometry (original frame before centering)
obj._wf     = nil          -- hs.window.filter instance
obj._log    = hs.logger.new("CenterFocus", "info")

-- helpers
local function win() return hs.window.focusedWindow() end
local function id(w) return w and tostring(w:id()) or nil end

local function centeredFrameForScreen(scr, widthFraction)
  local sf = scr:frame()
  local newW = math.floor(sf.w * widthFraction + 0.5)
  local newX = sf.x + math.floor((sf.w - newW) / 2 + 0.5)
  return { x = newX, y = sf.y, w = newW, h = sf.h }
end

local function saveOriginalIfNeeded(obj, w)
  local wid = id(w); if not wid then return end
  if not obj._saved[wid] then
    obj._saved[wid] = w:frame()
  end
end

local function restoreIfSaved(obj, w)
  local wid = id(w); if not wid then return end
  local saved = obj._saved[wid]
  if saved then
    w:setFrame(saved)
    obj._saved[wid] = nil
  end
end

local function applyCenter(obj, w)
  if not w then return end
  saveOriginalIfNeeded(obj, w)
  w:setFrame(centeredFrameForScreen(w:screen(), obj.widthFraction))
end

-- PUBLIC: start/stop/toggle
function obj:start()
  if self._active then return self end
  self._active = true

  if not self._wf then
    self._wf = hs.window.filter.new(nil) -- default filter (all windows)
    self._wf:subscribe(hs.window.filter.windowUnfocused, function(w)
      if self._active then restoreIfSaved(self, w) end
    end)
    self._wf:subscribe(hs.window.filter.windowFocused, function(w)
      if self._active and w then applyCenter(self, w) end
    end)
    self._wf:subscribe(hs.window.filter.windowDestroyed, function(w)
      if not w then return end
      local wid = id(w)
      if wid then self._saved[wid] = nil end
    end)
  end

  -- center current focused window immediately
  local w = win()
  if w then applyCenter(self, w) end

  if self.showAlerts then hs.alert.show("Center Focus: ON") end
  return self
end

function obj:stop()
  if not self._active then return self end
  self._active = false

  -- restore all saved windows
  for wid, frame in pairs(self._saved) do
    local w = hs.window.get(wid)
    if w and frame then w:setFrame(frame) end
  end
  self._saved = {}

  if self.showAlerts then hs.alert.show("Center Focus: OFF") end
  return self
end

function obj:toggle()
  if self._active then return self:stop() else return self:start() end
end

-- -- OPTIONAL: Hotkey binding interface (standard Spoon pattern)
-- function obj:bindHotkeys(mapping)
--   local def = { toggle = { {"ctrl","alt"}, "s" } }
--   local spec = mapping or def
--   if spec.toggle then
--     if self._hk then self._hk:delete() end
--     self._hk = hs.hotkey.bind(spec.toggle[1], spec.toggle[2], function() self:toggle() end)
--   end
--   return self
-- end

return obj
