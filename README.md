Aufgabe 1
git commit --allow-empty -m "fix: test patch tagging"
git commit --allow-empty -m "feat: test minor tagging"
git commit --allow-empty -m "feat!: test major tagging"

Aufgabe 2
git add .
git commit -m "fix: configure automatic version tagging"
git -c push.followTags=false push origin main
-> tags in GitHub

