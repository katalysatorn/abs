use serde::Serialize;
use serde_json::{Deserializer, Serializer};
use std::{fs::File, io::BufReader};
use tracing::{error, info};

const CONFIGFILEPATHS: [&str; 3] = ["./abs", "./exampledir/abs.json", "~/.config/abs/abs.json"];

fn open_config_old() -> Result<(), ()> {
    for validpath in CONFIGFILEPATHS {
        match File::open(validpath) {
            Ok(f) => {
                let mut r = BufReader::new(f);
                info!("Found config file {}", validpath);
                serde_json::Deserializer::from_reader(r);
                break;
            }

            Err(err) => {
                error!("Failed reading config file\n\n{}", err);
            }
        }
    }

    return Err(());
}

struct Repository {
    name: String,
    exclude_packages: [String]
}
struct Config {
    rootdir: String,
    logdir: String,
    pubdir: String
}

fn open_config() -> Config

fn main() {
    tracing_subscriber::fmt::init();

    let mut absconfig = open_config();
    assert!(absconfig.is_ok());
    let mut absconfig = absconfig.unwrap();
}
