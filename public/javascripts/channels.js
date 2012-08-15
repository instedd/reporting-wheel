function initChannels(address) {
  var ChannelsViewModel = function(address) {
    var self = this;

    this.state = ko.observable(address ? 'finished' : 'unconfigured');
    this.device = ko.observable('android');
    this.code = ko.observable('');
    this.address = ko.observable(address);

    this.configure = function() {
      self.state('select_device');
    };

    this.chooseDevice = function() {
      self.state('download');
    };

    this.doneDownload = function() {
      self.state('enter_code');
    };

    this.submitCode = function() {
      $.post("/users/configure_local_gateway", {code: self.code()}, function(data) {
        if (data.success) {
          self.state('configured');
          self.address(data.address);
        } else {
          alert("The code you entered is invalid. Please check that you entered it correctly.")
        }
      });
    };

    this.finish = function() {
      self.state('finished');
    };

    this.unregister = function() {
      $.post("/users/unregister_local_gateway", {code: self.code()}, function(data) {
        if (data == 'ok') {
          self.state('unconfigured');
          self.address(null);
        } else {
          alert("Couldn't unregister channel, please contact an administrator :-(")
        }
      });
    };
  };

  window.model = new ChannelsViewModel(address);
  ko.applyBindings(model);
};