from datetime import datetime
from termcolor import colored

def get_valid_input(prompt, validation_fn, error_message):
    """Funkcja pomocnicza do walidacji danych wejściowych."""
    while True:
        user_input = input(prompt)
        try:
            return validation_fn(user_input)
        except ValueError as e:
            print(colored(f"\n{error_message}: {e}\n", 'red'))


# Walidatory ogólne
def validate_non_empty(value, allow_empty=False):
    if not value.strip() and not allow_empty:
        raise ValueError("Value cannot be empty")
    return value.strip() if value.strip() else None


def validate_positive_number(value, allow_empty=False):
    if not value.strip() and allow_empty:
        return None
    try:
        num = float(value)
        if num <= 0:
            raise ValueError("Value must be positive")
        return num
    except ValueError:
        raise ValueError("Value must be a positive number")


def validate_integer(value, allow_empty=False):
    if not value.strip() and allow_empty:
        return None
    try:
        return int(value)
    except ValueError:
        raise ValueError("Value must be an integer")


def validate_positive_integer(value, allow_empty=False):
    num = validate_integer(value, allow_empty=allow_empty)
    if num is not None and num <= 0:
        raise ValueError("Value must be a positive integer")
    return num


def validate_date(value, date_format="%Y-%m-%d", allow_empty=False):
    if not value.strip() and allow_empty:
        return None
    try:
        return datetime.strptime(value, date_format).strftime(date_format)
    except ValueError:
        raise ValueError(f"Date must be in {date_format} format")


def validate_choice(value, choices, allow_empty=False):
    choices = [choice.upper() for choice in choices]
    if not value.strip() and allow_empty:
        return None
    if value.upper() not in choices:
        raise ValueError(f"Value must be one of {', '.join(choices)}")
    return value.upper()
