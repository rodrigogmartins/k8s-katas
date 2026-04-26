# 📦 Kata 02 — Understanding Service (ClusterIP vs NodePort)

## 🎯 Contexto

Sua aplicação já está rodando no cluster e acessível externamente.

E se existir outra aplicação dentro do cluster precisa consumir essa API?

Ao mesmo tempo, o acesso externo não deve mais ser exposto diretamente.

Você precisa ajustar a forma como o Service funciona.

## 🚀 Como executar

1. Certifique-se de que seu cluster Kubernetes está rodando
2. Acesse a pasta `manifests/`
3. Analise os arquivos YAML disponíveis
4. Complete/ajuste o que for necessário
5. Aplique no cluster:

```bash
kubectl apply -f manifests/
```

6. Valide os critérios de sucesso abaixo
7. Se travar, consulte a pasta `solution/`

---

## 🧩 Objetivos

- Tornar a aplicação acessível apenas dentro do cluster
- Permitir que outro Pod consuma essa API
- Remover a exposição externa

---

## 📜 Regras

- O Service não pode ser do tipo NodePort
- O acesso externo direto deve deixar de funcionar
- A comunicação deve acontecer via DNS interno do Kubernetes
- Não usar port-forward como solução final

---

## ✅ Critérios de sucesso

- [ ] A aplicação não está mais acessível via NodePort
- [ ] Um Pod dentro do cluster consegue acessar a API
- [ ] A comunicação ocorre usando o nome do Service
- [ ] O Service está configurado corretamente para uso interno

---

## 🧠 O que você precisa descobrir

- Qual tipo de Service usar para comunicação interna
- Como funciona o DNS interno do Kubernetes
- Como um Pod acessa outro via Service
- Por que não é necessário expor tudo externamente

---

## 📁 Arquivos disponíveis

Você terá:

- Um Deployment da API (já conhecido)
- Um Service (precisa ser ajustado)
- Um segundo Pod (cliente) que tentará consumir a API

---

## 💡 Dicas (use só se travar)

- `kubectl get pods`
- `kubectl get svc`
- `kubectl describe svc`
- `kubectl exec -it <pod> -- sh`
- Dentro do Pod:
  - `curl http://<service-name>:<port>`
- Services criam entradas DNS automaticamente

---

## 🔍 Validação manual

1. Verifique que o acesso externo não funciona mais

### Se estiver usando Docker Desktop

```bash
curl localhost:<NODE_PORT>
```

### Se estiver usando Minikube

```bash
curl $(minikube ip):<NODE_PORT>
```

### Outros ambientes

Use o IP do node onde o cluster está rodando:

```bash
curl <NODE_IP>:<NODE_PORT>
```

👉 Deve falhar

2. Acesse o Pod cliente

```bash
kubectl get pods
kubectl exec -it <nome-do-pod-cliente> -- sh
```

3. Faça a requisição interna

```bash
curl http://<SERVICE_NAME>:80
```

👉 Deve funcionar

---

## 💣 Modo caos (opcional)

Delete o Pod da API:

```bash
kubectl delete pod <nome-do-pod>
```

Observe:

- Um novo Pod sendo criado automaticamente
- Se o cliente continua conseguindo acessar

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

- Diferença prática entre NodePort e ClusterIP
- Como funciona comunicação interna no Kubernetes
- Uso de DNS interno baseado em Service
- Por que expor serviços externamente nem sempre é necessário
