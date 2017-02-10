# README

This is the repository for the yowbook web app. The app will help keep breeding and husbandry records for shepherds.



## License
All source code for yowbook is available jointly under the [MIT License](LICENSE.md) for details.


## Getting started
To get started with the app, clone the repo and then install the needed gems:
```
$ bundle install --without production
```
Next, migrate the database:
```
$ rails db:migrate
```
Finally, run the test suite to verify that everything is working correctly:
```
$ rails test
```
If the test suite passes, you'll be ready to run the app in a local server:
```
$ rails server
```


## Recovering from byebug crash

lsof -wni tcp:3000 
kill -9 PID
