// baseado na LeaveOneOutCV.m
function idx = ufr_DeixeUmaFora(X, y, fun_train, fun_predict, print_debug)// nomes de algumas funcoes ainda em ingles pois elas sao de outras equipes, mudaremos no futuro.
unção  validation_result = LeaveOneOutCV ( X , Y , fun_train , fun_predict , print_debug )
	%% Executa uma validação Leave-One-Out-Cross.
	%%
	%% Args:
	%% Ver KFoldCV.m
	
	se (~ exist ( ' print_debug ' ))  %% aqui a função verifica se há algum erro na verificação do código
		print_debug = 0 ;
	fim
	
	dataset% Shuffle   Representa dados em um cache de memória.
	[d idx] = espécie ( linha ( 1 , tamanho (X, 2 )));   %% aqui faz uma leitura na matriz
	X = X (:, idx);
	y = y (idx);
	
	tp = 0 ; fp = 0 ; tn = 0 ; fn = 0 ;
	n = comprimento (y);
	para  i = 1 : n
		Se (print_debug)
			fprintf ( 1 , ' Processamento dobra % d / % d . \ n ' , i , n);
			Se isoctave ()
				fflush (stdout);
			fim
		fim
		
		Xi = X (:, 1 ); X (:, 1 ) = [];
		yi = y ( 1 ); Y ( 1 ) = [];
	  
		model = fun_train (x, y);
		previsão = fun_predict (modelo, Xi);

		%% Se quiser contar [tn, fn] adicione o seu código aqui
		Se (predição == yi)
			tp = tp +  1 ;
		outro
			fp = fp +  1 ;
		fim
		
		% Adicionar para testar final instância de lista
		X = [X, Xi];
		y = [Y, Yi];
	fim
		
	validation_result = [tp fp tn fn];
	
fim
