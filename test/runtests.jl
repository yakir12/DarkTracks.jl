using DarkTracks
using Test

videofile = joinpath(@__DIR__(), "testvideo.mp4")
ts, inds = main(videofile, stop_frame = 100, spatialscale = 10)

@test ts == [1.32, 1.54, 1.76, 1.98]
@test inds = [(510, 730), (520, 730), (520, 730), (520, 730)]
