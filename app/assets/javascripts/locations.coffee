# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.validate_loc = (t) ->
  russian = t.match /[а-яА-ЯЁё«»]/ig
  others = t.length - russian.length
  calc_len = others + russian.length * 3
  return ("Error! Calculated length of the string is " + calc_len + " bytes (max is 63)") if calc_len > 63
  ""

window.save_location = (x) ->
  text_trans = $("#txt#{x}").val()
  error = validate_loc text_trans
  if error.length > 0
    $("#txt#{x}").css "border-color", "red"
    $("#txt#{x}").css "border-width", "3"
    alert error
    return false
  $("#txt#{x}").css "border-color", ""
  $.ajax "/locations/#{x}",
    type: "PUT"
    dataType: "json"
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    data: { location: { content_translated: text_trans } }
    error: (jqXHR, textStatus, errorThrown) ->
      alert "Error! Could not save translation for this location."
    success: (data, textStatus, jqXHR) ->
      alert "Translation for this location has been saved."
      $("#upd#{x}").text "#{data.updated_at[0..9]} by #{data.updated_by}"

ready_loc = ->
  $(":text").on 'change keyup paste', ->
    error = validate_loc $(this).val()
    if error.length > 0
      $(this).css "border-color", "red"
      $(this).css "border-width", "3"
    else
      $(this).css "border-color", ""
      $(this).css "border-width", ""

  $(":text").each (index, element) =>
    error = validate_loc $(element).val()
    if error.length > 0
      $(element).css "border-color", "red"
      $(element).css "border-width", "3"

$(document).ready ready_loc
$(document).on 'turbolinks:load', ready_loc
