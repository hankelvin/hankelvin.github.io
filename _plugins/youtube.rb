## Liquid tag 'marginyoutube' used to embed a YouTube iframe in the right margin column.
## Usage {% marginyoutube 'margin-id-whatever' 'https://www.youtube-nocookie.com/embed/VIDEO_ID' 'Optional caption' %}
##
## Liquid tag 'youtube' used to embed a YouTube iframe inline in the main column.
## Usage {% youtube 'yt-id-whatever' 'https://www.youtube-nocookie.com/embed/VIDEO_ID' 'Optional caption' %}
##
module Jekyll
  class RenderMarginYouTubeTag < Liquid::Tag

    require "shellwords"

    def initialize(tag_name, text, tokens)
      super
      @text = text.shellsplit
    end

    def render(context)
      id      = @text[0]
      src     = @text[1]
      caption = @text[2] || ""

      caption_html = caption.empty? ? "" : "<br>#{caption}"

      style = <<~CSS
        <style>
          iframe.marginyoutube { width: 100%; aspect-ratio: 16 / 9; border: 0; display: block; }
        </style>
      CSS

      "#{style}" \
      "<label for='#{id}' class='margin-toggle'>&#8853;</label>" \
      "<input type='checkbox' id='#{id}' class='margin-toggle'/>" \
      "<span class='marginnote'>" \
        "<span id='yt-#{id}' data-src='#{src}'></span>#{caption_html}" \
      "</span>" \
      "<script>(function(){" \
        "function init(){" \
          "var p=document.getElementById('yt-#{id}');" \
          "if(!p)return;" \
          "var f=document.createElement('iframe');" \
          "f.src=p.getAttribute('data-src');" \
          "f.className='marginyoutube';" \
          "f.setAttribute('frameborder','0');" \
          "f.setAttribute('allow','accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share');" \
          "f.setAttribute('allowfullscreen','');" \
          "p.parentNode.replaceChild(f,p);" \
        "}" \
        "if(document.readyState==='loading'){document.addEventListener('DOMContentLoaded',init);}else{init();}" \
      "}());</script>"
    end
  end

  class RenderYouTubeTag < Liquid::Tag

    require "shellwords"

    def initialize(tag_name, text, tokens)
      super
      @text = text.shellsplit
    end

    def render(context)
      id      = @text[0]
      src     = @text[1]
      caption = @text[2] || ""

      caption_html = caption.empty? ? "" : "<figcaption class='youtubenote'>#{caption}</figcaption>"

      style = <<~CSS
        <style>
          figure.youtube-figure { max-width: 55%; margin: 1rem 0; }
          figure.youtube-figure iframe.youtube { width: 100%; aspect-ratio: 16 / 9; border: 0; display: block; }
          figure.youtube-figure figcaption.youtubenote { margin-top: 0.5rem; font-size: 0.9rem; font-style: italic; color: #666; }
          @media screen and (max-width: 760px) {
            figure.youtube-figure { max-width: 90%; }
          }
        </style>
      CSS

      "#{style}" \
      "<figure class='youtube-figure'>" \
        "<span id='yt-#{id}' data-src='#{src}'></span>" \
        "#{caption_html}" \
      "</figure>" \
      "<script>(function(){" \
        "function init(){" \
          "var p=document.getElementById('yt-#{id}');" \
          "if(!p)return;" \
          "var f=document.createElement('iframe');" \
          "f.src=p.getAttribute('data-src');" \
          "f.className='youtube';" \
          "f.setAttribute('frameborder','0');" \
          "f.setAttribute('allow','accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share');" \
          "f.setAttribute('allowfullscreen','');" \
          "p.parentNode.replaceChild(f,p);" \
        "}" \
        "if(document.readyState==='loading'){document.addEventListener('DOMContentLoaded',init);}else{init();}" \
      "}());</script>"
    end
  end
end

Liquid::Template.register_tag('marginyoutube', Jekyll::RenderMarginYouTubeTag)
Liquid::Template.register_tag('youtube', Jekyll::RenderYouTubeTag)
