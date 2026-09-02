# Mahfazti Development Guide

## Java

Mahfazti backend uses Java 21.

Check:

```bash
java -version
```

---

# Maven

Compile:

```bash
./mvnw clean compile
```

Run:

```bash
./mvnw spring-boot:run
```

Test:

```bash
./mvnw test
```

### Windows PowerShell

```powershell
.\mvnw clean compile
.\mvnw spring-boot:run
```

---

# MySQL

Create the database:

```sql
CREATE DATABASE mahfazti_db;
```

Configure the credentials in the local application configuration.

Never commit real credentials.

---

# Swagger

```text
http://localhost:8080/swagger-ui/index.html
```

---

# Postman

Recommended environment:

```text
baseUrl = http://localhost:8080
accessToken =
userId =
```

Collection authorization:

```text
Bearer Token
{{accessToken}}
```

After login, save the JWT as:

```text
accessToken
```

---

# Recommended Testing Order

```text
1. Register
2. Login
3. Get current user
4. Get categories
5. Create income
6. Create expense
7. Get expenses
8. Update expense
9. Delete expense
10. Create budget
11. Cross 80%
12. Verify warning
13. Cross 100%
14. Verify exceeded notification
15. Test reports
16. Test duplicate budget protection
17. Test ownership isolation
```

---

# Git Workflow

Update develop:

```bash
git checkout develop
git pull origin develop
```

Create feature branch:

```bash
git checkout -b feature/name
```

Commit:

```bash
git add .
git commit -m "feat: add feature"
```

Push:

```bash
git push -u origin feature/name
```

Create a Pull Request into:

```text
develop
```

---

# Troubleshooting

## Java 17 Instead of Java 21

Check:

```powershell
java -version
.\mvnw -version
```

Make sure `JAVA_HOME` points to JDK 21.

After changing environment variables, open a new terminal.

## MySQL Connection Error

Check:

* MySQL is running.
* Database exists.
* Port is correct.
* Username is correct.
* Password is correct.
* JDBC URL is correct.

## Port 8080 Already Used

Check which process uses port 8080 or change:

```yaml
server:
  port: 8081
```
