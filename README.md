# GmOwl (Quizzes Web-app)
GmOwl is an engaging quiz platform catering to both users and administrators. Users can explore timed quizzes across various subjects and difficulty levels. Admins have control over content, managing quizzes and user interactions. Quizzes are conveniently sorted, offering an interactive experience for all quiz enthusiasts.

# How to install?
```
git clone https://github.com/twistedmisted/quiz-app.git
```

# How to run app using docker compose?

### Pre-requirements
This version of application uses [Cloud SQL](https://portal.dap.isccloud.io/account/login). If you want to run InterSystems IRIS database locally you need to use [this branch](https://github.com/twistedmisted/quiz-app/tree/local-irisdb). So, you need follow these steps to run application successfully (also you can use this [guide](https://community.intersystems.com/post/connecting-cloud-sql-dbeaver-using-ssltls) if something is hard):
1. You need to register and create InterSystems IRIS Cloud SQL deployment.
2. Get X.509 certificate.
3. Create a keystore.jks using this command:
   ```
   keytool -importcert -file path-to-cert/cert-file.pem -keystore keystore.jks
   ```
4. Copy this keystore.jks to /quiz-app/certs/ folder.
5. Set password to your keystore.jks in SSLConfig.properties file in the same folder.
6. Everything done! Now you can follow instructions from the "Main Part".

### Main Part
1. Open 'quiz-app' folder in the terminal.
2. Run this command:
   ```
   docker-compose up
   ```
3. Open http://localhost:8080/
4. Everything done

# Video Demo
https://github.com/twistedmisted/quiz-app/assets/49749263/dd3e8ace-808f-421d-8ffb-608f254ec909

