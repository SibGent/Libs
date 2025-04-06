local M = {}

local soundHandle
local musicPathList
local musicHandle
local musicChannels
local canPlayMusic
local canPlaySound

local loadMusicList
, loadSoundList


function M.init(options)
    soundHandle = {}
    musicPathList = {}
    musicHandle = {}
    musicChannels = {}
    canPlayMusic = options.canPlayMusic
    canPlaySound = options.canPlaySound

    loadMusicList(options.musicList)
    loadSoundList(options.soundList)
end


function M.enableMusic(isEnabled)
    canPlayMusic = isEnabled
end


function M.enableSound(isEnabled)
    canPlaySound = isEnabled
end


function M.playMusic(musicId, options)
    if canPlayMusic then
        local musicPath = musicPathList[musicId]

        if musicHandle[musicId] then
            audio.stop(musicChannels[musicId])
            audio.dispose(musicHandle[musicId])
            musicHandle[musicId] = nil
        end

        musicHandle[musicId] = audio.loadStream(musicPath)
        musicChannels[musicId] = audio.play(musicHandle[musicId], options)
    end
end


function M.stopMusic(channelId)
    audio.stop(musicChannels[channelId])
end


function M.pauseMusic(channelId)
    audio.pause(musicChannels[channelId])
end


function M.resumeMusic(channelId)
    audio.resume(musicChannels[channelId])
end


function M.playSound(soundId)
    if canPlaySound then
        audio.play(soundHandle[soundId])
    end
end


-- private
function loadMusicList(musicList)
    if not musicList then
        return
    end

    for musicId, musicPath in pairs(musicList) do
        if not musicPathList[musicId] then
            musicPathList[musicId] = musicPath
        end
    end
end

function loadSoundList(soundList)
    if not soundList then
        return
    end

    for soundId, soundPath in pairs(soundList) do
        if not soundHandle[soundId] then
            soundHandle[soundId] = audio.loadSound(soundPath)
        end
    end
end

return M
