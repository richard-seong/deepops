# addon

주요 구성 사항 
- cluster :  k8s cluster 구성 및 제거
- component : k8s내 구성을 위한 component
- diag : megazone 검증 체크용 tools
- gpu : gpu-operation 구성을 위한 component
- modified : k8s의 일부 수정
- roles : component 구성을 위한 playbook

## cluster 생성

```
$ ansible-playbook -i inventory/test.ini addon/cluster/create_cluster.yml
```
