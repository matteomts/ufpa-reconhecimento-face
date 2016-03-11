function validacao_rs = ufr_DeixeUmaClasseFora(X, y, g, fun_train, fun_predict, print_debug)
%% Executa a validacao cruzada Leave-One-Out .
	%%
	%% Args:
	%%  g [1 x num_data] grupos correspondem a classes de y
	%%  vide KFoldCV.m
	
	if(~exist('print_debug'))
		print_debug = 0;
	end
	
	% embaralha idx
	[d idx] = sort(rand(1, size(X,2)));
	% embaralha X,y,g da mesma forma
	X = X(:,idx);
	y = y(idx);
	g = g(idx);
	
	% inicializa os resultados da predicao
	tp = 0; fp = 0; tn = 0; fn = 0;
	
	% Executa a validacao cruzada Leave Class Out 
	C = max(y); % y deve ser {1,2,3,...,C}
	for i = 1:C
		if(print_debug)
			fprintf(1,'Processando classe %d/%d.\n',i,C);
			if isoctave()
				fflush(stdout);
			end
		end
		% monta os indices
		testIdx = find(y==i);
		trainIdx = findclasses(y, [1:(i-1), (i+1):C]); 		% vide findclasses.m (provavelmente ha uma maneira melhor acerca)
		% ajusta o modelo (desta vez: por grupos!)
		model = fun_train(X(:, trainIdx), g(trainIdx));
		% testa o modelo
		for idx=testIdx
			prediction = fun_predict(model, X(:,idx));
			if(prediction == g(idx))
				tp = tp + 1;
			else
				fp = fp + 1;
			end
		end
	end
	% retorna o resultado
	validacao_rs = [tp fp tn fn];
end

%% Baseado na LeaveOneClassOutCV.m
%% Funcao não refatorada para manter a compatibilidade com o codigo original
%% comentarios traduzidos para maior compreensao do codigo
