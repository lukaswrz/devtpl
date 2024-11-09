# devtpl

devenv templates for some of the stacks that I use.

## `.gitignore`

```
.direnv/
.devenv/
```

## Symfony `.env`

```sh
APP_URL=http://localhost:8000
APP_SECRET=secret
DATABASE_URL=mysql://example:example@127.0.0.1:3306/example
MESSENGER_TRANSPORT_DSN=doctrine://default
```
