// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// Update stimulus controllers after Turbo requests
document.addEventListener("turbo:load", () => {
  initLibraries();
});

document.addEventListener("turbo:render", () => {
  initLibraries();
});

document.addEventListener("turbo:frame-render", () => {
  initLibraries();
});

document.addEventListener("turbo:before-stream-render", (event) => {
  const originalRender = event.detail.render;

  event.detail.render = function (streamElement) {
    originalRender(streamElement);
    initLibraries();
  };
});

function initLibraries() {
  initFlowbite();
}
