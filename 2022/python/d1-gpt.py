# solution written by GPT chatbot
# works and provides correct results

# parse the input
calories = []
current_elf = []
with open('../inputs/day1') as f:
    for line in f:
        # if the line is blank, store the current elf's calories and start a new elf
        if line.strip() == "":
            calories.append(sum(current_elf))
            current_elf = []
        else:
            # add the calorie count to the current elf's list
            current_elf.append(int(line))

# add the last elf's calories to the list
calories.append(sum(current_elf))

# find the elf with the most calories
most_calories = max(calories)

# print the result T1
print(f"The elf carrying the most calories has a total of {most_calories} calories.")

# find the top three elves with the most calories
calories.sort(reverse=True)
top_three_calories = calories[:3]

# calculate the total number of calories for the top three elves
total_calories = sum(top_three_calories)

# print the result T2
print(f"The top three elves are carrying a total of {total_calories} calories.")