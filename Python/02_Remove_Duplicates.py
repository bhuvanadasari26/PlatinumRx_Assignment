# Remove duplicate characters from a string

text = "programming"
result = ""

for char in text:
    if char not in result:
        result += char

print(result)
