# 📚 Kubernetes Katas

![Kubernetes](https://img.shields.io/badge/Kubernetes-Learning-326CE5?logo=kubernetes&logoColor=white)
![Level](https://img.shields.io/badge/Level-Beginner%20→%20Advanced-orange)
![Focus](https://img.shields.io/badge/Focus-Hands--On%20System%20Design-blue)
![Status](https://img.shields.io/badge/Status-Active%20Learning-green)

---

## 💡 Por que este projeto existe

Kubernetes muitas vezes é aprendido de forma abstrata — através de diagramas, exemplos isolados e tutoriais baseados em "caminhos felizes".

O problema é que sistemas reais não funcionam assim.

Eles falham. Se recuperam. Degradam parcialmente. Mudam o roteamento de tráfego durante atualizações. Exibem condições de corrida entre controladores.

Este repositório existe para preencher essa lacuna.

Em vez de ensinar Kubernetes como um conjunto de funcionalidades, estes katas foram criados para expor o *comportamento do sistema sob pressão*:

- O que realmente acontece quando um Pod morre durante uma requisição?
- Como o tráfego é redistribuído quando um readiness falha, mas o container ainda está rodando?
- Por que um sistema pode parecer saudável, mas ainda assim retornar erros?
- O que "auto-recuperação" realmente significa na prática?

O objetivo não é decorar conceitos do Kubernetes, mas desenvolver intuição sobre como sistemas distribuídos se comportam quando algo dá errado.

Se você consegue entender o que o cluster está fazendo enquanto ele falha, você já está pensando como alguém que opera sistemas em produção.

---

## 🎯 O que é este projeto?

Este repositório é uma sequência prática de katas para aprender Kubernetes através de **cenários reais de sistemas distribuídos**.

Em vez de teoria isolada, você vai trabalhar com:

- falhas reais
- instabilidade de serviços
- comportamento de rede
- self-healing automático
- rollouts e updates

👉 O foco é entender **como o Kubernetes se comporta**, não apenas como configurá-lo.


---

## 🧠 Filosofia de aprendizado

Este não é um repositório de exercícios.

É um laboratório.

Você vai aprender mais quando:

- algo quebrar
- o tráfego falhar
- os pods reiniciarem inesperadamente
- o sistema "parecer instável"

👉 Isso é intencional.

---

## 🗺️ Estrutura dos Katas

Cada kata simula um problema real:

| Kata    | Tema                                              |
| ------- | ------------------------------------------------- |
| Kata 01 | Deploy e exposição básica                         |
| Kata 02 | Comunicação interna (ClusterIP vs NodePort)       |
| Kata 03 | Self-healing e health checks                      |
| Kata 04 | Zero downtime e rolling updates *(em construção)* |

---

## 🚀 Como usar

Cada kata segue a mesma estrutura:

```md
kata-xx/
├── manifests/ # sua solução
├── scripts/ # simulação de carga/falhas
├── solution/ # referência (use só se necessário)
└── README.md # desafio
```

### Passos:

```bash
kubectl apply -f manifests/
```

Depois:

```bash
kubectl get pods
```

E observe o comportamento do sistema.

---

## 🧪 Como extrair o máximo valor

### 🔁 1. Repita os katas

Não resolva apenas uma vez.

Refaça tentando:

- abordagens diferentes
- configurações mais simples
- menos recursos
- mais observabilidade

---

### 💥 2. Quebre o sistema intencionalmente

Experimente:

- deletar pods manualmente
- forçar falhas
- alterar probes
- observar rollout em andamento

---

### 👀 3. Observe, não só configure

Use sempre:

```bash
kubectl get pods -w
kubectl get endpoints
kubectl describe pod <pod>
kubectl get svc
```

O comportamento importa mais que o YAML.

---

### 🧠 4. Pense em fluxo de tráfego

Pergunta central:

> "Para onde estão indo as requisições agora?"

---

## ⚠️ Importante

O objetivo não é "fazer funcionar".

É entender:

- por que funciona
- quando para de funcionar
- como o sistema se recupera
- o que muda no meio do caminho

---

## 🔥 O que você vai desenvolver aqui

- Intuição de sistemas distribuídos
- Leitura de estado de cluster
- Diagnóstico de falhas reais
- Entendimento de self-healing
- Base sólida de Kubernetes para produção

---

## 🧭 Mentalidade recomendada

> Se funcionou de primeira, você provavelmente ainda não viu o problema real.
