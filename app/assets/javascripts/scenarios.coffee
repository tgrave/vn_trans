# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.validate_text = (t) ->
  lines = t.split "@@"
  return "Please use no more then 3 lines per a fragment" if lines.length > 3
  long_lines = lines.filter (l) -> l.length > 56
  return "Please use no more then 56 characters per a line" if long_lines.length > 0
  ""

window.change_who = (x) ->
  orig = $("#who#{x}").text()
  trans = $("#twho#{x}").val()
  $.ajax "/lines/#{x}/who",
    type: "POST"
    dataType: "json"
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    data: { trans_val: trans }
    error: (jqXHR, textStatus, errorThrown) ->
      alert "Error! Could not translate all '#{orig}' to '#{trans}'."
    success: (data, textStatus, jqXHR) ->
      alert "Translations for all '#{orig}' have been set to '#{trans}'.\nNow the page will be reloaded."
      document.location.reload(true)

window.save_line = (x) ->
  who_trans = $("#twho#{x}").val()
  text_trans = $("#txt#{x}").val()
  error = validate_text text_trans
  if error.length > 0
    $("#txt#{x}").css "border-color", "red"
    $("#txt#{x}").css "border-width", "3"
    alert error
    return false
  $("#txt#{x}").css "border-color", ""
  $.ajax "/lines/#{x}",
    type: "PUT"
    dataType: "json"
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    data: { line: { who_translated: who_trans, content_translated: text_trans } }
    error: (jqXHR, textStatus, errorThrown) ->
      alert "Error! Could not save translation for this fragment."
    success: (data, textStatus, jqXHR) ->
      alert "Translation for this fragment has been saved."
      $("#upd#{x}").text "#{data.updated_at[0..9]} by #{data.updated_by}"

ready = ->
  $("textarea").on 'change keyup paste', ->
    error = validate_text $(this).val()
    if error.length > 0
      $(this).css "border-color", "red"
      $(this).css "border-width", "3"
    else
      $(this).css "border-color", ""
      $(this).css "border-width", ""

  $("textarea").each (index, element) =>
    error = validate_text $(element).val()
    if error.length > 0
      $(element).css "border-color", "red"
      $(element).css "border-width", "3"

$(document).ready ready
$(document).on 'turbolinks:load', ready
