window.addEventListener("DOMContentLoaded", (event) => {
  // Keep one set of installation instructions open at all times.
  document.querySelectorAll(".install-instructions").forEach((items) => {
    items.querySelector("details:first-child").open = true;

    const allDetails = items.querySelectorAll("details");
    allDetails.forEach((details) => {
      details.querySelectorAll("summary").forEach((summary) => {
        summary.addEventListener("click", (event) => {
          if (details.open) {
            // Don't allow closing the one that's currently open.
            event.preventDefault();
          } else {
            // Close all of them (the clicked one will be opened after this).
            allDetails.forEach((details) => (details.open = false));
          }

          // Remove focus.
          summary.blur();
        });
      });
    });
  });
});
