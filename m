Reply-To: kernel-hardening@lists.openwall.com
From: Jann Horn <jannh@google.com>
Date: Sat, 25 Jun 2016 03:13:11 +0200
Message-Id: <1466817192-9586-1-git-send-email-jannh@google.com>
Subject: [kernel-hardening] [RFC] reference count hardening via kref: another attempt
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: pageexec@freemail.hu, Kees Cook <keescook@google.com>, jann@thejh.net, Jann Horn <jannh@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

I would like to harden the kernel against reference count
overflow bugs. The commit message of the patch contains
a short analysis of code size impact, an explanation why I
want reference count hardening to land in the kernel, and a
description of the algorithm I'd want to use.

The reason I'm writing a cover letter is that my patch, on
its own, is pretty useless: My patch only adds hardening to
struct kref, but nearly all reference counters are
currently implemented using atomic_t, which is a generic
atomic number type. For the patch to be useful, I'll have
to go through the kernel and, for every atomic_t, decide
whether it is a reference count and, if so, change it
(together with all accesses to it) to a kref. According to
a quick grep, there are currently about 2700 atomic_t
struct members or variables in the kernel, so it's going to
be a big amount of work, and the resulting patches will be
gigantic.

Therefore, before I actually spend lots of time on this,
I'd like to know:

 - Does the reference count hardening in my patch look
   okay, and does it have good chances to get accepted
   when submitted for inclusion in the kernel at a later
   point in time?

 - If I manually go through the kernel and write a
   gigantic atomic_t -> struct kref patch (or a few
   patches coarsely grouped by subsystem), how high is
   the probability that it will get accepted?

(Note: I won't have much time for kernel work in the next
four months or so - but afterwards, I could probably
allocate time for getting this done.)

Jann Horn (1):
  kref: pin objects with dangerously high reference count

 include/linux/kref.h | 39 +++++++++++++++++++++++++++++++++------
 init/Kconfig         | 16 ++++++++++++++++
 kernel/Makefile      |  2 +-
 kernel/kref.c        | 17 +++++++++++++++++
 4 files changed, 67 insertions(+), 7 deletions(-)
 create mode 100644 kernel/kref.c

-- 
2.8.0.rc3.226.g39d4020
