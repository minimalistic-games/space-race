# space-race

  [![travis][travis-image]][travis-url]
  [![deps][deps-image]][deps-url]
  [![license][license-image]][license-url]
  ![code size][code-size-image]

canvas 'n' node multiplayer game

## to run locally

1. install npm deps: `npm install`
1. install bower deps: `cd public/js/ && bower install && cd ../../`
1. compile [with watch]: `gulp [watch]`
1. run unit tests: `gulp test`
1. run the back-end: `node server/build/app`
1. open app in browser: `localhost:3000` (see [config](/server/src/config/server.coffee))

## to play

### keys

* move: arrow keys
* fire: `ctrl` (hold to charge a gun and free to fire in moving directions)

details in code: [controlled.coffee](/public/js/src/behaviors/controlled.coffee)

## screenshots

![screenshot](https://raw.githubusercontent.com/oleksmarkh/oleksmarkh.github.io/master/uploads/space_race_screenshot.png)

## todo

- [ ] add "stars/black holes" (growing, exploding, transforming) so "ship's" movements are affected by "gravity"
- [ ] remove static "bounds", make an auto-scrollable map that fills all the window (introduce global coords origin instead of [0, 0] of the canvas)
- [ ] add zoom O_o
- [ ] add mini-map

[travis-image]: https://img.shields.io/travis/minimalistic-games/space-race/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/minimalistic-games/space-race
[deps-image]: https://img.shields.io/david/minimalistic-games/space-race.svg?style=flat-square
[deps-url]: https://david-dm.org/minimalistic-games/space-race
[license-image]: https://img.shields.io/github/license/minimalistic-games/space-race.svg?style=flat-square
[license-url]: https://github.com/minimalistic-games/space-race/blob/master/LICENSE
[code-size-image]: https://img.shields.io/github/languages/code-size/minimalistic-games/space-race.svg?style=flat-square
