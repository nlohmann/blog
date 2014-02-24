module Jekyll
  class Audio < Liquid::Tag

    def initialize(name, id, tokens)
      super
      @id = id
    end

    def render(context)
      @id_stripped = @id.strip.tr('"', '')
      %(<audio controls style="margin-top: 0.5em; width: 100%;">
        <source src="/assets/audio/#{@id_stripped}.ogg" type="audio/ogg">
        <source src="/assets/audio/#{@id_stripped}.mp3" type="audio/mpeg">
        <a href="/assets/audio/#{@id_stripped}.mp3">Beitrag als MP3</a>, 
        <a href="/assets/audio/#{@id_stripped}.ogg">Beitrag als OGG</a>
        </audio>)
    end
  end
end

Liquid::Template.register_tag('audio', Jekyll::Audio)