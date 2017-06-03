require "open4"

module ExtractFrames
    extend self
    
    def get_fps(
        video_filename
    )
        fps = nil
        Open4::popen4 "ffmpeg -i #{video_filename}" do |pid, stdin, stdout, stderr| 
            output = stderr.read.strip.split(" ")
            fps = output[output.index("fps,")-1].to_f
        end
        return fps
    end

    def get_n_frames(
        video_filename: "#{__dir__}/examples/small.mp4",
        number_frames: 10, 
        time_offset: 2,
        format: "png"
    )
        # number_frames: Number of frames to save (integer)
        # time_offset: Time to start grabbing frames, in seconds (float) 
        
        #Run ffmpeg to get the fps of the video
        fps = get_fps(video_filename) 
        
        #Grab n frames, with timestamps in the middle of each frame period, starting at the frame beginning immediately prior to time_offset:
        initial_frame = (time_offset*fps).floor
        floored_time_offset = (initial_frame + 0.5)/fps
        for i in 0..(number_frames-1)
            start_time = floored_time_offset + i/fps
            get_frame(video_filename: video_filename, time_offset: start_time)
            puts "Saved frame #{i} from #{'%3f' % start_time.round(3)}s!"
        end
        
        # Returns the timestamp of the frame following the lasts frame grabbed
        return (start_time+1/fps)
    end

    def get_frame(
        video_filename: "#{__dir__}/examples/small.mp4",
        time_offset: 0,
        number_frames: 1,
        format: "png"
    )
        # -i - input file
        # -ss - seek to time_offset before starting recording
        # -frames - number of frames to record 
        # output filename formatting follows C printf, except integers only
        cmd = "ffmpeg "\
                "-i #{video_filename} "\
                "-ss #{time_offset} "\
                "-frames #{number_frames} "\
                "#{video_filename}-#{'%.3f' % time_offset.round(3)}-%03d.#{format}"

        out = nil
        err = nil
        Open4::popen4 cmd do |pid, stdin, stdout, stderr| 
            out = stdout.read
            err = stderr.read
        end
    end
end

ExtractFrames.get_n_frames if __FILE__ == $PROGRAM_NAME