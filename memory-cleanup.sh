#!/bin/bash
# OpenClaw Memory Cleanup Script
# Run via cron: 0 3 * * 0 /root/.openclaw/workspace/scripts/memory-cleanup.sh

WORKSPACE="/root/.openclaw/workspace"
MEMORY_DIR="$WORKSPACE/memory"
ARCHIVE_DIR="$MEMORY_DIR/archive"
MEMORY_FILE="$WORKSPACE/MEMORY.md"
LOG_FILE="/var/log/openclaw-memory.log"
MAX_MEMORY_CHARS=8000
ARCHIVE_DAYS=7

# Ensure directories exist
mkdir -p "$ARCHIVE_DIR"

echo "$(date '+%Y-%m-%d %H:%M') — Memory cleanup started" >> "$LOG_FILE"

# 1. Archive old daily memory files (> 7 days)
ARCHIVED=$(find "$MEMORY_DIR" -maxdepth 1 -name "*.md" -mtime +$ARCHIVE_DAYS -exec mv {} "$ARCHIVE_DIR/" \; -print | wc -l)
if [ "$ARCHIVED" -gt 0 ]; then
    echo "  Archived $ARCHIVED files older than $ARCHIVE_DAYS days" >> "$LOG_FILE"
fi

# 2. Check MEMORY.md size
if [ -f "$MEMORY_FILE" ]; then
    CHARS=$(wc -c < "$MEMORY_FILE")
    echo "  MEMORY.md size: $CHARS chars (limit: $MAX_MEMORY_CHARS)" >> "$LOG_FILE"
    
    if [ "$CHARS" -gt "$MAX_MEMORY_CHARS" ]; then
        # Backup and truncate
        cp "$MEMORY_FILE" "$ARCHIVE_DIR/MEMORY-overflow-$(date +%F).md"
        head -80 "$MEMORY_FILE" > /tmp/memory-trimmed.md
        mv /tmp/memory-trimmed.md "$MEMORY_FILE"
        echo "  ⚠️ MEMORY.md was $CHARS chars — trimmed to 80 lines, backup saved" >> "$LOG_FILE"
    fi
fi

# 3. Weekly consolidation (run on Sundays)
if [ "$(date +%u)" = "7" ]; then
    WEEK=$(date +%Y-W%V)
    WEEKLY_FILE="$ARCHIVE_DIR/semana-$WEEK.md"
    
    if [ ! -f "$WEEKLY_FILE" ]; then
        echo "# Resumo Semanal — $WEEK" > "$WEEKLY_FILE"
        echo "" >> "$WEEKLY_FILE"
        
        # Consolidate this week's daily files
        for f in "$MEMORY_DIR"/$(date -d "7 days ago" +%Y-%m)*.md "$MEMORY_DIR"/$(date +%Y-%m)*.md; do
            if [ -f "$f" ]; then
                echo "---" >> "$WEEKLY_FILE"
                echo "## $(basename "$f" .md)" >> "$WEEKLY_FILE"
                cat "$f" >> "$WEEKLY_FILE"
                echo "" >> "$WEEKLY_FILE"
            fi
        done
        
        echo "  Created weekly consolidation: $WEEKLY_FILE" >> "$LOG_FILE"
    fi
fi

echo "$(date '+%Y-%m-%d %H:%M') — Memory cleanup completed" >> "$LOG_FILE"
