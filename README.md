# ExtractFrames

Extract frames from a video file using ffmpeg.

## Setup

Clone the repo, install ruby and ffmpeg, run `gem install bundler`, and then run `bundle install`. Some of this might need admin priveliges.

## Example

Run `ruby extractframes.rb` to extract the first ten frames from the file `small.mp4`, located in the `examples` folder, starting at 1 second into the video. These will be created in the `examples` folder as png files. 

## Usage

Using `get_n_frames` will grab the first `number_frames` frames in `video_filename`, one at a time, starting at `time_offset`, and save them in the given `format`. Provide the full filepath in `video_filename`. Returns the timestamp half-a-frame after the start of the frame immediately following the last frame saved. 
```ruby
ExtractFrames.get_n_frames(
    video_filename: path_to_video,
    number_frames: number_of_frames,
    time_offset: offset_in_seconds,
    format: "png"
)
```

Using `get_nth_frame` will grab the `frame_no`'th frame in `video_filename` and save it as the given `format`. Provide the full filepath in `video_filename`. Returns frame_number + 1. Optionally, set `number_frames` to something other than 1 to save a series of `number_frames` frames, starting at `frame_no`.  
```ruby
ExtractFrames.get_nth_frame(
    video_filename: path_to_file,
    frame_no: frame_number,
    number_frames: number_of_frames
    format: "png"
)
```

Using `get_frame` will grab the frame in `video_filename` at the given `time_offset`, and save it in the given `format`. PNG or BMP is recommended here if you optionally want to use `number_frames` as an argument to get more than one frame from this point, as jpeg corruption got quite bad after a few frames.
```ruby
ExtractFrames.get_frame(
    video_filename: path_to_video,
    time_offset: offset_in_seconds,
    format: "png" 
)
```

## Thanks

Thanks to Jessica Stokes ([@ticky](https://www.twitter.com/ticky/)) for the idea to make this. 

Thanks to a techslides post [here](http://techslides.com/sample-webm-ogg-and-mp4-video-files-for-html5) for the source video file. 