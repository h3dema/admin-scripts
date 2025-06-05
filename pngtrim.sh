# The idea is to create a shell alias called pngtrim that runs:
# convert <filename> -trim -transparent white <filename>
#
# i.e., it removes the white margins around the image and use all the white pixels as transparent background.
#
# Since we can't directly use shell aliases with positional parameters.
# We use a function instead of a simple alias.
# If you're using bash, add the function below to your ~/.bashrc.
# Notice that if you use one parameter, the original image will be overwritten.
# Otherwise, the name provided in the second parameter is used to name the output.

pngtrim() {
  if [ -z "$1" ]; then
    echo "Usage: pngtrim <filename> [output_file]"
    return 1
  fi

  input="$1"
  output="${2:-$1}"  # Use second argument if provided; else same as input

  convert "$input" -trim -transparent white "$output"
  echo "Saved to $output"
}
