---
title: "terraform 0.8.8でEC2のインスタンスタイプ変更ができるようになったので試してみた"
thumbnailImage: images/eye-catch/terraform.png
thumbnailImagePosition: left
metaAlignment: left
date: 2017-03-06
categories:
- technology
tags:
- terraform
- aws
---

今までのterraformでは, EC2のインスタンスタイプ変更を行なった場合に強制的にインスタンスの再作成が行われてしまうため一手間必要だった.  
[Terraform で作ったEC2インスタンスのタイプを変更するには](http://qiita.com/kjm/items/83609ad4d7eb4af58db4)
  
それがterraform 0.8.8でようやくインスタンスタイプの変更に対応したようなので早速試してみた.  
(対応するPR https://github.com/hashicorp/terraform/pull/11998)

<!--more-->

### 準備

まずはインスタンス作成.

```
provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "test_instance" {
  ami           = "ami-56d4ad31"
  instance_type = "t2.nano"
}
```

```
$ terraform plan

+ aws_instance.test_instance
    ami:                         "ami-56d4ad31"
    associate_public_ip_address: "<computed>"
    availability_zone:           "<computed>"
    ebs_block_device.#:          "<computed>"
    ephemeral_block_device.#:    "<computed>"
    instance_state:              "<computed>"
    instance_type:               "t2.micro"
    ipv6_addresses.#:            "<computed>"
    key_name:                    "<computed>"
    network_interface_id:        "<computed>"
    placement_group:             "<computed>"
    private_dns:                 "<computed>"
    private_ip:                  "<computed>"
    public_dns:                  "<computed>"
    public_ip:                   "<computed>"
    root_block_device.#:         "<computed>"
    security_groups.#:           "<computed>"
    source_dest_check:           "true"
    subnet_id:                   "<computed>"
    tenancy:                     "<computed>"
    vpc_security_group_ids.#:    "<computed>"


Plan: 1 to add, 0 to change, 0 to destroy.
```

```
$ terraform apply
aws_instance.test_instance: Creating...
  ami:                         "" => "ami-56d4ad31"
  associate_public_ip_address: "" => "<computed>"
  availability_zone:           "" => "<computed>"
  ebs_block_device.#:          "" => "<computed>"
  ephemeral_block_device.#:    "" => "<computed>"
  instance_state:              "" => "<computed>"
  instance_type:               "" => "t2.micro"
  ipv6_addresses.#:            "" => "<computed>"
  key_name:                    "" => "<computed>"
  network_interface_id:        "" => "<computed>"
  placement_group:             "" => "<computed>"
  private_dns:                 "" => "<computed>"
  private_ip:                  "" => "<computed>"
  public_dns:                  "" => "<computed>"
  public_ip:                   "" => "<computed>"
  root_block_device.#:         "" => "<computed>"
  security_groups.#:           "" => "<computed>"
  source_dest_check:           "" => "true"
  subnet_id:                   "" => "<computed>"
  tenancy:                     "" => "<computed>"
  vpc_security_group_ids.#:    "" => "<computed>"
aws_instance.test_instance: Still creating... (10s elapsed)
aws_instance.test_instance: Still creating... (20s elapsed)
aws_instance.test_instance: Still creating... (30s elapsed)
aws_instance.test_instance: Creation complete

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

サクッと完成.

```
$ terraform show | egrep -w "id|instance_type"
id = i-0a38dad8d43d205f3
instance_type = t2.micro
```

### 変更を試す

`t2.micro` から `t2.nano` へ変更してみる.

```
ec2-test.tf
provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "test_instance" {
  ami           = "ami-56d4ad31"
  instance_type = "t2.nano"
}
```

```
$ terraform plan
~ aws_instance.test_instance
    instance_type: "t2.micro" => "t2.nano"


Plan: 0 to add, 1 to change, 0 to destroy.
```

```
$ terraform apply
aws_instance.test_instance: Refreshing state... (ID: i-0a38dad8d43d205f3)
aws_instance.test_instance: Modifying...
  instance_type: "t2.micro" => "t2.nano"
aws_instance.test_instance: Still modifying... (10s elapsed)
aws_instance.test_instance: Still modifying... (20s elapsed)
aws_instance.test_instance: Still modifying... (30s elapsed)
aws_instance.test_instance: Still modifying... (40s elapsed)
aws_instance.test_instance: Still modifying... (50s elapsed)
aws_instance.test_instance: Modifications complete

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```

無事変更できた.  
instance-idも変わっておらず、再作成は行われていない.

```
$ terraform show | egrep -w "id|instance_type"
id = i-0a38dad8d43d205f3
instance_type = t2.nano
```

`Still modifying...` の間, マネジメントコンソールを眺めていたが, インスタンスのstop/startが行われている様子が確認できた.

---

これからは安心してインスタンスタイプの変更を行える.
