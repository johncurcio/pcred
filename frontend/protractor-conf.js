exports.config = {
  allScriptsTimeout: 11000,

  specs: [
    'e2e/*.js'
  ],

  capabilities: {
    'browserName': 'chrome',
    'chromeOptions': {
    'args': [
      'start-maximized',
      '--load-extension=' + 'C:\\Users\\The\ Walrus\\Documents\\Experiments\\simpleLogin']
    }
  },

  chromeOnly: true,

  seleniumAddress: 'http://localhost:4444/wd/hub',

  framework: 'jasmine2',

  jasmineNodeOpts: {
    defaultTimeoutInterval: 30000
  }
};
