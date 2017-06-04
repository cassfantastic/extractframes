# ExtractFrames

Extract frames from a video file using ffmpeg.

## Setup

This will probably only work on unix-like things. Tested on Bash on Ubuntu for Windows.
 
Clone the repo, install ruby and ffmpeg, run `gem install bundler`, and then run `bundle install`. Some of this might need admin priveliges.

## Example

Run `ruby extractframes.rb` to extract the first ten frames from the file `small.mp4`, located in the `examples` folder, starting at 61 frames into the video. These will be created in the current working directory as jpeg files. This was implemented with: 
```ruby
ExtractFrames.get_frames(
    num_frames: 10,
    offset_type: "frame",
    offset: 61,
    save: true
)
```

## Usage

Using `get_frames()` will grab the first `number_frames` frames in `video_name` located in `video_dir`, one at a time. This will start at an `offset`, specified as either an `offset_type` of `"time"` or `"frame`. If `save` is set `true`, the files will be saved as jpegs in `output_dir` and this returns an empty array. Otherwise, this returns an array of pairs `[jpeg_frame_data, timestamp]`. 
```ruby
ExtractFrames.get_frames(
    video_dir: path_to_file,
    video_name: filename,
    num_frames: some_number,
    offset_type: "frame", # "frame" or "time"
    offset: 1,            # positive integer for "frame", positive float for "time"
    save: false,
    output_dir: "./"
)
```

Using `get_frame_at_time()` will grab the frame at `time_offset` from `video_name`, located in `video_dir`, and return the frame as raw jpeg data.
```ruby
ExtractFrames.get_frame_at_time(
    video_dir: "#{__dir__}/examples/",
    video_name: "small.mp4",
    time_offset: 2
)
```

## Thanks

Thanks to Jessica Stokes ([@ticky](https://www.twitter.com/ticky/)) for the idea to make this. 

Thanks to a techslides post [here](http://techslides.com/sample-webm-ogg-and-mp4-video-files-for-html5) for the source video file. 