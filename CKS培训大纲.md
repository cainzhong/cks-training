# CKS培训大纲

## 背景 

​	Kubernetes可谓是当前最火热的技术之一，想必很多人都已经会基本的Kubernetes操作了，但大家有考虑过Kubernetes的安全性问题吗？Kubernetes集群是否存在安全隐患、所使用的容器镜像是否存在安全漏洞、如何通过黑名单/白名单来限制访问容器镜像仓库、如何限制容器进程的系统调用等。

​	安全无小事，所以当务之急是亟需解决Kubernetes的安全性问题。

​	Kubernetes安全认证专家（Certified Kubernetes Security Specialist）是由云原生基金会（CNCF）继CKA和CKAD之后，业界备受关注的另一个高含金量的Kubernetes认证，主要考察的就是如何排查及解决Kubernetes的安全隐患。

​	Linux基金会的内容和社交媒体高级经理Dan Brown表示：“对于处理越来越多使用云技术的安全团队以及需要改善其安全性的云团队来说，这个认证至关重要。” 

​	  CKS值得每一位Kubernetes从业者及爱好者去学习并考取证书。CKS考试基于[Kubernetes 1.21](https://github.com/cncf/curriculum)版本，时长为2个小时，题目在15-20题之间，所有题目均为实操题。考试采用远程方式进行，由监考员通过网络摄像头和屏幕共享进行实时监控。报考CKS必须要通过CKA考试，且证书在有效期内，CKS证书有效期为2年。



## 目录

> 每天按8个课时计算

## 第一天上午：

（上午3个小时计算，能讲到 Kubernetes工作负载，下午接着将 Kubernetes工作负载）

### 一、容器与Kubernetes介绍

1. 容器技术  （课时预估1小时）
2. Kubernetes 核心概念  （课时预估1小时）
3. Kubernetes 核心概念扩展之 Kubernetes Autoscaling  （课时预估30分钟）
4. Kubernetes工作负载（Workloads）与调度（Scheduling）  （课时预估1.5小时）
5. Kubernetes服务与网络      （课时预估 100 分钟）
6. Kubernetes存储   （课时预估30分钟）



## 第一天下午：

### 二、CKS最新考纲解读与如何保护Kubernetes集群

0. CKS最新考纲解读      （课时预估 10 分钟）

7. 概览：如何保护Kubernetes集群  （课时预估 10 分钟）
   - 概览：Kubernetes集群组件架构
   - 概览：保护Kubernetes集群安全



### 三、Kubernetes安全领域知识介绍

8. Kubernetes的威胁模型 / Kubernetes Threat modeling  （课时预估1小时）

   - Kubernetes的威胁模型 / Kubernetes Threat modeling
     - 什么是威胁模型 / Threat modeling？
       - 何时做威胁建模？
       - 如何对威胁建模？
       - 威胁建模中的一些实际问题
     - Kubernetes集群中的威胁源 / Threat actors in Kubernetes environments
     - Kubernetes集群中的主要威胁

   - Kubernetes安全边界
     - 什么是安全边界（security boundaries）
     - 安全边界（security boundaries）和信任边界（trust boundaries）
       - Linux系统的安全边界
       - 网络的安全边界
       - Kubernetes的安全边界
       - 安全边界和信任边界在 DMZ 区域中的应用

   - 纵深防御 / Defense in Depth

     - Kubernetes审计介绍

     - Kubernetes集群的高可用性

     - 管理Kubernetes秘钥

     - 使用 HashiCorp Vault 管理秘钥

     - 用Falco探测Kubernetes集群异常

     - Sysdig 介绍

### 四、Kubernetes 集群安全强化

9. Kubernetes 集群安全强化  Cluster Hardening  （课时预估1小时）

   - 使用网络策略 NetworkPolicy 限制集群网络访问
      - Kubernetes NetworkPolicy 工作原理浅析
      - 选择器和网络隔离策略
      - 更多 NetworkPolicy 的用例
      - 实战：使用网络插件Calico，实现NetworkPolicy

   - 使用 CIS 基准来检查Kubernetes组件（kube-api-server、kube-scheduler、kubelet、etcd）的安全配置
      - 了解什么是CIS（Center for Internet Security）基准
      - 安装和使用 [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes/) 测试工具：kube-bench
      - 使用kube-bench检测master及worker nodes的安全隐患配置
   - Ingress 的安全配置
      - 了解什么是Ingress
      - 为Ingress配置自签名证书，建立TLS安全通信
      - 实战练习
        - 为NGINX Ingress Controller配置默认证书
        - 通过Ingress，为不同的host配置不同的TLS证书

   - 部署前验证Kubernetes二进制文件
      - 通过sha512sum验证Kubernetes二进制文件

   - 限制对Kubernetes API的访问

     - Kubernetes的身份验证 / Kubernetes authentication

     - Kubernetes的授权 / Kubernetes authorization

     - Kubernetes的准入控制 / Kubernetes Admission Control

   - RBAC（基于角色的访问控制）

     - 了解什么是RBAC
     
     - RBAC的使用，创建ServiceAccount, Role/ClusterRole 和 RoleBinding /ClusterRoleBinding 

   - ServiceAccount的最佳安全实践

      - 禁用默认的ServiceAccount
      - 对新创建的ServiceAccount应用最小权限原则

   - 升级Kubernetes 

      - 使用kubeadm升级Kubernetes集群



## 第二天上午：

### 五、系统强化

10. 系统强化  System Hardening        （课时预估20分钟）

    - 减小系统的被攻击面
       - 强化容器镜像 / Harden a container image
       - 配置pod（或pod模板）的安全属性 / Configure the security attributes of pods (or pod templates) 

    - 限制对外网的访问
       - 使用NetworkPolicy限制对外网的访问

    - 使用Linux系统安全模块
       - 使用AppArmor限制容器对资源的访问
       - 使用Seccomp限制容器内进程的系统调用


11. 最小化微服务漏洞 / Minimize Microservice Vulnerabilities  （课时预估1小时）

    - 使用PSP，OPA，安全上下文提高安全性

       - 了解并配置Pod安全策略 （PSP）
       - 了解并配置OPA Gatekeeper
       - 了解并配置Pod或容器安全上下文（securityContext）
       - Pod Security Admission（PSA）
    - 管理Kubernetes Secret
          - 使用Kubernetes Secret存储敏感信息
    
    - 在多租户环境中使用沙箱运行容器（例如gvisor，kata容器）
    
       - 了解为什么要部署沙箱
       - 什么是gVisor？
       - 实践：安装并使用 gvisor 运行 Pod
    
    
    - 实现Pod和Pod之间的双向TLS认证
    
       - 了解什么是mTLS（mutual TLS）
       - 实践：使用mTLS进行安全通信


### 六、供应链安全

12. 供应链安全  Supply Chain Security   （课时预估1小时）

    - 容器安全
      - 选择尽可能小的基础镜像
      - 对容器镜像进行签名和验证

    - 防止恶意容器创建

       - 通过黑名单/白名单来限制访问容器镜像仓库
       - 了解准入控制器 Admission Control
       - 了解并配置 ImagePolicyWebhook 
    - 分析文件及镜像安全隐患
       - 分析Dockerfile、Kubernetes yaml文件的安全隐患
       - 实践：使用 KUBESEC
       - 使用工具扫描镜像漏洞
           - 实践：使用 trivy 扫描镜像漏洞
    
    - 案例分享
      - 启用 FIPS 标准，强化容器安全
      - 容器镜像扫描


### 七、监控、审计和运行时安全

13. 监控、审计和运行时安全  Monitoring, Logging and Runtime Security    （课时预估10分钟）

    - 分析容器系统调用，检测恶意进程
       - 实践：使用Falcon监控Kubernetes运行时安全

    - 构建不可变容器（Immutable container）

      - 不变性的好处
      - 在Kubernetes环境中构建不可变容器
        - 如何往不可变容器里面写入文件呢？

    - Kubernetes审计 / Auditing

      - 开启Kubernetes审计日志

      - 分析Kubernetes审计日志



## 第二天下午：

### 八、Kubernetes常见漏洞  Kubernetes CVEs(Common Vulnerabilities and Exposures)

14. Kubernetes常见漏洞  Kubernetes CVEs(Common Vulnerabilities and Exposures) （课时预估 1 小时）

    - Kubernetes 常见漏洞

      - 检测和分析加密货币挖矿攻击（Crypto-Mining Attacks）
        - 分析加密货币挖矿攻击
        - 实例：加密货币挖矿攻击 “特斯拉的Kubernetes集群”
        - 检测加密货币挖矿攻击
        - 防御加密货币挖矿攻击
      - Kubernetes常见漏洞分析及应对方法
      - 使用第三方工具扫描Kubernetes常见漏洞
        - 实践：安装以及使用kube-hunter


- 从Kubernetes CVE中学习经验教训

  - DoS issues in JSON parsing – CVE-2019-1002100

    - 缓解策略 / Mitigation strategy

- 常用开源工具总结

  - CIS benchmark
  - Kubernetes YAML 文件扫描 / Kubernetes Deployment Codes Analysis
  - 镜像扫描工具 / Image Vulnerability Scanning
  - Pod安全策略 / Policy and Governance for Kubernetes (Admission Control)
  - 运行时安全检测 / Runtime Security


### 九、Kubernetes 的灾难恢复（灾备 Disaster recovery）

15. Kubernetes 的灾难恢复（灾备 Disaster recovery）  （课时预估 50 分钟）

    - 如何实现灾难恢复（Disaster recovery）？
      - 灾难恢复计划（DRP）


    - Kubernetes 的灾难恢复解决方案
      - TrilioVault for Kubernetes
      - Portworx by Pure Storage
      - Velero


    - Velero
      - Velero 是如何工作的？
      - Velero 的后端存储
      - 备份
      - 实践：在 On-premise 环境备份还原 Kubernetes 集群


### 十、Helm - Kubernetes包管理器

16. Helm - Kubernetes包管理器  （课时预估 30 分钟）

    - 为什么需要Helm？

    - Helm 介绍

    - Helm v3.0 稳定版发布，一个重要的里程碑

    - Helm 客户端

    - Helm 的基本使用

    - 构建一个 Helm Chart

    - 发布 Chart

    - Helm 插件


### 十一、了解一下 Kubernetes 的 Operator 模式

17. 了解一下 Kubernetes 的 Operator 模式   （课时预估 10 分钟）

    - 什么是 CRD？
      - 创建 CustomResourceDefinition
      - 创建自定义对象 Custom Resource

    - 什么是 Operator ?
      - 如何去实现一个 Controller 呢？
      - 运行 Controller

    - 什么时候使用 Operator ？
      - CRD vs. ConfigMap



## 附加内容

1. Kubernetes 和 DMZ   （课时预估 1 小时）
2. Log4Shell                     （课时预估 40 分钟）
3. 微服务日志链路追踪：Spring Cloud Sleuth   （课时预估 20 分钟）
4. 技术栈过于复杂，修不完的 CVEs    （课时预估 15 分钟）
