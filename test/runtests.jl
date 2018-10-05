using DarkTracks
using Test

videofile = joinpath(@__DIR__(), "testvideo.mp4")

start_frame = 1
stop_frame = 250
spatialscale = 10
temporalscale = 10

ts, inds = main(videofile, start_frame, stop_frame, spatialscale, temporalscale)

@test ts == [1.0375, 1.245, 1.4525, 1.66, 1.8675, 2.2825, 2.49, 2.6975, 2.905, 3.1125, 3.32, 3.9425, 4.15, 4.3575, 4.565, 4.7725, 4.98]
@test inds == [(510, 730), (510, 730), (520, 730), (520, 730), (520, 730), (510, 740), (510, 740), (510, 740), (530, 730), (530, 720), (530, 730), (540, 720), (550, 720), (550, 720), (550, 720), (540, 720), (530, 720)]
