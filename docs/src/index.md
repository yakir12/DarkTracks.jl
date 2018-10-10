```@meta
CurrentModule = DarkTracks
```

# DarkTracks.jl 

Track a bright spot in a dim video. The initial location of the spot is assumed to be somewhere in the middle of the video-frame. The video should be more or less uniformly dark. The bright spot doesn't need to be visible all of the time, but should be fairly brighter than the background when visible.

## Prerequisites

You have to have `ffmpeg` installed (this package also utilizes `ffprobe`, which comes bundled with `ffmpeg`).

## Installation

1. If you haven't already, install the current release of [Julia](https://julialang.org/downloads/) -> you should be able to launch it (some icon on the Desktop or some such).
2. Start Julia -> a Julia-terminal popped up.
3. Copy: 
   ```julia
   using Pkg
   Pkg.add("https://github.com/yakir12/DarkTracks.jl")
   ```
   and paste it in the newly opened Julia-terminal, press Enter.
4. (*not necessary*) To test the package, copy: 
   ```julia
   Pkg.test("DarkTracks")
   ```
   and paste it in the Julia-terminal. Press enter to check if all the tests pass -> this may take some time (all tests should pass).
5. You can close the Julia-terminal after it's done running.

## Quick start
1. Start Julia -> a Julia-terminal popped up.
2. Copy and paste this in the newly opened Julia-terminal: 
   ```julia
   using DarkTracks
   seconds, coordinates = main(videofile)
   ``` 
   where `videofile` is the path to the video file you want to process. Please read about the different options the [`main`](@ref) function can accept. 

## Output
Apart from the return variables of the [`main`](@ref) function, the function saves a tab-delimited file with the seconds and coordinates of the tracked spot. The file name is the same name as the video file with a `csv` file extension and is located in the same directory as the video file.

## Functions

```@docs
main
```

## Index

```@index
```

