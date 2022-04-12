// Why we need this: https://gorails.com/episodes/how-to-use-jquery-with-esbuild

import jquery from "jquery";
window.jQuery = jquery;
window.jquery = jquery;
window.$ = jquery;
