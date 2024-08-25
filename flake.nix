{
  description = "A few development environments";

  outputs = {self}: {
    templates = {
      symfony = {
        path = ./symfony;
        description = "Development environment for Symfony web applications";
      };

      go-backend = {
        path = ./go-backend;
        description = "Development environment for Go web applications";
      };

      js-fullstack = {
        path = ./js-fullstack;
        description = "Development environment for fullstack web applications in JavaScript";
      };
    };
  };
}
