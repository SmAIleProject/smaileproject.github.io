#!/bin/bash

# --- CONFIGURATION ---
PUBLIC_BRANCH="public"
WORK_BRANCH="main"
REMOTE_NAME="origin"
REMOTE_BRANCH="main" # The branch name on GitHub

echo "-------------------------------------------------------"
echo "ERASMUS+ PROJECT: WEBSITE PUBLISHING TOOL"
echo "-------------------------------------------------------"

# 1. Ensure we are on the work branch to start
git checkout $WORK_BRANCH

# 2. Check for uncommitted changes in the work branch
if [ -n "$(git status --porcelain)" ]; then
  echo "⚠️  WARNING: You have uncommitted changes in '$WORK_BRANCH'."
  echo "Please commit or stash your changes before publishing."
  exit 1
fi

# 3. Confirm with the user
echo "This will take a snapshot of '$WORK_BRANCH' and push it to GitHub."
echo "The public will ONLY see this single new version, not your intermediate commits."
read -p "Are you sure you want to go public? (y/n): " confirm

if [ "$confirm" != "y" ]; then
    echo "❌ Publication cancelled."
    exit 1
fi

# 4. Perform the Snapshot
echo "📦 Creating snapshot..."
git checkout $PUBLIC_BRANCH
git checkout $WORK_BRANCH -- . # Overwrite everything in public with files from main

# 5. Review step
echo "-------------------------------------------------------"
echo "Check the files above. This is exactly what will go live."
read -p "Does everything look correct? (y/n): " confirm_files

if [ "$confirm_files" != "y" ]; then
    echo "❌ Reverting. No changes were pushed."
    git checkout $WORK_BRANCH
    exit 1
fi

# 6. Commit and Push
read -p "Enter a public commit message (e.g., 'Update v1.2'): " commit_msg
git add .
git commit -m "$commit_msg"
echo "📤 Pushing to GitHub..."
git push $REMOTE_NAME $PUBLIC_BRANCH:$REMOTE_BRANCH

# 7. Safety: Return to Work Branch
echo "✅ Done! Returning to '$WORK_BRANCH' for safety."
git checkout $WORK_BRANCH

echo "-------------------------------------------------------"
echo "🌐 Your site should be live at: https://smaileproject.github.io"
