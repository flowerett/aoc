package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"
)

func main() {
	maxDay := 5
	if len(os.Args) > 1 {
		fmt.Sscanf(os.Args[1], "%d", &maxDay)
	}

	fmt.Println(strings.Repeat("=", 70))
	fmt.Printf("🎄 Running AoC 2025 - Days 1-%d\n", maxDay)
	fmt.Println(strings.Repeat("=", 70))

	totalStart := time.Now()
	successCount := 0
	failCount := 0

	for day := 1; day <= maxDay; day++ {
		dayDir := fmt.Sprintf("day%d", day)
		dayPath := filepath.Join(".", dayDir)

		if _, err := os.Stat(dayPath); os.IsNotExist(err) {
			fmt.Printf("⏭️  Day %d: Directory not found, skipping...\n", day)
			continue
		}

		fmt.Printf("\n Day %d:", day)

		start := time.Now()
		cmd := exec.Command("go", "run", "main.go")
		cmd.Dir = dayPath
		output, err := cmd.CombinedOutput()
		elapsed := time.Since(start)

		if err != nil {
			fmt.Printf("   ❌ Failed (%.2fs)\n", elapsed.Seconds())
			fmt.Printf("   Error: %v\n", err)
			failCount++
		} else {
			fmt.Printf("   ✅ Success (%.2fs)\n", elapsed.Seconds())
			lines := strings.Split(strings.TrimSpace(string(output)), "\n")
			for _, line := range lines {
				fmt.Printf("   %s\n", line)
			}
			successCount++
		}
	}

	totalElapsed := time.Since(totalStart)

	fmt.Println()
	fmt.Println(strings.Repeat("=", 70))
	fmt.Printf("📊 Summary: %d succeeded, %d failed (Total: %.2fs)\n",
		successCount, failCount, totalElapsed.Seconds())
	fmt.Println(strings.Repeat("=", 70))
}
