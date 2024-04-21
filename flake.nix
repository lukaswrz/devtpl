{
  description = "A few development environments";

  outputs = {self}: {
    templates = {
      symfony = {
        path = ./symfony;
        description = "Development environment for Symfony";
      };

      go = {
        path = ./go;
        description = "Development environment for Go";
      };
    };
  };
}
