
push: 
	@echo Pushing to remote repoistory
	${CMD} git add .
		${CMD} git commit -m "development commit" 
			${CMD} git push -f