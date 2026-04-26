# 📦 Kata 03 — Self-Healing & Health Checks

## 🎯 Contexto

Sua aplicação está rodando e sendo consumida corretamente dentro do cluster.

Porém, em ambientes reais, aplicações falham:

- travam
- param de responder
- entram em estado inconsistente
- ficam parcialmente degradadas

O Kubernetes tenta lidar com isso automaticamente — mas ele não “adivinha” o estado da aplicação. Ele depende de sinais explícitos de saúde.

Neste kata, você vai observar como o cluster reage a falhas reais e intermitentes.

## 🚀 Como executar

1. Certifique-se de que seu cluster Kubernetes está rodando
2. Acesse a pasta `manifests/`
3. Analise os arquivos YAML disponíveis
4. Identifique o que está faltando
5. Aplique no cluster:

```bash
kubectl apply -f manifests/
```

6. Valide os critérios de sucesso abaixo
7. Se travar, consulte a pasta `solution/`

---

## 🧩 Objetivos

- Garantir que a aplicação se recupere automaticamente de falhas
- Evitar que Pods não saudáveis recebam tráfego
- Tornar o comportamento da aplicação resiliente sob instabilidade
- Observar como o Kubernetes reage a falhas parciais e completas

---

## 📜 Regras

- Não alterar a imagem da aplicação
- Não remover o Deployment
- Resolver usando apenas configuração do Kubernetes
- Não usar ferramentas externas de observabilidade (Prometheus etc.)

---

## ✅ Critérios de sucesso

- [ ] Pods que falham são reiniciados automaticamente
- [ ] Pods não saudáveis deixam de receber tráfego
- [ ] A aplicação continua respondendo mesmo durante falhas
- [ ] O comportamento pode ser observado via `kubectl`

---

## ⚠️ O que observar (IMPORTANTE)

Durante a execução do kata, você pode ver estados como:

- `READY 0/1`
- `CrashLoopBackOff`
- `pod=unknown` no script
- `TIMEOUT` intermitente
- múltiplos ReplicaSets ativos ao mesmo tempo

👉 Isso não significa necessariamente erro.

Esses sinais representam diferentes estados do sistema:

- **READINESS falhando** → Pod existe, mas não recebe tráfego
- **LIVENESS falhando** → Pod é reiniciado
- **ROLLING UPDATE ativo** → versões coexistindo
- **TIMEOUT no tráfego** → janela sem endpoints ou troca de pods
- **pod=unknown** → request ocorreu fora de um endpoint válido ou durante transição

---

## 🧠 O que você precisa descobrir

- Diferença entre `livenessProbe` e `readinessProbe`
- Como Kubernetes decide enviar tráfego para um Pod
- O papel do Service na seleção de endpoints
- Como o sistema se comporta durante falhas transitórias
- Como interpretar estados inconsistentes durante rollout ou falhas

---

## 📁 Arquivos disponíveis

Você terá:

- Um Deployment da aplicação (incompleto)
- Um Service já configurado
- Um script opcional para simular requisições contínuas

---

## 💡 Dicas (use só se travar)

Observe o sistema antes de tentar corrigir:

```bash
kubectl get pods
kubectl get endpoints
kubectl describe pod <pod>
kubectl get rs
```

Para observar comportamento dinâmico:

```bash
kubectl get pods -w
```

E durante testes:

```bash
./scripts/test.sh
```

👉 O objetivo aqui não é só “funcionar”, mas entender como o estado muda ao longo do tempo.

---

## 🔍 Validação manual

1. Acompanhe os Pods em tempo real

```bash
kubectl get pods -w
```

---

2. Executar carga contínua

Execute o script para observar o comportamento da aplicação ao longo do tempo:

```bash
./scripts/test.sh
```

Exemplo de output:

```bash
[17:21:10] event=ok | traffic=✅ OK | pod=unstable-app-749544bddd-jm6ck | ready=200 | health=200
[17:21:12] event=ok | traffic=✅ OK | pod=unstable-app-585466bfb8-pqslj | ready=200 | health=200
[17:21:13] event=timeout | traffic=✅ OK | pod=unstable-app-585466bfb8-pqslj | ready=200 | health=200
[17:21:14] event=shutdown | traffic=✅ OK | pod=unstable-app-585466bfb8-pqslj | ready=200 | health=000
[17:21:16] event=ok | traffic=⏱️ TIMEOUT | pod=unknown | ready=000 | health=000
[17:21:25] event=timeout | traffic=⏱️ TIMEOUT | pod=unknown | ready=000 | health=000
[17:21:36] event=timeout | traffic=⏱️ TIMEOUT | pod=unknown | ready=000 | health=000
[17:21:48] event=timeout | traffic=⏱️ TIMEOUT | pod=unknown | ready=000 | health=000
[17:21:59] event=timeout | traffic=⏱️ TIMEOUT | pod=unknown | ready=000 | health=000
[17:22:11] event=ok | traffic=✅ OK | pod=unstable-app-585466bfb8-f9sjc | ready=200 | health=200
```

👉 Use isso enquanto executa testes de falha

---

3. Simular falha controlada

```bash
kubectl exec -it <nome-do-pod> -- sh
kill 1
```

---

👉 Observe o comportamento:

- O Pod deve ser reiniciado automaticamente
- A aplicação deve continuar respondendo
- Pods problemáticos não devem receber tráfego

---

## 💣 Modo caos (opcional)

- Delete múltiplos Pods
- Repita o teste de carga
- Observe como o sistema se recupera

---

## 🧹 Cleanup

Manter o ambiente limpo evita conflitos com os próximos katas e facilita o debug.

Para remover todos os recursos criados neste kata:

```bash
kubectl delete -f manifests/
```

Caso tenha aplicado a solução:

```bash
kubectl delete -f solution/
```

### 🔍 Verificação

Confirme que os recursos foram removidos:

```bash
kubectl get pods
kubectl get svc
```

---

## 🎓 O que você deveria ter aprendido

- O Kubernetes não “detecta falha”, ele reage a sinais
- `livenessProbe` e `readinessProbe` têm efeitos diferentes no fluxo de tráfego
- Pods podem estar “Running” mas não “Serving”
- O Service não garante saúde, só roteamento para endpoints válidos
- Sistemas reais são transitórios, não binários

---

## 🧠 Conceito final importante

Aplicações modernas expõem dois sinais de saúde:

- `/healthz` → o processo está vivo?
- `/readyz` → pode receber tráfego?

O Kubernetes usa esses sinais para decidir:

- reiniciar Pods
- remover endpoints
- evitar tráfego para instâncias instáveis

👉 O objetivo deste kata não é configurar isso mecanicamente, mas aprender a **interpretar o comportamento emergente do sistema distribuído**.
