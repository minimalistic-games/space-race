# space-race

canvas 'n' node multiplayer game

## to run locally

1. clone repo: `git clone git@github.com:markhovskiy/space-race.git && cd space-race`
2. install npm deps: `npm install`
3. install bower deps: `cd public/js/ && bower install && cd ../../`
4. to compile the back-end: `cd server/ && coffee -c -o lib/ src/ && cd ../`
5. to compile the front-end: `cd public/js/ && coffee -c -o lib/ src/ && cd ../../`
6. run the back-end: `node server/lib/app`
7. open app in browser (only chrome for now): `localhost:3000` (see server config to change port)

## keys

- move: arrows
- turn on a shield (only while moving): space
- fire: ctrl (hold to charge a gun and free to fire)

details in code: [controllable.coffee](/public/js/src/behaviors/controllable.coffee)
