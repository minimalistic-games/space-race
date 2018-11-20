# space-race

  [![travis][travis-image]][travis-url]
  [![deps][deps-image]][deps-url]
  [![license][license-image]][license-url]
  ![code size][code-size-image]

canvas 'n' node multiplayer game

## to run locally

1. install npm deps: `npm install`
2. install bower deps: `cd public/js/ && bower install && cd ../../`
3. compile [with watch]: `gulp [watch]`
4. run the back-end: `node server/build/app`
5. open app in browser: `localhost:3000` (see [config](/server/src/config/server.coffee))

## to run tests

`gulp test`

## to play

### keys

* move: `arrows`
* fire: `ctrl` (hold to charge a gun and free to fire in moving directions)

details in code: [controlled.coffee](/public/js/src/behaviors/controlled.coffee)

## screenshots

![screenshot](https://raw.githubusercontent.com/oleksmarkh/oleksmarkh.github.io/master/uploads/space_race_screenshot.png)

## todo

- [ ] add "stars/black holes" (growing, exploding, transforming) so "ship's" movements are affected by "gravity"
- [ ] remove static "bounds", make an auto-scrollable map that fills all the window (introduce global coords origin instead of [0, 0] of the canvas)
- [ ] add zoom O_o
- [ ] add mini-map

[travis-image]: https://img.shields.io/travis/oleksmarkh/space-race/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/oleksmarkh/space-race
[deps-image]: https://img.shields.io/david/oleksmarkh/space-race.svg?style=flat-square
[deps-url]: https://david-dm.org/oleksmarkh/space-race
[license-image]: https://img.shields.io/github/license/oleksmarkh/space-race.svg?style=flat-square
[license-url]: https://github.com/oleksmarkh/space-race/blob/master/LICENSE
[code-size-image]: https://img.shields.io/github/languages/code-size/oleksmarkh/space-race.svg?style=flat-square
