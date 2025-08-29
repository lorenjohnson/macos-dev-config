-- minimal vim-ish window manager (hjkl + f)

-- deps for skhd -> hs CLI:
require("hs.ipc")
-- optional: auto-install/update the `hs` tool
-- hs.ipc.cliInstall()

hs.window.animationDuration = 0

local state = {
  posIdx   = {},  -- [winId] = 1..3  (1=left, 2=center, 3=right)
  sizeIdx  = {},  -- [winId] = 1..3  (1=1/3, 2=1/2, 3=2/3)
  prevFrame= {},  -- maximize restore
  heightTop= {},  -- top cycle idx
  heightBot= {},  -- bottom cycle idx
}

local sizes   = { 1/3, 1/2, 2/3 }   -- three width options per position
local hSteps  = { 1.0, 0.8, 0.5 }   -- height cycles

local function win() return hs.window.focusedWindow() end
local function id(w)  return w and tostring(w:id()) or nil end

local function applyFrame(w)
  if not w then return end
  local key = id(w)
  local pos = state.posIdx[key]  or 2 -- default center
  local siz = state.sizeIdx[key] or 2 -- default 1/2

  local scr = w:screen():frame()
  local wf  = w:frame()

  local newW = math.floor(scr.w * sizes[siz] + 0.5)
  local newX
  if     pos == 1 then newX = scr.x                            -- left
  elseif pos == 2 then newX = scr.x + math.floor((scr.w - newW)/2 + 0.5) -- center
  else                 newX = scr.x + scr.w - newW             -- right
  end

  w:setFrame({ x = newX, y = wf.y, w = newW, h = wf.h })
end

local function posLeft()
  local w = win(); if not w then return end
  local key = id(w)
  state.posIdx[key] = ((state.posIdx[key] or 2) - 2) % 3 + 1  -- -1 in 1..3
  applyFrame(w)
end

local function posRight()
  local w = win(); if not w then return end
  local key = id(w)
  state.posIdx[key] = ((state.posIdx[key] or 2)    ) % 3 + 1  -- +1 in 1..3
  applyFrame(w)
end

local function sizePrev()
  local w = win(); if not w then return end
  local key = id(w)
  state.sizeIdx[key] = ((state.sizeIdx[key] or 2) - 2) % 3 + 1
  applyFrame(w)
end

local function sizeNext()
  local w = win(); if not w then return end
  local key = id(w)
  state.sizeIdx[key] = ((state.sizeIdx[key] or 2)    ) % 3 + 1
  applyFrame(w)
end

-- height cycles (unchanged)
local function cycleHeightBottom()
  local w = win(); if not w then return end
  local key = id(w)
  state.heightBot[key] = ((state.heightBot[key] or 0) % #hSteps) + 1
  local scr = w:screen():frame()
  local wf  = w:frame()
  local ratio = hSteps[state.heightBot[key]]
  local newH = math.floor(scr.h * ratio + 0.5)
  local newY = scr.y + scr.h - newH
  w:setFrame({ x = wf.x, y = newY, w = wf.w, h = newH })
end

local function cycleHeightTop()
  local w = win(); if not w then return end
  local key = id(w)
  state.heightTop[key] = ((state.heightTop[key] or 0) % #hSteps) + 1
  local scr = w:screen():frame()
  local wf  = w:frame()
  local ratio = hSteps[state.heightTop[key]]
  local newH = math.floor(scr.h * ratio + 0.5)
  local newY = scr.y
  w:setFrame({ x = wf.x, y = newY, w = wf.w, h = newH })
end

local function toggleMax()
  local w = win(); if not w then return end
  local key = id(w)
  if state.prevFrame[key] then
    w:setFrame(state.prevFrame[key]); state.prevFrame[key] = nil
  else
    state.prevFrame[key] = w:frame(); w:maximize()
  end
end

_G.wm = {
  left   = posLeft,      -- ⌥H
  right  = posRight,     -- ⌥L
  sizeP  = sizePrev,     -- ⌥⇧H
  sizeN  = sizeNext,     -- ⌥⇧L
  down   = cycleHeightBottom, -- ⌥J
  up     = cycleHeightTop,    -- ⌥K
  max    = toggleMax,    -- ⌥F
}

-- optional on-load toast
-- hs.alert.show("wm loaded")

-- Using MiroWindowManager:
-- local hyper = {"ctrl", "alt", "cmd"}

-- hs.loadSpoon("MiroWindowsManager")

-- hs.window.animationDuration = 0.3
-- spoon.MiroWindowsManager:bindHotkeys({
--   up = {hyper, "up"},
--   right = {hyper, "right"},
--   down = {hyper, "down"},
--   left = {hyper, "left"},
--   fullscreen = {hyper, "f"},
--   nextscreen = {hyper, "n"}
-- })
