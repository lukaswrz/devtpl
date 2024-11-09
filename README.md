# devtpl

devenv templates for some of the stacks that I use.

## `.gitignore`

```bash
cat <<EOF >> .gitignore
.direnv/
.devenv/
EOF
```

## Symfony `.env`

```bash
APP_URL=http://localhost:8000
APP_SECRET=secret
DATABASE_URL=mysql://example:example@127.0.0.1:3306/example
MESSENGER_TRANSPORT_DSN=doctrine://default
```
