use rocket_contrib::databases::postgres;
use rocket_contrib::json::{Json, JsonValue};

use super::model;

#[database("postgres_db")]
struct MyDatabase(postgres::Connection);

#[derive(Serialize, Deserialize)]
struct CreateUser {
    email: String,
    first_name: String,
    last_name: String,
    access_token: String,
}

#[derive(Serialize, Deserialize)]
struct CreateCategory {
    name: String,
    display_name: String,
    parent_id: Option<i64>,
}

#[derive(Serialize, Deserialize)]
struct Category {
    name: String,
    display_name: String,
    children: Vec<Category>,
}

#[derive(Serialize, Deserialize)]
struct Product {
    code: String,
    display_name: String,
    description: String,
    image_url: String,
    pub price: f64,
    pub rating: f32,
}

///
/// curl -X POST -H "Content-Type:application/json" -d '{"email":"batman@cave.com","first_name":"Bruce","last_name":"Wayne","access_token":"pass"}' http://localhost:8000/api/user/create
///
#[post("/users/create", format = "json", data = "<data>")]
fn create_user(data: Json<CreateUser>, conn: MyDatabase) -> JsonValue {
    model::User::create(&data.email, &data.first_name, &data.last_name, &data.access_token, &conn);
    json!({ "status": "ok"})
}

///
/// curl -X POST -H "Content-Type:application/json" -d '{"name":"cars","display_name":"Batmobile"}' http://localhost:8000/api/categories/create
///
#[post("/categories/create", format = "json", data = "<data>")]
fn create_category(data: Json<CreateCategory>, conn: MyDatabase) -> JsonValue {
    model::Category::create(&data.name, &data.display_name, &data.parent_id, &conn);

    json!({ "status": "ok"})
}

#[get("/categories")]
fn list_category(conn: MyDatabase) -> JsonValue {
    let categories = list_category_by_parent(None, &conn);
    json!({"status": "ok","categories":categories})
}

fn list_category_by_parent(parent_id: Option<i64>, conn: &postgres::Connection) -> Vec<Category> {
    model::Category::list_by_parent(parent_id, conn)
        .iter()
        .map(|cat| Category {
            name: cat.name.clone(),
            display_name: cat.display_name.clone(),
            children: list_category_by_parent(Some(cat.id), conn),
        })
        .collect()
}

#[get("/categories/<category_name>/products?<is_asc>&<first>&<max>")]
fn list_product(
    category_name: String,
    is_asc: Option<bool>,
    first: Option<i64>,
    max: Option<i64>,
    conn: MyDatabase,
) -> JsonValue {
    let is_asc = is_asc.unwrap_or_else(|| true);
    let max = max.unwrap_or_else(|| 10);
    let first = first.unwrap_or_else(|| 0);

    let category = model::Category::get_by_name(&category_name, &conn);

    //Error: category doesn't exist
    if category.is_none() {
        return json!({"status": "error","text":"wrong category_name"});
    };

    let category = category.unwrap();

    let products: Vec<Product> =
        model::Product::list_by_category(category.id, "displayname", is_asc, first, max, &conn)
            .iter()
            .map(|prod| Product {
                code: prod.code.clone(),
                display_name: prod.display_name.clone(),
                description: prod.description.clone(),
                image_url: prod.image_url.clone(),
                price: prod.price,
                rating: prod.rating,
            })
            .collect();

    json!({"status": "ok","products":products})
}

pub fn launch() {
    rocket::ignite()
        .attach(MyDatabase::fairing())
        .mount(
            "/api",
            routes![create_user, create_category, list_category, list_product],
        )
        .launch();
}
