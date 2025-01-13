def get_valid_input(prompt, validation_fn, error_message):
    """Funkcja pomocnicza do walidacji danych wejściowych."""
    while True:
        user_input = input(prompt)
        try:
            return validation_fn(user_input)
        except ValueError:
            print(error_message)

def validate_non_empty(name):
    """Sprawdzanie, czy ciąg znaków nie jest pusty."""
    if not name.strip():
        raise ValueError("Name cannot be empty")
    return name