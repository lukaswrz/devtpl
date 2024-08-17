{
  description = "A few development environments";

  outputs = {self}: {
    templates = {
      symfony = {
        path = ./symfony;
        description = "Development environment for Symfony";
      };

      go-backend = {
        path = ./go-backend;
        description = "Development environment for Go backends";
      };

      rust-backend = {
        path = ./rust-backend;
        description = "Development environment for Rust backends";
      };

      frontend = {
        path = ./frontend;
        description = "Development environment for interactive web frontends";
      };
    };
  };
}
