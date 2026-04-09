def remove_duplicates(s):
    result = ""

    for char in s:
        if char not in result:
            result += char

    return result


if __name__ == "__main__":
    print(remove_duplicates("aabbcc"))
    print(remove_duplicates("programming"))
