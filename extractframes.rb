require "open4"

module ExtractFrames
    extend self
    
    def get_n_frames(
        video_filename: "#{__dir__}/examples/small.mp4",
        n: 10
    )
        fps = nil
        #Run ffmpeg to get the fps of the video
        Open4::popen4 "ffmpeg -i #{video_filename}" do |pid, stdin, stdout, stderr| 
            output = stderr.read.strip.split(" ")
            fps = output[output.index("fps,")-1].to_f
        end
        
        #Grab n frames, with timestamps in the middle of each frame period. 
        for i in 0..(n-1)
            start_time = (i+0.5)/fps
            get_frame(video_filename: video_filename, timestamp: start_time)
            puts "Saved frame #{i}!"
        end
    end

    def get_frame(
        video_filename: "#{__dir__}/examples/small.mp4",
        timestamp: 0,
        number_frames: 1,
        format: "png"
    )
        # -i - input file
        # -ss - seek to timestamp before starting recording
        # -frames - number of frames to record 
        # output filename formatting follows C printf, except integers only
        cmd = "ffmpeg "\
                "-i #{video_filename} "\
                "-ss #{timestamp} "\
                "-frames #{number_frames} "\
                "#{video_filename}-#{'%.3f' % timestamp.round(3)}-%03d.#{format}"

        out = nil
        err = nil
        Open4::popen4 cmd do |pid, stdin, stdout, stderr| 
            out = stdout.read
            err = stderr.read
        end
    end
end

ExtractFrames.get_n_frames if __FILE__ == $PROGRAM_NAME