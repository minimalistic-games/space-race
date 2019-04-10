# space-race

  [![license][license-image]][license-url]
  [![travis][travis-image]][travis-url]
  [![deps][deps-image]][deps-url]
  ![code size][code-size-image]

canvas 'n' node multiplayer game

## to run locally

```bash
$ npm install                                  # install npm deps
$ cd public/js/ && bower install && cd ../../  # install bower deps
$ gulp [watch]                                 # compile [with watch]
$ gulp test                                    # run unit tests
$ node server/build/app                        # run the back-end
```

The app should be accessible at `http://localhost:3000` (see [config](/server/src/config/server.coffee)).

## to play

### keys

* move: arrow keys
* fire: `ctrl` (hold to charge a gun and free to fire in moving directions)

Details in code: [controlled.coffee](/public/js/src/behaviors/controlled.coffee).

## screenshots

![screenshot](/screenshot.png)

## todo

- [ ] add *stars/black holes* (growing, exploding, transforming) so *ship's* movements are affected by *gravity*
- [ ] remove static *bounds*, make an auto-scrollable map that fills all the window (introduce global coords origin instead of [0, 0] of the canvas)
- [ ] add zoom O_o
- [ ] add mini-map

[license-image]: https://img.shields.io/github/license/minimalistic-games/space-race.svg?style=flat-square
[license-url]: https://github.com/minimalistic-games/space-race/blob/master/LICENSE
[travis-image]: https://img.shields.io/travis/minimalistic-games/space-race/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/minimalistic-games/space-race
[deps-image]: https://img.shields.io/david/minimalistic-games/space-race.svg?style=flat-square
[deps-url]: https://david-dm.org/minimalistic-games/space-race
[code-size-image]: https://img.shields.io/github/languages/code-size/minimalistic-games/space-race.svg?style=flat-square
