module DarkTracks

export main

using FFmpegPipe, OnlineStats, Statistics, IdentityRanges, Dates, Images, Unitful, JSON, DelimitedFiles#, Printf, , ImageDraw


function lastframe(videofile)
    str = read(`ffprobe -show_streams -of json -v quiet -i $videofile`, String)
    jsn = JSON.parse(str)
    stream = findfirst(x -> x["codec_type"] == "video", jsn["streams"])
    txt = jsn["streams"][stream]["nb_frames"]
    parse(Int, txt)
end

function getdimensions(videofile, start_frame, stop_frame)
    str = read(`ffprobe -show_streams -of json -v quiet -i $videofile`, String)
    jsn = JSON.parse(str)
    stream = findfirst(x -> x["codec_type"] == "video", jsn["streams"])
    txt = jsn["streams"][stream]["r_frame_rate"]
    m = match(r"(\d*)/(\d*)", txt)
    f, s = parse.(Int, m.captures)
    fps₀ = f/(s*Unitful.s)
    w₀ = jsn["streams"][stream]["width"]
    h₀ = jsn["streams"][stream]["height"]
    start_second = ustrip(start_frame/fps₀)
    duration_second = ustrip((stop_frame - start_frame)/fps₀)
    w₀, h₀, fps₀, start_second, duration_second
end

function warpdimensions(w₀, h₀, fps₀, spatialscale, temporalscale)
    w, h = round.(Int, [w₀, h₀]./spatialscale)
    fps = round(Int, ustrip(fps₀)/temporalscale)
    w, h, fps
end

function detectnext(r, img, noise, ind)
    rows = IdentityRange((-r:r) .+ ind[1])
    cols = IdentityRange((-r:r) .+ ind[2])
    pimg = padarray(img, Fill(zero(img[1]), (r, r)))
    roi = @view pimg[rows, cols]
    M, ind = findmax(roi)
    M > noise[ind] ? ind : missing
end

function detectfirst(vi, noise, sz, n)
    ind₀ = round.(Int, sz./2)
    r₀ = min(sz...) ÷ 11
    for i in 1:n
        img = readframe(vi)
        ind = detectnext(r₀, img, noise, ind₀)
        if !ismissing(ind)
            return i, ind
        end
    end
    error("failed to detect the beetle's initial starting point!")
end

function track(r₀, vi, noise, n, sz)
    inds = Vector{Union{Missing, CartesianIndex{2}}}(missing, n)
    i1, ind = detectfirst(vi, noise, sz, n)
    inds[i1] = ind
    r = copy(r₀)
    for i in i1+1:n
        img = readframe(vi)
        inds[i] = detectnext(r, img, noise, inds[findlast(!ismissing, inds)])
        if ismissing(inds[i])
            r += r₀
        else
            r = copy(r₀)
        end
    end
    inds
end

function savedata(videofile, ts, inds)
    path, nameext = splitdir(videofile)
    name, _ = splitext(nameext)
    csvname = joinpath(path, "$name.csv")
    xs = ["x"; getindex.(inds, 1)]
    ys = ["y"; getindex.(inds, 2)]
    writedlm(csvname, zip(["seconds"; ts], xs, ys))
end

#=function drawit(videofile, n, inds, imgs)
    path, nameext = splitdir(videofile)
    name, _ = splitext(nameext)
    imgs2 = joinpath(path, name)
    mkpath(imgs2)
    rm.(joinpath.(imgs2, readdir(imgs2)))
    for (i, ind, img) in zip(1:n, inds, imgs)
        img2 = RGB.(img)
        if !ismissing(ind)
            draw!(img2, CirclePointRadius(ind, 2), RGB(1,0,0))
        end
        save(joinpath(imgs2, @sprintf "%06i.png" i), img2)
    end
    run(`ffmpeg -y -framerate 25 -i $(joinpath(imgs2, "%06d.png")) $(joinpath(imgs2, "0.mp4"))`)
end=#

function getnoise(sz, videofile, start_second, duration_second)
    h, w = sz
    o = [Mean() for i in 1:h, j in 1:w]
    nframes = 9
    vi = openvideo(videofile, "r", ss_in = start_second, t = duration_second, r = nframes/duration_second, s = string(w, "x", h), pix_fmt = "gray")
    for i in 1:nframes
        img = readframe(vi)
        for j in eachindex(img)
            fit!(o[j], Float64(img[j]))
        end
    end
    close(vi)
    2value.(o)
end

getradius(sscale, tscale) = 10exp(-1.020819402836599log(sscale) + 0.7668247162044156log(tscale) + 0.8641290371601322)

"""
    seconds, coordinates = main(videofile; start_frame = 1, stop_frame = lastframe(videofile),  spatialscale = 10, temporalscale = 10)

Track a bright spot in a dim video file, `videofile`. Optionally give a frame number to start at, `start_frame`, and stop, `stop_frame`. These default to the beginning and ending of the video file. `spatialscale` and `temporalscale` help subsample the video for faster processing. When these equal 1 then there is no sub-sampling and the video is processed in original spatial and temporal resolutions. For example, for scaling the frame by half its original size and sampling every second frame use `spatialscale = 2, temporalscale = 2`. A default value of 10 for both works well.

# Return variables
`seconds` is a `Vector{Float64}` of times in second for each of the `coordinates` (itself a `Vector{Tuple{Int, Int}}`).  


# Examples

```jldoctest; setup = :(using DarkTracks; videofile = abspath(joinpath(dirname(pathof(DarkTracks)), "..", "test", "testvideo.mp4")))
julia> main(videofile, stop_frame = 100, spatialscale = 10)
([1.32, 1.54, 1.76, 1.98], Tuple{Int64,Int64}[(510, 730), (520, 730), (520, 730), (520, 730)])

```


"""
function main(videofile; start_frame = 1, stop_frame = lastframe(videofile),  spatialscale = 10, temporalscale = 10)
    w₀, h₀, fps₀, start_second, duration_second = getdimensions(videofile, start_frame, stop_frame)
    w, h, fps = warpdimensions(w₀, h₀, fps₀, spatialscale, temporalscale)
    sz = (h, w)
    n = round(Int, duration_second*fps)
    ts = range(0, stop = duration_second, length = n)
    r₀ = round(Int, getradius(spatialscale, temporalscale))
    noise = getnoise(sz, videofile, start_second, duration_second)
    vi = openvideo(videofile, "r", ss_in = start_second, t = duration_second, r = fps, s = string(w, "x", h), pix_fmt = "gray")
    inds = track(r₀, vi, noise, n, sz)
    close(vi)

    tss = [t for (t, ind) in zip(ts, inds) if !ismissing(ind)]
    indss = [spatialscale.*Tuple(ind) for ind in inds if !ismissing(ind)]
    savedata(videofile, tss, indss)
    tss, indss
    # drawit(videofile, n, inds, imgs)
end


end # module
