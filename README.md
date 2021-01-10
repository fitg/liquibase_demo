### Description

The purpose is to show liquibase capabilities on a simple application.

### Goal of the demo

Prove liquibase capabilities to migrate data and schema and rollback:
1. Liquibase status command to check which changesets have not been applied yet
2. Create a manual lqb sql to be applied
3. Update using changelog
4. List differences between reference database and current
5. Generate a changelog to be applied to fix differences
6. Generate a rollback sql
7. Rollback changes automatically
8. Show that only differences left are liquibase control tables

Note: 
Liquibase will stop execution at first error, no further sql will be applied after the one that broke. Each changeset runs in its own transaction.
It is sufficient to fix the faulty one and re-run migration, as liquibase will skip any previous changesets automatically.

This example also shows how to use YAML (xml, json are also supported). It also shows all possible scenarios for sql - yaml structure, embedded in yaml or a separate file.
One can also find on how to define rollback. 

For any other questions, suggest to refer to liquibase documentation.

### To run

sh run_demo.sh

You can access MySQL adminer on [localhost]:8080 to review changes as specific steps go through

### Liquibase links

https://www.liquibase.org/ 

