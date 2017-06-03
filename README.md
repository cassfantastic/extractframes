# ExtractFrames

Extract frames from a video file using ffmpeg.

## Setup

Clone the repo, install ruby and ffmpeg, run `gem install bundler`, and then run `bundle install`. Some of this might need admin priveliges.

## Example

Run `ruby extractframes.rb` to extract the first ten frames from the file `small.mp4` located in the `examples` folder. These will be created in the `examples` folder. This is not very interesting, as this example file only starts changing much after thirty frames or so. Oops.

## Usage

Using `get_n_frames` will grab the first n frames in the specified video file, one at a time: 
```ruby
ExtractFrames.get_n_frames(
    video_filename: path_to_video,
    n: number_of_frames
)
```
Using get_frame will grab the frame at the given timestamp, and save it in the given fileformat:
```ruby
ExtractFrames.get_frame(
    video_filename: path_to_video,
    timestamp: starttime_in_seconds,
    format: "png" 
)
```

## Thanks

Thanks to Jessica Stokes ([@ticky](https://www.twitter.com/ticky/)) for the idea to make this. 

Thanks to a techslides post [here](http://techslides.com/sample-webm-ogg-and-mp4-video-files-for-html5) for the source video file. 