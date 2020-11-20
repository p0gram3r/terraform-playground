# terraform-playground

## Prerequisites
- AWS account
- terraform - v0.12.28
- awscli 

```
brew install tfenv awscli

tfenv install 0.12.28 
tfenv use 0.12.28

aws init 
```

## Visualizing Terraform dependency graph
- GraphViz can be used to convert Terraform graphs to SVG images
```
brew install graphviz

terraform graph | dot -Tsvg > graph.svg
```
