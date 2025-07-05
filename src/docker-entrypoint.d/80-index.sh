#!/bin/sh

set -eu

TITLE="${TITLE:-"Docker Jokes"}"
HEIGHT="${HEIGHT:-"100vh"}"
WIDTH="${WIDTH:-"100%"}"
HEADLINE="${HEADLINE:-""}"
VIDEO="${VIDEO:-"Rickroll-1080.mp4"}"
RANDOM_VIDEO="${RANDOM_VIDEO:-"false"}"

# Select a random video
if [ "${RANDOM_VIDEO}" = "true" ]; then
  echo ""
  echo "Select a random video..."
  VIDEO=$(find /usr/share/nginx/html/ -type f -name "*.mp4" -exec basename {} \; | shuf -n 1)
  echo "Random video selected: ${VIDEO}"
fi

# Create index.html
tee /usr/share/nginx/html/index.html << EOF > /dev/null
<!DOCTYPE html>
<html>
  <body>
    <video autoplay loop width="100%">

  <source src="${VIDEO}" type="video/mp4">

  Sorry, your browser doesn't support embedded videos.
</video>
    <style>
      video {
        height: ${HEIGHT};
        width: ${WIDTH};
        object-fit: cover; /**/ use "cover" to avoid distortion
        position: absolute;
      }
    </style>
    <script>
      // Change the variables below to your liking
      const currentURL = "${VIDEO}";
      const pageTitle = "Loading...";
      // End of changeable variables

      function setTitle() {
        document.title = pageTitle;
      }

      function redirect() {
        window.location.href = currentURL;
      }

      function onload() {
        setTitle();
        redirect();
      }

      window.onload = onload();
    </script>
  </body>
</html>
EOF

echo ""
echo "###########################"
echo "Website title is: ${TITLE}"
echo "Website height: ${HEIGHT}"
echo "Website width: ${WIDTH}"
echo "Headline is: ${HEADLINE}"
echo "###########################"
echo ""

exec "$@"
