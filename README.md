# space-race

canvas 'n' node multiplayer game

## to run locally

1. clone repo: `git clone git@github.com:markhovskiy/space-race.git && cd space-race`
2. install npm deps: `npm install`
3. install bower deps: `cd public/js/ && bower install && cd ../../`
4. compile [with watch]: `gulp [watch]`
5. run the back-end: `node server/build/app`
6. open app in browser (only GC for now, see the [FF issue](https://github.com/markhovskiy/space-race/issues/1)): `localhost:3000` (port specified in the [server config] (https://github.com/markhovskiy/space-race/blob/master/server/src/config/server.coffee))

## keys

* move: `arrows`
* fire: `ctrl` (hold to charge a gun and free to fire in moving directions)

details in code: [controllable.coffee](/public/js/src/behaviors/controllable.coffee)

## todo

* add "stars/black holes" (growing, exploding, transforming) so "ship's" movements are affected by "gravity"
* remove static "bounds", make an auto-scrollable map that fills all the window (introduce global coords origin instead of [0, 0] of the canvas)
* add zoom O_o
* add mini-map
