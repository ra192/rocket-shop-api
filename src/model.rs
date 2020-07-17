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
            .query("SELECT nextval('users_sequence')", &[])
            .unwrap()
            .get(0)
            .get(0);

        conn.execute(
            "INSERT INTO users(id,email,firstname,lastname,accesstoken) VALUES($1,$2,$3,$4,$5) ",
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
            .query("SELECT nextval('category_sequence')", &[])
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

    pub fn get_by_name(name: String, conn: &postgres::Connection) -> Option<Category> {
        let result = conn
            .query("SELECT * FROM category WHERE name=$1", &[&name])
            .unwrap();
        if result.is_empty() {
            None
        } else {
            Some(Category::new_from_row(result.get(0)))
        }
    }

    pub fn list_by_parent(parent_id: Option<i64>, conn: &postgres::Connection) -> Vec<Category> {
        match parent_id {
            Some(parent_id) => {
                conn.query("SELECT * FROM category WHERE parent_id = $1", &[&parent_id])
            }
            None => conn.query("SELECT * FROM category WHERE parent_id IS NULL", &[]),
        }
        .unwrap()
        .iter()
        .map(|row| Category::new_from_row(row))
        .collect()
    }
}

pub struct Product {
    pub id: Option<i64>,
    pub code: String,
    pub display_name: String,
    pub description: String,
    pub image_url: String,
    pub price: f64,
    pub rating: f32,
    pub category_id: i64,
}

impl Product {
    fn new_from_row(row: postgres::rows::Row) -> Product {
        Product {
            id: Some(row.get("id")),
            code: row.get("code"),
            display_name: row.get("displayname"),
            description: row.get("description"),
            image_url: row.get("imageurl"),
            price: row.get("price"),
            rating: row.get("rating"),
            category_id: row.get("category_id"),
        }
    }

    pub fn list_by_category(
        category_id: i64,
        order_prop: &str,
        is_asc: bool,
        first: i64,
        max: i64,
        conn: &postgres::Connection,
    ) -> Vec<Product> {
        let query = if is_asc {
            format!(
                "SELECT * FROM product WHERE category_id=$1 order by {} limit $2 offset $3",
                order_prop
            )
        } else {
            format!(
                "SELECT * FROM product WHERE category_id=$1 order by {} desc limit $2 offset $3",
                order_prop
            )
        };
        conn.query(&query, &[&category_id, &max, &first])
            .unwrap()
            .iter()
            .map(|row| Product::new_from_row(row))
            .collect()
    }
}
