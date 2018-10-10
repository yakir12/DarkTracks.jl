# DarkTracks.jl 

Track a bright spot in a dim video. The initial location of the spot is assumed to be somewhere in the middle of the video-frame. The video should be more or less uniformly dark. The bright spot doesn't need to be visible all of the time, but should be fairly brighter than the background when visible.

## Prerequisites

You have to have `ffmpeg` installed (this package also utilizes `ffprobe`, which comes bundled with `ffmpeg`).

```@meta
CurrentModule = DarkTracks
```

## Table of contents

```@contents
```

## Functions

```@docs
main
```

## Index

```@index
```

