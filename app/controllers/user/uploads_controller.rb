require "google/cloud/video_intelligence"

class User::UploadsController < ApplicationController
  before_action :authenticate_user!

  def new
    @upload = Upload.new
  end

  def create
    @upload = current_user.uploads.new(upload_params)
    @upload.file.attach(params[:upload][:file])
    @upload.save!
    redirect_to dashboard_path
  end

  def analyze
    video = Google::Cloud::VideoIntelligence.new
    context = {
      speech_transcription_config: {
        language_code: "en-US",
        enable_automatic_punctuation: true
      }
    }
    path = "gs://beach_hacks_2019/#{params[:file_key]}"

    # Register a callback during the method call
    operation = video.annotate_video input_uri: path, features: [:SPEECH_TRANSCRIPTION], video_context: context do |operation|
        raise operation.results.message? if operation.error?
        puts "Finished Processing."

        transcriptions = operation.results.annotation_results.first.speech_transcriptions
        # return transcriptions to page
        transcriptions.each do |transcription|
          transcription.alternatives.each do |alternative|
            puts "Alternative level information:"

            puts "Transcript: #{alternative.transcript}"
            puts "Confidence: #{alternative.confidence}"

            puts "Word level information:"
            alternative.words.each do |word_info|
              start_time = (word_info.start_time.seconds + word_info.start_time.nanos / 1e9)
              end_time = (word_info.end_time.seconds + word_info.end_time.nanos / 1e9)
              puts "#{word_info.word}: #{start_time} to #{end_time}"
            end
          end
        end
      end

    puts "Processing video for speech transcriptions:"
    operation.wait_until_done!
    puts operation.results.annotation_results.inspect
  end

  private

  def upload_params
    params.require(:upload).permit(:title, :description, :file, :file_key)
  end
end
