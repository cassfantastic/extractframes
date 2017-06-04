require "open4"

module ExtractFrames
    extend self
    
    def get_frames(
        video_dir: "#{__dir__}/examples/",
        video_name: "small.mp4",
        num_frames: 1,
        offset_type: "frame",
        offset: 1,
        save: false,
        output_dir: "./"
    )
        # video_dir - a string containing the video directory, including separator
        # video_name - the filename of the video
        # num_frames - number of frames to record - default 1
        # offset_type - "time" or "frame" - default "frame"
        #   whether the initial offset is a timestamp or a frame number
        # offset - value of the initial offset - default 1
        #   if time, can be any non-negative float
        #   if frame, can be any positive integer
        # save - boolean, whether or not to save the resulting files - default false
        # output_dir - where to save files to - default ./

        # Assumptions:
        # The video stream begins with frame 1 at t=0, and continues with a 
        # frame every 1/fps seconds. Sampling the video frame stream at time 
        # t=0.5/fps and then every 1/fps following (so at 0.5/fps, 1.5/fps, ..)
        # should be grabbing frames maximally far away from any frame 
        # transitions. 
    
        format = "jpg"
        fps = get_fps(video_dir, video_name)
        case (offset_type)
        when "time"
            #clamp the timestamp to the middle of the frame period
            prior_frame = (offset*fps).floor
            time_offset = (prior_frame+0.5/fps)
        when "frame"
            #set the timestamp to the middle of the offset frame period
            time_offset = (offset - 0.5)/fps
        else # assume the offset is a time
            prior_frame = (offset*fps).floor
            time_offset = (prior_frame+0.5/fps)
        end

        frames = []
        for i in 0..(num_frames - 1)
            output_frame = get_frame_at_time(video_dir: video_dir, video_name: video_name, time_offset: time_offset)
            if (save) then
                savename = "#{output_dir}"+"#{video_name}-#{'%.3f' % (time_offset-0.5/fps).round(3)}s.#{format}"
                File.open(savename, "w") { |file| 
                    file.write(output_frame) 
                    puts "Saved frame #{i+1} as #{savename}!"
                }
            else
                frames.append [output_frame, time_offset]
            end
            time_offset = time_offset + 1/fps
        end
        return frames
    end


    def get_fps(
        video_dir,
        video_name
    )
        fps = nil
        video_filename = video_dir + video_name
        Open4::popen4 "ffmpeg -i #{video_filename}" do |pid, stdin, stdout, stderr| 
            output = stderr.read.strip.split(" ")
            fps = output[output.index("fps,")-1].to_f
        end
        return fps
    end

    def get_frame_at_time(
        video_dir: "#{__dir__}/examples/",
        video_name: "small.mp4",
        time_offset: 2
    )
        video_filepath = video_dir + video_name
        stdout_pipe = 1

        # -i - input file
        # -ss - seek to time_offset before starting recording
        # -frames - number of frames to save 
        # -f image2 - uses an image encoder (defaults to jpg)
        out, err = nil
        cmd = "ffmpeg "\
                "-i #{video_filepath} "\
                "-ss #{time_offset} "\
                "-frames 1 "\
                "-f image2 "\
                "pipe:#{stdout_pipe}"
        Open4::popen4 cmd do |pid, stdin, stdout, stderr| 
            out = stdout.read
            err = stderr.read
        end

        return out
    end
end

ExtractFrames.get_frames(
    num_frames: 10,
    offset_type: "frame",
    offset: 61,
    save: true
) if __FILE__ == $PROGRAM_NAME