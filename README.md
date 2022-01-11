## Usage

Very simple Ruby gem to store and retrieve tasks in a hash. CRUD functionality has been implemented. There are three different implementations
1. In-memory storage: all the data are stored in-memory
2. Filesystem storage for data and in-memory index. All the data are stored on an append-only file and an index is created to map the items to file lines
3. Fully persisted data in filesystem. Used for the command line application. Thor was used to create the CLI app.

## Instructions to run CLI

To run the CLI app, you should change directory to `/ruby-training/lib/ruby` and set THOR_SILENCE_DEPRECATION variable to false (not receiving deprecation warnings). Some examples of the CLI are the following

- thor cli:crud_app:crud_action --create --title 'First test' --is_done false --desc "This is a Task num 1"
- thor cli:crud_app:crud_action --create --title 'Second test' --is_done false --desc "This is a Task num 2"
- thor cli:crud_app:crud_action --read --all
- thor cli:crud_app:crud_action --read --id <task_id>
- thor cli:crud_app:crud_action --update --id <task_id> --title <text_to_update>
- thor cli:crud_app:crud_action --delete --id <task_id>

Or you can make thor file executable by running `chmod a+x crud_app.thor` and then run a simpler command like `./crud_app.thor crud_action --read --all` instead of `thor cli:crud_app:crud_action`.