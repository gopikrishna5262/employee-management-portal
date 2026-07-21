# How to install this into your project

## 1. Where to extract

Extract this zip's contents **directly into**:
```
C:\Users\Gopikrishna Patel\Desktop\DevOps\Devops_Project\employee-management-portal\application\backend
```

The zip's internal folder structure already matches your project exactly
(`src/main/java/com/empportal/backend/...`, `src/main/resources/templates/...`),
so when you extract with "merge/overwrite," everything lands in the right
place automatically. In Windows File Explorer: select all files inside the
zip → Extract → choose that `backend` folder as the destination → allow
overwrite if prompted for the template files (they're identical to what
you already have, just being made consistent).

## 2. Files included, and what each does

| File | Purpose |
|---|---|
| `entity/Employee.java` | Maps to your `employee` SQL table |
| `repository/EmployeeRepository.java` | Data access — Spring Data JPA auto-generates the SQL |
| `service/EmployeeService.java` | Business logic: create, update, delete, search |
| `controller/EmployeeController.java` | JSON REST API at `/api/employees` (GET/POST/PUT/DELETE) — this is what the CD pipeline's smoke tests hit |
| `controller/EmployeeWebController.java` | Serves the HTML pages at `/employees`, `/employees/new`, `/employees/edit/{id}` |
| `controller/LoginController.java` | Serves `/login`, redirects to `/employees` after "login" (placeholder auth — see note below) |
| `exception/ResourceNotFoundException.java` | Thrown when an employee ID doesn't exist |
| `exception/GlobalExceptionHandler.java` | Turns exceptions into clean JSON error responses instead of stack traces |
| `templates/*.html` | The three Thymeleaf pages (already in your repo — included here so the package is self-contained) |

## 3. One manual step required — add the Thymeleaf dependency

Open `pom.xml` in your project and add this inside the `<dependencies>` block
(if it's not already there from an earlier step):

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
```

## 4. Verify it builds

```powershell
cd C:\Users\Gopikrishna Patel\Desktop\DevOps\Devops_Project\employee-management-portal\application\backend
.\mvnw.cmd clean compile
```

## 5. Important note on login — read before treating this as "done"

`LoginController` is a **placeholder**. It accepts any username/password and
logs you in — it does not check credentials against anything. This matches
the assessment's minimum "simple authentication" requirement just enough to
get the UI flow working end-to-end, but it is not secure. Before this goes
anywhere near production, replace it with Spring Security (form login +
a real `User` table with hashed passwords, e.g. via `BCryptPasswordEncoder`).
Flagging this explicitly so it isn't mistaken for finished security work.

## 6. URLs once running

- `http://localhost:8080/` → redirects to `/login`
- `http://localhost:8080/login` → login page (any credentials work, see note above)
- `http://localhost:8080/employees` → employee list (HTML)
- `http://localhost:8080/employees/new` → add employee form
- `http://localhost:8080/api/employees` → JSON REST API
