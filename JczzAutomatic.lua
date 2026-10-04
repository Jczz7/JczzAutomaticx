--[[
    Jczz Automatic
    by: Jeannxx7_

    Para adicionar um script novo, basta incluir uma entrada na tabela "Scripts"
    (secao 1). A interface (cartoes, menu lateral, pesquisa) e gerada sozinha.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local okEnv, genv = pcall(function() return getgenv() end)
if not okEnv then genv = nil end

local IS_PC = UserInputService.KeyboardEnabled and not UserInputService.TouchEnabled
local TOP_H = 50

-- Forward declarations dos modulos
local UI = { items = {}, navButtons = {}, statusText = "Ready" }
local Log, Notify, Info, Status, Filter, Nav, Panel, Modal, Loader, Layout, Drag, Appearance, FPSPage, H =
    {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}

----------------------------------------------------------------------
-- 1. CONFIGURACAO
----------------------------------------------------------------------
local Config = {
    Name = "Jczz Automatic",
    Author = "by: Jeannxx7_",
    Categories = { "Hubs", "Performance", "Utilities", "Scripts" },
    CategoryIcons = { Hubs = "🧩", Performance = "⚡", Utilities = "🛠", Scripts = "📜" },
}

-- Cada Loader e usado exatamente como fornecido; so e executado ao clicar.
-- Obs: o Luminon usa HTTP (sem S). Alguns executores bloqueiam HTTP puro,
-- entao esse loader pode falhar por esse motivo.
local Scripts = {
    {
        Name = "Jual Nasi Rendang", Icon = "👑", Category = "Hubs", RequiresKey = false,
        Loader = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua"))()]],
    },
    {
        Name = "Miranda Hub", Icon = "◈", Category = "Hubs", RequiresKey = false,
        Loader = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/miirandahub/loader/refs/heads/main/afkk"))()]],
    },
    {
        Name = "Lennon Hub", Icon = "◈", Category = "Hubs", RequiresKey = false,
        Loader = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/lennonxscripts/lennonfarmv2/refs/heads/main/stealanegg"))()]],
    },
    {
        Name = "Chilli", Icon = "◈", Category = "Hubs", RequiresKey = false,
        Loader = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()]],
    },
    {
        Name = "Clouth", Icon = "◈", Category = "Hubs", RequiresKey = false,
        Loader = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/ClouthubOnTop/Loader/main/main.lua"))()]],
    },
    {
        Name = "Luminon", Icon = "◈", Category = "Hubs", RequiresKey = false,
        Loader = [[loadstring(game:HttpGet("http://luminon.top/loader.lua"))()]],
    },
    {
        Name = "Fyy", Icon = "◈", Category = "Hubs", RequiresKey = false,
        Loader = [[loadstring(game:HttpGet("https://fyycommunity.com/"))()]],
    },
    {
        Name = "Air Flow", Icon = "🔑", Category = "Hubs", RequiresKey = true,
        Loader = [[loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Airflow-HUB-240409"))()]],
    },
    {
        Name = "Sena Hub", Icon = "◈", Category = "Hubs", RequiresKey = false,
        Loader = [[loadstring(game:HttpGet("https://senahub.xyz/raw/loader"))()]],
    },
    {
        Name = "LKZ Hub", Icon = "◈", Category = "Hubs", RequiresKey = false,
        Loader = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/LucasggkX/LKZ-Hub/refs/heads/main/Loader.lua"))()]],
    },
    {
        Name = "Pulse Hub", Icon = "◈", Category = "Hubs", RequiresKey = false,
        Loader = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/PulseZax/Loader/refs/heads/main/.lua"))()]],
    },
    {
        Name = "Foxname Hub", Icon = "◈", Category = "Hubs", RequiresKey = false,
        Loader = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Fn-stealanegg.lua"))()]],
    },
    {
        Name = "Server Hop", Icon = "🌐", Category = "Utilities", RequiresKey = false,
        Loader = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/RealBatu20/AI-Scripts-2025/main/LowServerFinderGUI.lua", true))()]],
    },
    {
        Name = "Jczz FPS", Icon = "⚡", Category = "Performance", RequiresKey = false,
        Loader = "(painel)", Page = "fps", Desc = "Abrir painel de otimização  ›",
    },
}

----------------------------------------------------------------------
-- 2. TEMA E HELPERS
----------------------------------------------------------------------
local Settings

local Theme = {
    Bg = Color3.fromRGB(22, 18, 15),
    Side = Color3.fromRGB(12, 10, 8),
    Card = Color3.fromRGB(38, 32, 26),
    CardHover = Color3.fromRGB(52, 44, 33),
    CardPress = Color3.fromRGB(70, 57, 38),
    Accent = Color3.fromRGB(226, 176, 72),
    Text = Color3.fromRGB(240, 232, 218),
    Dim = Color3.fromRGB(160, 150, 134),
    Good = Color3.fromRGB(120, 205, 125),
    Warn = Color3.fromRGB(240, 200, 80),
    Bad = Color3.fromRGB(235, 105, 98),
    Key = Color3.fromRGB(240, 190, 80),
    Stroke = Color3.fromRGB(72, 60, 44),
}

local Accent = { targets = {}, hooks = {} }

local function mk(class, props, parent)
    local o = Instance.new(class)
    if o:IsA("GuiObject") then o.BorderSizePixel = 0 end
    if class == "TextLabel" or class == "TextButton" or class == "TextBox" then
        o.Font = Enum.Font.GothamMedium
        o.TextColor3 = Theme.Text
        o.TextSize = 13
        o.TextXAlignment = Enum.TextXAlignment.Left
    end
    if class == "TextLabel" then
        o.BackgroundTransparency = 1
    end
    if class == "TextButton" then
        o.AutoButtonColor = false
    end
    -- Qualquer propriedade criada com a cor de destaque atual e registrada
    -- para trocar junto quando o usuario escolher outra cor (use _static = true para evitar).
    local static = props._static
    for k, v in pairs(props) do
        if k ~= "_static" then
            o[k] = v
            if not static and Accent.reg and typeof(v) == "Color3" then
                if v == Theme.Accent then
                    Accent.reg(o, k)
                elseif v == Theme.Stroke then
                    Accent.reg(o, k, "Stroke")
                end
            end
        end
    end
    o.Parent = parent
    return o
end

local function round(o, r)
    return mk("UICorner", { CornerRadius = UDim.new(0, r) }, o)
end

local function stroke(o, color, thickness, transparency)
    return mk("UIStroke", {
        Color = color, Thickness = thickness or 1, Transparency = transparency or 0.4,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, o)
end

local function tween(o, t, props, style)
    if Settings and Settings.Animations == false then
        for k, v in pairs(props) do pcall(function() o[k] = v end) end
        return
    end
    TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function toHex(c)
    return string.format("#%02x%02x%02x",
        math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end

local function trim(s)
    return (tostring(s):match("^%s*(.-)%s*$"))
end

local function shortErr(e, max)
    max = max or 80
    local s = tostring(e or "erro desconhecido"):gsub("[\r\n]+", " ")
    s = trim(s)
    if #s > max then s = s:sub(1, max - 3) .. "..." end
    return s
end

----------------------------------------------------------------------
-- 2b. CONFIGURACOES E COR DE DESTAQUE (persistem durante a sessao)
----------------------------------------------------------------------
local HttpService = game:GetService("HttpService")

local SettingDefaults = {
    Notifications = true, AccentName = "GOLD", Background = true, Dim = 0.45, PanelSize = "Normal",
    Animations = true, FloatingButton = true, StartOpen = true, ToggleKey = "RightShift",
    SaveToFile = true, AutoFPS = false, FPSCap = 0,
}

-- Salva as configuracoes em arquivo (quando o executor permite) e na memoria da sessao.
local SaveSys = { file = "JczzAutomatic_config.json", pending = false }

function SaveSys.fill(t)
    for k, v in pairs(SettingDefaults) do
        if t[k] == nil or type(t[k]) ~= type(v) then t[k] = v end
    end
    if type(t.FPSFeatures) ~= "table" then t.FPSFeatures = {} end
    if type(t.Favorites) ~= "table" then t.Favorites = {} end
    return t
end

function SaveSys.read()
    if typeof(isfile) ~= "function" or typeof(readfile) ~= "function" then return nil end
    local ok, data = pcall(function()
        if not isfile(SaveSys.file) then return nil end
        return HttpService:JSONDecode(readfile(SaveSys.file))
    end)
    if ok and type(data) == "table" then return data end
    return nil
end

function SaveSys.flush()
    if Settings.SaveToFile == false then return end
    if typeof(writefile) ~= "function" then return end
    pcall(function() writefile(SaveSys.file, HttpService:JSONEncode(Settings)) end)
end

function SaveSys.queue()
    if SaveSys.pending then return end
    SaveSys.pending = true
    task.delay(1.5, function()
        SaveSys.pending = false
        SaveSys.flush()
    end)
end

Settings = {}
if genv and type(genv.JczzAutomaticSettings) == "table" then
    Settings = genv.JczzAutomaticSettings
else
    local saved = SaveSys.read()
    if saved then
        for k, v in pairs(saved) do Settings[k] = v end
    end
    if genv then genv.JczzAutomaticSettings = Settings end
end
SaveSys.fill(Settings)

local AccentColors = {
    { "GOLD", Color3.fromRGB(226, 176, 72) },
    { "BLUE", Color3.fromRGB(74, 144, 255) },
    { "CYAN", Color3.fromRGB(60, 200, 220) },
    { "GREEN", Color3.fromRGB(80, 200, 120) },
    { "LIME", Color3.fromRGB(160, 215, 60) },
    { "ORANGE", Color3.fromRGB(245, 140, 50) },
    { "RED", Color3.fromRGB(235, 85, 85) },
    { "PINK", Color3.fromRGB(240, 100, 170) },
    { "PURPLE", Color3.fromRGB(150, 100, 245) },
    { "WHITE", Color3.fromRGB(235, 235, 235) },
}

function Accent.colorOf(name)
    for _, c in ipairs(AccentColors) do
        if c[1] == name then return c[2] end
    end
    return AccentColors[1][2]
end

function Accent.reg(inst, prop, key)
    table.insert(Accent.targets, { inst, prop, key })
end

-- Cores derivadas da cor de destaque (contornos, hover e selecao).
-- O fundo (Bg, Side, Card e a imagem) nunca muda.
function Accent.derive(color)
    Theme.Stroke = Theme.Card:Lerp(color, 0.22)
    Theme.CardHover = Theme.Card:Lerp(color, 0.09)
    Theme.CardPress = Theme.Card:Lerp(color, 0.18)
end

-- Troca somente a cor de destaque (fundo e cartoes nao mudam).
function Accent.set(name)
    local color = Accent.colorOf(name)
    Settings.AccentName = name
    Theme.Accent = color
    Accent.derive(color)
    local alive = {}
    for _, t in ipairs(Accent.targets) do
        if t[1].Parent then
            t[1][t[2]] = t[3] and Theme[t[3]] or color
            table.insert(alive, t)
        end
    end
    Accent.targets = alive
    for _, fn in ipairs(Accent.hooks) do pcall(fn, color) end
    SaveSys.queue()
end

Theme.Accent = Accent.colorOf(Settings.AccentName)
Accent.derive(Theme.Accent)

----------------------------------------------------------------------
-- 2c. JCZZ FPS (motor de otimizacao)
-- Cada funcao guarda os valores originais e consegue desfazer o que fez.
----------------------------------------------------------------------
local FPS = { state = {}, hooks = {}, cap = 0, features = {}, groups = {}, presets = {}, byId = {} }
do
    local Lighting = game:GetService("Lighting")
    local StarterGui = game:GetService("StarterGui")
    local Workspace = game:GetService("Workspace")
    local SoundService = game:GetService("SoundService")
    local StatsService = game:GetService("Stats")
    local LocalPlayer = Players.LocalPlayer

    local orig, keep, fconns = {}, {}, {}
    local queue, qh, qt = {}, 1, 0
    local watch = { on = false }
    local objList = {}
    local coreOrig = {}
    local gcToken = 0
    local overlay = nil

    local EMIT = { ParticleEmitter = true, Trail = true, Beam = true, Smoke = true, Fire = true, Sparkles = true }
    local LIGHT = { PointLight = true, SpotLight = true, SurfaceLight = true }

    ------------------------------------------------------------------
    -- Leitura/escrita segura de propriedades (inclui propriedades ocultas)
    ------------------------------------------------------------------
    local function getp(inst, prop)
        local ok, v = pcall(function() return inst[prop] end)
        if ok then return true, v end
        if typeof(gethiddenproperty) == "function" then
            local ok2, v2 = pcall(gethiddenproperty, inst, prop)
            if ok2 then return true, v2 end
        end
        return false
    end

    local function setp(inst, prop, value)
        if pcall(function() inst[prop] = value end) then return true end
        if typeof(sethiddenproperty) == "function" then
            return (pcall(sethiddenproperty, inst, prop, value))
        end
        return false
    end

    -- Cria o "gravador" de uma funcao: muda a propriedade e lembra o valor original.
    local function recorder(id)
        return function(inst, prop, value)
            local t = orig[id]
            if not t then
                t = setmetatable({}, { __mode = "k" })
                orig[id] = t
            end
            local entry = t[inst]
            if not entry then
                entry = {}
                t[inst] = entry
            end
            if entry[prop] == nil then
                local ok, cur = getp(inst, prop)
                if not ok then return false end
                if cur == value then return true end
                entry[prop] = cur
            end
            if prop == "Parent" and value == nil then keep[inst] = true end
            return setp(inst, prop, value)
        end
    end

    local function restore(id)
        local t = orig[id]
        orig[id] = nil
        if not t then return end
        local n = 0
        for inst, props in pairs(t) do
            for prop, value in pairs(props) do
                if prop == "Parent" then
                    pcall(function() inst.Parent = value end)
                    keep[inst] = nil
                else
                    setp(inst, prop, value)
                end
            end
            n = n + 1
            if n % 300 == 0 then task.wait() end
        end
    end

    local function addConn(id, c)
        local list = fconns[id]
        if not list then
            list = {}
            fconns[id] = list
        end
        table.insert(list, c)
    end

    local function dropConns(id)
        local list = fconns[id]
        fconns[id] = nil
        if list then
            for _, c in ipairs(list) do pcall(function() c:Disconnect() end) end
        end
    end

    local function guiParent()
        local ok, hui = pcall(function() return gethui and gethui() end)
        if ok and typeof(hui) == "Instance" then return hui end
        local okCore = pcall(function()
            local t = Instance.new("Folder")
            t.Parent = CoreGui
            t:Destroy()
        end)
        if okCore then return CoreGui end
        return Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local function terrain() return Workspace:FindFirstChildOfClass("Terrain") end
    local function renderSettings()
        local ok, r = pcall(function() return settings().Rendering end)
        if ok then return r end
        return nil
    end
    local function physSettings()
        local ok, r = pcall(function() return settings().Physics end)
        if ok then return r end
        return nil
    end
    local function gameSettings()
        local ok, r = pcall(function() return UserSettings():GetService("UserGameSettings") end)
        if ok then return r end
        return nil
    end

    ------------------------------------------------------------------
    -- Grupos e funcoes
    ------------------------------------------------------------------
    FPS.groups = {
        { id = "gfx", title = "GRÁFICOS" },
        { id = "fx", title = "EFEITOS VISUAIS" },
        { id = "world", title = "MUNDO" },
        { id = "players", title = "OUTROS JOGADORES" },
        { id = "sys", title = "SISTEMA" },
    }

    local features = {
        -- GRAFICOS
        {
            id = "quality", group = "gfx", name = "Qualidade mínima", desc = "Nível gráfico 1 do Roblox",
            global = function(on, rec)
                if not on then return end
                local rs, gs = renderSettings(), gameSettings()
                if rs then rec(rs, "QualityLevel", Enum.QualityLevel.Level01) end
                if gs then rec(gs, "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1) end
            end,
        },
        {
            id = "shadows", group = "gfx", name = "Sem sombras", desc = "Desliga todas as sombras",
            global = function(on, rec)
                if not on then return end
                rec(Lighting, "GlobalShadows", false)
                rec(Lighting, "ShadowSoftness", 0)
            end,
            obj = function(v, rec)
                if LIGHT[v.ClassName] then
                    rec(v, "Shadows", false)
                elseif v:IsA("BasePart") and not v:IsA("Terrain") and v.CastShadow then
                    rec(v, "CastShadow", false)
                end
            end,
        },
        {
            id = "materials", group = "gfx", name = "Materiais lisos", desc = "Tudo vira plástico liso, sem reflexo",
            obj = function(v, rec)
                if v:IsA("BasePart") and not v:IsA("Terrain") then
                    rec(v, "Material", Enum.Material.SmoothPlastic)
                    rec(v, "Reflectance", 0)
                end
            end,
        },
        {
            id = "textures", group = "gfx", name = "Sem texturas", desc = "Remove texturas, decals e SurfaceAppearance",
            obj = function(v, rec)
                local c = v.ClassName
                if c == "MeshPart" then
                    rec(v, "TextureID", "")
                elseif c == "SpecialMesh" then
                    rec(v, "TextureId", "")
                elseif c == "Decal" or c == "Texture" then
                    if not (v.Parent and v.Parent.Name == "Head") then rec(v, "Transparency", 1) end
                elseif c == "SurfaceAppearance" then
                    rec(v, "Parent", nil)
                end
            end,
        },
        {
            id = "meshes", group = "gfx", name = "Malhas simples", desc = "Menos detalhe nos modelos 3D",
            global = function(on, rec)
                if not on then return end
                local rs = renderSettings()
                if rs then rec(rs, "MeshPartDetailLevel", Enum.MeshPartDetailLevel.Level04) end
            end,
            obj = function(v, rec)
                if v.ClassName == "MeshPart" then rec(v, "RenderFidelity", Enum.RenderFidelity.Performance) end
            end,
        },
        {
            id = "lighting", group = "gfx", name = "Iluminação simples", desc = "Sem reflexo do ambiente",
            global = function(on, rec)
                if not on then return end
                rec(Lighting, "EnvironmentDiffuseScale", 0)
                rec(Lighting, "EnvironmentSpecularScale", 0)
            end,
        },
        {
            id = "compat", group = "gfx", name = "Modo Compatibilidade", desc = "Iluminação mais leve (pode exigir reentrar)",
            supported = function() return typeof(sethiddenproperty) == "function" end,
            global = function(on, rec)
                if on then rec(Lighting, "Technology", Enum.Technology.Compatibility) end
            end,
        },

        -- EFEITOS
        {
            id = "particles", group = "fx", name = "Sem partículas", desc = "Fogo, fumaça, rastros, brilhos e explosões",
            obj = function(v, rec)
                local c = v.ClassName
                if EMIT[c] then
                    rec(v, "Enabled", false)
                elseif c == "Explosion" then
                    rec(v, "Visible", false)
                end
            end,
        },
        {
            id = "post", group = "fx", name = "Sem pós-efeitos", desc = "Bloom, blur, raios de sol e correção de cor",
            obj = function(v, rec)
                if v:IsA("PostEffect") then rec(v, "Enabled", false) end
            end,
        },
        {
            id = "atmosphere", group = "fx", name = "Céu e atmosfera leves", desc = "Sem névoa, nuvens, estrelas e sol/lua",
            obj = function(v, rec)
                local c = v.ClassName
                if c == "Atmosphere" then
                    rec(v, "Density", 0)
                    rec(v, "Haze", 0)
                    rec(v, "Glare", 0)
                elseif c == "Clouds" then
                    rec(v, "Enabled", false)
                elseif c == "Sky" then
                    rec(v, "StarCount", 0)
                    rec(v, "CelestialBodiesShown", false)
                end
            end,
        },
        {
            id = "lights", group = "fx", name = "Desligar luzes", desc = "PointLight, SpotLight e SurfaceLight",
            obj = function(v, rec)
                if LIGHT[v.ClassName] then rec(v, "Enabled", false) end
            end,
        },

        -- MUNDO
        {
            id = "water", group = "world", name = "Água simples", desc = "Sem ondas e sem reflexo",
            global = function(on, rec)
                if not on then return end
                local t = terrain()
                if t then
                    rec(t, "WaterWaveSize", 0)
                    rec(t, "WaterWaveSpeed", 0)
                    rec(t, "WaterReflectance", 0)
                end
            end,
        },
        {
            id = "grass", group = "world", name = "Sem grama", desc = "Remove a decoração do terreno",
            global = function(on, rec)
                if not on then return end
                local t = terrain()
                if t then rec(t, "Decoration", false) end
            end,
        },
        {
            id = "billboards", group = "world", name = "Sem painéis flutuantes", desc = "Esconde BillboardGui e SurfaceGui do mapa",
            obj = function(v, rec)
                local c = v.ClassName
                if c == "BillboardGui" or c == "SurfaceGui" then rec(v, "Enabled", false) end
            end,
        },
        {
            id = "physics", group = "world", name = "Física leve", desc = "Experimental: alivia a física do ambiente",
            global = function(on, rec)
                if not on then return end
                local ph = physSettings()
                if not ph then return end
                rec(ph, "AllowSleep", true)
                local ok, v = pcall(function() return Enum.EnviromentalPhysicsThrottle.Always end)
                if ok and v then rec(ph, "PhysicsEnvironmentalThrottle", v) end
            end,
        },

        -- OUTROS JOGADORES
        {
            id = "simpleplayers", group = "players", name = "Jogadores simples", desc = "Sem roupas e acessórios dos outros",
            charObj = function(d, rec)
                local c = d.ClassName
                if c == "Accessory" or c == "Shirt" or c == "Pants" or c == "ShirtGraphic" or c == "CharacterMesh" then
                    rec(d, "Parent", nil)
                end
            end,
        },
        {
            id = "noanim", group = "players", name = "Congelar animações", desc = "Para as animações dos outros jogadores",
            charObj = function(d, rec, conn)
                if d.ClassName == "Animator" then
                    pcall(function()
                        for _, tr in ipairs(d:GetPlayingAnimationTracks()) do tr:Stop(0) end
                    end)
                    conn(d.AnimationPlayed:Connect(function(tr) pcall(function() tr:Stop(0) end) end))
                end
            end,
        },
        {
            id = "hideplayers", group = "players", name = "Esconder jogadores", desc = "Deixa os outros jogadores invisíveis",
            charObj = function(d, rec)
                if d:IsA("BasePart") then
                    rec(d, "LocalTransparencyModifier", 1)
                elseif d:IsA("Decal") then
                    rec(d, "Transparency", 1)
                elseif EMIT[d.ClassName] then
                    rec(d, "Enabled", false)
                end
            end,
        },

        -- SISTEMA
        {
            id = "sound", group = "sys", name = "Silenciar o jogo", desc = "Volume zero e sem reverb",
            global = function(on, rec)
                if not on then return end
                local gs = gameSettings()
                if gs then rec(gs, "MasterVolume", 0) end
                rec(SoundService, "AmbientReverb", Enum.ReverbType.NoReverb)
            end,
        },
        {
            id = "coregui", group = "sys", name = "Esconder chat e lista", desc = "Menos interface para o Roblox desenhar",
            global = function(on, rec)
                local types = { Enum.CoreGuiType.Chat, Enum.CoreGuiType.PlayerList }
                if on then
                    for _, ct in ipairs(types) do
                        local cur = true
                        local ok, v = pcall(function() return StarterGui:GetCoreGuiEnabled(ct) end)
                        if ok then cur = v end
                        coreOrig[ct] = cur
                        pcall(function() StarterGui:SetCoreGuiEnabled(ct, false) end)
                    end
                    local okT, cfg = pcall(function() return game:GetService("TextChatService").ChatWindowConfiguration end)
                    if okT and cfg then rec(cfg, "Enabled", false) end
                else
                    for ct, v in pairs(coreOrig) do
                        pcall(function() StarterGui:SetCoreGuiEnabled(ct, v) end)
                    end
                    coreOrig = {}
                end
            end,
        },
        {
            id = "autogc", group = "sys", name = "Limpeza automática", desc = "Libera memória a cada 60 segundos",
            global = function(on)
                gcToken = gcToken + 1
                if not on then return end
                local my = gcToken
                task.spawn(function()
                    while my == gcToken do
                        for _ = 1, 60 do
                            task.wait(1)
                            if my ~= gcToken then return end
                        end
                        pcall(collectgarbage, "collect")
                    end
                end)
            end,
        },
        {
            id = "fpsOverlay", group = "sys", name = "Contador de FPS na tela", desc = "Mostra o FPS no canto da tela",
            global = function(on)
                if overlay then
                    pcall(function() overlay:Destroy() end)
                    overlay = nil
                end
                if not on then return end
                local parent = guiParent()
                local old = parent:FindFirstChild("JczzFPS")
                if old then old:Destroy() end

                local gui = Instance.new("ScreenGui")
                gui.Name = "JczzFPS"
                gui.ResetOnSpawn = false
                gui.DisplayOrder = 998
                local label = Instance.new("TextLabel")
                label.BackgroundColor3 = Color3.fromRGB(12, 10, 8)
                label.BackgroundTransparency = 0.35
                label.BorderSizePixel = 0
                label.Position = UDim2.fromOffset(8, 8)
                label.Size = UDim2.fromOffset(86, 24)
                label.Font = Enum.Font.GothamBold
                label.TextSize = 13
                label.TextColor3 = Color3.fromRGB(120, 205, 125)
                label.Text = "FPS: --"
                label.Parent = gui
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 8)
                corner.Parent = label
                gui.Parent = parent
                overlay = gui

                local frames, last = 0, os.clock()
                addConn("fpsOverlay", RunService.RenderStepped:Connect(function()
                    frames = frames + 1
                    local now = os.clock()
                    if now - last >= 0.5 then
                        local fps = math.floor(frames / (now - last) + 0.5)
                        label.Text = "FPS: " .. fps
                        label.TextColor3 = fps >= 50 and Color3.fromRGB(120, 205, 125)
                            or (fps >= 30 and Color3.fromRGB(240, 200, 80) or Color3.fromRGB(235, 105, 98))
                        frames, last = 0, now
                    end
                end))
            end,
        },
        {
            id = "afk3d", group = "sys", name = "Modo economia extrema", desc = "Desliga o 3D: FPS máximo e menos bateria (AFK)",
            nosave = true, note = "3D desligado. Volte aqui para religar.",
            global = function(on)
                pcall(function() RunService:Set3dRenderingEnabled(not on) end)
            end,
        },
    }

    for _, f in ipairs(features) do
        f.rec = recorder(f.id)
        FPS.byId[f.id] = f
    end
    FPS.features = features

    ------------------------------------------------------------------
    -- Observador de objetos novos (processados aos poucos, sem lag)
    ------------------------------------------------------------------
    local function push(v)
        qt = qt + 1
        queue[qt] = v
    end

    local function drain()
        local n = 0
        while qh <= qt and n < 80 do
            local v = queue[qh]
            queue[qh] = nil
            qh = qh + 1
            n = n + 1
            if v and v.Parent then
                for _, f in ipairs(objList) do
                    if FPS.state[f.id] then pcall(f.obj, v, f.rec) end
                end
            end
        end
        if qh > qt then qh, qt = 1, 0 end
    end

    local function rebuildLists()
        objList = {}
        for _, f in ipairs(features) do
            if FPS.state[f.id] and f.obj then table.insert(objList, f) end
        end
        if #objList > 0 then
            if not watch.on then
                watch.on = true
                watch.c1 = Workspace.DescendantAdded:Connect(push)
                watch.c2 = Lighting.DescendantAdded:Connect(push)
                watch.c3 = RunService.Heartbeat:Connect(drain)
            end
        elseif watch.on then
            watch.on = false
            for _, k in ipairs({ "c1", "c2", "c3" }) do
                if watch[k] then
                    watch[k]:Disconnect()
                    watch[k] = nil
                end
            end
            queue, qh, qt = {}, 1, 0
        end
    end

    local function sweepObjects(list)
        if #list == 0 then return end
        local function run(root)
            local items = root:GetDescendants()
            for i, v in ipairs(items) do
                for _, f in ipairs(list) do
                    if FPS.state[f.id] then pcall(f.obj, v, f.rec) end
                end
                if i % 300 == 0 then task.wait() end
            end
        end
        run(Lighting)
        run(Workspace)
    end

    local function hookChars(f)
        local function connFor() return function(c) addConn(f.id, c) end end
        local function onChar(char)
            if not FPS.state[f.id] then return end
            for _, d in ipairs(char:GetDescendants()) do
                pcall(f.charObj, d, f.rec, connFor())
            end
            addConn(f.id, char.DescendantAdded:Connect(function(d)
                pcall(f.charObj, d, f.rec, connFor())
            end))
        end
        local function hook(plr)
            if plr == LocalPlayer then return end
            if plr.Character then task.spawn(onChar, plr.Character) end
            addConn(f.id, plr.CharacterAdded:Connect(function(char) task.spawn(onChar, char) end))
        end
        for _, plr in ipairs(Players:GetPlayers()) do hook(plr) end
        addConn(f.id, Players.PlayerAdded:Connect(hook))
    end

    ------------------------------------------------------------------
    -- Ligar / desligar
    ------------------------------------------------------------------
    local function enable(f)
        FPS.state[f.id] = true
        if f.global then pcall(f.global, true, f.rec) end
        if f.charObj then hookChars(f) end
    end

    local function disable(f)
        FPS.state[f.id] = false
        dropConns(f.id)
        if f.global then pcall(f.global, false, f.rec) end
        restore(f.id)
    end

    function FPS.isOn(id) return FPS.state[id] == true end

    function FPS.isSupported(id)
        local f = FPS.byId[id]
        if not f then return false end
        if f.supported then
            local ok, r = pcall(f.supported)
            return ok and r == true
        end
        return true
    end

    function FPS.count()
        local n = 0
        for _, f in ipairs(features) do
            if FPS.state[f.id] then n = n + 1 end
        end
        return n, #features
    end

    function FPS.changed()
        local saved = {}
        for _, f in ipairs(features) do
            if FPS.state[f.id] and not f.nosave then saved[f.id] = true end
        end
        Settings.FPSFeatures = saved
        Settings.FPSCap = FPS.cap
        SaveSys.queue()
        for _, fn in ipairs(FPS.hooks) do pcall(fn) end
    end

    -- changes = { id = true/false, ... }
    function FPS.set(changes)
        task.spawn(function()
            local ons, offs = {}, {}
            for id, want in pairs(changes) do
                local f = FPS.byId[id]
                if f and (FPS.state[id] == true) ~= (want == true) then
                    if want then
                        if FPS.isSupported(id) then table.insert(ons, f) end
                    else
                        table.insert(offs, f)
                    end
                end
            end
            for _, f in ipairs(ons) do enable(f) end
            for _, f in ipairs(offs) do FPS.state[f.id] = false end
            rebuildLists()
            FPS.changed()

            local sweepList = {}
            for _, f in ipairs(ons) do
                if f.obj then table.insert(sweepList, f) end
            end
            for _, f in ipairs(offs) do disable(f) end
            sweepObjects(sweepList)
            FPS.changed()
        end)
    end

    ------------------------------------------------------------------
    -- Predefinicoes
    ------------------------------------------------------------------
    local function merge(a, b)
        local out = {}
        for _, v in ipairs(a) do table.insert(out, v) end
        for _, v in ipairs(b) do table.insert(out, v) end
        return out
    end
    local L = { "shadows", "post", "particles", "water", "atmosphere" }
    local M = merge(L, { "grass", "lighting", "meshes", "materials" })
    local U = merge(M, { "quality", "compat", "textures", "lights", "fpsOverlay" })
    local P = merge(U, { "simpleplayers", "noanim", "sound", "coregui", "autogc", "billboards", "physics" })

    FPS.presets = {
        { id = "light", name = "Leve", icon = "🍃", ids = L },
        { id = "medium", name = "Médio", icon = "⚖️", ids = M },
        { id = "ultra", name = "Ultra", icon = "🔥", ids = U },
        { id = "potato", name = "Batata", icon = "🥔", ids = P },
    }

    -- Funcoes que as predefinicoes nunca desligam sozinhas
    local KEEP = { fpsOverlay = true, afk3d = true, hideplayers = true }

    function FPS.applyPreset(pid)
        local preset
        for _, p in ipairs(FPS.presets) do
            if p.id == pid then preset = p end
        end
        if not preset then return end
        local want, changes = {}, {}
        for _, id in ipairs(preset.ids) do want[id] = true end
        for _, f in ipairs(features) do
            if want[f.id] then
                changes[f.id] = true
            elseif not KEEP[f.id] then
                changes[f.id] = false
            end
        end
        FPS.set(changes)
    end

    function FPS.disableAll()
        local changes = {}
        for _, f in ipairs(features) do changes[f.id] = false end
        FPS.set(changes)
    end

    ------------------------------------------------------------------
    -- Limite de FPS, memoria e ping
    ------------------------------------------------------------------
    FPS.caps = {
        { label = "30", value = 30 }, { label = "60", value = 60 }, { label = "90", value = 90 },
        { label = "120", value = 120 }, { label = "Livre", value = 0 },
    }

    function FPS.capSupported() return typeof(setfpscap) == "function" end

    function FPS.setCap(v)
        FPS.cap = v
        if FPS.capSupported() then
            pcall(setfpscap, v == 0 and 1000 or v)
        end
        FPS.changed()
    end

    function FPS.memory()
        local ok, mb = pcall(function() return StatsService:GetTotalMemoryUsageMb() end)
        if ok and type(mb) == "number" then return mb end
        return nil
    end

    function FPS.ping()
        local ok, v = pcall(function() return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue() end)
        if ok and type(v) == "number" then return math.floor(v + 0.5) end
        return nil
    end

    function FPS.clean()
        local before = FPS.memory()
        pcall(collectgarbage, "collect")
        task.wait(0.4)
        return before, FPS.memory()
    end

    ------------------------------------------------------------------
    -- Inicio / fim
    ------------------------------------------------------------------
    function FPS.autoApply()
        local changes = {}
        for id in pairs(Settings.FPSFeatures or {}) do
            local f = FPS.byId[id]
            if f and not f.nosave then changes[id] = true end
        end
        if next(changes) then FPS.set(changes) end
        if (Settings.FPSCap or 0) ~= 0 then
            FPS.cap = Settings.FPSCap
            if FPS.capSupported() then pcall(setfpscap, FPS.cap) end
        end
    end

    function FPS.shutdown()
        for _, f in ipairs(features) do
            if FPS.state[f.id] then disable(f) end
        end
        rebuildLists()
    end

    FPS.oldShutdown = genv and genv.JczzFPSShutdown or nil
    if genv then genv.JczzFPSShutdown = FPS.shutdown end
end

----------------------------------------------------------------------
-- 3. FUNDO (imagem embutida, gravada uma unica vez no workspace do executor)
----------------------------------------------------------------------
local BG_FILE = "JczzAutomatic_bg_v1.jpg"
local BG_B64 = table.concat({
    "/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAwICQsJCAwLCgsODQwOEh4UEhEREiUbHBYeLCcuLisnKyoxN0Y7MTRCNCorPVM+QkhKTk9OLztWXF",
    "VMW0ZNTkv/2wBDAQ0ODhIQEiQUFCRLMisyS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0v/wAARCAFz",
    "AeADASIAAhEBAxEB/8QAGwAAAQUBAQAAAAAAAAAAAAAAAAECAwQFBgf/xABEEAACAgEDAgQDBgUCBQMACwABAgADEQQSIQUxE0FRYQYicRQyQo",
    "GRsSNSocHRM+EVJGJy8DRD8QclNVNjc3SCorLC/8QAFQEBAQAAAAAAAAAAAAAAAAAAAAH/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIR",
    "AxEAPwDl+pVvfomavIYeXqM8y1uBRVZgDjv7xEZGqwDx7GRAkVkbt5HB9zAQ8cHkg+UWxgV8TOF7GLWcrk8cYkVuPBVBnIP9YFLWWstGxVPiLa",
    "CgHOT/APE0K70uoDqM5HOfIjylVVF+rr3f+382PfHEs1VKdRhVRC5LO2TycQEf56rR2O3GBE0+91rtYfxAM8+ZkKFqVZXwtjNgqT2OY7QWudIN",
    "zZZWOceXMCyNJS9FtzAC82ZYDzU55/L+8qX6IKud4+kk1BYV2MjYOwHP5iUrL7Hwr4+uIDbFVOBIdrd/KSBWPkSDLp0NopDKu5WGYGWVxExL1u",
    "kYAHBB8wZXC4OGHECHEMGTFVOcHt6x9SJghvMQKwj0QswEc1LLzjj1irwPeBJXpbC+3gEjg5kbq1ZKuMRwZwOCR7yO3cTljkwHKyYO4H8pMzC2",
    "tVVMFTjJPlKks6QAWAsMjzEBx01gGNh79xFYNps4zyJrmyuoIvbfwDiZ2vS+y3aEOM4ECqNQdhQ+chUbmxLraDw6GsuBXBxjzzKbEAcDBgPu0/",
    "hkAMGz6SLG0kQ3E+cMk94E41dnhGskbSMAY7SA8wxJ9PpjqG2ofnxwPWBABmOZNpwe8vJohSpsvVvkOMDzMhuQ3MWrqwPMDkwKmOYoHM1quloq",
    "CzUv4SnsD3lazSndisbh5H1gVF2q2Su4ektHU4qCIqqB2I5Ik2n6Y9m1xgoe/PMtf8Oo8ZecKO49YGaupIBFpdlPkDiWTqNKunxWCH9+eJBra1",
    "S4oq8Ke4HeVCDnGDAluKnlSPoJASDEMIBmODEDjiNhAMnMUOQMCNhAIRYCAAkDGeIsIoEBuIYkghiAiVlopQjvLOmo8RGPOR5esc2mttOKlyqj",
    "kjygVNhxmNIlgq1XDDuPOFdRsbAx+cCIVkrmWKNC9q7hwAZfqTS4CGwEpycL3iXaxK2C6QAZ7kjzgJp6jVuspbLDjexwBEt1rLYN/wDEx354kF",
    "32jnxX+U8geUiqq3ZJIgLbarEsq4YnOZGlZbuefLjvLVXT7LckY47DPJmh0/pj1kXXLgg/KDAdeRfW1tVYS4jNiLwG9SB6+3nMzRa5LtTZsU7S",
    "AcnjJH+00mrArJHl5yq2h0t1ZCg0agElLUPG7/qHp7wHMxAyDgekHUlWyMHIIlUXW6fWDSa5FrdR9/dlWHcEfWWdZqEqoe3eAMfL7nygQZdLi5",
    "TaCdnHc485aqGLgSO/GZUocvVS1xBY/MT2wTJ0GLWbdlcnHt9fWAtwS1BW2Tg7lPmp9ZFTX4dlqHGQ5zjsc4Mfq93jL4RxgBhIdXe9KPeibmVg",
    "G9x6frAl1DgJcg7+GT+WRMsWN6yd9ZlmVB87oyWK4+5K+2BKNS4XAA+sG1VrAA2NgeWZFg5gF55MBxtY/eYmKjK5wTj3jGAx3zI8QL/gUAgm8Z",
    "x2AjbdlZGF5+vBlPJgCYGil9WwKVz7Zj1Wm1CQjIR6jiUFdR5cyYap1r2g/nAuWUU+HuPmPWULQg+4cx5tLJhjxGrtLnA4gRKhJ9pcRUTbxz9I",
    "0IqjP9YjuQow0C/VdtxvI2iTnV1sQoAscchfUzFZnY4zCq80Whk7D1gaOv1a3IB8wYH5qyeJUOnWzTPZgIykfKfP6SHUak3Wl8AE+kgZie5gG3",
    "BhJKimDv7YkZ7wFAzLWn1Q0xV0rBsHmSeJV3Yis24dh9YGjp+qMS66lmauzvjykVmr26lXqyqIchcymoBYAnA9ZPcKanIrbxV8iRiBrHU6XUUn",
    "Uaysm0dgCQG9BIdP1hV1GWoQVYKhVAz7cyi9mqNFYbd4X4fSVW4MDb0/UUO4VVIjnkkthcRjOOoOFQrVwBy3eYuT6ySuzYpBGciBa1ATT2Bd++",
    "xD83p+Ua+qDnLICcfe85UzmKPeAMuTnGAY0rJDYfLtEzmBFiGI494YgJiAEXEeqZ9vrARULMB6xXrKnEt07FTOzcwlmzTpZQrt/CwecmBmeGQM",
    "+UaBLuqoStRtbjyOe8rKFz8xwIDMcx6ZHlJMfKAB595c6bordVeqqwX3MC1o7dDXpn8dAGUYHqxMm6bqGvS2rT1JUgU8k9jHH4a1D6lPEIK5G5",
    "geMS59l0PSWdx/qAE4LckemIGENFYd9jqzhc+XeVq8lWAGD+06fTaqrqLNQlTlD94jsPrJU0OhoFgI3ZxxAwOndM+0oxN2COwHlJrNAui52Gxz",
    "6jiagt2fJTUACfIRLarVO9ySW8jAxU0j6m4BgRnz8hLdXThpD4tw+RQSeJfJ2ICCEGeWJxiZHU9ZXZ8tVxfIwc5gTjq9deoyFAQdvlmXfrr73c",
    "tc2G8s8SsQztjkmBrYHGDmBt7vHrNana37yIKyuqP3iUEpqAG7mO1BdtSSckADiAa7SJrKKXNhUoChGMhsHgH+sxutaX7M2ahYNMw3IpO4IfMZ",
    "m4CLNqAYXd/WTg7aCo2srDa6su4MPcQMqp0xSnBDL5/SIiFHfJOGcsP8Sv1InT36Y1VKlAb5SD2z3Es4K4ycnOYFi9sXKa042DcfUSta4ap7lG",
    "ccgeRIMtbG7lsrjAmXrrvseSvLWKQQe31+sC/qKE1tDasfLq2G6xcYDrjuPcecoBPzmjotW6mq9FDMuD8wyDx2Mp3AJfYqfKoYgD0GYEeD6YkT",
    "Dk5lpTnvI7KvMCBAEyPeMI5k33Tz2jX247cwIoR0MQG4jhDbiOCZ8xAfWNw57R7UncAp4MahCEhjHeOF7ZPp7QBt9PDDIkABY4HnJfHJPPP1iF",
    "gpysBrK1RBPeNzmOZixyY+pFdSPOBDjMNsmahl5xxGg8HygRYhJ6KvFIGO5ktujaiwAjOe2YFMRcTTq6QWUP4i7Qfm57D1keu0o0zhABjGQ3rA",
    "ogGAgYd4Ejam0gLvO0fh8pETmKRCA2EdEAgJiOzkQEXEBuIsdiGIDcRcRcRwEBmJLUik/OwH1hsioCDgDmBuaQ6NarEq+/gNvYZGfYSumj3jxb",
    "G8RXYgKowfrE0+j1R0jX11k844zmXOlUa7Tuu8bKx3LeX0gVLOjXcgIwKjO3vgesTSdD1GocfIQnfcwwDN19aQxUE88GRX662ur5W4XkAnECR+",
    "g6VFV7rNq+SgYk9LrTU7VUBK1/kHJEzNdr7RXVbkkH+aQaH4gu07MLSbK+cLxAm6j1/UeLnTPilTjAGM/WZnVOoDXWLaE2vjDEecj1uqGpudkr",
    "FaE52gSOitGVmtfaB2HmYGh0bXto9+4LsI545mz07dqUOov2JUfugn95z2n1dejJJQXbvwntJ9b1MaugBa1pJOTtP3oF/V9Qop1Srp7y6jg4HA",
    "Mks67pxayCsso/F6mc0UbG/yzBXKgheCe8DpOofZrKBdbqFNeMrWoGczBtt03joKKSoPBycmQNYWwCc4lrSVV25RSFtP3SYEmqarTA1UoQRyHJ",
    "5mczFmJzz6ye+vY5FjgnzxIePSBpDDOM9xzJMg3fWQjO/ePzkyc4ccwHgbKGY9x6SHT6hLdKfBsDHJyc8jn0k2/wCQq3BJ4nPdV0b6ZxqqCVVz",
    "zj8JgbVtddtQWxVYKexlS6lq2zp1GxvvIW5B9pnafrN9S7bAtq+eeD+stV9Tps/EVOBw31gTW60VNV4gxWwwT/KfeJqKqtbaqZ3LWCcqfXtzIt",
    "dWtumuYMOfn79zMzR6ttK+Ryh7rA6NMLTtIAwOPeU9TU9d9gfvuJz6xterpasuj55+6e80rVFtSghS5AOCeYGWLAI1rfSTW6O1NxKHaPOR16c2",
    "ZweRAhZi3eJ83aTmhgcEYgaWxwuYEBRgMkcRMkSXDLkE/rAVMwJ29oDA3qIh78Zi7YE4gMbPmIkk4buY0p6QEEUKW7QHynOMx62lWDKAIAtbKR",
    "uU4Mur09zXuQjntkyJtULa9pTB9o+q53ZUUfpAZf4iBVZSpHr5ySjR+JSbGJ2D723kiaqULbhNSg3YwCT3lqjQ17WrS7A7EAwMazQJpqxaLsjG",
    "ceftFGors27l3H/qi9W0r6W3jfsxjLecywxBzmBoNcNMtifI/ijBx5StbrGtXDnOPOQM+fKMgOG0nniJiJCApiQi4gJCAEXEAEXEAOZOyjwwB3",
    "gQiSVopYbjtB85afp1yBXdQq4BBz3kg0tb1+IH4HBXEBraaliK6rdzAZxjvJ9N05rrAgRwPM7ZDo023l1paxV5xOl0upt1fzsoq0wGCPX1gcxf",
    "prksbNZA7A47zV6HoKwwu1JULnAB7k/2mp/xjQKwprXcla/eYcTOv14ssGq2oADjYB5QNBrvBU0079ufvE5Mjs1C6arxNS2Rj5VzyZRot1Gr1K",
    "27kSkN2LYE1+r19O+zVDUvwnLLWckwMzp+u02o1TLagrByVOfKJruq6J1UpTvZDwG4/WQDSaDWWk6S56gD91xjj6ylrNNVpuFsD5J5HaA7W6/7",
    "YwxUFP8AMTn9PSUXGDxGtqqE4Ni/rmRnWac/+4P0MCQsT3iRq30N2tX9pd0eibWNtrZe2cluIFUo23dg4j6VLuoC55l6+iqjCPaGKjGFORmS9P",
    "11WmJRqKnU92YcwI7qTeQXNdVaj5RkAmUtRt3YXGB6STXak6q/xSFBIxhRjErGAkelzVj5eIyEAJz3iQxFAgaAyEIGckTN1dnUdKm5bPEpPO4I",
    "OPrNKwjavPMsUAGnb/KPOBzQ61rB3dD9UEVus6h0KOlTKRggr5S9rOkJeosoxXYwyV/CT/aYdlbVOUcYZeCIDYQhAUOy9mIiE5OYQgKGIOQeZp",
    "6LqYHGoJJ4w3tjEy4QOqp6rWy7Q6MMdsyG63cdygD/ALZzcel1ifddh+cDoKreMEZPvJN2OWGJiVdQsQgsA2PylyrqVVnFg2n3gXmZLBgnGYw0",
    "lCGrJx54iDYRuX5h9cx4tAXBBH0gKK1vY7CAQOzecp3UOrnsw9RzHuQrgoSIhsO0jPJ7wK/Ihkxx+kae0BpJMMxIQHpZsPYGSreFwyfK3rK8IF",
    "s6y1juaxiw7GWD1S01oBhXX8Y7mZ0cIFi3UPfza+ccASue/EDAQExACOhiAmIu2KBHYgNC+sdhT7Rdp9OIBcwG49Iu2S+FtAJ4iYgNAHnJVuIA",
    "HBAORxGYzwBHisj72R+UCS/VW6ph4rbiBiXen6zT6ao1tSX38Pub9pnmlk2kjG7tLlWhJKsrK2V3H/p+sDb0eo/gO6adKE75z3jqupUbfBd/vZ",
    "+ZcfLMIEtcK2c4J5BPBl1OkWMj2MV8EDJsDDECq+nptuPgudueWaXqOhX2bQrK1TYywI7TO8WvPhoNwzx5SS0arIfayqBgbe0C7qNHTRhKPELV",
    "tnf+E+4mZ1Vjphv1VylmGcAgkynr+rvSvg1tuce/CzDssaxyzsWY+ZgXbOqWA4oGz385TststObHZvqZHFgEIRICx9d1lRzW7L9DiRwgX6uouO",
    "LRu9x3l+uxbV3IciYUkoual9yHHqPWBt4hiM01yaivcvcdx6SbY3pAj25PAzFNTKcEYMv6ChG3vfYa1UccdzLBr0VSFzduyMgEckwMgVnjjvJF",
    "px944HvEe0mzcOPQekjYlu5zAfqNVTTw9gB9ByZVs65tXFFeT/M/+JLrOl6d0D1Dwz57e36Snb0bUKm6oraPQcGBVu1uou4e1seg4Egj7abKW2",
    "2oUPfBEZAIQhAIQhAIQhAIQhAIQgID6rrKTlGIl6nqIOBcMe4mdCB0SVi2sPX8ynzEa1DgjKnB7TI0Ort0toKOVQn5hngidVZQ/hKK7NwPI94G",
    "fbpQApAIJHbEr3adqiM9iM5mzVpL/HBuUsvqD2j9QlN7+Fv+YHGMecDndkNk0tbojQ+DYuT2AErGoopLHnyECv4Zx2ibJISQcZOI0wG7YYMdHg",
    "Lj1MCMDMcAIn5QgOwIRBkxQIDtpx6yxRTWci1irEcDbIVZlIIPIkhtd3DudzepgatHSQtRGo1CVK4BTJ/ceUg1PRr6xZZUFsqU4yjbpRttew5Z",
    "iT7mSVau6uvw0dlQ9wDjMCz06lftCpqEY5IAHl+cl1Wjopvfe7uAcHw0wAfSVH6hqWXabTtGOPpG26267O5vvd8ecBrVtv8AkVv0iMHZ8OcEd9",
    "0VbHBDAkH1EUo1hLEkkwNPo+poS0fa7ENQ427ckybqPV67dIdPptKqUcckfNMqqqtmVWZlGfmIGcCbd1mk0OhWldr28Mtm0HP1HlAwRS7N8w2k",
    "d8+Uksvc1LT4rGtewzxDU6mzU2Gx8ZJzwMSLaSIFihKgm5iC3pKfWOt2BW02nfaD97b2H+8g6hqTpq9in+I/9B6zGJycnvAD3iQhAIQhAIQhAI",
    "QhAIQhAm0uoOmuWwDcB3HqJ0lVy3KttZwG5AHlOVmj0jUmu3wWPyP29jA17bC3AGAJAxJlk1Mc4UnELNM6AFhjIzAq4jghlhNM7AfKcHzxJF05",
    "bgYgRs6CglyFA8zMrVdYYfJpeABjef7TP1Oqt1LDxG4HZR2EhzAc7M7FnYsT3JMSJFgEIQgEIQgEIkWAQhCAQiRYBCPqrNr7V9CfyAiV1tbYqK",
    "MsxwIDQZ1nT9c7aPT5bsgHb04nJ42sR6Toemuo0VSsMjB/eBrp1EqxW0gjyla7UI9m9K9rg88xiilu7ED0xA1187LQB6MICahVtHiGw7vQiVgu",
    "4EjL4ljwWbhRu+hkaIa2zt+ogRilrM7U5kbUP/If0ls6t0BCqBn2kPjWK24MQfaBGumsfO1Scd423TvU2GUj6iWBrbwMLYwMlbXvaqi1Ecr+Ij",
    "mBQCHHaG2X31G9ga0C+oAkdhOcMgX2xAqYi4luqkWntiMtrQHC5gQBTFCmPAj0XJx2gQhT5x22Wl0rsCVGQBk4i1aSy08DA/mPaBXWstJQlYHb",
    "JlhqqVGN2W9pXZBmBNWul2jcWD+kkFiUcIFY+srpUpIJBx7TS0el072DfuHvAoMWxnb35zGgNbb83BY9zxOns6Ro6dOqPqVVieGMd9k0GpFVdC",
    "eM9fJZeA31gZFfQ3trD02Lau7adsXqWiGhVw7KEpTc57/1m/T49FLJVpzSEH4n4E47431+oW1NA2pS0FRZZ4fYnyB/eBzGpvbUXNa/dj29JFCE",
    "AhCEAhCEAhCEAhCEAhCEAijg5iQgd/8ADWp0+p6cNRY58VPksBPn6/nH3nTmzcrKQfXmcX0nVnTakKTiuzhv7GdCGKnI7iBbuvcHYWyPpIGLuw",
    "CDn0EhssaxizdzBXdc7WIz3xAhwh7quM45EzOrayklqdPXX3+Zwo/QRNf1AlGoq8/vMP2Ey4BFiRYBCJFgEJo9G6S/U7WJcVaerm20+Q9B7zoE",
    "6V0UYrei4KeBc7Y/vx+kDjR3iy/1zpy9M6g1CWF02hlJ7gHyMomAkBCL5QEHnCKBxBVLMFUZJOAIGhoaCvTtXqT5oUX+8k+HdMLtY1rfdpXd+f",
    "lNfU0V6L4Z1WnuXZqQE2Z7OpYZIP1zmP0WnHTPhGzVso8W1g4z6HgD9OYHIHlj9Zv9PX/lKvpMOimy59lSNY3ooyZvUW1Jp9v2fXBq1AOEUgH9",
    "IE+0RNo9ZBRraLEzZfXUw/C6sD/QGWSOEIKsrjKOjZDev/xAdS4rJyWwfSNe5kbNTNj0MQiNIgG7xDyoz7RWqazPliInytJRYfMcQKvhnPaOFZ",
    "B7SYuMZAhvJPaBJVpixAA258zJvsfiHBtT9ZX2bl4bn0jCGUYzA1tL064vt4dCMg+Ugt0N1mo8Jqx4h5G0YlbSa3UaVSKbCmfSWP8AjGt5/i7s",
    "jHIgMs0VumcC2sYb1Ee2nrUKy1eJuyBjy/KMo6lqqt2LWy3fPP7zS03xGadxbR0Ox7cY59TAZp7LKARToWZ2XOTmT6bUB9OqanwNpbJIOMflGa",
    "r4iOsqWq7S1hV7BCV5mTqLFFqmk4C9jjtA2b+lDa9/ghKcbgxbv9Jik0KGGWLD1Ekr6traskahySMcnOJTste1mZzlmOTAs061KlIFe4+We0ua",
    "TrzadsjTVDnuBzMcAwGRA1Op6wap2fwthY5z2P6Sx0nW0aUgbCzEEks2AsxVLE85McAxPAJPtA09T1Gpr7Gey19OoLYLHmcTqbjqL7LSMF2Jx6",
    "e02uq76dG2QV3ELMCAQhCAQj6qbL221IWjWUoxU9wcGAkI6td7qmcbjjMRgVYg9wcQEhCEAhCEAHJxJbdNfSoa2mxFPYshAM6T4V0dOl0lvVdQ",
    "m8pxWp9c4H55m3Tq9Rqyy2omqpfh02gY+n+8DzuE1fiDpP8Aw3UBqSW0t3NbHy9VPuJlQCb3SdeNQRRcQLfwk/i/3mDFBIII4I7GB2Jq8gMmPq",
    "0rWKxGePbvF+F+qabWVNRqdq6lBnJ7OPX6zZbVUUqRUAT6wPN9PodRfzXUSPU8CN1Wn+yv4bWKz/iC/hmxr+ofZa9lePFI49h6zBJLEknJPJJg",
    "AiZhCAsByYkudIrW3qmkrf7rWrnP1gdfotDZpOl10JXllw9g9bD/AI4k7U6XTVlNSXtvcZZE5x/57zQ11/2XTsyYDudqfU+f95hjFakk+7Mx5P",
    "uYHM9YsazqDhs/wwKxu74A4zKRk+tcW6y5xyGc4kMBvnHRo7x0Amn8NaU6nq1XyMy1fxGwM9u39cTMm98I9G1PWNRqU0t1tTVVB8VttLc4gb/x",
    "b9n1HRakUFra7V+XG1sHOeDIeu3067o9aaX/ANItakMPL0/QCUOpafqGl1mn6eLL7LQfEC24fGOPPkfTzjuqdMu0OmevTNtqt2C6s9gSe6/XB4",
    "gY3Sr+odNfxtLVnxFxyuciaOh+IdXorLm1mmazxGDZA27f9pZCgAADAHAjLraq1K2kfNxt7k/lAxup61OrdTFxRdOjlVPngepnY29GqTRrXpRg",
    "VjK85yfX85yd/SG8JnqptXb82Xx2k/w/8R29OYU6gtZpSfqU+nt7QL43EE7ceRB8jE2gnBIH5Ta6how9Z1ukG5WXdYijlh/MP7iZmFcAjkHkGA",
    "37INoY2IM9uYvgBEyWDg/yxr1iNXcn3WwIDTWc8COB2/gjksIY+cl8Q7TlFOfaBAxzyBiIK2YZAzmOO/8AlAiix1GMkCAPpLqsbkPIzGiokdjJ",
    "ar7azlHYfnJHue1stjPsMQKwq9+Y+vTs7YAEk7nJkyorD5Mk+0CAVqp2mslyfPtC3TpuwHx9QeJMA6cDO6KRYD8wOfeBRaoKT8wPuIzC+cvMMj",
    "lR+kDo1dc12KT5g8YgUTt/CMRyhRhu5ktlNanHiAn2EcUT8BziBJbbpvDAWsFyOTjErJZ4bBlHIjW7xIFL4g1D3UVKx43k4/KYU2Ot/wCnT9TM",
    "hF3uq5xk4z6QEGScAZJl/TdNLYa/5R/L5y3TpU0pIQAsPxnv/tHV3M2oes9lUH84D6dqbq1QIFPA9Zk9RTZq29wDNdPmZjnJzMzqhU3KVYE4wf",
    "aBVpGbUB/mEfqwg1D+Gcr/AHkdY3WKp8yBLuuqXYDWAAncCBQhFiQCEUxIHZdOY1fDWgKKr5vyVY8HG6aOk6jQLQbdP9nZvl3qcqfrM74drbW/",
    "DopQgPTeSue30/qYl6Mhem1Crgcg894Gr17S16npOsqx8yL4o9mH/wATzmena0EdOvB5IpYE+vyzzGAQhCA6t2rdXRirKcgjynX9J1I6jpwwID",
    "rw49DOOlzpetbQ6tXyfDbhx6iBWC26m04DO7HyEbdU1NhrfG5e+DnE3dbqK+nacJp1VbHHAA7e8wCckkwEhFhASPqsaqxLEOGRgw+ojRCB6bYq",
    "9U6YllRGbEDofRv/ADiZVJV7qPEX5fFAcHyPofzxH/CN5p6W1N7YCDxFz5Kf9/3mq+k073fa8EtjdjPBIHBx6wPNtS27U2t6ux/rI4rnLMfUkx",
    "ICCLCEAncfB+uHw/qum624gaW1Gp1B/lDHIY+wOJw4GSB6nE9GXptd+gCNkDbgA9hiBZKtrPjHrGvchq1KU0tnIKgA5Ht2/WUev6g26gacDC1A",
    "M3uxHH6D95e6RpG0GjWg3GxVPyZ52j0B9Jn9cAGvDZwHrBP5HH9xAzDTddp77KdoShSXZjjyzgTA0+t0/wDGbV0Pazrhdr7ds09d1RK+kvp6LF",
    "J1LEuB3A9P0xKPR9Al6tdcu5QcKPIwKz9QvbTHTK5Wkn7vc/rF6M9NfU9OdQivVvwQ3Ye82m6dpGYsaQMehImHqGor6gG0/wDpIwP6d4HpNtz1",
    "7ErqdyfMEAL+cp6zQhs3aZMk8vUvn7r/AI/SN0nVqupalqdIpsqUbrLCMAegHvL/AAMYHbtAwxXuUMOQfSJ4a+YOJq6jT72a1CqWHk54Vz7+h9",
    "/1kAsVGZLayGX7yN3H/nrApeDURw2D7xyU7SSrCW2t06rhUJ+sbvox8qnPoYAFUp8zrke0iNNNvJb5vYcRLPDZvl+XPr2jWrKeYP0gSDQoUJUn",
    "j14EeuiUDeGK84BIyMyqQT3klVtlJ+Ryp9oGlpen6OzT2K+rQuDgDHAP1lc9LvpqDoAzbsBEO449TiURvB+RiM+hjG3IeGIPngwNVkOgKnVVrZ",
    "lsEKSGB+kr9X162WYqrNYA4Gc5+sr01anHjV7sZ+9I7EtusJcMXPc4gVfHtznccx1mpstGGx+S4kjaaz+Q/pE+zso5GPrAr8mOXIElCDHIOY4b",
    "RjaPrmBCql2xnGY41gfiBIjyh3DaOTFbTOoye5gY/XV/g1f9x/aYwO1gR5HM3+uUsujVj5OP7znzA2dTaWo3ocFyAD9ZXruTSlxtyCSNwbJJEr",
    "pqWbSeCcDByD5w+TwmycOVwVI5J9cwLtSXOSLH8JX/AAr3/WN6hovB0yulZVAwGT55m/otHWlFTOubNozu8jiQdb2/8Os8axUb8K5+8c8QOc6c",
    "ofqGnUjINgzOh6pVpdPRaThDYDkes5rT2tp70uTG5DkZllKtX1W5nZiwH3nc4VYFMd43HJl/qehPTtWaCSw2qwY+YIlHHJgKewjY89o09hA6j4",
    "G1QF2o0rY+cCxfqO83OodOt1GsSxMGuwBHPmg55/rOI6e9/TtVptaEJrBzkdiOxE9Krdba1esgowypHmIEGsQtpNSoHBqYD9DPLZ6B17rCU6HU",
    "JpT4tu3aWXsmeDk+s4CAQhEzzAWJmO7xMQJWN2t1BOC9jdgBGXVNTY1bEFl4ODnmb2ssq6bpcadQruML6/Wc/mAmIsIQCS6TTnU6muofiPJ9B5",
    "yKb3w/pNlbalxy/C/SBsLmtlaptjIMA4yMehHmJYfql9dL+KtbV7CCVBUjjv3leMsw1dieqn9oHGwk2m051Btxn+FWXP5SGAsIQgWuk0faupaa",
    "r+awZ/eelWop0rVswVSuC3pOL+GNGU+IGU99Opb8+B/edz37wCoFa1DHJAwTMX4q0r36DxKSRan7HuJsu+wDCO5J7IMyvqdVpkUi1g2f/bHLH2",
    "xA89To+qd1Vk2DzYmbYSvRaT0rrWXa6jtAI2+gznA8h+Uq9XrI6fdnzAA+pMDn9b1J9SNqkonoD3lJVLEBRkngCdFpPhLUapwS/hUYHzOuCT7D",
    "/M6Ppfw5oenkMFN1n8z/AOIEPw/oP+G9PBdgN43WE+s1Gx3kGtVtTmnT2IVVsWqO4EkSoUoEUuQPN2LH9YCZDZUjIPcGJdUlyCuwZVfuN+JPof",
    "7Rx4jSYFK/TNQAWYNWTgWDgD/uH4f294luktrXJX9JoKSDkcSJ7G0a+JUB4P46/Jf+pfT3EDO+y2WAkAxgruT1+k2VcE5IB9MRXepz81fMDHVL",
    "FPIPMlXS3WPtVefPMvtgrgKMSRfE2gBj6CBkvUyA8doIm7nAP1nQ16Xev8S9fpiRvVpUBR0I9wIGM9tjqFJOF7Y4jfEtT8Tfr2muG0qNuXTlsf",
    "zNHPdS4JNag44AWBj+LqGPBb1j3tfGLAB7kSZ6nbs0QaK1yBkc+8CkdmTgcxaqlPJAl/8A4TdnDYHvEbp1ij5Tux6QK6KN2Qnb0EWymy4gLWwW",
    "WaUsUfN8v1k1S2sTt24HnAxeu6Fj0m8rX9wBs/QziGnp+p0l2pptrZhh0K4H0nmVowxEBKmVbFLglc8gek6N9RodNp1xapbHyEKGbE5mOQgMCw",
    "yM8gcQNi/r+odBVpxs8t5GWP8AiVTo9XdU+ovyABktYeTNfpN/TBbUqFaVcgM1g+YH6/8AxOobpulsf/TyFOUY8/n7wPO9HpzfqVpKnPPGcY+s",
    "63pjaHp1XiWsj7OFawgID7f7AzM02hU/FGp072eGF3EEY5zj1+sTqfQiNUK6mc2bsndycHGAP6wK3xJ1CvqWsrtqRgFTaWK4Dc+X6zJ8zNvqvT",
    "NRp9E9uoBLK6nJOSQRj/ExB3gERhxHRDA6r4apTU6AJZjGGxn1BnT6SpaqQtZyp5HPH5TlPhr5tLTX/PYVnXJhQUFZQIcAY4x7QOa6npwNZraA",
    "AFsAYDHbI/zONIwcHuO89A6un/P1t/NV+x/3nD69Al4I/EM/nkwEv0r00UXH7lykg49DiP0vT7dZRZZR8zVkbl9jOtr6WOofC2moxi1a99Z9Dy",
    "f6zG+EdQ2l6udO4wLlKMp9RyP2gYb12VMVsRlI8iMRuZ6VqenU3DIAU+mMiZl3TTUeaEI9QoMDn00dvUb/AB78pT2VfMiU+ptX9pNVKhaqvlAH",
    "r5mbus1Io0z29jjCj3mHbpzpdKLbv9a77qnyHmTApx1VbW2BEGSYIrWMFRSzHgATotD0wafTsHINtgwx9B6CBk6Xp7X2VIezDex9F8v1nToq1o",
    "qIMKowBIdvgB3RNzMRkDjjt/QSbMBlbuWIsAXPKgenvEfI+6Mt6Hz9orJ86uOCDycdx6R4EDK6BpS+n6q5GP4bVj2PJ/tMDynWdPVtKt7oM+JY",
    "5ZCeGGcfrOXWoveKgCCzbR+sCMGSadPFvrrH42C/qZH24mj8O1C/rWkQ9g+4/lzA6vo2m2/EHV7McBlUfnzN6V6KfC1GstBAa9lKkjzC4mZrR1",
    "yqh7K9RQ5QFiBXjgcmAvxPrzo101QUlbSWbnGQMcfqf6ShRrtOwUKBWX8sdpl9W63Z1arTpZWqeDkhvNs4z+0r6e3aS+NykFce8DpbGFK7nPGc",
    "DHmfSP0uhtuPjWEKwGa17hT5fn7zE+K0uA0mQRUVJJ8syHpXW7dJ0+/T1i269j/CwMhOOTA67QdQ0joc6ipX7OGcAgiR674i6fokJ8ZbnHaus5",
    "J/sJ529ViqHsRgGJwzDv6ze6X0CrUaFbtQXD2crtOMCBtj4m6SUa8WOjtgtXsO4n9pRv8AjKssfB0jEZ4LPjiU7fhZsE06kE+Qdcf1ErUfD166",
    "gDV5rpB5dAXz9MQOx0Wrr6hpE1NQIV/I9wY/LAiV9NqtDpqq9PS4VVGFQKcn8sS2rB1DDIB9QRAhrFrXsTaNqHBQL3yPP3lgqMYI4PlGoioxZR",
    "jJyREDMyncuPp5wG6DZ4b0PYA1DbRk91/Cf04/KXDVWle5iMHzzMHVkafVrqsjw3Ox8/oP0P7y227sBx6QLDWeC4DKD6EGPr1zMMDGfLkSkUYj",
    "zkVlTccmBqkszqTqK9meSrR9j6FMhr7HyeCo7flMUVv5gyQVk91zA02v0KggWXMfL5Bj95XbV6cNwrkefYSv4fHYiNNRbsIE730WHh3X2xmPpZ",
    "Rk1KXx5seP0lQ6cgZzI9jflA3F1FgAFtiDPmOYmp1DUqu1g+eSSOJjKtr4Vcn2j2qtC/N+mYE+s1QtvU1heB3MmbXJXUAoAf8A6ZneE4/CY5KS",
    "3fP5LmBMuutHCuRzOJfTBus+A44a4r+s7QVMxIRe3czn+qaV6fiHROR/qshHuQcf4gc2ylWKnuDgxs0Ou6Y6Xq+qqIxh84+vP95RCk5wM4GYAp",
    "PYes7r4T19t+jbT3Y31tlf+0+X5ThJu/D2v262lSvzKrAnP3uxH7QOh0+lR/izW+KiujadSQwyDnA/tLn/AAyyu9tRpbyr9hU5JTA7D1ETSWJf",
    "1W29RtZqFTHuGJmkvAwIHP8AXrbNTodRTbV4LqhO1u7YwflPY9pxAB7+U9T1VC6nTWUuoYOpGCM44nmS1t9lufHCWKpPoSD/AIgRRp7xZa02n8",
    "bRax8fNUEYfTPMDp/g2lLdHl1yUdip9DxOjru8TcrEb0OGAnP/AAeCvTQw7Na2f6TbBrTVnao3OAHb9oGf1o/85p8eVb/uJx3VaDWqtj8br/XP",
    "951OquGp1dtoOUH8NPoO5/XMyOt1700ygd7gP1gddoUFOh09Y/DUo/pOZ+JNC2i19PVdOuF8QG3Hk2e/5zp6/ujHbETUU130WU2rursUhhAVrc",
    "hGTBV8HPsY1iQ4ILc9x5SDptXg6UaW1tz0jZnPJXyP6S0FOTnkeUDkzWtprL/MEJIHln1mNrns6hrmFKs4X5VCjM3enaW7XHbV8tanD2Hy9h6n",
    "9pvaLp2m0NYSisD1J5Jgc70rpN+nTeumJtPdnOMfQTQOl1yjPgof1m4xwyrg5PbA4jhA5i0218XVPX/1LyB9fOSqQygqQQfMTomRbBh1DD3mTr",
    "ulNVm7RDJ7tWTw3+8CpF3bV/MRtbrYu5foQe4PpGak4oZh5YP9YEs57TgVfEK7lLKl+4gDnGczojMw6fHXRb5Grf8A2gYFoAtcKcgMcH85s/Bl",
    "e/ran+Stj/b+8y+oFDrbjWcqWJBm98CJ/wA9qbD+GoD9T/tA7C6lbQA3BU7lPofWY3XuuNobbNHTWpsav5nY/d3DyHria2ktfUFmb5VLkKuOwz",
    "395wXWdV9t6rqtQD8r2Hb/ANo4H9BAplSikgZAEl6cxa0HIwDkIeze0hsfFTL7xujbF6bs7c84gd2eqabVav7KaxYpXkEZGZoV6FK6d9VSIvmF",
    "AE5z4f6Q63nVMwNY+7g9zOh3uiKM5y3IgLfoNNqKgtiq6A5wyZGYppVQFG3AHGBiTo4C/dPuMyQ2I/D159MGBTXwEGHQlvaSJRVaP4b4PofKWC",
    "KOc1YPrnMRa6iO/wDSBWt0e9ChIKn35kFTOGem47rasAn+YHs3/noZqJWmeOZU6tUENWsXaPDOyzH8h8/yOD+sCPbkSLVWHT6Wx1BJVciTwasW",
    "IynswwcQMFqH6hpkDBdzZ28+Q88TW6JS2t0xTcGt07eHZ6+x/Mf3lWzRnp9aW6ZT4m7BHcGSaC2zpXUk1pT+BdldTjyB7N+X+YGvZ0m5eQmR7R",
    "v/AA7CljnI/CCMzW+2bLDhkZSMjmJTrtMc712t9M5gYg0rPZtRG57AiK+kerG9cE9hOhq12mI2nt7iSUVdLtYsQAT7wOcTSO5GFOPpLQ6PqCAy",
    "1OVY4B2zpKdN08uWVgpHGM8SLU0szEDqKKqj5VBxA5+/pwpRlurKlcfMCJAdMgP8OtRjsWmw/TkIHiapD7DJjW6VVayrTaD654gZGWB7gH2EFp",
    "yQSf6TWPRsMd1iBR55zBdDXXzvOR7QMq4v+FAPylYV3lsgn6ATfKBj95VHsI37Oi9rD9MwMdKLvMN+mJlfE2kdl0Op86NSgJ9iR/fE6sadSc7s",
    "/VpDrunpqdHdWAm4rlefMcj+ogee/HWlanqldzf+9XyfcHH+Jn/DWm+2dWTT4z4tbr//ABM6/wD+kfSq/StPqVABqt2nHow/yJz3wAufiWgnHy",
    "1uefpA511KOVYYIODLfRjjqdHu2P6S18V6T7F1/WVgYU2b1+jc/wB5n6K4abV03MpZUYMQDjIgejdM0qBPFYfO3nLRSzxtwtO0fgwMTHT4q6TV",
    "QCj2kgfc2HP+JN0Hren6rdeldTVOvzfM2Sw9f9oGnp6RSX2k/M24gngH2nFNo8aDruB/p6hSPyY/2M7vEx7NGPA6wnAFzsc//sBgefCdJ8L6Jd",
    "XoOpZzkqFHvwZzazsvglcdO1LActcB+gECx8IIV6UFYHctjg8e8s9c1y9N0Nl4OLG+VMeZMtU6U6enUIi8WWu68+vP7ziPijqf2/VLTWf4OnG0",
    "Y/E3mYG1Xjw0C8LgYlfWDd4LdxXaCf2k2nYPpqmHmg/aD17x/aBu6UEaVWJzkd5MJWqJbp2B32HH1k6NvRW8mAMBqptuZgAAwGfUmPssWqtrLG",
    "CooyxPkJFrNSmk07XWZIHAA7k+kzRqW6pqk011TU1IPEdGPL+g+nnA1aKa9PUtVShUQYAEf5whzAq6dPAezILmxycrkgD3JMtxqgKAAMARYDoZ",
    "jY6Bk9W0oosGqrACOcWgeR8m/sZn6kZ09o/6DOlsRba2rsGUYEEeonOmtq2sos5as7SfUeR/SAqHdWp9QJn9Y1C1bK1P8Rh82PJfT85erddPpQ",
    "93C1Vgt+XlOXv1L32va/3nbcfaAzVD+MTzyPOWui63VaXUldLbsLjkbQQ2BwMSpqLTaVLdwMSxoaQ7VODh1Yk/QQNvX/E2sRbNKtdaWAbTaufM",
    "eQ8u855B254lzrIH2iuxVA3pzg5BIPeUFPeAuobBAEbUcecbYcvgQPEDc03XbtLoBp6QVJsybM9vbE6boess1mmse8ZJbII7YnBaa7wnBI3LkH",
    "E1beuai/T+HuFdY4CoMQO9YIQCWK+5lLUdS0mmbB1QZs4wOcTi/wDiGovRUa1mVe2TG78nBgdtp+o06mzCXrnOPm4zLxS4dtv6zz9X2fnNvQde",
    "epNl4Nv8rZwfzgdIWuUYxz7Rr7nqeuxco4KsMdwZit1y7cClSBfcmaWl6xRftR3NbnyPb9YEehsJrNVhzZSfDY+uOx/MYMsLYp1BQsN4XIXzx6",
    "yHWBKdVVqkdWWzFVpBz/2n8jx+cmetfFWzO1hwT6j0gPfBGD5xGqWyplcZDDBkuIgII49YFTpdjKG0luTZRwpPmnl+nb9JoBMntM3qG7TvVrKh",
    "lqj8wz94eYP1/wATotJXRqtPXfTkpYMj/H1gVBXnyk6UNwNpl1NGh4OZYr0VZ4BYQKFdJB4P9Y/wG75Bm3T02jAHzk/STv0/TqmfDY49DA50v4",
    "ZbNYZj+ka92qZRtARfLCzZt02n3cU2fpKzUrXkeC3PbMDHst1RGSxGIxr7yuC2T6zV4UEmgAepWZGv6zo9HYwYFnHdV8oCfaLV7pmKbLyM+HxD",
    "SdU02vGaGOR3RuDLQsJHCcfSBUV7m/Dj8ornUYwCB9JYd2PGwyFiwOSh4gZHxHor9V0LWKwJ2JvH1Xn/ADOS+Bq2s6wxQElaWP8AUCdn1Dremq",
    "qeo/xSwKMq89+JxvwfrR0vqepsNZf+GUxnGPmH+IEvx9pXq12nuZSPFrxn6H/ectOx+NOqV9U0WnK0sjVWHkkHgj/aceBwTntAbLvSeo2dL1i6",
    "ipQ2AVKk8MDKZiQOr6f8R9V6leNLSKFsckhtv3R3lDr2k1tOqI1Ops1DMoZj/tMet3qYPWzIw7FTgidj8JdUpuqeq8INUgyHP3rB+fnA44Tu/g",
    "6vHRQ381rH9hOO6pX4PUtUmQdtrdhgd5s6b4hr6f8AD9Wm0uTqjuBJHCZJ594G51XXhzdotNYUsx/GsX8OR2HvOVs6BchJ8VSg54BJ/SR9Cvx1",
    "Aiw58YEEk9z3nQVMQzVN3XkH1ECvparaqEWu6uxAPlyuM/nmWKn3g5G1gcEeka9TKxeggE8lD91v8H3gl1bZZiK3HDBjgiBuaIf8ogPmDI+m2b",
    "9MFJ5QlZPSu2lFHkJn6E2JbatK72JxuP3F9z6n2ECx1JF1SDSD/Uchs/yAH7xlSvT09HW3UXWta23gnyEmu1FWhDYfxLWOXdj3P/nlOa+Idf4t",
    "a1hstYct9IHbQiRYERvQWioHdYTyo7geskVlYkKwJU4OD2kX2Wk6oalkzcF2hs9hE0w8F3rYLvcl8qMA5/vAn5iwiiATM6xpmzXqqyFK/JZnsV",
    "PbP0P7zTiWItlbVuMqwwYHI9fZx0/GxkJtXeD3AwSPqM+c5wjmeiV6WnqWiOm1yeIamKMc4II7MD7jBnK9c+HdR01TdVm/S/zqOU/7h/eBiNjb",
    "LOgJa6tR2zkyqRnkdpPU4oAcdzxAt9acbqEwQyoT+p4mcDxNB9I2sqR1tUMihAH4zgZ7/nM4qUYq4II4IPlAb5xc8yesUnAdTz5gyZ9PSavkVl",
    "YH72cgiBWGzbjziD5cgdot1T0vtcYOMj3ETuIElbkEY7SwjrvAJlTO3tJFUlt2CcekC4TzxFB94yvNhAUcnsIpbaxVhgjvmBaq1BUbWPHlHreQ",
    "c4BEqAA85j9yAhWPLdoF0aqpwVszgjBl5+rvqaEUnYayFdsfebyP95ivWAcHvHUv9ntD5yrfK39jA67R9Q3IF1IC2r3x2I8jLy4AwPrOT8RvtN",
    "Nxswc7dp7mdJptSLEUAexMCHTNdqLdRTrMAo2Qi/d2ntz5/wCZDo+tavomot0qhWoZtwLjO0/7zTKjduI+bGMyn1PRfaK8pgPjz7H2MC/R8T6u",
    "ty1iVOp8gMYl2r4ovdwRTWo9yZxDXPRtpbBYDjn+kkTWsB5CB6b0z4iDMBqSoU/yiWOqfENVFX/LnLHzM8yo15B+9uMsWdQLr8w/WBf1PVNUdS",
    "1w1FgY+e6Rn4k6jSMDVuw98GYN+oLE4Mqvcw8+JBu9Q65qdYF8a9sDyHA/pMu19w795SF4c4J5EFt8T/TbP0gTAsjZHGPOT09T1On4rvsUZzgN",
    "KTbjwSY1qjA39P8AFGqTAt2Wj3GD/SVOoda1WtY5fYnbYnAmQ2FyF5aNDOM7mwIE/iAAA8nMqUDZrtSRwCAZIrDjuSZUuuah3bsWAAlEmuuWzT",
    "uuTxyPrMoxzuznLHMbAQxI49ogEBYoODkQxCAuScknJ9TEhEgPqc12I691IInW12Jq6Vuocbh2Pp6gzj5Z0Ott0Vu6s5U/eU9jA6ut945G1hwy",
    "nymZ1bT2tqq7Uq8Vdu0rLum1VWs2W0MMjh1PfEmdSzIQcYP6iBN02qunptf2++ywgHFIfgDyBx3/ADiW6y+5dlIXT0jgBV5xIyOYQG+Eg+Zvmb",
    "+ZuTOU6hqDqdXZZn5c4X6CbfWLrKdI5J27zsUA8n1M5wCB6pCEIACD2jba1tADDsQR7GOhAWKI2LAXt3OISDU+G+yuwscnOwDhvrJoEB/ga5HH",
    "CagbG/7hyD+mRLueCPUYPvKmrqNumcJ/qL86f9w5EmS9LVRlI+ddwHtA4f4n6UvTdRXdSuKL8/KOysO4mK/3fznoPxJ09+pdO8KoZuVgyD1PpP",
    "PtpDFGBBXgg+RgX9M7NpdqsNxyceoH94dUqU6fSalc7nQpZn+YHv8AmCJBowEsocDkkgn9pdsTx6/DYAKy5B/kbyMDIHMsqX8DB+7K7q9NjI4w",
    "6kgg+RjkuK5B5HpAmoB1Iapm+YAlM+o8pHXYEJWysEdj6iFbgWbsZHpH6lUZVsQgA8EekB32XxBupfd7HgyP5qiQTjHlmRrYQNoPERgScmBaew",
    "Ckc+4kteqV0yQ2/GD55mfyQBHLvTyPMC4upa5tjBEPZTjEhsFgck9x/SH2W0J4hIHmBnJk9F63uTdTvc8Fs4B9zAathYgk5x6xS6co5G0+ckqW",
    "sW4srVq/QHBk9mh0lnzac2jHOGI/SBLQxtr07LgeGSr89z6zY0esNFjVqwJYgjPl6gTm69RTTftqDurjaQ3r5TV6fpbndbbCQgfsfIQOwxI0Yu",
    "1qvtyjYG3yGPP3j17SCqkaa5xWrFbmNjHOcHHMCprOkrat1q8uwz7jHpOZsY12FXOPftkes7rsJh9Z6SmorZkGGJznyU+v09YGHXqF3ADJk7Wn",
    "6D0JlSvSXoSDXgocN7R1isVPy5/MQJDemDzk+kge0vwp2qRyJGyNWM2VOnpkSMPuGBwPMwIzZsLY7yIsUPmDJWRRk7siQu24/NAkS61lI3k59Y",
    "ih62JVyCfeNC9ghyT5CTGi1VDMhz5A8QGo1incM/WD6oiwLnCjuR3MW5rCvhoo3nhgpzgegle6tqlBsUhj2zAkbWNg8n25la21rSCxzjgRkAIC",
    "QEUiEAEFHMI4doBAiLCAwjEMGK3l9Y6AzBhtJ/8AO8fHVtssUgA8+cCOuyylw1bFHHmODNbTdedcDUVCzH4l4MranSBQqt/rhtrc/eJ7NINRor",
    "qLvCZdzHkbfOBtf8d0p52WD8hILuvjGKaefVz/AGmKVIJBBBHfiGxsZ2mBLqNTdq7N1zlj5DyEZiIoxHQPUIRIZgEIhgIDoRIQECMLS/iMQR90",
    "9h9I+JFgKDjkd5XRjfpA+nXbjBUHjODyvt2xJ411UqSy7hgjGM5HpAfp7fFRbArLnyYYInK/GvShWw6np1wjnbcB5N5H8/3nVrgKAMAeQitTVq",
    "qrNNqBmq5Srf5geZ0Y2UMc7N+CZYXUUraKw/yDg8ZEr6/TXdP11mitP+k/6+h/OItW194HGMwJut1j7Z4iDC21q5HuR/tKIrdhwpl/qt7X2Uhx",
    "tZKVRh9MytVZjCt28j6QIRlQcgySva6lW8xx9ZIL7amOCCvoRkGNs2u6MhVN3f0BgVweY4txHCseKQ7YX1HnNChqTXsrrUeRPnAoVoQQxB/SbO",
    "kbxgA671xg5HaQGpVRgAfykdVn2ckFyQ3eBc1QprG1BtC+plSzULXT8qqec4HmJI91Y+YIremRmUntLK2VHJ8hAm+0aezkZQ48+ZXs1DFtoxiR",
    "FQVDL385GeDAfjnM6bpt2o1mnUo/f5XXHBnMg5mv8P64aW+1G+7YnHP4h2gd8vAA9BDvKfS7n1Gm3vknMuQFMyb9e3Tr7G1IDadmO1l5wfQ+k1",
    "e/nichr9OVuNADNucsxAzx5cQF6tqlssrfRvssJOB2z7ETOOqDkvfYbXHB+TE1dHoHvqsyQ7Unk4wD7Sr1vQh820Ai1VHiJj73uPeBDX1KirSW",
    "AKxc/gJ+U/3lK3qHibQ2nq245AGCfzlNAH7nEclYZuT8vmYFttRVcm1NMtZ9QxkS6d7HCgcn2im5UYeCACvnFOuvfCoMt2z5wLtBbT1stCHcD9",
    "7AzEYoVLazGT3BbmVd27Nd1xTaOVXJJMo3FS/yFsf9RgWrNbWAVprwPWVbLXtILsTjt7SOEBYqxPKOXtAQiIY+IRxAQCKO0QR0AhCEBDDMWIYB",
    "A9oCLA2afmVddfWrpevhlV7g9h+skejwqnW//wBWuGQ5ySDwAP2MqdGxqLPs1zN4XJTB7ORwZoV+Nq7DcLFa3ScVjyc+Z/OBW8MUUtqX5s3Fbk",
    "P/APUfSZ2uU1lK2IYkBsg5wD2E2zaLX/4l4Y8BPlKnufVvqO051232M2MAngekBIQhA9PiQzCAQhEgKIsTEUQFi5jYsBYAxIjMFUsxwAMkwFGc",
    "n08orbtp2fexxn1jUdXRWU5VhkH2jwYHP/GuhFtdOvVfmqxXaR6HsfyP7zlarSyOMk88T0w6dNZRdpbfuXIV/OeYWU2aLVW0Wr/ERihHuICazU",
    "PqLvGfAZ++BgccSNQzcKMmT+CtYG9SzZOPpmK9uOBgewEBKNN4j7LHFZzjkTTb4Z1XeqyqwdxgzK8RiQNxx7y3puoW6Rs1tgj37wKup0ep09jC",
    "ypxt7kDIEjpuZDxyJs0dc1FFrMbSyuM9hkGS623SazS+JZRWtqfIXQY3E9jAxbdVY7Ag7cDGBGD5jk95G67W4JI8siKobcBmBYDqBg9o0AHIXm",
    "NI+XJ7SJbCrZB9oEm7jBwp8xAaV7QWrIcjkgd4xMO+Dk59JcCeCA1eUsUck+cCknBwZIBkgp94ciPXbfcTg5PcSY6emv5jzn1MDt+lalLOirfW",
    "QCykEDyb0/WX69vhoEI27Rj6TkPhrXJ49mhBwlw3Vj/rH+ROvWuuskogUt3I84D5ldW0VuqtQ0VAH/70NgiamYZwIGfo+mmjSmtrW3E5Yyt1nS",
    "OwSxBgA5cjymzGuoZCG5B7iB5/r9Gqj7RUPlJ+dfQ+v0lBnIyBOz13R2uvb7OypVjJGO59Jy3VentorNy5NLHg+h9DAgqUMfyjq7xWGPibSD8o",
    "AzIPHZRhePeRCBJZaXYtzk+cjhFgJCKIEQF8ooiekdAImeYsQ9oCwiA5EDAWEIkBYRIsAhEzDMCbSlvGFaMF8X5CT2GfP9Zt3Hxa6l06MttSFb",
    "1Q8qg7j6+k576Tb0mqajTDWB/EsuJSwE4+b8J/KBF1q5EAr0jAUWYLhe2ccf0xmZUs68CvUGlX3LX5+W4/e/rK0AhCED02LEiwCEIQCLEEWAsM",
    "QhAJS6s+NJ4Sn572FS/n3/pmXZm2N9p6xWn4dMuT/wBx/wBsfrA0goRQo4CjAixPKEBysQQRwROR+NdMK+tVapB8mpQE/wDcOD/adaJlfFGnXU",
    "dHNuMvpbA/0B4MDiryTtJJHH9zISA2MHmSXvv2EjGQf3kS4zmAFjnGMR29dpBHMQndEdcJnPJgaWhOkur2agYZxtyDyD6ywiUKh01xKurYDHz9",
    "Jgr3k5YuwU5OfUwLuu0Jq3HxN2TlcDgmZu/B44Mma6xFCHOAeAfKQ2KQ2fWAr/8AdmM2k9hF5jlfa2YEumVq28TOCO2Yp1NjsSWz+UiNmVIz3g",
    "hxmAtbmuzIOD24j7WLDaXyScyEffH1lldMH3s91dePI8k/lAhrd6bFdGIdCCCPIiej9L1y9R0NepXu3DD0bzE4mpdBVkKpvcjhrcjB9gJr9F6n",
    "4GrG5Fr092FYAYCt5H+0DqZDqvGKg0opKgkFj5+wkx7wECl0lrG0u7UMx1BJ8QNng+mPKXcypRYftdwObctgWKowox90n2luAmPmHvMjq+kRnK",
    "uoNdo7TZEg11Xi6dsD5l5EDzrqOibRXlTyh5VvWVQMzqeqaYarSMoHzr8y/WcwICFeIkcIEQEEU9oCLAQRYgEWAg4OIRG9YoOYDexjm7RGHETP",
    "GIDxGnvFXtAwAQMBAwEhCEAk2luWmwlxuUqRj3kMO8BQYsbFzAWETMIHfdN1DWKdLY5FiDKNnll/yO00Zz6oX1unKttsBbYffGefbjE3abBbUH",
    "wVJ7qe4PpAfCESAsWNJgDAfCJmLAZbYtNT2OcKilj+Uy+jBmuex/vuC7fUmS9csIorpH/uvk/Qc/viP6XXio2fzcD6QL8WIIsBGztOwZbHAz3M",
    "iGnGq6fq6/lNmoqKtg5GQOB+snEKSK7zjgbg0Dy59xRPXnMQHjBHMt9Wp+zdQ1FI7Ja4H0zKjQEBwIrcriMBPaODYyDzmAztH5xg+kEUM0lq24",
    "ZSmc9j6QGC0ng88RpYnIPnzHGna2CcH3hs2thu3tAjJgvvHWoEb5SSp7ZiIrN2EBvnLlOgtesWuDXVnliP7SR10+norKANcTzu8o5S2pO7UXst",
    "YOcCBODo6EVE04sYjJZm5b/Eh1QVwuKmqUds9oW2UFVSlFQrxuB5MheyxyQ9hb84FuujRIFa3VHPnhDj9ZDcaN+0WZTyxKwTdhPXtG+AQcMcQO",
    "6+HeojXaPw2bN1HytnuR5Gah9jPO+m65+ma1LqwWA4df5l8xPQarUvqS2ttyOAyn1EB6KFGFAA9AIsAQO5xFgEMxIEBgQex4MDC1lfgahl8jyP",
    "pOS19Jq1L8fK5JX9Z3vV6Q2nFoHKHn6Tluoafxumh1GXrJce4JOYGEIGJmEAi5iQgKIGAgYAI37rYiwYZ+sB0Ywiq3kYHmAiecUxBw31iwFWBi",
    "DiEAhCEAhCB9YBCEIBFESEDsFbF+nf0tX+vH950AAGTjk95ylFvidOS0HJVQ35g/7TqgQeR2MADBlDLyD2gY0BvFIGdmMnJ8/aOgJFEIQHRY2L",
    "AyupA39RqpH4aif1P+00q0FaKi9lGJVoQP1DV2nkqVrH5DP95bxAcJF47I7pYoU8+GxPyt6DPkZMBGsm/crgFCMYPIMApZ2qRrVC2EfMo8jH94",
    "yqsVLtUsR5AnOJIvcQPPvigkdc1Z8jYcf0mYTxL3WLRqtTdePO5x+RMzoDswPbMQGGYElLquQ3c9jHZyflkEehOe/eBYYhuCR7SG0kAc/pGMcN",
    "AZIIgS1DxeHOEHOZYaxKwoRMY/UxqbH2BFwFHJiW3JuwFz7wGWVgp4hJznGIxWVlCcj3iOz2MM59AJMlZopawlST8uPSBE2CcA8CSliuM9pAq+",
    "cdu+XBgKzlvPGI5myg3cn1jFI+sRye3lAUPtPrOm+FOqBH+w3NhXOaifI+azlxyI8MVIKkgg5BHkYHptqF0wv3gQR9RHIwdcjB8jj185m/D/VB",
    "1LSDef8AmK+LB6+h/OaJUq25cYP3h7+sB0IAhgCDkHsYQGagF9PYqjczKQB9ZgvT4OaTyEG3nznQiZPVayuoD+Tj+sDiNZQdNqXq8gfl+nlIJu",
    "de0+6tb1HKcN9JhwCEIQCEIQCEIQEI84BosQiAH1ixvlHAwCEIQCEIQCEIQCEIQCEIQNror+JorqM8jOPzE67Q2eLotPZ/NWp/pOD6Ld4WtCk8",
    "WDE7bozZ6dWvmhZP0JgXLAWRlHcj1xErPyAdyOCcYzHCNWvFjuWJ3AAD0xAdFkdDtYpL1mshiNpOfzkkAzDMSA7wK2i58d/5r3/px/aWsyr07n",
    "SBv5mdv1YyzAcDGomwv8zEMcgHnEURRAWOU4IMbFEDguq0rpup66oeVxbHoM8fvKFlathhxnym18Ur4XWbsAZtqV8/lj+0xAxwRnvAj8PfYVqB",
    "9hG2VPWcOpGJa04CWh8lSDziXbbK7c8AtjBJHeBixc4mgml05Vg5IOeCDItTo1qKlLQVbsTApjJPvJ/AZVznJPkJGn8OwZ8pYF2cqDgesCPaR5",
    "cSfS1K5O4dhIi65yTn2iC9/ughQ3B4gWFH8Tds4XgHyzINWHWzDnk8xtl7E7U4RTxI2JY5JJPvAVe0UmMXvH4gMPHIhu4xF4xH16e1wCEO0nGT",
    "AjU4PtJaqrLn21qW+nYSXwK6a3awb2HAA7CWtG/hacFnXa3kB/5mA7pvidM1K6hLQ1i/eReQR6EzudHq6tdpkvpOVby8wfMGcKbagpIY4H4QJe",
    "6J1UaLUhXwuluOCc9j5NA7AV/OWBxngiR+PtZhdtqAbC7j3Hrn85OuMA5BBlbX63SaGvdrLFVT2U8lvoIFhefoZidd19FVwrewfIOw5OfpMfqv",
    "xTqLya9Ev2ertu/Ef8TCNhbljljySe5gaGs60LEeuun5WGCX/wATLByIOOcxo4gOhCEAhCEAhj0hHBWIyBxAZkiKMt2GY/aoB3g/UHtH1AYBVx",
    "we0CAj2gPeSWjbYcdjGseAPSAkIQgEIQgEIQgEIQgEIQgJU5rsV17qQRO7+HL1v0tpU8eKSPzAM4Q/enUfBtm0WJngt/aB0yMW3ZUrhiBnz948",
    "RlasNxYAbjnAOY+BCtO3VWXAnDADbk4z5n9pKYsSAQhG2HFTn0U/tAr9L/8As/T+6Ay0JW6dxodOP/wl/aWgIBFEAIsAiOdqMeBgefaKJFqDzU",
    "n89g/Qcn9oHM/GSY1ulc/i07KfyJ/zObVeZ1nxvX/y+is8w7qT9QDORVvI9oEyPsPaP8Q53gfL6SPxDjy/ORljyB2MC0tiA5YEg8/SQ6xhlQvb",
    "GYi2sibSuY1bEIIdMny9oEecgRVQkZPaPYKVBAwRE3kDEBR7ACRk4JgWMSA5QYNgLiJmNzAWSqC7BVHJkSLuYCWQyV8LyRwDAlr0gWxckOfNZK",
    "5fdgZ4Hn2Ehr1DBMcqT+KFlhasLvzn94EtrFgAQufQ9pVsDs+307D0jOVbGckR25xnB5PnALM1/LnkekhLFu/Mc5yee8YO8DQ0/WuoaeoVVaux",
    "UAwAcHH0zKl99t9hsvsaxz3ZjkwSp7RlFJA7nHaWH0a01FrrP4mOEAgVTyY6sAMN+ce3eXNPWa9MbW+XJ47Q14RERkQbm7t2gR6apLGcuhCrK9",
    "9Yrc7clPL2k2ltzlDnPliW7Spq2Bc+ogZcI+yplPAOD2i1V73AJwIEck8F9m7j6Zi2IAxCjiKLMJtIyYESDc2JOoNTZJjQosX5fvRVUuuNxyIA",
    "/wB7cvn5YkLAqSR2kjVsBkxmfLy9ICFs94wnmSFQVJHcSKA4RYgPEWAQhCAQhCAQhCAQhCAN5fSbnwsSLbMH8SwhA7FmIvVc8FSY+EIBCEIEdh",
    "IavB7tg/pEv/8AT2/9h/aEIEXTj/yVH/5a/tLSwhAWLCEBRK13Ou0w8trn8+IQgZPxmP8A6s0//wCo/wD8mcUsIQJUAiOMPxCEA8jBQN35QhAU",
    "fdkRhCAkIQgJCEIE+m/1Fhb/AKrfWEICEnA5jMneOYQgOXzkinmEIELdzJNGivcAwyPSEIGzf8ujAXgZxgcSih3XENzgHH6QhAZqiflXPGAcfl",
    "INWcXFR2GOIQgLpeNQmJPvb7SwzxmEIEAdt3fzjj3B8yYQgWLAPBzjnIla0AMMQhAaO8W0lbSAcdoQgS5zUM8yq4w5hCA8Rjj5RCEBi9o4doQg",
    "EIQgIYCEICwhCAQhCB//2Q==",
})

local B64CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function b64decode(data)
    local lookup = {}
    for i = 1, 64 do lookup[B64CHARS:byte(i)] = i - 1 end
    local out, n = {}, 0
    local buf, bits = 0, 0
    for i = 1, #data do
        local v = lookup[data:byte(i)]
        if v then
            buf = bit32.bor(bit32.lshift(buf, 6), v)
            bits = bits + 6
            if bits >= 8 then
                bits = bits - 8
                n = n + 1
                out[n] = string.char(bit32.band(bit32.rshift(buf, bits), 255))
                buf = bit32.band(buf, bit32.lshift(1, bits) - 1)
            end
        end
    end
    return table.concat(out)
end

-- Retorna o asset do fundo ou nil (sem writefile/getcustomasset o painel usa cor lisa).
local function loadBackground()
    local getAsset = getcustomasset or getsynasset
    if typeof(writefile) ~= "function" or typeof(getAsset) ~= "function" then return nil end
    local ok, asset = pcall(function()
        local exists = typeof(isfile) == "function" and isfile(BG_FILE)
        if not exists then writefile(BG_FILE, b64decode(BG_B64)) end
        return getAsset(BG_FILE)
    end)
    if ok and type(asset) == "string" and asset ~= "" then return asset end
    return nil
end

----------------------------------------------------------------------
-- 4. FAVORITOS (persistem durante a sessao)
----------------------------------------------------------------------
local Favs = {}
if genv then
    genv.JczzAutomaticFavorites = genv.JczzAutomaticFavorites or {}
    Favs = genv.JczzAutomaticFavorites
end
for k, v in pairs(Settings.Favorites) do
    if Favs[k] == nil then Favs[k] = v end
end
Settings.Favorites = Favs

local function countFavs()
    local n = 0
    for _, e in ipairs(Scripts) do
        if Favs[e.Name] then n = n + 1 end
    end
    return n
end

----------------------------------------------------------------------
-- 5. LOG
----------------------------------------------------------------------
Log.lines = {}
Log.counter = 0

function Log.add(text, color)
    if not UI.logList then return end
    Log.counter = Log.counter + 1
    local l = mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        TextWrapped = true, TextSize = 11, Font = Enum.Font.Code,
        TextColor3 = color or Theme.Dim, LayoutOrder = Log.counter,
        Text = string.format("[%s] %s", os.date("%H:%M:%S"), text),
    }, UI.logList)
    table.insert(Log.lines, l)
    if #Log.lines > 60 then
        table.remove(Log.lines, 1):Destroy()
    end
end

function Log.clear()
    for _, l in ipairs(Log.lines) do l:Destroy() end
    Log.lines = {}
end

----------------------------------------------------------------------
-- 6. NOTIFICACOES
----------------------------------------------------------------------
Notify.queue = {}
Notify.counter = 0

function Notify.push(text, color)
    if Settings.Notifications == false then return end
    local holder = UI.notifHolder
    if not holder then return end
    color = color or Theme.Accent
    Notify.counter = Notify.counter + 1

    local g = mk("CanvasGroup", {
        Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = Theme.Bg,
        GroupTransparency = 1, LayoutOrder = Notify.counter,
    }, holder)
    round(g, 10)
    stroke(g, color, 1, 0.3)
    local bar = mk("Frame", {
        Size = UDim2.new(0, 3, 1, -14), Position = UDim2.fromOffset(8, 7), BackgroundColor3 = color,
    }, g)
    round(bar, 2)
    mk("TextLabel", {
        Text = Config.Name, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = color,
        Position = UDim2.fromOffset(20, 5), Size = UDim2.new(1, -28, 0, 14),
    }, g)
    mk("TextLabel", {
        Text = text, TextSize = 13, TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(20, 22), Size = UDim2.new(1, -28, 0, 18),
    }, g)

    table.insert(Notify.queue, g)
    if #Notify.queue > 3 then
        table.remove(Notify.queue, 1):Destroy()
    end
    tween(g, 0.15, { GroupTransparency = 0 })

    task.delay(2.6, function()
        if not g.Parent then return end
        tween(g, 0.25, { GroupTransparency = 1 })
        task.delay(0.3, function()
            local idx = table.find(Notify.queue, g)
            if idx then table.remove(Notify.queue, idx) end
            if g.Parent then g:Destroy() end
        end)
    end)
end

----------------------------------------------------------------------
-- 7. STATUS GLOBAL
----------------------------------------------------------------------
Status.loading = 0
Status.errored = false
Status.token = 0

function Status.refresh()
    if Status.loading > 0 then
        UI.setStatus("Loading...", Theme.Warn)
    elseif Status.errored then
        UI.setStatus("Error", Theme.Bad)
    else
        UI.setStatus("Ready", Theme.Good)
    end
end

function Status.begin()
    Status.loading = Status.loading + 1
    Status.refresh()
end

function Status.finish(ok)
    Status.loading = math.max(0, Status.loading - 1)
    if not ok then
        Status.errored = true
        Status.token = Status.token + 1
        local t = Status.token
        task.delay(4, function()
            if t == Status.token then
                Status.errored = false
                Status.refresh()
            end
        end)
    end
    Status.refresh()
end

----------------------------------------------------------------------
-- 8. INFO DO CARTAO (estado exibido abaixo do nome)
----------------------------------------------------------------------
Info.data = {}

function Info.paint(entry)
    local item = UI.items[entry]
    if not item or not item.Info.Parent then return end
    local d = Info.data[entry]
    if d then
        item.Info.Text, item.Info.TextColor3 = d[1], d[2]
    elseif entry.Desc then
        item.Info.Text, item.Info.TextColor3 = entry.Desc, Theme.Accent
    elseif entry.RequiresKey then
        item.Info.Text, item.Info.TextColor3 = "Requires Key", Theme.Key
    else
        item.Info.Text, item.Info.TextColor3 = "(no Key)", Theme.Dim
    end
end

function Info.set(entry, text, color)
    Info.data[entry] = { text, color }
    Info.paint(entry)
end

function Info.reset(entry)
    Info.data[entry] = nil
    Info.paint(entry)
end

----------------------------------------------------------------------
-- 9. CARREGAMENTO E TRATAMENTO DE ERROS
----------------------------------------------------------------------
Loader.busy = {}

function Loader.isBusy(entry)
    return Loader.busy[entry] == true
end

-- Download alternativo para executores onde game:HttpGet falha.
local function httpRequest(url)
    local req = (syn and syn.request) or (http and http.request) or http_request or request
        or (fluxus and fluxus.request)
    if typeof(req) ~= "function" then return nil, nil end
    local ok, res = pcall(req, { Url = url, Method = "GET" })
    if not ok then return nil, shortErr(res, 100) end
    if type(res) ~= "table" then return nil, "resposta invalida" end
    if res.StatusCode and res.StatusCode ~= 200 then return nil, "HTTP " .. tostring(res.StatusCode) end
    if type(res.Body) ~= "string" then return nil, "sem corpo" end
    return res.Body
end

-- Tenta game:HttpGet e, se falhar, a funcao request do executor.
-- Links http:// tambem sao tentados em https://.
local function httpGet(url, useTrue)
    local candidates = { url }
    if url:sub(1, 7) == "http://" then table.insert(candidates, "https://" .. url:sub(8)) end
    local lastErr = "sem resposta"
    for _, u in ipairs(candidates) do
        local ok, res = pcall(function()
            if useTrue then return game:HttpGet(u, true) end
            return game:HttpGet(u)
        end)
        if ok and type(res) == "string" and #res > 0 then return res end
        lastErr = ok and "resposta vazia" or shortErr(res, 100)
        local body, err = httpRequest(u)
        if body and #body > 0 then return body end
        if err then lastErr = lastErr .. " / " .. err end
    end
    return nil, lastErr
end

-- Baixa e executa SOMENTE o loader registrado na configuracao.
-- A key (quando existir) e entregue ao script via variavel global "script_key",
-- mantida apenas na memoria e removida depois de 60s. Nada e salvo nem enviado
-- para servidor proprio; a validacao fica por conta do proprio loader.
local function fetchAndRun(entry, key)
    if not table.find(Scripts, entry) then
        return false, "Entrada nao registrada na configuracao"
    end
    -- Scripts embutidos (ex.: Jczz FPS) rodam direto, sem download.
    if entry.Run then
        local okE, errE = pcall(entry.Run)
        if not okE then return false, "Erro no script: " .. shortErr(errE, 140) end
        return true
    end
    if typeof(loadstring) ~= "function" then
        return false, "loadstring indisponivel neste executor"
    end
    local url = entry.Loader:match('HttpGet%(%s*"([^"]+)"')
    if not url then
        return false, "Loader invalido na configuracao"
    end
    local useTrue = entry.Loader:find('HttpGet%(%s*"[^"]+"%s*,%s*true') ~= nil

    local src, gerr = httpGet(url, useTrue)
    if not src then
        return false, "Download falhou: " .. tostring(gerr)
    end

    local head = trim(src:sub(1, 300)):lower()
    if head:sub(1, 1) == "<" then
        return false, "O link devolveu uma pagina web, nao um script"
    end
    if head:sub(1, 13) == "404: not found" then
        return false, "Link offline (404)"
    end

    local fn, cerr = loadstring(src)
    if not fn then
        return false, "loadstring falhou: " .. shortErr(cerr, 120)
    end

    if key and genv then
        genv.script_key = key
        task.delay(60, function()
            if genv.script_key == key then genv.script_key = nil end
        end)
    end

    -- Roda em outra thread: hubs que ficam em loop nao travam o botao nem
    -- sao marcados como falha. Erros imediatos (ate 5s) ainda sao detectados.
    local finished, okRun, rerr = false, true, nil
    task.spawn(function()
        local ok, e = pcall(fn)
        okRun, rerr, finished = ok, e, true
    end)
    local t0 = os.clock()
    while not finished and os.clock() - t0 < 5 do task.wait(0.1) end
    if finished and not okRun then
        return false, "Erro no script: " .. shortErr(rerr, 140)
    end
    return true
end

function Loader.run(entry, key)
    if Loader.busy[entry] then return end
    Loader.busy[entry] = true

    Info.set(entry, "⏳ Loading...", Theme.Warn)
    Status.begin()
    Log.add("Executing loader: " .. entry.Name)
    Notify.push(entry.Name .. " carregando...", Theme.Warn)

    local done = false
    local function finish(ok, err)
        if done then return end
        done = true
        Status.finish(ok)
        if ok then
            Info.set(entry, "✓ Loaded", Theme.Good)
            Log.add("Loader executed: " .. entry.Name, Theme.Good)
            Notify.push(entry.Name .. " executado.", Theme.Good)
        else
            Info.set(entry, "✕ " .. shortErr(err, 44), Theme.Bad)
            Log.add("Falha ao carregar " .. entry.Name .. ": " .. shortErr(err, 200), Theme.Bad)
            Notify.push(entry.Name .. ": " .. shortErr(err, 38), Theme.Bad)
        end
        -- Cooldown curto: o botao volta ao normal e pode tentar de novo.
        task.delay(ok and 3 or 6, function()
            Info.reset(entry)
            Loader.busy[entry] = nil
        end)
    end

    task.spawn(function()
        local ok, a, b = pcall(fetchAndRun, entry, key)
        if not ok then
            finish(false, a)
        else
            finish(a, b)
        end
    end)

    -- Watchdog: nunca deixa o botao preso se o HttpGet nao responder.
    task.delay(30, function()
        finish(false, "Tempo esgotado (30s)")
    end)
end

----------------------------------------------------------------------
-- 10. PESQUISA / CATEGORIAS / FILTRO
----------------------------------------------------------------------
Filter.query = ""
Filter.category = "All"

function Filter.matches(entry)
    if Filter.category == "Favorites" then
        if not Favs[entry.Name] then return false end
    elseif Filter.category ~= "All" and entry.Category ~= Filter.category then
        return false
    end
    if Filter.query ~= "" and not string.find(entry.Name:lower(), Filter.query, 1, true) then
        return false
    end
    return true
end

function Filter.apply()
    local shown = 0
    for i, entry in ipairs(Scripts) do
        local item = UI.items[entry]
        if item then
            local vis = Filter.matches(entry)
            local fav = Favs[entry.Name] == true
            item.Frame.Visible = vis
            item.Frame.LayoutOrder = (fav and 0 or 1000) + i
            item.Star.Text = fav and "★" or "☆"
            item.Star.TextColor3 = fav and Theme.Warn or Theme.Dim
            if vis then shown = shown + 1 end
        end
    end
    if UI.empty then UI.empty.Visible = (shown == 0) end
    UI.refreshHome()
end

----------------------------------------------------------------------
-- 11. MODAL DE KEY
----------------------------------------------------------------------
Modal.entry = nil

function Modal.close()
    Modal.entry = nil
    if UI.keyOverlay then
        UI.keyOverlay.Visible = false
        UI.keyBox.Text = ""
        UI.keyHint.Text = ""
    end
end

function Modal.open(entry)
    if Modal.entry or Loader.isBusy(entry) then return end
    Modal.entry = entry
    UI.keyTitle.Text = entry.Name
    UI.keyBox.Text = ""
    UI.keyHint.Text = ""
    UI.keyOverlay.Visible = true
end

function Modal.confirm()
    local entry = Modal.entry
    if not entry then return end
    local key = trim(UI.keyBox.Text)
    if key == "" then
        UI.keyHint.Text = "Digite a key antes de confirmar."
        return
    end
    Modal.close()
    Loader.run(entry, key)
end

function Modal.cancel()
    if Modal.entry then Log.add(Modal.entry.Name .. " cancelado") end
    Modal.close()
end

----------------------------------------------------------------------
-- 12. DRAG (mouse e toque, sem conflitar com botoes/scroll)
----------------------------------------------------------------------
function Drag.make(handle, target)
    local state = { moved = false }
    handle.InputBegan:Connect(function(input)
        local t = input.UserInputType
        if t ~= Enum.UserInputType.MouseButton1 and t ~= Enum.UserInputType.Touch then return end
        state.moved = false
        local startInput = input.Position
        local startPos = target.Position
        local moveConn, endConn

        local function stop()
            if moveConn then moveConn:Disconnect() moveConn = nil end
            if endConn then endConn:Disconnect() endConn = nil end
        end

        moveConn = UserInputService.InputChanged:Connect(function(i)
            if i ~= input and i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            local d = i.Position - startInput
            if not state.moved and d.Magnitude < 6 then return end
            state.moved = true
            local vp = Layout.viewport()
            local sz = target.AbsoluteSize
            local x = math.clamp(startPos.X.Offset + d.X, 0, math.max(0, vp.X - sz.X))
            local y = math.clamp(startPos.Y.Offset + d.Y, 0, math.max(0, vp.Y - sz.Y))
            target.Position = UDim2.fromOffset(x, y)
        end)
        endConn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then stop() end
        end)
    end)
    return state
end

----------------------------------------------------------------------
-- 13. LAYOUT RESPONSIVO
----------------------------------------------------------------------
Layout.wide = true

function Layout.viewport()
    local s = UI.gui.AbsoluteSize
    if s.X < 50 or s.Y < 50 then
        local cam = workspace.CurrentCamera
        if cam then s = cam.ViewportSize end
    end
    return s
end

function Layout.panelSize()
    local vp = Layout.viewport()
    local portrait = vp.Y > vp.X
    local k = Appearance.sizeFactor()
    local maxW = (IS_PC and 600 or 560) * k
    local maxH = (portrait and 520 or 380) * k
    local w = math.min(math.max(240, math.min(maxW, vp.X * 0.92)), vp.X - 8)
    local h = math.min(math.max(260, math.min(maxH, vp.Y * 0.82)), vp.Y - 8)
    return w, h
end

function Layout.clampTo(obj, w, h)
    local vp = Layout.viewport()
    local p = obj.Position
    obj.Position = UDim2.fromOffset(
        math.clamp(p.X.Offset, 0, math.max(0, vp.X - w)),
        math.clamp(p.Y.Offset, 0, math.max(0, vp.Y - h))
    )
end

function Layout.centerPanel()
    local vp = Layout.viewport()
    local w, h = Layout.panelSize()
    UI.panel.Position = UDim2.fromOffset(math.floor((vp.X - w) / 2), math.max(8, math.floor((vp.Y - h) / 2)))
    UI.toggle.Position = UDim2.fromOffset(math.floor(vp.X / 2 - 80), 6)
end

function Layout.apply(animate)
    local vp = Layout.viewport()
    local w, h = Layout.panelSize()
    Layout.wide = w >= 440
    local sbw = Layout.wide and 150 or 52
    local curH = Panel.minimized and TOP_H or h
    local size = UDim2.fromOffset(w, curH)

    UI.sidebar.Size = UDim2.new(0, sbw, 1, 0)
    UI.main.Position = UDim2.new(0, sbw, 0, 0)
    UI.main.Size = UDim2.new(1, -sbw, 1, 0)
    UI.brandTitle.Visible = Layout.wide
    UI.brandSub.Visible = Layout.wide
    UI.nav.Visible = not Panel.minimized
    UI.pages.Visible = not Panel.minimized
    UI.hint.Visible = Layout.wide and not Panel.minimized
    for _, b in pairs(UI.navButtons) do b.Text.Visible = Layout.wide end

    if animate then
        tween(UI.panel, 0.18, { Size = size })
    else
        UI.panel.Size = size
    end

    UI.notifHolder.Size = UDim2.new(0, math.min(300, vp.X - 16), 0, 0)
    Layout.clampTo(UI.panel, w, curH)
    Layout.clampTo(UI.toggle, UI.toggle.AbsoluteSize.X, UI.toggle.AbsoluteSize.Y)
end

----------------------------------------------------------------------
-- 14. PAINEL (abrir / fechar / minimizar)
----------------------------------------------------------------------
Panel.open = false
Panel.minimized = false
Panel.token = 0

function Panel.show()
    Panel.token = Panel.token + 1
    Panel.open = true
    UI.panel.Visible = true
    UI.scale.Scale = 0.93
    tween(UI.scale, 0.16, { Scale = 1 }, Enum.EasingStyle.Back)
end

function Panel.hide()
    Panel.token = Panel.token + 1
    local t = Panel.token
    Panel.open = false
    Modal.close()
    tween(UI.scale, 0.1, { Scale = 0.93 })
    task.delay(0.11, function()
        if t == Panel.token and not Panel.open then
            UI.panel.Visible = false
        end
    end)
end

function Panel.toggle()
    if Panel.open then Panel.hide() else Panel.show() end
end

function Panel.setMinimized(v)
    Panel.minimized = v
    Modal.close()
    UI.minBtn.Text = v and "+" or "–"
    Layout.apply(true)
end

----------------------------------------------------------------------
-- 15. NAVEGACAO (menu lateral)
----------------------------------------------------------------------
Nav.current = "home"

function Nav.paint()
    for id, b in pairs(Nav.buttonsById or {}) do
        local sel = (id == Nav.current) or (Nav.current == "fps" and id == "Performance")
        b.Btn.BackgroundColor3 = sel and Theme.CardPress or Theme.Card
        b.Btn.BackgroundTransparency = sel and 0.15 or 1
        b.Bar.Visible = sel
        b.Text.TextColor3 = sel and Theme.Text or Theme.Dim
    end
end

table.insert(Accent.hooks, function() Nav.paint() end)

function Nav.select(id)
    if Nav.current ~= id and Nav.current ~= "fps" then Nav.last = Nav.current end
    Nav.current = id
    Modal.close()
    UI.homePage.Visible = (id == "home")
    UI.logPage.Visible = (id == "log")
    UI.settingsPage.Visible = (id == "settings")
    UI.fpsPage.Visible = (id == "fps")
    UI.scriptsPage.Visible = not (id == "home" or id == "log" or id == "settings" or id == "fps")
    FPSPage.setActive(id == "fps")
    if id == "fps" then
        UI.pageTitle.Text = "Jczz FPS"
    elseif id == "home" then
        UI.pageTitle.Text = "Home"
        UI.refreshHome()
    elseif id == "settings" then
        UI.pageTitle.Text = "Settings"
    elseif id == "log" then
        UI.pageTitle.Text = "Execution Log"
    else
        Filter.category = id
        UI.pageTitle.Text = (id == "All") and "All Scripts" or id
        Filter.apply()
    end
    Nav.paint()
end

function Nav.build()
    for _, b in pairs(UI.navButtons) do b.Btn:Destroy() end
    UI.navButtons = {}
    Nav.buttonsById = UI.navButtons

    local defs = {
        { id = "home", label = "Home", icon = "🏠" },
        { id = "All", label = "All Scripts", icon = "📚" },
    }
    local present, used = {}, {}
    for _, e in ipairs(Scripts) do
        if e.Category then present[e.Category] = true end
    end
    for _, c in ipairs(Config.Categories) do
        if present[c] then
            table.insert(defs, { id = c, label = c, icon = Config.CategoryIcons[c] or "📁" })
            used[c] = true
        end
    end
    for c in pairs(present) do
        if not used[c] and c ~= "All" and c ~= "Favorites" then
            table.insert(defs, { id = c, label = c, icon = Config.CategoryIcons[c] or "📁" })
        end
    end
    table.insert(defs, { id = "Favorites", label = "Favorites", icon = "⭐" })
    table.insert(defs, { id = "settings", label = "Settings", icon = "⚙️" })
    table.insert(defs, { id = "log", label = "Log", icon = "📋" })

    local valid = {}
    for i, d in ipairs(defs) do
        valid[d.id] = true
        local btn = mk("TextButton", {
            Name = d.id, Text = "", Size = UDim2.new(1, 0, 0, 40), LayoutOrder = i,
            BackgroundColor3 = Theme.Card, BackgroundTransparency = 1,
        }, UI.nav)
        round(btn, 10)
        local bar = mk("Frame", {
            Size = UDim2.fromOffset(3, 18), Position = UDim2.new(0, 0, 0.5, -9),
            BackgroundColor3 = Theme.Accent, Visible = false,
        }, btn)
        round(bar, 2)
        mk("TextLabel", {
            Text = d.icon, TextSize = 17, TextXAlignment = Enum.TextXAlignment.Center,
            Position = UDim2.fromOffset(6, 0), Size = UDim2.new(0, 28, 1, 0),
        }, btn)
        local text = mk("TextLabel", {
            Text = d.label, TextSize = 14, TextColor3 = Theme.Dim, TextTruncate = Enum.TextTruncate.AtEnd,
            Position = UDim2.fromOffset(42, 0), Size = UDim2.new(1, -46, 1, 0),
        }, btn)
        UI.navButtons[d.id] = { Btn = btn, Bar = bar, Text = text }
        btn.Activated:Connect(function() Nav.select(d.id) end)
    end

    valid.fps = true
    if not valid[Nav.current] then Nav.current = "home" end
    Nav.paint()
end

----------------------------------------------------------------------
-- 16. INTERFACE
----------------------------------------------------------------------
function UI.setStatus(text, color)
    UI.statusText, UI.statusColor = text, color
    UI.refreshStatusText()
end

function UI.refreshStatusText()
    if not UI.chip then return end
    local hex = toHex(UI.statusColor or Theme.Good)
    UI.chip.Text = string.format('<font color="%s">● %s</font>', hex, UI.statusText)
end

function UI.refreshHome()
    if not UI.cardScripts then return end
    UI.cardScripts.Text = tostring(UI.count or 0)
    UI.cardFavs.Text = tostring(countFavs())
end

local function statCard(parent, title, value, order)
    local card = mk("Frame", { BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.12, LayoutOrder = order }, parent)
    round(card, 12)
    stroke(card, Theme.Stroke, 1, 0.5)
    mk("TextLabel", {
        Text = title, TextSize = 11, TextColor3 = Theme.Dim,
        Position = UDim2.fromOffset(12, 10), Size = UDim2.new(1, -24, 0, 14),
    }, card)
    return mk("TextLabel", {
        Text = value, Font = Enum.Font.GothamBold, TextSize = 15, TextTruncate = Enum.TextTruncate.AtEnd,
        TextColor3 = Theme.Accent,
        Position = UDim2.fromOffset(12, 30), Size = UDim2.new(1, -24, 0, 22),
    }, card)
end

function UI.makeItem(entry, index)
    local frame = mk("TextButton", {
        Name = entry.Name, Text = "", Size = UDim2.new(1, 0, 0, 56),
        BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.12, LayoutOrder = index,
    }, UI.list)
    round(frame, 12)
    stroke(frame, Theme.Stroke, 1, 0.5)
    local scale = mk("UIScale", { Scale = 1 }, frame)

    mk("TextLabel", {
        Text = entry.Icon or (entry.RequiresKey and "🔑" or "◈"), TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Center,
        Position = UDim2.fromOffset(8, 0), Size = UDim2.new(0, 34, 1, 0),
        TextColor3 = entry.RequiresKey and Theme.Key or Theme.Accent,
    }, frame)
    mk("TextLabel", {
        Text = entry.Name, Font = Enum.Font.GothamBold, TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(48, 9), Size = UDim2.new(1, -96, 0, 20),
    }, frame)
    local info = mk("TextLabel", {
        TextSize = 12, TextColor3 = Theme.Dim, TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(48, 30), Size = UDim2.new(1, -96, 0, 16),
    }, frame)
    local star = mk("TextButton", {
        Text = "☆", TextSize = 22, TextXAlignment = Enum.TextXAlignment.Center,
        BackgroundTransparency = 1, TextColor3 = Theme.Dim,
        Size = UDim2.fromOffset(38, 38), Position = UDim2.new(1, -44, 0.5, -19),
    }, frame)

    UI.items[entry] = { Frame = frame, Info = info, Star = star }
    Info.paint(entry)

    -- Feedback visual (mouse e toque)
    local pressed = false
    frame.MouseEnter:Connect(function()
        if not pressed then tween(frame, 0.1, { BackgroundColor3 = Theme.CardHover }) end
    end)
    frame.MouseLeave:Connect(function()
        pressed = false
        tween(frame, 0.15, { BackgroundColor3 = Theme.Card })
        tween(scale, 0.12, { Scale = 1 })
    end)
    frame.InputBegan:Connect(function(input)
        local t = input.UserInputType
        if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
            pressed = true
            tween(frame, 0.07, { BackgroundColor3 = Theme.CardPress })
            tween(scale, 0.07, { Scale = 0.975 })
        end
    end)
    frame.InputEnded:Connect(function(input)
        local t = input.UserInputType
        if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
            pressed = false
            tween(frame, 0.15, { BackgroundColor3 = (t == Enum.UserInputType.Touch) and Theme.Card or Theme.CardHover })
            tween(scale, 0.12, { Scale = 1 })
        end
    end)

    frame.Activated:Connect(function()
        if entry.Page then
            Log.add(entry.Name .. " aberto")
            Nav.select(entry.Page)
            return
        end
        if Loader.isBusy(entry) then return end
        Log.add(entry.Name .. " selected")
        if entry.RequiresKey then
            Modal.open(entry)
        else
            Loader.run(entry)
        end
    end)

    star.Activated:Connect(function()
        if Favs[entry.Name] then
            Favs[entry.Name] = nil
            Log.add(entry.Name .. " removido dos favoritos")
        else
            Favs[entry.Name] = true
            Log.add(entry.Name .. " adicionado aos favoritos")
        end
        Filter.apply()
        SaveSys.queue()
    end)
end

function UI.populate()
    for _, item in pairs(UI.items) do item.Frame:Destroy() end
    UI.items = {}
    local count = 0
    for i, entry in ipairs(Scripts) do
        if type(entry.Name) == "string" and type(entry.Loader) == "string" then
            entry.Category = entry.Category or "Scripts"
            UI.makeItem(entry, i)
            count = count + 1
        else
            Log.add("Entrada invalida ignorada (posicao " .. i .. ")", Theme.Bad)
        end
    end
    UI.count = count
    Nav.build()
    Nav.select(Nav.current)
end

----------------------------------------------------------------------
-- 15b. COMPONENTES REUTILIZAVEIS (cartoes, interruptores, seletores)
----------------------------------------------------------------------
H.painters = {}

function H.paintAll()
    for _, fn in ipairs(H.painters) do pcall(fn) end
end

function H.header(parent, text, order)
    local h = mk("Frame", {
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), LayoutOrder = order, ClipsDescendants = true,
    }, parent)
    mk("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder,
    }, h)
    mk("TextLabel", {
        Text = text, TextSize = 11, TextColor3 = Theme.Dim, LayoutOrder = 1,
        AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 16),
    }, h)
    mk("Frame", {
        Size = UDim2.fromOffset(700, 1), LayoutOrder = 2,
        BackgroundColor3 = Theme.Stroke, BackgroundTransparency = 0.2,
    }, h)
    return h
end

function H.card(parent, title, sub, order, height)
    local r = mk("Frame", {
        Size = UDim2.new(1, 0, 0, height or 52), BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.12, LayoutOrder = order,
    }, parent)
    round(r, 12)
    stroke(r, Theme.Stroke, 1, 0.5)
    local t = mk("TextLabel", {
        Text = title, Font = Enum.Font.GothamBold, TextSize = 14, TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -110, 0, 20),
    }, r)
    local s = mk("TextLabel", {
        Text = sub or "", TextSize = 11, TextColor3 = Theme.Dim, TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(14, 29), Size = UDim2.new(1, -110, 0, 16),
    }, r)
    return r, t, s
end

function H.switch(card, isOn, onClick)
    local track = mk("TextButton", {
        Text = "", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.fromOffset(46, 22), BackgroundColor3 = Theme.Stroke, _static = true,
    }, card)
    round(track, 11)
    local knob = mk("Frame", {
        Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(2, 2),
        BackgroundColor3 = Theme.Text, _static = true,
    }, track)
    round(knob, 9)
    local sw = { track = track }
    function sw.paint(animate)
        local on = isOn()
        local color = on and Theme.Accent or Theme.Stroke
        local pos = UDim2.fromOffset(on and 26 or 2, 2)
        if animate then
            tween(track, 0.12, { BackgroundColor3 = color })
            tween(knob, 0.12, { Position = pos })
        else
            track.BackgroundColor3 = color
            knob.Position = pos
        end
    end
    sw.paint(false)
    table.insert(Accent.hooks, function() sw.paint(false) end)
    table.insert(H.painters, function() sw.paint(false) end)
    track.Activated:Connect(function()
        onClick()
        sw.paint(true)
    end)
    return sw
end

function H.action(card, text, callback, width)
    local b = mk("TextButton", {
        Text = text, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center,
        BackgroundColor3 = Theme.Side, BackgroundTransparency = 0.1,
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.fromOffset(width or 74, 30),
    }, card)
    round(b, 8)
    stroke(b, Theme.Stroke, 1, 0.4)
    b.Activated:Connect(callback)
    return b
end

-- Cartao com seletor segmentado (ex.: 30 / 60 / 90 / 120 / Livre)
function H.segCard(parent, title, sub, order, options, isSel, onPick)
    local card, _, subLabel = H.card(parent, title, sub, order, 88)
    subLabel.Size = UDim2.new(1, -28, 0, 16)
    local row = mk("Frame", {
        BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 52), Size = UDim2.new(1, -28, 0, 28),
    }, card)
    mk("UIGridLayout", {
        CellSize = UDim2.new(1 / #options, -4, 1, 0), CellPadding = UDim2.fromOffset(4, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, row)
    local btns = {}
    local function paint()
        for i, b in ipairs(btns) do
            local sel = isSel(options[i].value)
            b.BackgroundColor3 = sel and Theme.Accent or Theme.Side
            b.TextColor3 = sel and Color3.fromRGB(25, 18, 8) or Theme.Text
        end
    end
    for i, o in ipairs(options) do
        local b = mk("TextButton", {
            Text = o.label, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center,
            BackgroundColor3 = Theme.Side, BackgroundTransparency = 0.1, LayoutOrder = i, _static = true,
        }, row)
        round(b, 8)
        btns[i] = b
        b.Activated:Connect(function()
            onPick(o.value)
            paint()
        end)
    end
    paint()
    table.insert(Accent.hooks, paint)
    table.insert(H.painters, paint)
    return card, paint, subLabel
end

----------------------------------------------------------------------
-- 15c. APARENCIA (aplica as configuracoes visuais do hub)
----------------------------------------------------------------------
function Appearance.sizeFactor()
    local m = Settings.PanelSize
    if m == "Compacto" then return 0.85 end
    if m == "Grande" then return 1.12 end
    return 1
end

Appearance.keyLabels = {
    RightShift = "RShift", RightControl = "RCtrl", Insert = "Insert", K = "K", F6 = "F6", Home = "Home",
}
Appearance.keyOrder = { "RightShift", "RightControl", "Insert", "K", "F6", "Home" }

function Appearance.ensureBg()
    if UI.bgAsset or UI.bgLoading or Settings.Background == false then return end
    UI.bgLoading = true
    task.spawn(function()
        local asset = loadBackground()
        UI.bgLoading = false
        if asset then
            UI.bgAsset = asset
            Appearance.apply(false)
        end
    end)
end

function Appearance.apply(animate)
    if not UI.panel then return end
    local useBg = Settings.Background ~= false and UI.bgAsset ~= nil
    if useBg and UI.bg.Image == "" then UI.bg.Image = UI.bgAsset end
    UI.bg.Visible = useBg
    UI.shade.BackgroundTransparency = useBg and (Settings.Dim or 0.45) or 0
    UI.toggle.Visible = (not IS_PC) or Settings.FloatingButton ~= false
    local key = Appearance.keyLabels[Settings.ToggleKey] or "RShift"
    UI.hint.Text = (IS_PC and (key .. "  ·  ou ") or "") .. "toque na pílula"
    if Settings.Background ~= false then Appearance.ensureBg() end
    Layout.apply(animate)
end

----------------------------------------------------------------------
-- 15d. PAGINA DO JCZZ FPS
----------------------------------------------------------------------
FPSPage.switches = {}
FPSPage.active = false

function FPSPage.repaint()
    for _, sw in pairs(FPSPage.switches) do sw.paint(false) end
    if FPSPage.sub and FPSPage.sub.Parent then
        local n, total = FPS.count()
        FPSPage.sub.Text = n == 0 and "Nenhuma otimização ativa" or (n .. " de " .. total .. " otimizações ativas")
    end
    if FPSPage.capPaint then FPSPage.capPaint() end
end

function FPSPage.setActive(on)
    on = on == true
    if on == FPSPage.active then return end
    FPSPage.active = on
    if FPSPage.conn then
        FPSPage.conn:Disconnect()
        FPSPage.conn = nil
    end
    if not on then return end
    FPSPage.repaint()
    local frames, last = 0, os.clock()
    FPSPage.conn = RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local now = os.clock()
        if now - last < 0.5 then return end
        local fps = math.floor(frames / (now - last) + 0.5)
        frames, last = 0, now
        if not (UI.panel and UI.panel.Visible) or Panel.minimized then return end
        FPSPage.vFPS.Text = tostring(fps)
        FPSPage.vFPS.TextColor3 = fps >= 50 and Theme.Good or (fps >= 30 and Theme.Warn or Theme.Bad)
        local ping, mem = FPS.ping(), FPS.memory()
        FPSPage.vPing.Text = ping and (ping .. " ms") or "--"
        FPSPage.vMem.Text = mem and (math.floor(mem) .. " MB") or "--"
    end)
end

function FPSPage.build(pages)
    local pg = mk("ScrollingFrame", {
        Name = "FPS", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Visible = false,
        ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
    }, pages)
    UI.fpsPage = pg
    mk("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, pg)
    mk("UIPadding", { PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 4) }, pg)

    local order = 0
    local function nextOrder()
        order = order + 1
        return order
    end

    -- Topo
    local hero = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 64), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.12,
        LayoutOrder = nextOrder(),
    }, pg)
    round(hero, 12)
    stroke(hero, Theme.Stroke, 1, 0.5)
    mk("TextLabel", {
        Text = "⚡", TextSize = 26, TextXAlignment = Enum.TextXAlignment.Center,
        Position = UDim2.fromOffset(8, 0), Size = UDim2.new(0, 40, 1, 0),
    }, hero)
    mk("TextLabel", {
        Text = "Jczz FPS", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Theme.Accent,
        Position = UDim2.fromOffset(54, 10), Size = UDim2.new(1, -150, 0, 20),
    }, hero)
    FPSPage.sub = mk("TextLabel", {
        Text = "", TextSize = 12, TextColor3 = Theme.Dim, TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(54, 32), Size = UDim2.new(1, -150, 0, 18),
    }, hero)
    local back = mk("TextButton", {
        Text = "‹ Voltar", Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center,
        BackgroundColor3 = Theme.Side, BackgroundTransparency = 0.1,
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(78, 30),
    }, hero)
    round(back, 8)
    stroke(back, Theme.Stroke, 1, 0.4)
    back.Activated:Connect(function() Nav.select(Nav.last or "Performance") end)

    -- Medidores ao vivo
    local grid = mk("Frame", {
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = nextOrder(),
    }, pg)
    mk("UIGridLayout", {
        CellSize = UDim2.new(1 / 3, -6, 0, 54), CellPadding = UDim2.fromOffset(8, 8), SortOrder = Enum.SortOrder.LayoutOrder,
    }, grid)
    FPSPage.vFPS = statCard(grid, "FPS", "--", 1)
    FPSPage.vPing = statCard(grid, "PING", "--", 2)
    FPSPage.vMem = statCard(grid, "MEMÓRIA", "--", 3)

    -- Predefinicoes
    H.header(pg, "PREDEFINIÇÕES", nextOrder())
    local pgrid = mk("Frame", {
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = nextOrder(),
    }, pg)
    mk("UIGridLayout", {
        CellSize = UDim2.new(0.5, -4, 0, 40), CellPadding = UDim2.fromOffset(8, 8), SortOrder = Enum.SortOrder.LayoutOrder,
    }, pgrid)
    local function gridButton(label, idx, callback)
        local b = mk("TextButton", {
            Text = label, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Center,
            BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.12, LayoutOrder = idx,
        }, pgrid)
        round(b, 10)
        stroke(b, Theme.Stroke, 1, 0.5)
        b.Activated:Connect(callback)
    end
    for i, p in ipairs(FPS.presets) do
        gridButton(p.icon .. "  " .. p.name, i, function()
            FPS.applyPreset(p.id)
            Log.add("Jczz FPS: predefinição " .. p.name)
            Notify.push("Predefinição " .. p.name .. " aplicada.", Theme.Good)
        end)
    end
    gridButton("🧹  Limpar memória", 5, function()
        task.spawn(function()
            local before, after = FPS.clean()
            Log.add("Jczz FPS: memória limpa")
            if before and after then
                Notify.push(string.format("Memória: %d → %d MB", before, after), Theme.Good)
            else
                Notify.push("Memória limpa.", Theme.Good)
            end
        end)
    end)
    gridButton("⛔  Desligar tudo", 6, function()
        FPS.disableAll()
        Log.add("Jczz FPS: tudo desligado")
        Notify.push("Otimizações desligadas e restauradas.", Theme.Warn)
    end)
    mk("TextLabel", {
        Text = "Leve: sombras e efeitos  ·  Médio: + materiais e malhas  ·  Ultra: + texturas e luzes  ·  Batata: tudo, até jogadores e som.",
        TextSize = 11, TextColor3 = Theme.Dim, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = nextOrder(),
    }, pg)

    -- Limite de FPS
    local capOptions = {}
    for _, c in ipairs(FPS.caps) do table.insert(capOptions, c) end
    local _, capPaint, capSub = H.segCard(pg, "Limite de FPS", "Quanto menor, menos esquenta e gasta bateria", nextOrder(),
        capOptions, function(v) return FPS.cap == v end,
        function(v)
            if not FPS.capSupported() then
                Notify.push("Seu executor não suporta limite de FPS.", Theme.Warn)
                return
            end
            FPS.setCap(v)
            Log.add("Jczz FPS: limite " .. (v == 0 and "livre" or tostring(v)))
        end)
    if not FPS.capSupported() then capSub.Text = "Seu executor não suporta setfpscap" end
    FPSPage.capPaint = capPaint

    -- Funcoes por grupo
    for _, g in ipairs(FPS.groups) do
        H.header(pg, g.title, nextOrder())
        for _, f in ipairs(FPS.features) do
            if f.group == g.id then
                local supported = FPS.isSupported(f.id)
                local card, title = H.card(pg, f.name, f.desc, nextOrder())
                if not supported then
                    title.Text = f.name .. " (indisponível)"
                    title.TextColor3 = Theme.Dim
                end
                local sw
                sw = H.switch(card, function() return FPS.isOn(f.id) end, function()
                    if not supported then
                        Notify.push(f.name .. ": seu executor não suporta.", Theme.Warn)
                        return
                    end
                    local turnOn = not FPS.isOn(f.id)
                    FPS.set({ [f.id] = turnOn })
                    Log.add("Jczz FPS: " .. f.name .. (turnOn and " ligado" or " desligado"))
                    if turnOn and f.note then Notify.push(f.note, Theme.Warn) end
                end)
                if not supported then sw.track.BackgroundTransparency = 0.6 end
                FPSPage.switches[f.id] = sw
            end
        end
    end

    table.insert(FPS.hooks, FPSPage.repaint)
    table.insert(Accent.hooks, FPSPage.repaint)
    FPSPage.repaint()
end

function UI.build(parent)
    local gui = mk("ScreenGui", {
        Name = "JczzAutomatic", ResetOnSpawn = false, DisplayOrder = 999,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = false,
    }, parent)
    UI.gui = gui
    local vp = Layout.viewport()

    -- Notificacoes
    UI.notifHolder = mk("Frame", {
        Name = "Notifications", BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 52), Size = UDim2.new(0, 280, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
    }, gui)
    mk("UIListLayout", {
        Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    }, UI.notifHolder)

    -- Botao principal (pilula)
    local toggle = mk("TextButton", {
        Name = "Toggle", Text = "👑  Jczz Automatic", Font = Enum.Font.GothamBold, TextSize = 13,
        TextColor3 = Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Center, BackgroundColor3 = Theme.Bg,
        Size = UDim2.fromOffset(160, 34), Position = UDim2.fromOffset(math.floor(vp.X / 2 - 80), 6),
    }, gui)
    round(toggle, 17)
    stroke(toggle, Theme.Accent, 1, 0.35)
    UI.toggle = toggle

    -- Painel
    local panel = mk("Frame", {
        Name = "Panel", BackgroundColor3 = Theme.Bg, Active = true, ClipsDescendants = true,
        Visible = false, Size = UDim2.fromOffset(520, 320), Position = UDim2.fromOffset(20, 60),
    }, gui)
    round(panel, 16)
    stroke(panel, Theme.Stroke, 1, 0.1)
    UI.panel = panel
    UI.scale = mk("UIScale", { Scale = 1 }, panel)

    -- Fundo: imagem (quando disponivel) + camada escura para legibilidade
    UI.bg = mk("ImageLabel", {
        Name = "Background", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
        ScaleType = Enum.ScaleType.Crop, Image = "", Visible = false,
    }, panel)
    round(UI.bg, 16)
    UI.shade = mk("Frame", { Name = "Shade", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Theme.Bg }, panel)
    round(UI.shade, 16)

    -- Barra lateral
    local sidebar = mk("Frame", {
        Name = "Sidebar", BackgroundColor3 = Theme.Side, BackgroundTransparency = 0.3,
        Size = UDim2.new(0, 150, 1, 0),
    }, panel)
    UI.sidebar = sidebar
    mk("Frame", {
        Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = Theme.Stroke, BackgroundTransparency = 0.3,
    }, sidebar)
    local brand = mk("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 58) }, sidebar)
    mk("TextLabel", {
        Text = "👑", TextSize = 26, TextXAlignment = Enum.TextXAlignment.Center,
        Position = UDim2.fromOffset(6, 8), Size = UDim2.fromOffset(40, 36),
    }, brand)
    UI.brandTitle = mk("TextLabel", {
        Text = Config.Name, Font = Enum.Font.GothamBold, TextSize = 14, TextTruncate = Enum.TextTruncate.AtEnd,
        TextColor3 = Theme.Accent, Position = UDim2.fromOffset(50, 10), Size = UDim2.new(1, -54, 0, 20),
    }, brand)
    UI.brandSub = mk("TextLabel", {
        Text = Config.Author, TextSize = 11, TextColor3 = Theme.Dim, TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(50, 30), Size = UDim2.new(1, -54, 0, 16),
    }, brand)

    UI.nav = mk("ScrollingFrame", {
        BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 62), Size = UDim2.new(1, 0, 1, -98),
        ScrollBarThickness = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
    }, sidebar)
    mk("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, UI.nav)
    mk("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, UI.nav)

    UI.hint = mk("TextLabel", {
        Text = "RShift  ·  or tap the pill", TextSize = 10, TextColor3 = Theme.Dim,
        Position = UDim2.new(0, 12, 1, -30), Size = UDim2.new(1, -16, 0, 24),
    }, sidebar)

    -- Area principal
    local main = mk("Frame", {
        Name = "Main", BackgroundTransparency = 1,
        Position = UDim2.new(0, 150, 0, 0), Size = UDim2.new(1, -150, 1, 0),
    }, panel)
    UI.main = main

    local topbar = mk("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, TOP_H) }, main)
    UI.pageTitle = mk("TextLabel", {
        Text = "Home", Font = Enum.Font.GothamBold, TextSize = 18, TextTruncate = Enum.TextTruncate.AtEnd,
        TextColor3 = Theme.Accent,
        Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -196, 1, 0),
    }, topbar)
    UI.chip = mk("TextLabel", {
        RichText = true, Text = "", TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right,
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -88, 0.5, 0), Size = UDim2.fromOffset(84, 22),
    }, topbar)
    UI.minBtn = mk("TextButton", {
        Text = "–", Font = Enum.Font.GothamBold, TextSize = 18, BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.2, TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.fromOffset(34, 34), Position = UDim2.new(1, -80, 0, 8),
    }, topbar)
    round(UI.minBtn, 10)
    UI.closeBtn = mk("TextButton", {
        Text = "X", Font = Enum.Font.GothamBold, TextSize = 14, BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.2, TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.fromOffset(34, 34), Position = UDim2.new(1, -42, 0, 8),
    }, topbar)
    round(UI.closeBtn, 10)

    UI.pages = mk("Frame", {
        Name = "Pages", BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, TOP_H + 2), Size = UDim2.new(1, -24, 1, -(TOP_H + 12)),
    }, main)

    -- Pagina: Home
    local home = mk("ScrollingFrame", {
        Name = "Home", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
        ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
    }, UI.pages)
    UI.homePage = home
    mk("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }, home)
    mk("UIPadding", { PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 4) }, home)

    local lp = Players.LocalPlayer
    local welcome = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 68), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.12, LayoutOrder = 1,
    }, home)
    round(welcome, 12)
    stroke(welcome, Theme.Stroke, 1, 0.5)
    local avatar = mk("ImageLabel", {
        BackgroundColor3 = Theme.Side, Size = UDim2.fromOffset(46, 46), Position = UDim2.fromOffset(12, 11),
        Image = lp and string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", lp.UserId) or "",
    }, welcome)
    round(avatar, 23)
    local hour = tonumber(os.date("%H")) or 12
    local greeting = hour < 12 and "Good morning." or (hour < 18 and "Good afternoon." or "Good evening.")
    mk("TextLabel", {
        Text = "Welcome back, " .. (lp and lp.DisplayName or "player"), Font = Enum.Font.GothamBold, TextSize = 15,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(70, 12), Size = UDim2.new(1, -80, 0, 22),
    }, welcome)
    mk("TextLabel", {
        Text = greeting, TextSize = 13, TextColor3 = Theme.Dim,
        Position = UDim2.fromOffset(70, 36), Size = UDim2.new(1, -80, 0, 18),
    }, welcome)

    local sec = mk("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), LayoutOrder = 2 }, home)
    mk("TextLabel", {
        Text = "SESSION", TextSize = 11, TextColor3 = Theme.Dim, Size = UDim2.fromOffset(64, 16),
    }, sec)
    mk("Frame", {
        Position = UDim2.new(0, 66, 0.5, 0), Size = UDim2.new(1, -66, 0, 1),
        BackgroundColor3 = Theme.Stroke, BackgroundTransparency = 0.2,
    }, sec)

    local grid = mk("Frame", {
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 3,
    }, home)
    mk("UIGridLayout", {
        CellSize = UDim2.new(0.5, -4, 0, 60), CellPadding = UDim2.fromOffset(8, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, grid)
    UI.cardScripts = statCard(grid, "Scripts", "0", 1)
    UI.cardFavs = statCard(grid, "Favorites", "0", 2)
    UI.cardGame = statCard(grid, "Game", tostring(game.Name), 3)
    local execName = "Unknown"
    pcall(function()
        if identifyexecutor then execName = tostring((identifyexecutor())) end
    end)
    statCard(grid, "Executor", execName, 4)

    -- Pagina: lista de scripts
    local sp = mk("Frame", { Name = "Scripts", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Visible = false }, UI.pages)
    UI.scriptsPage = sp
    local searchBox = mk("Frame", {
        Size = UDim2.new(1, -44, 0, 36), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.12,
    }, sp)
    round(searchBox, 10)
    stroke(searchBox, Theme.Stroke, 1, 0.5)
    mk("TextLabel", {
        Text = "🔎", TextSize = 14, TextXAlignment = Enum.TextXAlignment.Center,
        Position = UDim2.fromOffset(6, 0), Size = UDim2.new(0, 24, 1, 0),
    }, searchBox)
    UI.search = mk("TextBox", {
        Text = "", PlaceholderText = "Search scripts...", PlaceholderColor3 = Theme.Dim,
        ClearTextOnFocus = false, TextSize = 14, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(34, 0), Size = UDim2.new(1, -40, 1, 0),
    }, searchBox)
    local refresh = mk("TextButton", {
        Text = "↻", Font = Enum.Font.GothamBold, TextSize = 20, BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.12, TextXAlignment = Enum.TextXAlignment.Center,
        Position = UDim2.new(1, -36, 0, 0), Size = UDim2.fromOffset(36, 36),
    }, sp)
    round(refresh, 10)
    stroke(refresh, Theme.Stroke, 1, 0.5)

    UI.list = mk("ScrollingFrame", {
        BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 44), Size = UDim2.new(1, 0, 1, -44),
        ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
        ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
    }, sp)
    mk("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, UI.list)
    mk("UIPadding", { PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 4) }, UI.list)
    UI.empty = mk("TextLabel", {
        Text = "No scripts found", TextColor3 = Theme.Dim, TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.new(1, 0, 0, 60), LayoutOrder = 99999, Visible = false,
    }, UI.list)

    -- Pagina: log
    local lg = mk("Frame", { Name = "Log", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Visible = false }, UI.pages)
    UI.logPage = lg
    local clearBtn = mk("TextButton", {
        Text = "Clear Log", Font = Enum.Font.GothamBold, TextSize = 12, BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.12, TextXAlignment = Enum.TextXAlignment.Center,
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.fromOffset(90, 30),
    }, lg)
    round(clearBtn, 10)
    stroke(clearBtn, Theme.Stroke, 1, 0.5)
    local logBox = mk("Frame", {
        Position = UDim2.fromOffset(0, 38), Size = UDim2.new(1, 0, 1, -38),
        BackgroundColor3 = Theme.Side, BackgroundTransparency = 0.25,
    }, lg)
    round(logBox, 12)
    stroke(logBox, Theme.Stroke, 1, 0.5)
    UI.logList = mk("ScrollingFrame", {
        BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 8), Size = UDim2.new(1, -20, 1, -16),
        ScrollBarThickness = 2, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
    }, logBox)
    local logLayout = mk("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, UI.logList)
    logLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        UI.logList.CanvasPosition = Vector2.new(0, math.max(0, logLayout.AbsoluteContentSize.Y))
    end)

    FPSPage.build(UI.pages)

    -- Pagina: configuracoes
    local st = mk("ScrollingFrame", {
        Name = "Settings", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Visible = false,
        ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
    }, UI.pages)
    UI.settingsPage = st
    mk("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }, st)
    mk("UIPadding", { PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 4) }, st)

    local function sectionHeader(text, order)
        local h = mk("Frame", {
            BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), LayoutOrder = order, ClipsDescendants = true,
        }, st)
        mk("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8),
            VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder,
        }, h)
        mk("TextLabel", {
            Text = text, TextSize = 11, TextColor3 = Theme.Dim, LayoutOrder = 1,
            AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 16),
        }, h)
        mk("Frame", {
            Size = UDim2.fromOffset(700, 1), LayoutOrder = 2,
            BackgroundColor3 = Theme.Stroke, BackgroundTransparency = 0.2,
        }, h)
    end

    local function settingRow(order, title, sub)
        local r = mk("Frame", {
            Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.12, LayoutOrder = order,
        }, st)
        round(r, 12)
        stroke(r, Theme.Stroke, 1, 0.5)
        mk("TextLabel", {
            Text = title, Font = Enum.Font.GothamBold, TextSize = 14, TextTruncate = Enum.TextTruncate.AtEnd,
            Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -110, 0, 20),
        }, r)
        mk("TextLabel", {
            Text = sub, TextSize = 11, TextColor3 = Theme.Dim, TextTruncate = Enum.TextTruncate.AtEnd,
            Position = UDim2.fromOffset(14, 29), Size = UDim2.new(1, -110, 0, 16),
        }, r)
        return r
    end

    local function actionButton(row, text, callback)
        local b = mk("TextButton", {
            Text = text, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center,
            BackgroundColor3 = Theme.Side, BackgroundTransparency = 0.1,
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(74, 30),
        }, row)
        round(b, 8)
        stroke(b, Theme.Stroke, 1, 0.4)
        b.Activated:Connect(callback)
    end

    -- Aparencia: cor de destaque
    sectionHeader("APARÊNCIA", 1)
    mk("TextLabel", {
        Text = "Cor de destaque: toque numa cor para trocar os destaques. O fundo não muda.",
        TextSize = 12, TextColor3 = Theme.Dim, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
        Size = UDim2.new(1, 0, 0, 32), LayoutOrder = 2,
    }, st)
    local swGrid = mk("Frame", {
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 3,
    }, st)
    mk("UIGridLayout", {
        CellSize = UDim2.new(0.5, -4, 0, 40), CellPadding = UDim2.fromOffset(8, 8), SortOrder = Enum.SortOrder.LayoutOrder,
    }, swGrid)

    local swatches = {}
    local function paintSwatches()
        for name, sw in pairs(swatches) do
            local sel = (name == Settings.AccentName)
            sw.Check.Visible = sel
            sw.Ring.Color = sel and Theme.Text or Theme.Stroke
            sw.Ring.Transparency = sel and 0.1 or 0.5
        end
    end
    for i, c in ipairs(AccentColors) do
        local btn = mk("TextButton", {
            Text = "", BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.12, LayoutOrder = i,
        }, swGrid)
        round(btn, 10)
        local ring = stroke(btn, Theme.Stroke, 1, 0.5)
        local dot = mk("Frame", {
            BackgroundColor3 = c[2], Size = UDim2.fromOffset(18, 18), Position = UDim2.new(0, 12, 0.5, -9), _static = true,
        }, btn)
        round(dot, 9)
        mk("TextLabel", {
            Text = c[1], Font = Enum.Font.GothamBold, TextSize = 13,
            Position = UDim2.fromOffset(40, 0), Size = UDim2.new(1, -76, 1, 0),
        }, btn)
        local check = mk("TextLabel", {
            Text = "✓", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = c[2], TextXAlignment = Enum.TextXAlignment.Right,
            Position = UDim2.new(1, -34, 0, 0), Size = UDim2.fromOffset(24, 40), Visible = false, _static = true,
        }, btn)
        swatches[c[1]] = { Ring = ring, Check = check }
        btn.Activated:Connect(function()
            Accent.set(c[1])
            paintSwatches()
            Log.add("Accent color: " .. c[1])
        end)
    end
    paintSwatches()
    table.insert(Accent.hooks, paintSwatches)

    local so = 3
    local function nso()
        so = so + 1
        return so
    end

    local function switchRow(title, sub, key, default, after)
        local card = H.card(st, title, sub, nso())
        H.switch(card, function()
            local v = Settings[key]
            if v == nil then v = default end
            return v == true
        end, function()
            local v = Settings[key]
            if v == nil then v = default end
            Settings[key] = not v
            if after then after() end
            SaveSys.queue()
        end)
        return card
    end

    local function dimIs(v) return math.abs((Settings.Dim or 0.45) - v) < 0.01 end

    -- Aparencia (continuacao)
    do
        local card = H.card(st, "Hub leve", "Sem fundo e sem animações: ideal para celular fraco", nso())
        H.switch(card, function()
            return Settings.Background == false and Settings.Animations == false
        end, function()
            local light = not (Settings.Background == false and Settings.Animations == false)
            Settings.Background = not light
            Settings.Animations = not light
            Appearance.apply(false)
            H.paintAll()
            SaveSys.queue()
        end)
    end
    switchRow("Imagem de fundo", "Desligue para economizar memória", "Background", true, function()
        Appearance.apply(false)
    end)
    H.segCard(st, "Escurecimento do fundo", "Quanto mais forte, mais fácil de ler", nso(), {
        { label = "Leve", value = 0.6 }, { label = "Médio", value = 0.45 }, { label = "Forte", value = 0.25 },
    }, dimIs, function(v)
        Settings.Dim = v
        Appearance.apply(false)
        SaveSys.queue()
    end)
    H.segCard(st, "Tamanho do painel", "Compacto ocupa menos tela", nso(), {
        { label = "Compacto", value = "Compacto" }, { label = "Normal", value = "Normal" },
        { label = "Grande", value = "Grande" },
    }, function(v) return (Settings.PanelSize or "Normal") == v end, function(v)
        Settings.PanelSize = v
        Layout.centerPanel()
        Appearance.apply(true)
        SaveSys.queue()
    end)
    switchRow("Animações", "Transições suaves de abrir, fechar e trocar cor", "Animations", true)
    if IS_PC then
        switchRow("Botão flutuante", "Mostra a pílula no topo da tela", "FloatingButton", true, function()
            Appearance.apply(false)
        end)
    end

    -- Geral
    H.header(st, "GERAL", nso())
    switchRow("Notificações", "Avisos ao executar scripts", "Notifications", true)
    switchRow("Abrir ao iniciar", "Mostra o painel assim que o hub carrega", "StartOpen", true)
    if IS_PC then
        local keyCard, _, keySub = H.card(st, "Tecla para abrir", "", nso())
        local keyBtn
        local function paintKey()
            local name = Settings.ToggleKey or "RightShift"
            keySub.Text = "Atalho atual: " .. name
            if keyBtn then keyBtn.Text = Appearance.keyLabels[name] or name end
        end
        keyBtn = H.action(keyCard, "", function()
            local cur = Settings.ToggleKey or "RightShift"
            local idx = table.find(Appearance.keyOrder, cur) or 0
            Settings.ToggleKey = Appearance.keyOrder[(idx % #Appearance.keyOrder) + 1]
            paintKey()
            Appearance.apply(false)
            SaveSys.queue()
            Log.add("Tecla do hub: " .. Settings.ToggleKey)
        end, 84)
        paintKey()
        table.insert(H.painters, paintKey)
    end
    H.action(H.card(st, "Posição da janela", "Volta o painel para o centro", nso()), "Centralizar", function()
        Layout.centerPanel()
        Layout.apply(false)
        Log.add("Posicao da janela redefinida")
    end, 92)
    H.action(H.card(st, "Favoritos", "Remove todos os scripts marcados", nso()), "Limpar", function()
        for k in pairs(Favs) do Favs[k] = nil end
        Filter.apply()
        SaveSys.queue()
        Log.add("Favoritos limpos")
        Notify.push("Favoritos limpos.", Theme.Good)
    end)

    -- Jczz FPS
    H.header(st, "JCZZ FPS", nso())
    switchRow("Aplicar ao iniciar", "Reaplica suas otimizações toda vez que o hub abrir", "AutoFPS", false)
    H.action(H.card(st, "Otimizações", "Desliga e restaura tudo que o Jczz FPS mudou", nso()), "Desligar", function()
        FPS.disableAll()
        Log.add("Jczz FPS: tudo desligado")
        Notify.push("Otimizações desligadas e restauradas.", Theme.Warn)
    end)

    -- Dados
    H.header(st, "DADOS", nso())
    switchRow("Salvar configurações", "Guarda tudo em arquivo para a próxima vez", "SaveToFile", true)
    H.action(H.card(st, "Restaurar padrões", "Volta todas as configurações ao original", nso()), "Restaurar", function()
        local favs = Settings.Favorites
        for k in pairs(Settings) do Settings[k] = nil end
        SaveSys.fill(Settings)
        if favs then Settings.Favorites = favs end
        Accent.set(Settings.AccentName)
        Layout.centerPanel()
        Appearance.apply(false)
        H.paintAll()
        SaveSys.queue()
        Log.add("Configuracoes restauradas")
        Notify.push("Configurações restauradas.", Theme.Good)
    end)
    H.action(H.card(st, "Fechar o hub", "Remove a janela (as otimizações continuam ativas)", nso()), "Fechar", function()
        if genv and genv.JczzAutomaticKeyConn then
            pcall(function() genv.JczzAutomaticKeyConn:Disconnect() end)
        end
        FPSPage.setActive(false)
        gui:Destroy()
    end)

    -- Sobre
    H.header(st, "SOBRE", nso())
    H.card(st, Config.Name, Config.Author, nso())
    local execName = "Desconhecido"
    pcall(function()
        if identifyexecutor then execName = tostring((identifyexecutor())) end
    end)
    local canSave = typeof(writefile) == "function" and typeof(readfile) == "function"
    H.card(st, "Executor: " .. execName, canSave and "Salvar arquivos: disponível" or "Salvar arquivos: indisponível", nso())

    -- Modal de key (dentro do painel, acima de tudo)
    UI.keyOverlay = mk("Frame", {
        Name = "KeyOverlay", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.35, Active = true, Visible = false, ZIndex = 50,
    }, panel)
    local box = mk("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -28, 0, 176), BackgroundColor3 = Theme.Bg,
    }, UI.keyOverlay)
    round(box, 14)
    stroke(box, Theme.Accent, 1, 0.3)
    mk("UISizeConstraint", { MaxSize = Vector2.new(320, 176) }, box)
    UI.keyTitle = mk("TextLabel", {
        Text = "Air Flow", Font = Enum.Font.GothamBold, TextSize = 16,
        Position = UDim2.fromOffset(14, 10), Size = UDim2.new(1, -28, 0, 22),
    }, box)
    mk("TextLabel", {
        Text = "Este script necessita de uma key.", TextSize = 12, TextColor3 = Theme.Dim,
        Position = UDim2.fromOffset(14, 34), Size = UDim2.new(1, -28, 0, 18),
    }, box)
    local keyWrap = mk("Frame", {
        Position = UDim2.fromOffset(14, 60), Size = UDim2.new(1, -28, 0, 38), BackgroundColor3 = Theme.Side,
    }, box)
    round(keyWrap, 10)
    stroke(keyWrap, Theme.Stroke, 1, 0.4)
    UI.keyBox = mk("TextBox", {
        Text = "", PlaceholderText = "Digite sua key...", PlaceholderColor3 = Theme.Dim,
        ClearTextOnFocus = false, TextSize = 14, BackgroundTransparency = 1, TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -20, 1, 0),
    }, keyWrap)
    UI.keyHint = mk("TextLabel", {
        Text = "", TextSize = 11, TextColor3 = Theme.Bad,
        Position = UDim2.fromOffset(14, 101), Size = UDim2.new(1, -28, 0, 14),
    }, box)
    local cancel = mk("TextButton", {
        Text = "Cancelar", Font = Enum.Font.GothamBold, TextSize = 13, BackgroundColor3 = Theme.Card,
        TextXAlignment = Enum.TextXAlignment.Center,
        Position = UDim2.new(0, 14, 1, -50), Size = UDim2.new(0.5, -19, 0, 38),
    }, box)
    round(cancel, 10)
    local confirm = mk("TextButton", {
        Text = "Confirmar", Font = Enum.Font.GothamBold, TextSize = 13, BackgroundColor3 = Theme.Accent,
        TextColor3 = Color3.fromRGB(25, 18, 8), TextXAlignment = Enum.TextXAlignment.Center,
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 1, -50), Size = UDim2.new(0.5, -19, 0, 38),
    }, box)
    round(confirm, 10)

    -- Eventos
    local toggleDrag = Drag.make(toggle, toggle)
    Drag.make(brand, panel)
    Drag.make(topbar, panel)

    toggle.Activated:Connect(function()
        if toggleDrag.moved then toggleDrag.moved = false return end
        Panel.toggle()
    end)
    UI.closeBtn.Activated:Connect(Panel.hide)
    UI.minBtn.Activated:Connect(function() Panel.setMinimized(not Panel.minimized) end)

    UI.search:GetPropertyChangedSignal("Text"):Connect(function()
        Filter.query = trim(UI.search.Text):lower()
        Filter.apply()
    end)

    refresh.Activated:Connect(function()
        UI.populate()
        Log.add("Lista atualizada (" .. tostring(UI.count) .. " scripts)")
    end)
    clearBtn.Activated:Connect(Log.clear)

    confirm.Activated:Connect(Modal.confirm)
    cancel.Activated:Connect(Modal.cancel)
    UI.keyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then Modal.confirm() end
    end)

    gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() Layout.apply(false) end)
end

----------------------------------------------------------------------
-- 17. INICIALIZACAO
----------------------------------------------------------------------
local function resolveParent()
    local ok, hui = pcall(function() return gethui and gethui() end)
    if ok and typeof(hui) == "Instance" then return hui end
    local okCore = pcall(function()
        local t = Instance.new("Folder")
        t.Parent = CoreGui
        t:Destroy()
    end)
    if okCore then return CoreGui end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local parent = resolveParent()
local old = parent:FindFirstChild("JczzAutomatic")
if old then old:Destroy() end
if genv and genv.JczzAutomaticKeyConn then
    pcall(function() genv.JczzAutomaticKeyConn:Disconnect() end)
end

if FPS.oldShutdown then pcall(FPS.oldShutdown) end

UI.build(parent)

-- posicao inicial do painel centralizada
Layout.centerPanel()

UI.populate()
Layout.apply(false)
Appearance.apply(false)
Status.refresh()
Log.add("Jczz Automatic initialized")
if Settings.StartOpen ~= false then Panel.show() end
if Settings.AutoFPS then task.spawn(FPS.autoApply) end

-- Atalho de teclado (PC)
local keyConn = UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode.Name == (Settings.ToggleKey or "RightShift") then Panel.toggle() end
end)
if genv then genv.JczzAutomaticKeyConn = keyConn end

-- Nome do jogo (pode demorar, entao roda em segundo plano)
task.spawn(function()
    local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
    if ok and info and info.Name and UI.cardGame and UI.cardGame.Parent then
        UI.cardGame.Text = info.Name
    end
end)

-- Fundo (grava a imagem uma vez e aplica; sem suporte do executor fica cor lisa)
Appearance.ensureBg()
