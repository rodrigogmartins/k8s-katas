# 📦 Kata 01 — Basic Deployment & Exposure

## 🎯 Contexto

Você desenvolveu uma API simples que roda localmente, mas agora precisa disponibilizá-la dentro de um cluster Kubernetes.

O objetivo não é só “rodar o container”, mas entender como Kubernetes organiza e expõe aplicações.

---

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

## 🧩 Objetivo

Implantar a aplicação no Kubernetes e torná-la acessível externamente.

---

## 📜 Regras

- Você não pode criar Pods diretamente (use Deployment)
- A aplicação deve rodar com mais de uma réplica
- O acesso externo deve ser feito via Service do tipo NodePort
- Não usar Ingress ou LoadBalancer

---

## ✅ Critérios de sucesso

- [ ] Existem pelo menos 2 Pods rodando
- [ ] A aplicação está acessível via navegador ou curl
- [ ] O acesso é feito através de um NodePort
- [ ] Os Pods são gerenciados por um Deployment
- [ ] Requisições sucessivas podem atingir Pods diferentes (validação simples)

---

## 🧠 O que você precisa descobrir

- Como escalar o Deployment corretamente
- Qual tipo de Service usar para acesso externo
- Como acessar a aplicação a partir do NodePort
- Como verificar se múltiplos Pods estão respondendo

---

## 🧪 Aplicação base

Você pode usar qualquer API simples. Se quiser algo pronto:

```bash
docker run -p 3000:3000 hashicorp/http-echo -text="hello from pod"
```

Ou usar a imagem diretamente no Kubernetes:

```bash
hashicorp/http-echo
```

---

## 💡 Dicas (use só se travar)

- `kubectl get pods`
- `kubectl get svc`
- `kubectl describe svc`
- NodePort geralmente fica na faixa 30000-32767

---

## 🔍 Validação manual

Depois de tudo rodando, execute:

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

Repita o comando algumas vezes para verificar se diferentes Pods respondem.

> 👉 O NodePort expõe a aplicação através do IP do Node do cluster — o formato de acesso pode variar dependendo do ambiente.
 

### (Opcional) Modifique o texto da aplicação para incluir hostname

```yaml
-text="hello from $(HOSTNAME)"
```

👉 Isso ajuda a identificar qual Pod respondeu

---

## 💣 Modo caos (opcional, mas recomendado)

Delete um dos Pods manualmente:

```bash
kubectl delete pod <nome-do-pod>
```

Observe:

- Um novo Pod sendo criado automaticamente
- A aplicação continua respondendo

---

## 🧹 Cleanup

Manter o ambiente limpo evita conflitos com os próximos katas e facilita o debug.

Para remover todos os recursos criados neste kata:

```bash
kubectl delete -f manifests/
```

Isso irá remover:

- Deployment
- Service

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

## 🎓 O que você deve ter aprendido com esse Kata

- Diferença entre Pod e Deployment
- Como escalar uma aplicação
- Como um Service roteia tráfego para múltiplos Pods
- Como acessar uma aplicação via NodePort
- Noção básica de self-healing no Kubernetes
