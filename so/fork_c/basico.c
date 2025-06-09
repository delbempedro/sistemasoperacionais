#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

void tarefa(int segundos) {
    sleep(segundos);
}

void filho(int numero, int segundos) {
    printf("Filho %d (PID %d) iniciado\n", numero, getpid());
    tarefa(segundos);
    printf("Filho %d (PID %d) finalizado após %d segundos\n", numero, getpid(), segundos);
    exit(0);  // Finaliza o processo filho com sucesso
}

int main() {
    printf("Pai (PID %d) iniciando...\n", getpid());

    int tempos[] = {3, 2, 4};
    pid_t pids[3];

    for (int i = 0; i < 3; i++) {
        pid_t pid = fork();
        if (pid < 0) {
            perror("Erro ao criar processo filho");
            exit(1);
            } else if (pid == 0) {
            // Código do filho
            filho(i + 1, tempos[i]);
            } else {
            // Código do pai
            pids[i] = pid;
            printf("Pai criou Filho %d com PID %d\n", i + 1, pid);

            // Pai espera os filhos terminarem
            for (int i = 0; i < 3; i++) {
                int status;
                pid_t terminado = waitpid(pids[i], &status, 0);
                if (terminado > 0) {
                    printf("Pai detectou que Filho %d terminou (PID %d)\n", i + 1, terminado);
                }
            }
            printf("Pai finalizado. Todos os filhos terminaram.\n");
        }

    }   
    
    return 0;
}