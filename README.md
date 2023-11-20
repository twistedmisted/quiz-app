# GmOwl (Quizzes Web-app)
This is a web-app in which the User can take quizzes and see the results. The administrator can perform such actions 
with tests as add new ones, edit existing ones and delete. Administrator also can edit/block/unblock/delete users. 
Tests can be sort by subject, name, difficulty, number of questions. Each quiz has time to pass.
# How to install?
    https://github.com/twistedmisted/quiz-app.git
# How to run app using docker compose?
#### Running for the first time
1. Open 'quiz-app' folder in the terminal.
2. Run this command:
   ```
   docker-compose up -d iris
   ```
3. Open http://localhost:9092/csp/sys/UtilHome.csp and login:
   - username - _SYSTEM
   - password - SYS
4. Change password to PASSWORD
5. Use maven to package the project
   ```
   mvn package
   ```
6. Run this command to deploy the application:
   ```
   docker-compose up -d app
   ```
7. Open http://localhost:8080/
8. Everything done

#### Not the First Program Launch
1. Open 'quiz-app' folder in the terminal.
2. Run this command:
   ```
   docker-compose up
   ```
3.  Open http://localhost:8080/
4. Everything done

# Video Demo
https://github.com/twistedmisted/quiz-app/assets/49749263/dd3e8ace-808f-421d-8ffb-608f254ec909

