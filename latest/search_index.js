var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "DarkTracks.jl",
    "title": "DarkTracks.jl",
    "category": "page",
    "text": "CurrentModule = DarkTracks"
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
    "text": "You have to have ffmpeg installed (this package also utilizes ffprobe, which comes bundled with ffmpeg)."
},

{
    "location": "index.html#Installation-1",
    "page": "DarkTracks.jl",
    "title": "Installation",
    "category": "section",
    "text": "If you haven\'t already, install the current release of Julia -> you should be able to launch it (some icon on the Desktop or some such).\nStart Julia -> a Julia-terminal popped up.\nCopy: \nusing Pkg\nPkg.add(PackageSpec(url = \"https://github.com/yakir12/DarkTracks.jl\"))\nand paste it in the newly opened Julia-terminal, press Enter.\n(not necessary) To test the package, copy: \nPkg.test(\"DarkTracks\")\nand paste it in the Julia-terminal. Press enter to check if all the tests pass -> this may take some time (all tests should pass).\nYou can close the Julia-terminal after it\'s done running."
},

{
    "location": "index.html#Quick-start-1",
    "page": "DarkTracks.jl",
    "title": "Quick start",
    "category": "section",
    "text": "Start Julia -> a Julia-terminal popped up.\nCopy and paste this in the newly opened Julia-terminal: \nusing DarkTracks\nseconds, coordinates = main(videofile)\nwhere videofile is the path to the video file you want to process. Please read about the different options the main function can accept. "
},

{
    "location": "index.html#Output-1",
    "page": "DarkTracks.jl",
    "title": "Output",
    "category": "section",
    "text": "Apart from the return variables of the main function, the function saves a tab-delimited file with the seconds and coordinates of the tracked spot. The file name is the same name as the video file with a csv file extension and is located in the same directory as the video file."
},

{
    "location": "index.html#DarkTracks.main",
    "page": "DarkTracks.jl",
    "title": "DarkTracks.main",
    "category": "function",
    "text": "seconds, coordinates = main(videofile; start_frame = 1, stop_frame = lastframe(videofile),  spatialscale = 10, temporalscale = 10)\n\nTrack a bright spot in a dim video file, videofile. Optionally give a frame number to start at, start_frame, and stop, stop_frame. These default to the beginning and ending of the video file. spatialscale and temporalscale help subsample the video for faster processing. When these equal 1 then there is no sub-sampling and the video is processed in original spatial and temporal resolutions. For example, for scaling the frame by half its original size and sampling every second frame use spatialscale = 2, temporalscale = 2. A default value of 10 for both works well.\n\nReturn variables\n\nseconds is a Vector{Float64} of times in second for each of the coordinates (itself a Vector{Tuple{Int, Int}}).  \n\nExamples\n\njulia> main(videofile, stop_frame = 100, spatialscale = 10)\n([1.32, 1.54, 1.76, 1.98], Tuple{Int64,Int64}[(510, 730), (520, 730), (520, 730), (520, 730)])\n\n\n\n\n\n\n"
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
