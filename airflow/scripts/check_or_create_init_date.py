import io
import yaml
from datetime import datetime, timedelta
import pendulum
from pendulum.parsing.exceptions import ParserError

file = "/opt/pipeline_config/pipeline_config.yml"


def check_date():
    with open(file) as f:
        string_date = yaml.safe_load(f)["pipeline"]["init_load_date"]
        init_date = pendulum.parse(string_date).in_timezone("UTC")
        print(f"Init_date: {init_date}; type: {type(init_date)}")


def rewrite_date():
    init_load_date = datetime.today().date() - timedelta(days=2)
    config = {"pipeline": {"init_load_date": str(init_load_date)}}
    with io.open(file, "w", encoding="utf8") as f:
        yaml.dump(config, f, default_flow_style=False, allow_unicode=True)


try:
    check_date()
except (FileNotFoundError, ParserError):
    print("no file or the date is incorrect - the file will be recreated")
    rewrite_date()
    check_date()
