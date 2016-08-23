module.exports = {
  before: function(client){
    this.page = client.page.page().navigate()
  },

  beforeEach: function(client){
    client.refresh()
  },

  after: function(client){
    client.end()
  },

  'Clicking the button should open the modal': function(){
    this.page
      .verify.hidden('ui-modal')
      .click('tr:nth-child(13) ui-icon-button')
      .waitForElementVisible('ui-modal', 1000)
  },

  'Clicking on backdrop sould close the modal': function(client){
    client
      .verify.hidden('ui-modal')
      .click('tr:nth-child(13) ui-icon-button')
      .waitForElementVisible('ui-modal', 1000)
      .moveToElement('ui-modal-backdrop', 10, 10)
      .mouseButtonClick(0)
      .waitForElementNotVisible('ui-modal', 1000)
  },

  'Clicking on close icon sould close the modal': function(){
    this.page
      .verify.hidden('ui-modal')
      .click('tr:nth-child(13) ui-icon-button')
      .waitForElementVisible('ui-modal', 1000)
      .click('.ui-modal-open ui-icon')
      .waitForElementNotVisible('ui-modal', 1000)
  }
}
