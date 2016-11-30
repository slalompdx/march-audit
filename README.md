march
=====

Tool for quickly auditing branches in any GitHub or GHE repository you own for:

- merged status: automate the process of deleting branches that have been merged
- age: find and (optionally) cull branches that are older than `--max_age` seconds

Installation
------------

```
$ gem install march-audit
```

Usage
-----

To get help:

```
$ march -h
```

Sample usage:

```
$ march audit_merged slalompdx march-audit
```

`march` is configured via environment variables, which may optionally be supplied in a file called `.env` in your working directory:

- GITHUB_TOKEN
  - required, use a personal auth token
  - application only requires access to the `repo` group of permissions
- GITHUB_API
  - optional, for use with on-prem GHE
- VERIFY_SSL
  - optional, defaults to `true`

Development
-----------

### Building

```
$ bundle install
$ bundle exec rake build
```

Links
-----

- [dotenv](https://github.com/bkeepers/dotenv)
- [Multnomah County Auditor Steve March](https://multco.us/auditor)
