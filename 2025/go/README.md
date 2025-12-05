# Advent of Code 2025 - Go Solutions

## Project Structure

Each day's solution is in its own directory:

```
go/
├── day1/
│   └── main.go
├── day2/
│   ├── main.go
│   └── main_test.go
├── ...
├── go.mod
└── README.md
```

## Running Solutions

```bash
go run day1/main.go

gr 1
```

## Running Tests

```bash
cd day2 && go test -v


# or from the root directory
go test ./day3/... -v

# or using the alias
./test 3
```
