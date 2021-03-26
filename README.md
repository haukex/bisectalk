
Pinpointing Changes with Bisection
==================================

This is a talk about `git bisect` and how it can be used on the Perl core,
inspired by my node [How to Bisect Perl](https://www.perlmonks.org/?node_id=11110663) on PerlMonks.

**[Watch the talk here!](https://haukex.github.io/bisectalk)** (in German)

This talk was given (in German) at the *23rd German Perl/Raku Workshop 2021*
<https://act.yapc.eu/gpw2021/talk/7761>

This repository contains all the material for the talk:

- The recording of the talk and the player in the `docs` directory,
  served by GitHub at <https://haukex.github.io/bisectalk>

- The `cpanfile` that lists the dependencies for the repository,
  which you can install via `cpanm --installdeps .`;
  Perl v5.28 or better is also required

- The slide viewer and slides in `slide.pl` and `slides.inc.pl`,
  the latter also includes the "script" used for the commandline demos

- The demo script whose history I bisect is `math.pl`

- Scripts used for bisection in the `bisect` directory, including
  `runner.sh` for the simpler bash-based bisection runner,
  and `viz.pl` for the Perl-based visualization

- Examples of binary search in `binsearch.pl` and `binsearch_viz.pl`,
  plus some code to fetch the list I search in my demo in `getlist.pl`

- A few more examples used in the talk are in the `examples` directory

- Tests for several of the above scripts in the `t` directory
  (run via e.g. `prove`)

