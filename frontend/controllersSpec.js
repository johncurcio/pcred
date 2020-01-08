'use strict';

/* jasmine specs for controllers go here */
describe('pCred Controllers', function() {

  describe('LoginController', function(){

    beforeEach(module('app'));

    it('should fail when email and password suck', inject(
          function($controller) {
              var scope = {},
              ctrl = $controller('PhoneListCtrl', {$scope:scope}); 
              expect(scope.phones.length).toBe(3);
          }
    ));

  });

  describe('RegisterController', function() {

  });

  describe('HomeController', function() {
    
  });
});
