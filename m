From: procmem <procmem@riseup.net>
Subject: Nethammer and kernel network drivers
Message-ID: <078f9b83-44d9-e7b2-6608-41a88e23b63e@riseup.net>
Date: Sat, 2 Jun 2018 03:46:19 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hello. I wanted to get your attention about a new, more serious
reincarnation of rowhammer called nethammer that doesn't need to execut
any code on the system like in the past nor does it leave a trace.

The summary of the paper is that rowhammer can be
remotely triggered by feeding susceptible* network driver crafted
traffic. This attack can do all kinds of nasty things such as modifying
SSL certs on the victim system.

* Susceptible drivers are those relying on Intel CAT, uncached memory or
the clflush instruction.

In absence of hardware mitigations, please identify and disable/fix
susceptible network drivers to avoid this type of attack. Thanks.

**

[0] https://arxiv.org/abs/1805.04956
