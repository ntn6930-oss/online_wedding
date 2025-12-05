# 📚 TRAE PROJECT RULES

This set of rules defines the core structure, architecture, and quality standards for all source code in the Online Wedding E-Card Project.

## 📌 ARCHITECTURE CONTEXT

* **Front-end Framework:** Flutter (Multi-platform: Web/Android).
* **State Management/DI:** Riverpod.
* **Backend Solution:** **Firebase** (Firestore, Storage, Cloud Functions).
* **Immutability:** Freezed/Const.

---

## I. ARCHITECTURE AND STRUCTURE

| ID | Rule | Detailed Description |
| :--- | :--- | :--- |
| **I.1** | **Strict Clean Architecture** | The project must strictly adhere to the 3-layer model: **`data`** (Repository Impl, Data Sources), **`domain`** (Entities, Use Cases, Repositories), and **`presentation`** (Widgets, Screens, UI Providers). |
| **I.2** | **Feature-Based Structure** | Code must be organized by Feature (Module) under the `lib/features/` directory. **FORBIDDEN** to structure code by layer globally (e.g., no `lib/blocs/` or `lib/widgets/` folders). |
| **I.3** | **State Management: Riverpod** | All state (UI, Logic, and Dependency Injection) must be managed using **Riverpod** (`flutter_riverpod`). **FORBIDDEN** to use Global Singletons, BLoC, basic Provider, or GetX. |
| **I.4** | **Domain Error Handling** | The **`data`** layer must always catch low-level errors (HTTP, I/O, **Firebase Errors**) and map them into **`Failure` Classes** defined in the **`domain`** layer before being returned (using `dartz` or `fpdart`). |

## II. CODE AND QUALITY STANDARDS

| ID | Rule | Detailed Description |
| :--- | :--- | :--- |
| **II.1** | **Class Size Limit** | The maximum size for a Class (including Widgets) is **100 lines**. If exceeded, the code must be refactored into smaller Classes/Widgets. |
| **II.2** | **Function/Method Size Limit** | The maximum size for any function or method is **40 lines**. If exceeded, it must be refactored into auxiliary helper functions. |
| **II.3** | **Line Length Limit** | The maximum length of a single line of code is **80 characters**. Lines must be wrapped if this limit is exceeded. |
| **II.4** | **Mandatory Immutability** | Use **`freezed`** for all **Entities/Models** and **`StateNotifier`** for complex states. Prioritize the **`const`** keyword wherever possible. |

## III. NAMING CONVENTIONS

| ID | Rule | Detailed Description |
| :--- | :--- | :--- |
| **III.1** | **File/Folder Names** | Must use **`snake_case`** (e.g., `wedding_card_entity.dart`). |
| **III.2** | **Classes/Widgets/Providers** | Must use **`PascalCase`** (e.g., `WeddingCardEntity`, `SignInPage`, `final UserProvider`). |
| **III.3** | **Variables/Methods** | Must use **`camelCase`** (e.g., `final isLoading`, `fetchUserData()`). |

---

**Requirement for the AI (TRAE):** When prompted to write code, you must **only provide the source code** and **strictly adhere** to these rules, even if it requires splitting Widgets or Classes.