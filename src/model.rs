use rocket_contrib::databases::postgres;

fn nextval(seq_name: &str, conn: &postgres::Connection) -> i64 {
    let query=format!("SELECT nextval('{}')", seq_name);
    let nextval=conn.query(&query, &[]).unwrap().get(0).get(0);
    nextval
}

pub struct User {
    pub id: i64,
    pub email: String,
    pub first_name: String,
    pub last_name: String,
    pub access_token: String,
}

impl User {
    pub fn create(email: &str, first_name: &str, last_name: &str, access_token: &str, conn: &postgres::Connection) -> i64 {
        let id = nextval("users_sequence", &conn);

        conn.execute(
            "INSERT INTO users(id,email,firstname,lastname,accesstoken) VALUES($1,$2,$3,$4,$5) ",
            &[
                &id,
                &email,
                &first_name,
                &last_name,
                &access_token,
            ],
        )
        .unwrap();
        
        id
    }
}

pub struct Category {
    pub id: i64,
    pub name: String,
    pub display_name: String,
    pub parent_id: Option<i64>,
}

impl Category {
    pub fn create(name: &str, display_name: &str, parent_id: &Option<i64>, conn: &postgres::Connection) -> i64 {
        let id = nextval("category_sequence",&conn);

        conn.execute(
            "INSERT INTO category(id,name,displayname,parent_id) VALUES($1,$2,$3,$4) ",
            &[
                &id,
                &name,
                &display_name,
                &parent_id,
            ],
        )
        .unwrap();

        id
    }

    fn new_from_row(row: postgres::rows::Row) -> Category {
        Category {
            id: row.get("id"),
            name: row.get("name"),
            display_name: row.get("displayname"),
            parent_id: row.get("parent_id"),
        }
    }

    pub fn get_by_name(name: &str, conn: &postgres::Connection) -> Option<Category> {
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
    pub id: i64,
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
            id: row.get("id"),
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
