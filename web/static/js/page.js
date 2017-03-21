import socket from "./socket.js";

class Page {
  constructor(container) {
    this.container = container;
    this.pageId = container.dataset.pageId;
    this.joinPageChannel();
  }

  joinPageChannel() {
    let channel = socket.channel(`page:${this.pageId}`);

    channel.on("page-update", (payload) => {
      this.updateResults(payload);
    });

    channel.join()
      .receive("ok", resp => { console.debug("Joined successfully", resp) })
      .receive("error", resp => { console.debug("Unable to join", resp) })
  }

  updateResults(payload) {
    this.container.innerHTML = payload.results;
  }
}

export default Page;
