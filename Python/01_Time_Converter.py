def convert_minutes(minutes):
    hours = minutes // 60
    remaining = minutes % 60

    if hours == 1:
        return f"{hours} hr {remaining} minutes"
    return f"{hours} hrs {remaining} minutes"


if __name__ == "__main__":
    print(convert_minutes(130))
    print(convert_minutes(110))  
