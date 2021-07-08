App = {
  web3Provider: null,
  contracts: {},

  init: function () {
    return App.initWeb3();
  },

  initWeb3: function () {
    // answer the question: what blockchain we working on
    if (typeof wweb3 !== "undefined") {
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      web3 = new Web3(new Web3.providers.HttpProvider("HTTP://127.0.0.1:7545"));
      App.web3Provider = web3.currentProvider;
    }
    return App.initContract();
  },

  initContract: function () {
    // answer the question: what contract we working on
    $.getJSON("Election.json", function (election) {
      App.contracts.Election = TruffleContract(election);
      App.contracts.Election.setProvider(App.web3Provider);
      App.render();
    });
  },

  render: function () {
    web3.eth.getCoinbase(function (error, account) {
      if (error === null) {
        App.account = account;
        console.log(account);
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    //get candidate information
    var electionInstance = null;
    App.contracts.Election.deployed()
      .then(function (instance) {
        electionInstance = instance;
        return electionInstance.candidateCount();
      })
      .then(function (candidateCount) {
        console.log(candidateCount);
        var candidatesResults = $("#candidatesResults");
        // candidatesResults.empty();

        var candidateSelect = $('#candidateSelect');
        candidateSelect.empty();

        for (var i = 1; i <= candidateCount; i++) {
          electionInstance.candidates(i).then(function(candidate){
            var id = candidate[0];
            var name = candidate[1];
            var voteCount = candidate[2];
            candidateTemplate = "<tr><td>" + id + "</td><td>" + name + "</td><td>" + voteCount + "</td></tr>";
            candidatesResults.append(candidateTemplate);

            candidateOption = "<option value='" + id + "'>" + name + "</option>";
            candidateSelect.append(candidateOption);
          })
        }
      });
  },

  vote: function(){
    var candidateId = $('#candidateSelect').val();
    App.contracts.Election.deployed().then(function(instance){
      return instance.vote(candidateId, {from:App.account})
    }).then(function(result){
      console.log('after vote');
      console.log(result);
    }).catch(function(error){
      console.log(error);
    })
  }
};

$(function () {
  $(window).load(function () {
    App.init();
  });
});
