## Liquid tag 'marginvideo' used to add video in the right margin column area.
## Usage {% marginvideo 'margin-id-whatever' 'path/to/video.mp4' 'This is the caption' %}
##
## Liquid tag 'mainvideo' used to add video inline in the main column.
## Usage {% mainvideo 'main-id-whatever' 'path/to/video.mp4' 'This is the caption' %}
##
module Jekyll
  class RenderMarginVideoTag < Liquid::Tag

    require "shellwords"

    def initialize(tag_name, text, tokens)
      super
      @text = text.shellsplit
    end

    def render(context)
      id      = @text[0]
      src     = @text[1]
      caption = @text[2] || ""
      baseurl = context.registers[:site].config['baseurl']

      unless src.start_with?('http://', 'https://', '//')
        src = "#{baseurl}/#{src}"
      end

      caption_html = caption.empty? ? "" : "<br>#{caption}"

      style = <<~CSS
        <style>
          video.marginvideo { width: 100%; height: auto; display: block; opacity: 0; }
        </style>
      CSS

      "#{style}" \
      "<label for='#{id}' class='margin-toggle'>&#8853;</label>" \
      "<input type='checkbox' id='#{id}' class='margin-toggle'/>" \
      "<span class='marginnote'>" \
        "<video class='marginvideo' muted playsinline src='#{src}'>" \
          "Your browser does not support the video tag." \
        "</video>#{caption_html}" \
      "</span>" \
      "<script>(function(){" \
        "if(window._marginVideoInited)return;window._marginVideoInited=true;" \
        "function setup(){" \
          "document.querySelectorAll('.marginvideo').forEach(function(v){" \
            "if(v._inited)return;v._inited=true;" \
            "var t=5000;v.playbackRate=0.5;v.style.opacity='0';v.style.transition='none';" \
            "requestAnimationFrame(function(){" \
              "v.style.transition='opacity '+t+'ms linear';v.style.opacity='1';" \
              "setTimeout(function(){v.style.transition='none';v.play();},t);" \
            "});" \
            "v.addEventListener('ended',function(){" \
              "v.style.transition='opacity '+t+'ms linear';v.style.opacity='0';" \
              "setTimeout(function(){" \
                "v.currentTime=0;v.style.transition='none';" \
                "setTimeout(function(){" \
                  "v.style.transition='opacity '+t+'ms linear';v.style.opacity='1';" \
                  "setTimeout(function(){v.style.transition='none';v.play();},t);" \
                "},50);" \
              "},t);" \
            "});" \
          "});" \
        "}" \
        "if(document.readyState==='loading'){document.addEventListener('DOMContentLoaded',setup);}else{setup();}" \
      "}());</script>"
    end
  end

  class RenderMainVideoTag < Liquid::Tag

    require "shellwords"

    def initialize(tag_name, text, tokens)
      super
      @text = text.shellsplit
    end

    def render(context)
      id      = @text[0]
      src     = @text[1]
      caption = @text[2] || ""
      baseurl = context.registers[:site].config['baseurl']

      unless src.start_with?('http://', 'https://', '//')
        src = "#{baseurl}/#{src}"
      end

      caption_html = caption.empty? ? "" : "<figcaption class='mainnote'>#{caption}</figcaption>"

      style = <<~CSS
        <style>
          figure.mainvideo-figure { max-width: 55%; margin: 1rem 0; }
          figure.mainvideo-figure video.mainvideo { width: 100%; height: auto; display: block; }
          figure.mainvideo-figure figcaption.mainnote { margin-top: 0.5rem; font-size: 0.9rem; font-style: italic; color: #666; }
          @media screen and (max-width: 760px) {
            figure.mainvideo-figure { max-width: 90%; }
          }
        </style>
      CSS

      "#{style}" \
      "<figure id='#{id}' class='mainvideo-figure'>" \
        "<video class='mainvideo' muted playsinline src='#{src}'>" \
          "Your browser does not support the video tag." \
        "</video>#{caption_html}" \
      "</figure>" \
      "<script>(function(){" \
        "if(window._mainVideoInited)return;window._mainVideoInited=true;" \
        "function setup(){" \
          "document.querySelectorAll('.mainvideo').forEach(function(v){" \
            "if(v._inited)return;v._inited=true;" \
            "var t=5000;v.playbackRate=0.5;v.style.opacity='0';v.style.transition='none';" \
            "requestAnimationFrame(function(){" \
              "v.style.transition='opacity '+t+'ms linear';v.style.opacity='1';" \
              "setTimeout(function(){v.style.transition='none';v.play();},t);" \
            "});" \
            "v.addEventListener('ended',function(){" \
              "v.style.transition='opacity '+t+'ms linear';v.style.opacity='0';" \
              "setTimeout(function(){" \
                "v.currentTime=0;v.style.transition='none';" \
                "setTimeout(function(){" \
                  "v.style.transition='opacity '+t+'ms linear';v.style.opacity='1';" \
                  "setTimeout(function(){v.style.transition='none';v.play();},t);" \
                "},50);" \
              "},t);" \
            "});" \
          "});" \
        "}" \
        "if(document.readyState==='loading'){document.addEventListener('DOMContentLoaded',setup);}else{setup();}" \
      "}());</script>"
    end
  end
end

Liquid::Template.register_tag('marginvideo', Jekyll::RenderMarginVideoTag)
Liquid::Template.register_tag('mainvideo', Jekyll::RenderMainVideoTag)
