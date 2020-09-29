Return-Path: <SRS0=mIHW=DG=lists.openwall.com=kernel-hardening-return-20020-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416ADC47423
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 18:36:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DEBD3208B8
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 18:35:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEBD3208B8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20020-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23761 invoked by uid 550); 29 Sep 2020 18:35:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23734 invoked from network); 29 Sep 2020 18:35:50 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eqJLertCH1IwPmpvLzgQGPTWwPvCX5lgWM52z3jpf1I=;
        b=q0i8OryO5XB926dvWocLpVm1yL1owLBoas4wINXC1LX0R8VRl9/HyGQu9TTotzZzqD
         QCLccTel8g2RTLMccpYV1+aK5E86eCNkSFOMyYYviEKkADWoaJa1jfz5vlaU51KmfIUp
         Lcjanr3UpaeORg0JrhlZv+wVA6L5IFvMveME2KXMKM7nVHRwGbEoIuRG7J/9NNpzv6ww
         11xL/yRWPZEKOmP0OsZKxZyaaW7D+u2FE8usgohcs1vGnlZ5/oDK/LISgDVwVmzgKs49
         Ey6jWRWxZq1IuOrHB2jKaPwpOBlDBCxo49WFLNjGIGD92rtjOANTwBenUna5AwEXpk4n
         fRsw==
X-Gm-Message-State: AOAM532UVtD+iyaaRrsSxOoqWZw8Lk1TsykAAp+/x6ikoERTDcMOtV7S
	lmiWApwV65J/Fo5rF56LG8bvdyCm87Y08g==
X-Google-Smtp-Source: ABdhPJxWZLL9RP7nXf3W4jf2LKYICeObNnqcueChYVBbcf4bfgeDNmDM/nZcIVKbwqwVFYQ7oBrK+A==
X-Received: by 2002:a5d:6b84:: with SMTP id n4mr6285730wrx.55.1601404538270;
        Tue, 29 Sep 2020 11:35:38 -0700 (PDT)
From: Alexander Popov <alex.popov@linux.com>
To: Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>,
	Will Deacon <will@kernel.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Patrick Bellasi <patrick.bellasi@arm.com>,
	David Howells <dhowells@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Laura Abbott <labbott@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Daniel Micay <danielmicay@gmail.com>,
	Andrey Konovalov <andreyknvl@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Pavel Machek <pavel@denx.de>,
	Valentin Schneider <valentin.schneider@arm.com>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org,
	Alexander Popov <alex.popov@linux.com>
Cc: notify@kernel.org
Subject: [PATCH RFC v2 0/6] Break heap spraying needed for exploiting use-after-free
Date: Tue, 29 Sep 2020 21:35:07 +0300
Message-Id: <20200929183513.380760-1-alex.popov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello everyone! Requesting for your comments.

This is the second version of the heap quarantine prototype for the Linux
kernel. I performed a deeper evaluation of its security properties and
developed new features like quarantine randomization and integration with
init_on_free. That is fun! See below for more details.


Rationale
=========

Use-after-free vulnerabilities in the Linux kernel are very popular for
exploitation. There are many examples, some of them:
 https://googleprojectzero.blogspot.com/2018/09/a-cache-invalidation-bug-in-linux.html
 https://googleprojectzero.blogspot.com/2019/11/bad-binder-android-in-wild-exploit.html?m=1
 https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html

Use-after-free exploits usually employ heap spraying technique.
Generally it aims to put controlled bytes at a predetermined memory
location on the heap.

Heap spraying for exploiting use-after-free in the Linux kernel relies on
the fact that on kmalloc(), the slab allocator returns the address of
the memory that was recently freed. So allocating a kernel object with
the same size and controlled contents allows overwriting the vulnerable
freed object.

I've found an easy way to break the heap spraying for use-after-free
exploitation. I extracted slab freelist quarantine from KASAN functionality
and called it CONFIG_SLAB_QUARANTINE. Please see patch 1/6.

If this feature is enabled, freed allocations are stored in the quarantine
queue where they wait for actual freeing. So they can't be instantly
reallocated and overwritten by use-after-free exploits.

N.B. Heap spraying for out-of-bounds exploitation is another technique,
heap quarantine doesn't break it.


Security properties
===================

For researching security properties of the heap quarantine I developed 2 lkdtm
tests (see the patch 5/6).

The first test is called lkdtm_HEAP_SPRAY. It allocates and frees an object
from a separate kmem_cache and then allocates 400000 similar objects.
I.e. this test performs an original heap spraying technique for use-after-free
exploitation.

If CONFIG_SLAB_QUARANTINE is disabled, the freed object is instantly
reallocated and overwritten:
  # echo HEAP_SPRAY > /sys/kernel/debug/provoke-crash/DIRECT
   lkdtm: Performing direct entry HEAP_SPRAY
   lkdtm: Allocated and freed spray_cache object 000000002b5b3ad4 of size 333
   lkdtm: Original heap spraying: allocate 400000 objects of size 333...
   lkdtm: FAIL: attempt 0: freed object is reallocated

If CONFIG_SLAB_QUARANTINE is enabled, 400000 new allocations don't overwrite
the freed object:
  # echo HEAP_SPRAY > /sys/kernel/debug/provoke-crash/DIRECT
   lkdtm: Performing direct entry HEAP_SPRAY
   lkdtm: Allocated and freed spray_cache object 000000009909e777 of size 333
   lkdtm: Original heap spraying: allocate 400000 objects of size 333...
   lkdtm: OK: original heap spraying hasn't succeed

That happens because pushing an object through the quarantine requires _both_
allocating and freeing memory. Objects are released from the quarantine on
new memory allocations, but only when the quarantine size is over the limit.
And the quarantine size grows on new memory freeing.

That's why I created the second test called lkdtm_PUSH_THROUGH_QUARANTINE.
It allocates and frees an object from a separate kmem_cache and then performs
kmem_cache_alloc()+kmem_cache_free() for that cache 400000 times.
This test effectively pushes the object through the heap quarantine and
reallocates it after it returns back to the allocator freelist:
  # echo PUSH_THROUGH_QUARANTINE > /sys/kernel/debug/provoke-crash/
   lkdtm: Performing direct entry PUSH_THROUGH_QUARANTINE
   lkdtm: Allocated and freed spray_cache object 000000008fdb15c3 of size 333
   lkdtm: Push through quarantine: allocate and free 400000 objects of size 333...
   lkdtm: Target object is reallocated at attempt 182994
  # echo PUSH_THROUGH_QUARANTINE > /sys/kernel/debug/provoke-crash/
   lkdtm: Performing direct entry PUSH_THROUGH_QUARANTINE
   lkdtm: Allocated and freed spray_cache object 000000004e223cbe of size 333
   lkdtm: Push through quarantine: allocate and free 400000 objects of size 333...
   lkdtm: Target object is reallocated at attempt 186830
  # echo PUSH_THROUGH_QUARANTINE > /sys/kernel/debug/provoke-crash/
   lkdtm: Performing direct entry PUSH_THROUGH_QUARANTINE
   lkdtm: Allocated and freed spray_cache object 000000007663a058 of size 333
   lkdtm: Push through quarantine: allocate and free 400000 objects of size 333...
   lkdtm: Target object is reallocated at attempt 182010

As you can see, the number of the allocations that are needed for overwriting
the vulnerable object is almost the same. That would be good for stable
use-after-free exploitation and should not be allowed.
That's why I developed the quarantine randomization (see the patch 4/6).

This randomization required very small hackish changes of the heap quarantine
mechanism. At first all quarantine batches are filled by objects. Then during
the quarantine reducing I randomly choose and free 1/2 of objects from a
randomly chosen batch. Now the randomized quarantine releases the freed object
at an unpredictable moment:
   lkdtm: Target object is reallocated at attempt 107884
   lkdtm: Target object is reallocated at attempt 265641
   lkdtm: Target object is reallocated at attempt 100030
   lkdtm: Target object is NOT reallocated in 400000 attempts
   lkdtm: Target object is reallocated at attempt 204731
   lkdtm: Target object is reallocated at attempt 359333
   lkdtm: Target object is reallocated at attempt 289349
   lkdtm: Target object is reallocated at attempt 119893
   lkdtm: Target object is reallocated at attempt 225202
   lkdtm: Target object is reallocated at attempt 87343

However, this randomization alone would not disturb the attacker, because
the quarantine stores the attacker's data (the payload) in the sprayed objects.
I.e. the reallocated and overwritten vulnerable object contains the payload
until the next reallocation (very bad).

Hence heap objects should be erased before going to the heap quarantine.
Moreover, filling them by zeros gives a chance to detect use-after-free
accesses to non-zero data while an object stays in the quarantine (nice!).
That functionality already exists in the kernel, it's called init_on_free.
I integrated it with CONFIG_SLAB_QUARANTINE in the patch 3/6.

During that work I found a bug: in CONFIG_SLAB init_on_free happens too
late, and heap objects go to the KASAN quarantine being dirty. See the fix
in the patch 2/6.

For deeper understanding of the heap quarantine inner workings, I attach
the patch 6/6, which contains verbose debugging (not for merge).
It's very helpful, see the output example:
   quarantine: PUT 508992 to tail batch 123, whole sz 65118872, batch sz 508854
   quarantine: whole sz exceed max by 494552, REDUCE head batch 0 by 415392, leave 396304
   quarantine: data level in batches:
     0 - 77%
     1 - 108%
     2 - 83%
     3 - 21%
   ...
     125 - 75%
     126 - 12%
     127 - 108%
   quarantine: whole sz exceed max by 79160, REDUCE head batch 12 by 14160, leave 17608
   quarantine: whole sz exceed max by 65000, REDUCE head batch 75 by 218328, leave 195232
   quarantine: PUT 508992 to tail batch 124, whole sz 64979984, batch sz 508854
   ...


Changes in v2
=============

 - Added heap quarantine randomization (the patch 4/6).

 - Integrated CONFIG_SLAB_QUARANTINE with init_on_free (the patch 3/6).

 - Fixed late init_on_free in CONFIG_SLAB (the patch 2/6).

 - Added lkdtm_PUSH_THROUGH_QUARANTINE test.

 - Added the quarantine verbose debugging (the patch 6/6, not for merge).

 - Improved the descriptions according to the feedback from Kees Cook
   and Matthew Wilcox.

 - Made fixes recommended by Kees Cook:

   * Avoided BUG_ON() in kasan_cache_create() by handling the error and
     reporting with WARN_ON().

   * Created a separate kmem_cache for new lkdtm tests.

   * Fixed kasan_track.pid type to pid_t.


TODO for the next prototypes
============================

1. Performance evaluation and optimization.
   I would really appreciate your ideas about performance testing of a
   kernel with the heap quarantine. The first prototype was tested with
   hackbench and kernel build timing (which showed very different numbers).
   Earlier the developers similarly tested init_on_free functionality.
   However, Brad Spengler says in his twitter that such testing method
   is poor.

2. Complete separation of CONFIG_SLAB_QUARANTINE from KASAN (feedback
   from Andrey Konovalov).

3. Adding a kernel boot parameter for enabling/disabling the heap quaranitne
   (feedback from Kees Cook).

4. Testing the heap quarantine in near-OOM situations (feedback from
   Pavel Machek).

5. Does this work somehow help or disturb the integration of the
   Memory Tagging for the Linux kernel?

6. After rebasing the series onto v5.9.0-rc6, CONFIG_SLAB kernel started to
   show warnings about few slab caches that have no space for additional
   metadata. It needs more investigation. I believe it affects KASAN bug
   detection abilities as well. Warning example:
     WARNING: CPU: 0 PID: 0 at mm/kasan/slab_quarantine.c:38 kasan_cache_create+0x37/0x50
     Modules linked in:
     CPU: 0 PID: 0 Comm: swapper Not tainted 5.9.0-rc6+ #1
     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
     RIP: 0010:kasan_cache_create+0x37/0x50
     ...
     Call Trace:
      __kmem_cache_create+0x74/0x250
      create_boot_cache+0x6d/0x91
      create_kmalloc_cache+0x57/0x93
      new_kmalloc_cache+0x39/0x47
      create_kmalloc_caches+0x33/0xd9
      start_kernel+0x25b/0x532
      secondary_startup_64+0xb6/0xc0

Thanks in advance for your feedback.
Best regards,
Alexander


Alexander Popov (6):
  mm: Extract SLAB_QUARANTINE from KASAN
  mm/slab: Perform init_on_free earlier
  mm: Integrate SLAB_QUARANTINE with init_on_free
  mm: Implement slab quarantine randomization
  lkdtm: Add heap quarantine tests
  mm: Add heap quarantine verbose debugging (not for merge)

 drivers/misc/lkdtm/core.c  |   2 +
 drivers/misc/lkdtm/heap.c  | 110 +++++++++++++++++++++++++++++++++++++
 drivers/misc/lkdtm/lkdtm.h |   2 +
 include/linux/kasan.h      | 107 ++++++++++++++++++++----------------
 include/linux/slab_def.h   |   2 +-
 include/linux/slub_def.h   |   2 +-
 init/Kconfig               |  14 +++++
 mm/Makefile                |   3 +-
 mm/kasan/Makefile          |   2 +
 mm/kasan/kasan.h           |  75 +++++++++++++------------
 mm/kasan/quarantine.c      | 102 ++++++++++++++++++++++++++++++----
 mm/kasan/slab_quarantine.c | 106 +++++++++++++++++++++++++++++++++++
 mm/page_alloc.c            |  22 ++++++++
 mm/slab.c                  |   5 +-
 mm/slub.c                  |   2 +-
 15 files changed, 455 insertions(+), 101 deletions(-)
 create mode 100644 mm/kasan/slab_quarantine.c

-- 
2.26.2

