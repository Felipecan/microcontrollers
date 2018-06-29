#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

#define ARRAY_SIZE 40

int main(int argc, char** argv)
{
	/*pronteiro para o vetor de bytes. 
	O tipo define 1 byte para cada inteiro.*/
	uint_least8_t* vetor = NULL;

	/*variáveis auxiliares. O random é usado para construir o 
	vetor com números aleatórios, ele salva esse números para serem
	adicionados ao vetor. O temp simplesmente auxilia na ordenação
	do vetor*/
	uint_least8_t random, temp; 

	/*váriáveis auxiliares para os loops e na ordenação do vetor*/
	unsigned int i, j, min;


	vetor = (uint_least8_t*)malloc(sizeof(uint_least8_t)*ARRAY_SIZE);
	if (vetor == NULL)
	{
		printf("Algum erro na alocacao de mormoria com o malloc no vetor\n");
		exit(1);
	}

	srand(time(NULL)); //Alimenta a função rand toda vez que o programa roda com o tempo que ele foi rodado.
	for(i = 0; i < ARRAY_SIZE; i++)
	{
		random = rand()%255;
		//printf("valor %i\n", random);
		*(vetor + i) = random;
	}

	printf("\nVetor desordenado: ");
	for(i = 0; i < ARRAY_SIZE; i++)
	{
		printf("[%i]=%i, ", i, *(vetor + i));
	}
	printf("\n");

	// Inicio da ordenação do vetor. Utilizado o selection sort.
	// O funcionamento se da da seguinte forma: O primeiro for ira percorrer cada posição
	// de memória  até o pnúltimo valor, pois ao fim, o último valor já será o maior.
	for(i = 0; i < (ARRAY_SIZE-1); i++)
	{
		// Sempre que esse loop começar, ele ira armezar o índice do menor valor na variável min
		// Ao início, o índice do menor valor será considerado a do primeiro endereço de memória,
		// No próximo, esse valor vai ser o segundo, já que o primeiro foi ordenado.
		min = i;

		// Nesse segundo laço, o vetor vai ser percorrido a partir do índice que está o lanço anterior.
		// Por exemplo, se on laço anterior estiver com i == 5, esse segundo laço vai iniciar da posição 6 e
		// vai até o fim do çao de fato.
		for(j = (i+1); j < ARRAY_SIZE; j++)
		{
			// Ao ir pecorrendo o vetor, a sguinte comparação procura achar o índice onde se 
			// encontra o menor valor em questão para então ser ordenado, então troca com o índice desse
			// valor com o que esta armazenado na variável min.
			if( (*(vetor+j)) < (*(vetor+min)) )
			{
				min = j;
			}
		}

		// Apos o fim do segundo for, a variável min irá conter o indíce do menor valor a ser
		// 
		if( (*(vetor+i)) != (*(vetor+min)) )
		{
			temp = *(vetor+i);
			*(vetor+i) = *(vetor+min);
			*(vetor+min) = temp;
		}
	}

	printf("\nVetor ordenado: ");
	for(i = 0; i < ARRAY_SIZE; i++)
	{
		printf("[%i]=%i, ", i, *(vetor + i));
	}
	printf("\n");

	//Libera a memória alocada
	free(vetor);

	return 0;
}