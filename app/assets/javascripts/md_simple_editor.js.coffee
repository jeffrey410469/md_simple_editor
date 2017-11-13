# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

md_simple_editor = () ->
  $(document).on 'click', '.btn-toolbar .btn-group button', ->
    att_class = this.classList
    rgex = /md_/

    option = $.grep att_class, (item) ->
      return rgex.test(item)

    if option.length != 0
      option = option[0].toString()

      text = if option == 'md_h1'
               "# Your Title here"
            else if option == 'md_h2'
               "## Your Title here"
            else if option == 'md_h3'
               "### Your Title here"
            else if option == 'md_h4'
               "#### Your Title here"
            else if option == 'md_h5'
               "##### Your Title here"
            else if option == 'md_italic'
               "_Your italic text here_"
            else if option == 'md_bold'
               "__Your bold text here__"
            else if option == 'md_text_specific_color'
              "<span class='text-special-color'>Your text with special color here</span>"
            else if option == 'md_list-ul'
               "\n\n* Item 1\n* Item 2\n* Item 3 \n\n<br>"
            else if option == 'md_list-ol'
               "\n\n1. Item 1\n2. Item 2\n3. Item 3 \n\n<br> "
            else if option == 'md_indent'
               ">Your indented text here"
            else if option == 'md_underline'
               "<u>Your undelined text here </u>"
            else if option == 'md_table'
               "\n|Header|Header|Header|\n|:------|:-------:|------:|\n|Left alignment|Centered|Right alignment|\n\n<br>"
            else if option == 'md_minus'
               "\n<hr>\n"
            else if option == 'md_square'
               "\n\t Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam ut aliquet velit. Nam fermentum, mi quis egestas ornare, massa velit pharetra ante, sed
                      pellentesque tortor nisl non quam. Nunc eget egestas orci.\n\n<br> "
            else if option == 'md_terminal'
               "<div class='terminal-block'>
               \n\t<div class='terminal-block-head'>Terminal</div>
               \n\t<div class='terminal-block-body'>
               \n\t\t<div class='terminal-code-line'>
               \n\t\t\t<span class='terminal-path'>Your path here </span><span class='terminal-command'>$ Your command</span>
               \n\t\t</div>
               \n\t</div>
               \n</div>\n"
            else if option == 'md_link'
              "\n[This is a link](http://google.com)\n"
            else if option == 'md_camera-retro'
              "\n![Alt](https://www.google.com.co/images/srpr/logo11w.png)\n"
            else if option == 'md_external_link_block'
              "<div class='external-link-block'>
              \n\t<h5>延伸閱讀</h5>
              \n\t<ul>
              \n\t\t<li><a target='_blank' href='Your link here'>Text to display</a></li>
              \n\t</ul>
              \n</div>"
            else if option == 'md_notice_block'
              "<div class='notice-block'>
              \n\t<i class='fa fa-exclamation-circle fa-5x notice-icon'></i>
              \n\t<div class='notice-text-wrapper'>
              \n\t\t<p class='notice-text'>Your notice texts here. To add another paragraph, simply copy and paster this line with 'p' and '/p' tag.</p>
              \n\t</div>
              \n</div>"

      textarea = $(this).parents('.md-editor').find('#md-text textarea')
      insertAtCaret(textarea.attr('id'), text)

preview = (elem) ->
  $parent = $(elem).parents('.md-editor')
  $md_text = $parent.find('#md-text')
  if $md_text.prop('hidden')
    $(elem).text('Preview')
    $md_text.removeAttr('hidden')
    $parent.find('.preview-panel').attr('hidden', 'true')
    false
  else
    $.post(
      '/md_simple_editor/preview',
      {md: $parent.find('#md-text textarea').val()},
      (data) ->
        $(elem).text('Editor')
        $md_text.attr('hidden', 'true')
        $parent.find('.preview-panel').removeAttr('hidden')
        $parent.find('#md-preview').html(data)
    )

insertAtCaret = (areaId, text) ->
  txtarea = document.getElementById(areaId)
  scrollPos = txtarea.scrollTop
  strPos = 0
  br = ((if (txtarea.selectionStart or txtarea.selectionStart is "0") then "ff" else ((if document.selection then "ie" else false))))
  if br is "ie"
    txtarea.focus()
    range = document.selection.createRange()
    range.moveStart "character", -txtarea.value.length
    strPos = range.text.length
  else strPos = txtarea.selectionStart  if br is "ff"
  front = (txtarea.value).substring(0, strPos)
  back = (txtarea.value).substring(strPos, txtarea.value.length)
  txtarea.value = front + text + back
  strPos = strPos + text.length
  if br is "ie"
    txtarea.focus()
    range = document.selection.createRange()
    range.moveStart "character", -txtarea.value.length
    range.moveStart "character", strPos
    range.moveEnd "character", 0
    range.select()
  else if br is "ff"
    txtarea.selectionStart = strPos
    txtarea.selectionEnd = strPos
    txtarea.focus()
  txtarea.scrollTop = scrollPos

initializeEditor = ->
  md_simple_editor()
  $(document).off 'turbolinks:load page:load ready', initializeEditor
  $(document).on 'click', '.previw_md', ->
  $('.preview_md').click (e) ->
    preview(e.target)

$(document).on 'turbolinks:load page:load ready', initializeEditor
