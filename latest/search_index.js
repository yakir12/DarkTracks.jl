var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "DarkTracks.jl",
    "title": "DarkTracks.jl",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#DarkTracks.jl-1",
    "page": "DarkTracks.jl",
    "title": "DarkTracks.jl",
    "category": "section",
    "text": "Track a bright spot in a dim video. The initial location of the spot is assumed to be somewhere in the middle of the video-frame. The video should be more or less uniformly dark. The bright spot doesn\'t need to be visible all of the time, but should be fairly brighter than the background when visible."
},

{
    "location": "index.html#Prerequisites-1",
    "page": "DarkTracks.jl",
    "title": "Prerequisites",
    "category": "section",
    "text": "You have to have ffmpeg installed (this package also utilizes ffprobe, which comes bundled with ffmpeg).CurrentModule = DarkTracks"
},

{
    "location": "index.html#Table-of-contents-1",
    "page": "DarkTracks.jl",
    "title": "Table of contents",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#DarkTracks.main",
    "page": "DarkTracks.jl",
    "title": "DarkTracks.main",
    "category": "function",
    "text": "main(videofile; start_frame = 1, stop_frame = lastframe(videofile),  spatialscale = 10, temporalscale = 10)\n\nTrack a bright spot in a dim video file, videofile. Optionally give a frame number to start at, start_frame, and stop, stop_frame. These default to the beginning and ending of the video file. spatialscale and temporalscale help subsample the video for faster processing. When these equal 1 then there is no sub-sampling and the video is processed in original spatial and temporal resolutions. For example, for scaling the frame by half its original size and sampling every second frame use spatialscale = 2, temporalscale = 2. A default value of 10 for both works well.\n\nExamples\n\njulia> main(videofile, stop_frame = 100, spatialscale = 10)\n([1.32, 1.54, 1.76, 1.98], Tuple{Int64,Int64}[(510, 730), (520, 730), (520, 730), (520, 730)])\n\n\n\n\n\n\n"
},

{
    "location": "index.html#Functions-1",
    "page": "DarkTracks.jl",
    "title": "Functions",
    "category": "section",
    "text": "main"
},

{
    "location": "index.html#Index-1",
    "page": "DarkTracks.jl",
    "title": "Index",
    "category": "section",
    "text": ""
},

]}
