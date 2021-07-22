#! /usr/bin/env bash

produce() {
   # # $1: absolute input folder
   # # $2: absolute output folder
   suffix_in="txt"
   suffix_out="html"
   suffix_last="tex"
   suffix_next="pdf"
   program_out="$1/convert-html.sh"
   program_last="$1/convert-tex.sh"
   program_last="pdflatex"
   if [ ! -f "${program_out}" ]
      echo "${program_out}" "could not be found."
      exit
   fi
   if [ ! -f "${program_last}" ]
      echo "${program_last}" "could not be found."
      exit
   fi
   if ! command -v "${program_next}" &> /dev/null
   then
      echo "${program_next}" "could not be found."
      exit
   fi

   for path_in in $1/*; do
      if [ ! -f "${path_in}" ]
         continue
      fi
      name="$(basename ${path_in})"
      bare="${name%.*}"
      extension="${name##*.}"
      if [ "${extension}" != "${suffix_in}" ]
         continue
      fi

      path_out="$2/${bare}${suffix_out}"
      if [ -f "${path_out}" ] && [ "${path_in}" -nt "${path_out}" ]
      then
         set -x
         "${program_out}" -o "${path_out}" "${path_in}"
         { set +x; } 2>/dev/null
      fi

      path_last="$1/${bare}${suffix_last}"
      if [ -f "${path_last}" ] && [ "${path_in}" -nt "${path_last}" ]
      then
         set -x
         "${program_last}" -o "${path_last}" "${path_in}"
         { set +x; } 2>/dev/null
      fi

      path_next="$2/${bare}${suffix_next}"
      if [ -f "${path_next}" ] && [ "${path_last}" -nt "${path_next}" ]
      then
         set -x
         "${program_next}" -o "${path_next}" "${path_last}"
         { set +x; } 2>/dev/null
      fi
   done
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

THIS="$(dirname $0)"
produce "$THIS/source" "$THIS/sink"