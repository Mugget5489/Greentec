-- GREENTEC Studio Facility Bootstrap
-- Safe bootstrap foundation: records identity and verifies repository connectivity.
-- It does not invoke machine-control peripheral methods.
local FACILITY_ID="6b10415d-abbf-4a8e-b194-7ec9f07bf21e"
local FACILITY_NAME="GREENTEC facility"
local NODE_ID="71a0d313-88f4-4779-a6a1-d36e4fa04f4e"
local NODE_NAME="CORE-3"
local NODE_TYPE="core"
local REPOSITORY="https://mugget5489.github.io/Greentec"

local function writeIdentity()
  if settings then
    settings.set("greentec.facility_id", FACILITY_ID)
    settings.set("greentec.facility_name", FACILITY_NAME)
    settings.set("greentec.node_id", NODE_ID)
    settings.set("greentec.node_name", NODE_NAME)
    settings.set("greentec.node_type", NODE_TYPE)
    settings.set("greentec.repository", REPOSITORY)
    pcall(settings.save)
  end
  if os.setComputerLabel and NODE_NAME ~= "" then pcall(os.setComputerLabel, NODE_NAME) end
end

local function repositoryCheck()
  if REPOSITORY == "" then return false, "OFFLINE // no repository URL configured" end
  if not http then return false, "HTTP API unavailable on this server" end
  local url=REPOSITORY.."/index.json"
  if http.checkURL then
    local allowed,reason=http.checkURL(url)
    if not allowed then return false, "URL blocked: "..tostring(reason) end
  end
  local response,err=http.get(url)
  if not response then return false, "Repository request failed: "..tostring(err) end
  local body=response.readAll(); response.close()
  if not textutils or not textutils.unserializeJSON then return true, "ONLINE // index downloaded" end
  local data=textutils.unserializeJSON(body)
  if type(data)~="table" then return false, "Repository response was not valid JSON" end
  if data.facilityId and data.facilityId~=FACILITY_ID then return false, "Repository belongs to another facility" end
  return true, "ONLINE // latest "..tostring(data.latest or "none")
end

writeIdentity()
term.clear(); term.setCursorPos(1,1)
print("GREENTEC FACILITY BOOTSTRAP")
print("FACILITY: "..FACILITY_NAME)
print("FACILITY ID: "..FACILITY_ID)
print("NODE: "..NODE_NAME.." // "..NODE_TYPE)
print("NODE UUID: "..NODE_ID)
print("CC ID: "..tostring(os.getComputerID and os.getComputerID() or "unknown"))
print("")
local online,message=repositoryCheck()
print("REPOSITORY: "..message)
print("")
if online then
  print("BOOTSTRAP READY // identity saved")
else
  print("BOOTSTRAP READY // offline mode")
end
print("Studio can now deploy the full node runtime when the world is closed.")
