# space-race

canvas 'n' node multiplayer game

## to run locally

1. clone repo: `git clone git@github.com:markhovskiy/space-race.git && cd space-race`
2. install npm deps: `npm install`
3. install bower deps: `cd public/js/ && bower install && cd ../../`
4. compile [with watch]: `gulp [watch]`
5. run the back-end: `node server/lib/app`
6. open app in browser (only chrome for now): `localhost:3000` (see server config to change port)

## keys

- move: arrows
- turn on a shield (only while moving): space
- fire: ctrl (hold to charge a gun and free to fire)

details in code: [controllable.coffee](/public/js/src/behaviors/controllable.coffee)
