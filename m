Return-Path: <SRS0=n8VH=BX=lists.openwall.com=kernel-hardening-return-19620-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48443C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Aug 2020 15:19:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6AD942078D
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Aug 2020 15:19:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AD942078D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19620-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1523 invoked by uid 550); 13 Aug 2020 15:19:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1500 invoked from network); 13 Aug 2020 15:19:48 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kHpviHVAWFum71m9T91C+ViCrMTffHDaBIsRm4hTUyU=;
        b=JPAKZgpPBTUC8QIQYBJD1sY5O8n1yIBpUGkRKVdp/O0bjth9kL8V1CTfF38PN9LBxW
         eZGb/yTCBlA+6cogpeCxmMjGhJXY2ZHLXTjojHTGpNwt/b3GwZV+R0/NgbjF7uFQ7tK2
         xJmz3Bl/lDmYrx1FomEBnZegW0oDlzO2E5veBHcw6vzMZN6U6djjDeokU9UBjN1i6Q50
         VHmCUTd7U12Ch62i4IfFnz/kjEDVFUeK8vmAic6Sh9G8Tmo0Vr2JPyFtha0ErgSDtcLx
         r33AVvfUx6aDVuUEZaIrh23hcf3zfm4s8aP2R7wR4T1fr4lfddDxUGjeFIMkU4Ke8ZMh
         Eo5A==
X-Gm-Message-State: AOAM531+o3WRIhroV5un2raUeXDdrPPI7xu1k8YNvO20OoL9b3FiussJ
	KlrIQeGGlNTS0w1V0XUwQ+E=
X-Google-Smtp-Source: ABdhPJwtcfXWy9ymXF9xh5AnIJbVJZKRsqkwfDB6bwfz2pR9v2SLKeaOyzgDFjsRvOSztqlcctDyPw==
X-Received: by 2002:a5d:6505:: with SMTP id x5mr4470670wru.336.1597331977069;
        Thu, 13 Aug 2020 08:19:37 -0700 (PDT)
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
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org,
	Alexander Popov <alex.popov@linux.com>
Cc: notify@kernel.org
Subject: [PATCH RFC 0/2] Break heap spraying needed for exploiting use-after-free
Date: Thu, 13 Aug 2020 18:19:20 +0300
Message-Id: <20200813151922.1093791-1-alex.popov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello everyone! Requesting for your comments.

Use-after-free vulnerabilities in the Linux kernel are very popular for
exploitation. A few examples:
 https://googleprojectzero.blogspot.com/2018/09/a-cache-invalidation-bug-in-linux.html
 https://googleprojectzero.blogspot.com/2019/11/bad-binder-android-in-wild-exploit.html?m=1
 https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html

Use-after-free exploits usually employ heap spraying technique.
Generally it aims to put controlled bytes at a predetermined memory
location on the heap. Heap spraying for exploiting use-after-free in
the Linux kernel relies on the fact that on kmalloc(), the slab allocator
returns the address of the memory that was recently freed. So allocating
a kernel object with the same size and controlled contents allows
overwriting the vulnerable freed object.

I've found an easy way to break heap spraying for use-after-free
exploitation. I simply extracted slab freelist quarantine from KASAN
functionality and called it CONFIG_SLAB_QUARANTINE. Please see patch 1.

If this feature is enabled, freed allocations are stored in the quarantine
and can't be instantly reallocated and overwritten by the exploit
performing heap spraying.

In patch 2 you can see the lkdtm test showing how CONFIG_SLAB_QUARANTINE
prevents immediate reallocation of a freed heap object.

I tested this patch series both for CONFIG_SLUB and CONFIG_SLAB.

CONFIG_SLAB_QUARANTINE disabled:
  # echo HEAP_SPRAY > /sys/kernel/debug/provoke-crash/DIRECT
  lkdtm: Performing direct entry HEAP_SPRAY
  lkdtm: Performing heap spraying...
  lkdtm: attempt 0: spray alloc addr 00000000f8699c7d vs freed addr 00000000f8699c7d
  lkdtm: freed addr is reallocated!
  lkdtm: FAIL! Heap spraying succeed :(

CONFIG_SLAB_QUARANTINE enabled:
  # echo HEAP_SPRAY > /sys/kernel/debug/provoke-crash/DIRECT
  lkdtm: Performing direct entry HEAP_SPRAY
  lkdtm: Performing heap spraying...
  lkdtm: attempt 0: spray alloc addr 000000009cafb63f vs freed addr 00000000173cce94
  lkdtm: attempt 1: spray alloc addr 000000003096911f vs freed addr 00000000173cce94
  lkdtm: attempt 2: spray alloc addr 00000000da60d755 vs freed addr 00000000173cce94
  lkdtm: attempt 3: spray alloc addr 000000000b415070 vs freed addr 00000000173cce94
  ...
  lkdtm: attempt 126: spray alloc addr 00000000e80ef807 vs freed addr 00000000173cce94
  lkdtm: attempt 127: spray alloc addr 00000000398fe535 vs freed addr 00000000173cce94
  lkdtm: OK! Heap spraying hasn't succeed :)

I did a brief performance evaluation of this feature.

1. Memory consumption. KASAN quarantine uses 1/32 of the memory.
CONFIG_SLAB_QUARANTINE disabled:
  # free -m
                total        used        free      shared  buff/cache   available
  Mem:           1987          39        1862          10          86        1907
  Swap:             0           0           0
CONFIG_SLAB_QUARANTINE enabled:
  # free -m
                total        used        free      shared  buff/cache   available
  Mem:           1987         140        1760          10          87        1805
  Swap:             0           0           0

2. Performance penalty. I used `hackbench -s 256 -l 200 -g 15 -f 25 -P`.
CONFIG_SLAB_QUARANTINE disabled (x86_64, CONFIG_SLUB):
  Times: 3.088, 3.103, 3.068, 3.103, 3.107
  Mean: 3.0938
  Standard deviation: 0.0144
CONFIG_SLAB_QUARANTINE enabled (x86_64, CONFIG_SLUB):
  Times: 3.303, 3.329, 3.356, 3.314, 3.292
  Mean: 3.3188 (+7.3%)
  Standard deviation: 0.0223

I would appreciate your feedback!

Best regards,
Alexander

Alexander Popov (2):
  mm: Extract SLAB_QUARANTINE from KASAN
  lkdtm: Add heap spraying test

 drivers/misc/lkdtm/core.c  |   1 +
 drivers/misc/lkdtm/heap.c  |  40 ++++++++++++++
 drivers/misc/lkdtm/lkdtm.h |   1 +
 include/linux/kasan.h      | 107 ++++++++++++++++++++-----------------
 include/linux/slab_def.h   |   2 +-
 include/linux/slub_def.h   |   2 +-
 init/Kconfig               |  11 ++++
 mm/Makefile                |   3 +-
 mm/kasan/Makefile          |   2 +
 mm/kasan/kasan.h           |  75 +++++++++++++-------------
 mm/kasan/quarantine.c      |   2 +
 mm/kasan/slab_quarantine.c |  99 ++++++++++++++++++++++++++++++++++
 mm/slub.c                  |   2 +-
 13 files changed, 258 insertions(+), 89 deletions(-)
 create mode 100644 mm/kasan/slab_quarantine.c

-- 
2.26.2

