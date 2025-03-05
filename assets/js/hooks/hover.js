export default Hover = {
  mounted() {
    this.el.addEventListener("mouseenter", e => {
      const messageId = this.el.id.replace("messages-", "");
      const targetId = e.currentTarget.id.replace("messages-", "");

      if (messageId == targetId) {
        showEl = document.querySelector(`#message-${messageId}-buttons`);
        liveSocket.execJS(showEl, this.el.getAttribute("data-toggle"))
      }
    })

     this.el.addEventListener('mouseleave', e => {
      let messageId = this.el.id.replace("messages-", "")
      let targetId = e.currentTarget.id.replace("messages-", "")
      if (messageId == targetId) {
        showEl = document.getElementById(`message-${messageId}-buttons`)
        liveSocket.execJS(showEl, this.el.getAttribute("data-toggle"))
      }
    });
  }
}
