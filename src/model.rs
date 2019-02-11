use rocket_contrib::databases::postgres;

pub struct User {
    pub id: Option<i64>,
    pub email: String,
    pub first_name: String,
    pub last_name: String,
    pub access_token: String,
    pub user_id: i64,
}

impl User {
    pub fn create(user: User, conn: &postgres::Connection) -> User {
        let id: i64 = conn
            .query("SELECT nextval('hibernate_sequence')", &[])
            .unwrap()
            .get(0)
            .get(0);

        conn.execute(
            "INSERT INTO users(id,email,firstname,lastname,accesstoken,userid) VALUES($1,$2,$3,$4,$5,$6) ",
            &[
                &id,
                &user.email,
                &user.first_name,
                &user.last_name,
                &user.access_token,
                &user.user_id,
            ],
        )
        .unwrap();
        User {
            id: Some(id),
            ..user
        }
    }
}

pub struct Category {
    pub id: Option<i64>,
    pub name: String,
    pub display_name: String,
    pub parent_id: Option<i64>,
}

impl Category {
    pub fn create(new_item: Category, conn: &postgres::Connection) -> Category {
        let id: i64 = conn
            .query("SELECT nextval('hibernate_sequence')", &[])
            .unwrap()
            .get(0)
            .get(0);

        conn.execute(
            "INSERT INTO category(id,name,displayname,parent_id) VALUES($1,$2,$3,$4) ",
            &[
                &id,
                &new_item.name,
                &new_item.display_name,
                &new_item.parent_id,
            ],
        )
        .unwrap();

        Category {
            id: Some(id),
            ..new_item
        }
    }

    fn new_from_row(row: postgres::rows::Row) -> Category {
        Category {
            id: Some(row.get("id")),
            name: row.get("name"),
            display_name: row.get("displayname"),
            parent_id: row.get("parent_id"),
        }
    }

    pub fn list_by_parent(parent_id: Option<i64>, conn: &postgres::Connection) -> Vec<Category> {
        match parent_id {
            Some(parent_id) => {
                conn.query("SELECT * FROM category WHERE parent_id = $1", &[&parent_id])
            }
            None => conn.query("SELECT * FROM category WHERE parent_id IS NULL", &[]),
        }.unwrap()
            .iter()
            .map(|row| Category::new_from_row(row))
            .collect()
    }
}
