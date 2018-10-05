module DarkTracks

export main

using FFmpegPipe, MappedArrays, Statistics, IdentityRanges, Dates, Images, Unitful, DelimitedFiles, Printf, JSON, ImageDraw

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


function getimages(videofile, start_second, duration_second, fps, w, h)
    imgs = Vector{Array{Gray{N0f8}, 2}}()
    vi = openvideo(videofile, "r", options = (ss = start_second, t = duration_second, r = fps, s = string(w, "x", h), pix_fmt = "gray"))
    while !eof(vi)
        push!(imgs, readframe(vi))
    end
    close(vi)
    n = length(imgs)
    ts = range(0, stop = duration_second, length = n)
    imgs, ts, n
end

function detectnext(r, img, noise, ind)
    rows = IdentityRange((-r:r) .+ ind[1])
    cols = IdentityRange((-r:r) .+ ind[2])
    roi = view(padarray(img, Fill(zero(img[1]), (r, r))), rows, cols)
    M, ind = findmax(roi)
    M > noise[ind] ? ind : missing
end

function detectfirst(imgs, noise, sz)
    ind₀ = round.(Int, sz./2)
    r₀ = min(sz...) ÷ 11
    for (i, img) in enumerate(imgs)
        ind = detectnext(r₀, img, noise, ind₀)
        if !ismissing(ind)
            return i, ind
        end
    end
    error("failed to detect the beetle's initial starting point!")
end


function track(r₀, imgs, noise, n, sz)
    inds = Vector{Union{Missing, CartesianIndex{2}}}(missing, n)
    i1, ind = detectfirst(imgs, noise, sz)
    inds[i1] = ind
    r = copy(r₀)
    for i in i1+1:n
        inds[i] = detectnext(r, imgs[i], noise, inds[findlast(!ismissing, inds)])
        if ismissing(inds[i])
            r += r₀ # TODO
        else
            r = copy(r₀)
        end
    end
    inds
end


function savedata(videofile, ts, inds, spatialscale)
    path, nameext = splitdir(videofile)
    name, _ = splitext(nameext)
    csvname = joinpath(path, "$name.csv")
    xs = ["x"; spatialscale.*getindex.(inds, 1)]
    ys = ["y"; spatialscale.*getindex.(inds, 2)]
    writedlm(csvname, zip(["seconds"; ts], xs, ys))
end


function drawit(videofile, n, inds, imgs)
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
end

getnoise(x) = 2mean(Float64.(x))

getradius(sscale, tscale) = 10exp(-1.020819402836599log(sscale) + 0.7668247162044156log(tscale) + 0.8641290371601322)

function main(videofile, start_frame, stop_frame,  spatialscale, temporalscale)

    w₀, h₀, fps₀, start_second, duration_second = getdimensions(videofile, start_frame, stop_frame)
    w, h, fps = warpdimensions(w₀, h₀, fps₀, spatialscale, temporalscale)
    sz = (h, w)
    imgs, ts, n = getimages(videofile, start_second, duration_second, fps, w, h)
    r₀ = round(Int, getradius(spatialscale, temporalscale))
    o = [[imgs[j][i] for j in 1:(n-1)÷9:n] for i in CartesianIndices(sz)] # TODO
    noise = mappedarray(getnoise, o);
    inds = track(r₀, imgs, noise, n, sz)
    tss = [t for (t, ind) in zip(ts, inds) if !ismissing(ind)]
    indss = [spatialscale.*Tuple(ind) for ind in inds if !ismissing(ind)]

    # drawit(videofile, n, inds, imgs)

    # savedata(videofile, ts, inds, spatialscale)

    tss, indss

end


end # module
