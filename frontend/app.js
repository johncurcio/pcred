(function () {
    'use strict';

    angular
        .module('app', ['ngRoute', 'ngCookies'])
        .config(config)
        .run(run);

    config.$inject = ['$routeProvider', '$locationProvider'];
    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                controller: 'HomeController',
                templateUrl: 'views/home.view.html',
                controllerAs: 'vm'
            })

            .when('/login', {
                controller: 'LoginController',
                templateUrl: 'views/login.view.html',
                controllerAs: 'vm'
            })

            .when('/register', {
                controller: 'RegisterController',
                templateUrl: 'views/register.view.html',
                controllerAs: 'vm'
            })
            .when('/recover', {
                controller: 'RecoverController',
                templateUrl: 'views/recover.view.html',
                controllerAs: 'vm'
            })

            .otherwise({ redirectTo: '/login' });
    }

    run.$inject = ['$rootScope', '$location', '$cookies', '$http'];
    function run($rootScope, $location, $cookies, $http) {
        $rootScope.$on('$locationChangeStart', function (event, next, current) {
            // redirect to login page if not logged in and trying to access a 
            // restricted page
            var restrictedPage = $.inArray($location.path(), ['/login', '/register', '/recover']) === -1;
            var sessEmail = sessionStorage.getItem("email");
            var sessToken = sessionStorage.getItem("token");

            var loggedIn = (sessEmail && sessToken);
            if (restrictedPage && !loggedIn) {
                sessionStorage.removeItem("email");
                sessionStorage.removeItem("token");
                $location.path('/login');
            }
        });
    }
})();
