# 📦 Kata 04 — Zero Downtime & Rolling Updates

## 🎯 Contexto

Sua aplicação já é resiliente.

Ela se recupera de falhas, evita enviar tráfego para Pods não saudáveis e continua operando sob instabilidade.

Agora surge um novo problema:

👉 **como atualizar a aplicação sem interromper o tráfego?**

Em sistemas reais, deploys acontecem constantemente.  
Se não forem bem configurados, podem causar:

- indisponibilidade temporária
- erros intermitentes
- perda de requisições
- comportamento inconsistente

O Kubernetes oferece mecanismos para atualizar aplicações gradualmente.

Mas eles precisam ser compreendidos e configurados corretamente.

---

## 🚀 Como executar

1. Certifique-se de que seu cluster Kubernetes está rodando
2. Acesse a pasta `manifests/`
3. Analise os arquivos disponíveis
4. Identifique o que precisa ser ajustado
5. Aplique no cluster:

```bash
kubectl apply -f manifests/
```

6. Execute o script de requisições contínuas
7. Simule um update da aplicação
8. Observe o comportamento do sistema

---

## 🧩 Objetivos

- Atualizar a aplicação sem interromper o tráfego
- Evitar janelas de indisponibilidade
- Garantir que sempre existam Pods disponíveis
- Entender como o Kubernetes faz rollout de versões

---

## 📜 Regras

- Não usar `Recreate`
- Não reduzir manualmente o número de réplicas para zero
- Resolver apenas via configuração do Deployment
- Não usar ferramentas externas

---

## ✅ Critérios de sucesso

- [ ] A aplicação continua respondendo durante o deploy
- [ ] Não há falhas perceptíveis durante a atualização
- [ ] Pods antigos e novos coexistem temporariamente
- [ ] O tráfego é gradualmente transferido
- [ ] O comportamento pode ser observado via script e kubectl

---

## 🧠 O que você precisa descobrir

- Como funciona `RollingUpdate`
- O papel de `maxUnavailable`
- O papel de `maxSurge`
- Como readinessProbe afeta o rollout
- Como o Service decide para onde enviar tráfego

---

## 📁 Arquivos disponíveis

Você terá:

- Um Deployment inicial
- Um Service configurado
- Um script de carga contínua
- Uma forma de alterar a versão da aplicação (imagem ou resposta)

---

## 💡 Dicas (use só se travar)

Observe o estado do sistema durante o deploy:

```bash
kubectl get pods -w
kubectl get rs
kubectl describe deployment
kubectl get endpoints
```

👉 O comportamento dos endpoints muda durante o rollout

---

## 🔍 Validação manual

### 1. Inicie o tráfego contínuo

```bash
./scripts/test.sh http://localhost:30080
```

### 2. Dispare um update

Exemplo:

```bash
kubectl set image deployment/zero-downtime-app app=registry.k8s.io/e2e-test-images/agnhost:2.45
```

### 3. Observe

Durante o update, observe:

- Pods antigos sendo removidos gradualmente
- Pods novos sendo criados
- Tráfego alternando entre versões
- Possíveis janelas de instabilidade

---

## ⚠️ O que observar (IMPORTANTE)

Durante o rollout, você pode ver:

- múltiplos ReplicaSets ativos
- pods com versões diferentes
- tráfego alternando entre pods
- respostas inconsistentes temporariamente

👉 Isso é esperado.

Mas atenção para sinais de problema:

- TIMEOUTs frequentes
- pod=unknown constante
- quedas completas de tráfego
- ausência de endpoints

👉 Esses sinais indicam que o rollout não está bem configurado.

---

## 💣 Experimentos recomendados

- Reduzir `maxUnavailable`
- Aumentar `maxSurge`
- Tornar readiness mais lenta
- Simular falhas durante o rollout
- Observar impacto no tráfego

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

## 🎓 O que você deve ter aprendido

- Como Kubernetes realiza deploys sem downtime
- Como controlar o ritmo de rollout
- Como evitar indisponibilidade durante updates
- Como readiness influencia tráfego durante deploy
- Como interpretar comportamento durante mudanças

---

## 🧠 Conceito final importante

Zero downtime não significa ausência total de falhas.

Significa que o sistema continua funcional enquanto muda.

O Kubernetes não garante perfeição, ele fornece mecanismos para controlar risco.

👉 Cabe a você configurá-los corretamente.
