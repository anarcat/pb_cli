#!/bin/bash

endpoint="${PB_ENDPOINT:-https://ptpb.pw}"
jq_args="${PB_JSON:--r .url}"
private="${PB_PRIVATE:-0}"
clipboard="${PB_CLIPBOARD}"
clipboard_tool="${PB_CLIPBOARD_TOOL:-xclip}"

pb_ () {
  local filename extension

  filename="${1:--}"
  extension="${2:-}"

  shift 2

  data=$(curl -sF "c=@$filename" -F "f=-$extension" -F "p=$private" \
           -H 'accept: application/json' "$@" "$endpoint" | jq $jq_args)
  if [[ ! -z $clipboard ]]; then
    printf "${data}" | "${clipboard_tool}"
  fi
  echo "${data}"
}

pb_png () {
  maim -s | pb_ - .png
}

pb_gif () {
  capture gif - | pb_ - .gif
}

pb_webm () {
  capture webm - | pb_ - .webm
}

usage() {
    cat <<EOF
Usage: $0 [ private ] [ png | gif | webm | <filename> [ <extension> ] ]

  private: make the paste unlisted
  png: upload a PNG screenshot created with maim -s
  gif: upload a GIF animation created with capture
  webm: upload a WEBM animation created with capture
  <filename>: upload the given file, optionally with the specified <extension>

Defaults to reading from standard input, use - as a filename to
specify an extension.

Environment:
  PB_ENDPOINT: pastebin server URL (default: $endpoint)
  PB_JSON: which bit of the JSON output to extract with jq (default: $jq_args)
  PB_PRIVATE: make paste unlisted (default: $private)
  PB_CLIPBOARD: if set, send paste output to the clipboard (default: $clipboard)
  PB_CLIPBOARD_TOOL: which clipboard tool to use (default: $clipboard_tool)
EOF
}

pb () {
  local command="$1"

  case $command in
    png)
      shift
      pb_png "$@"
      ;;
    gif)
      shift
      pb_gif "$@"
      ;;
    webm)
      shift
      pb_webm "$@"
      ;;
    private)
      shift
      private=1
      pb_ "$@"
      ;;
<<<<<<< .merge_file_ykj3Ho
    -*)
      usage
      ;;
=======
>>>>>>> .merge_file_f7U3yo
    *)
      pb_ "$@"
      ;;
  esac
}

eval " ${0##*/}" "$@"
