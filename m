Return-Path: <SRS0=4KFD=DM=lists.openwall.com=kernel-hardening-return-20098-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07350C4363A
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Oct 2020 22:57:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B9C672074F
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Oct 2020 22:57:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LzInzBBk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9C672074F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20098-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19846 invoked by uid 550); 5 Oct 2020 22:57:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19819 invoked from network); 5 Oct 2020 22:57:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Plwfd7H8tCYXAG47Hb1jocyHIm5qQosjRcCwHQHMhLQ=;
        b=LzInzBBkyOAlRLrd9DIoCXw4pTZ7u5HoIs4Khj64PnxL7d2Kc4bctqZC4RdhjxZPOc
         D18rzbDzBCMDuOV0Pj3iTqrEQ06LeRPJjujq9ltFxeNXZWLnsSsq1Nnx6wbyh5i4Hb9L
         RaiV7U4t1fTg+RIySYrBJViXTvdBIZBnm20L7PvSOKIWNlO0fC2/Fcmqk90o93hKznsY
         HcSwqrok1Hw7ZOWavR9Nq8GmCW6V/Zn2puJXT/0o0aS5oEqz3+pVVKeou93PxU5873q7
         Gfv40YwT+BVzbx+BQLZwv1gu4BU41K9Wn6HFeCPeMdWAkNa2+lh8w2kHx8/+m0dUKQAm
         repg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Plwfd7H8tCYXAG47Hb1jocyHIm5qQosjRcCwHQHMhLQ=;
        b=M56LkXQ6Qj8ZiodlaYbpH8YfLVXYuAs8M2UAMhW/aDuzjX50zUz1fMa2lZOqBFA9cZ
         Q16nLeek+d34wM383p5ytpD8mtZboIJQ7rzo+GIHtNIfpYKQ2mZZLDMe0LSy/0x8Hphq
         WIF+V+0T57lIfR4mSSkuHF2eP+fGkVqJGlo1bJQRjFjiMWJdEZMdX4n7YVI01/8a57xO
         0EQifbN+nCl2qHfnqo/ALYY+ozjd/P040a9+gTk5h4l5danRXNqyU3lCR6v+t8WL2Z31
         a7wHmc4Ital3pcNP9yysoFl9kH2WHxYgVGZtOdvzMoDKIpAXFEuUJESp/tE5hR1ZnCAm
         Nm/g==
X-Gm-Message-State: AOAM533RvluhBcV5lwW5+A7R+I5Fh4KqWk6bkqQsNFD0X4+pvse6R4/f
	Axcm+icQdEs3pvDB6dkBzQpocjl8wiD9ZCfdzbtHJA==
X-Google-Smtp-Source: ABdhPJxRuWMwQ47slmRQ6lEBgSDNf082OrP+P5YyRptQ047RbkpKnF15AOQMDA80yoZ8VgDSaQIpBF5aFIzAOF8DApk=
X-Received: by 2002:a17:906:86c3:: with SMTP id j3mr2078310ejy.493.1601938620315;
 Mon, 05 Oct 2020 15:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200929183513.380760-1-alex.popov@linux.com> <91d564a6-9000-b4c5-15fd-8774b06f5ab0@linux.com>
In-Reply-To: <91d564a6-9000-b4c5-15fd-8774b06f5ab0@linux.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 6 Oct 2020 00:56:33 +0200
Message-ID: <CAG48ez1tNU_7n8qtnxTYZ5qt-upJ81Fcb0P2rZe38ARK=iyBkA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/6] Break heap spraying needed for exploiting use-after-free
To: Alexander Popov <alex.popov@linux.com>
Cc: Kees Cook <keescook@chromium.org>, Will Deacon <will@kernel.org>, 
	Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Peter Zijlstra <peterz@infradead.org>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Patrick Bellasi <patrick.bellasi@arm.com>, David Howells <dhowells@redhat.com>, 
	Eric Biederman <ebiederm@xmission.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Laura Abbott <labbott@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Micay <danielmicay@gmail.com>, 
	Andrey Konovalov <andreyknvl@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Pavel Machek <pavel@denx.de>, Valentin Schneider <valentin.schneider@arm.com>, 
	kasan-dev <kasan-dev@googlegroups.com>, Linux-MM <linux-mm@kvack.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	kernel list <linux-kernel@vger.kernel.org>, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 1, 2020 at 9:43 PM Alexander Popov <alex.popov@linux.com> wrote:
> On 29.09.2020 21:35, Alexander Popov wrote:
> > This is the second version of the heap quarantine prototype for the Linux
> > kernel. I performed a deeper evaluation of its security properties and
> > developed new features like quarantine randomization and integration with
> > init_on_free. That is fun! See below for more details.
> >
> >
> > Rationale
> > =========
> >
> > Use-after-free vulnerabilities in the Linux kernel are very popular for
> > exploitation. There are many examples, some of them:
> >  https://googleprojectzero.blogspot.com/2018/09/a-cache-invalidation-bug-in-linux.html

I don't think your proposed mitigation would work with much
reliability against this bug; the attacker has full control over the
timing of the original use and the following use, so an attacker
should be able to trigger the kmem_cache_free(), then spam enough new
VMAs and delete them to flush out the quarantine, and then do heap
spraying as normal, or something like that.

Also, note that here, if the reallocation fails, the kernel still
wouldn't crash because the dangling object is not accessed further if
the address range stored in it doesn't match the fault address. So an
attacker could potentially try multiple times, and if the object
happens to be on the quarantine the first time, that wouldn't really
be a showstopper, you'd just try again.

> >  https://googleprojectzero.blogspot.com/2019/11/bad-binder-android-in-wild-exploit.html?m=1

I think that here, again, the free() and the dangling pointer use were
caused by separate syscalls, meaning the attacker had control over
that timing?

> >  https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html

Haven't looked at that one in detail.

> > Use-after-free exploits usually employ heap spraying technique.
> > Generally it aims to put controlled bytes at a predetermined memory
> > location on the heap.

Well, not necessarily "predetermined". Depending on the circumstances,
you don't necessarily need to know which address you're writing to;
and you might not even need to overwrite a specific object, but
instead just have to overwrite one out of a bunch of objects, no
matter which.

> > Heap spraying for exploiting use-after-free in the Linux kernel relies on
> > the fact that on kmalloc(), the slab allocator returns the address of
> > the memory that was recently freed.

Yeah; and that behavior is pretty critical for performance. The longer
it's been since a newly allocated object was freed, the higher the
chance that you'll end up having to go further down the memory cache
hierarchy.

> > So allocating a kernel object with
> > the same size and controlled contents allows overwriting the vulnerable
> > freed object.

The vmacache exploit you linked to doesn't do that, it frees the
object all the way back to the page allocator and then sprays 4MiB of
memory from the page allocator. (Because VMAs use their own
kmem_cache, and the kmem_cache wasn't merged with any interesting
ones, and I saw no good way to exploit the bug by reallocating another
VMA over the old VMA back then. Although of course that doesn't mean
that there is no such way.)

[...]
> > Security properties
> > ===================
> >
> > For researching security properties of the heap quarantine I developed 2 lkdtm
> > tests (see the patch 5/6).
> >
> > The first test is called lkdtm_HEAP_SPRAY. It allocates and frees an object
> > from a separate kmem_cache and then allocates 400000 similar objects.
> > I.e. this test performs an original heap spraying technique for use-after-free
> > exploitation.
> >
> > If CONFIG_SLAB_QUARANTINE is disabled, the freed object is instantly
> > reallocated and overwritten:
> >   # echo HEAP_SPRAY > /sys/kernel/debug/provoke-crash/DIRECT
> >    lkdtm: Performing direct entry HEAP_SPRAY
> >    lkdtm: Allocated and freed spray_cache object 000000002b5b3ad4 of size 333
> >    lkdtm: Original heap spraying: allocate 400000 objects of size 333...
> >    lkdtm: FAIL: attempt 0: freed object is reallocated
> >
> > If CONFIG_SLAB_QUARANTINE is enabled, 400000 new allocations don't overwrite
> > the freed object:
> >   # echo HEAP_SPRAY > /sys/kernel/debug/provoke-crash/DIRECT
> >    lkdtm: Performing direct entry HEAP_SPRAY
> >    lkdtm: Allocated and freed spray_cache object 000000009909e777 of size 333
> >    lkdtm: Original heap spraying: allocate 400000 objects of size 333...
> >    lkdtm: OK: original heap spraying hasn't succeed
> >
> > That happens because pushing an object through the quarantine requires _both_
> > allocating and freeing memory. Objects are released from the quarantine on
> > new memory allocations, but only when the quarantine size is over the limit.
> > And the quarantine size grows on new memory freeing.
> >
> > That's why I created the second test called lkdtm_PUSH_THROUGH_QUARANTINE.
> > It allocates and frees an object from a separate kmem_cache and then performs
> > kmem_cache_alloc()+kmem_cache_free() for that cache 400000 times.
> > This test effectively pushes the object through the heap quarantine and
> > reallocates it after it returns back to the allocator freelist:
[...]
> > As you can see, the number of the allocations that are needed for overwriting
> > the vulnerable object is almost the same. That would be good for stable
> > use-after-free exploitation and should not be allowed.
> > That's why I developed the quarantine randomization (see the patch 4/6).
> >
> > This randomization required very small hackish changes of the heap quarantine
> > mechanism. At first all quarantine batches are filled by objects. Then during
> > the quarantine reducing I randomly choose and free 1/2 of objects from a
> > randomly chosen batch. Now the randomized quarantine releases the freed object
> > at an unpredictable moment:
> >    lkdtm: Target object is reallocated at attempt 107884
[...]
> >    lkdtm: Target object is reallocated at attempt 87343

Those numbers are fairly big. At that point you might not even fit
into L3 cache anymore, right? You'd often be hitting DRAM for new
allocations? And for many slabs, you might end using much more memory
for the quarantine than for actual in-use allocations.

It seems to me like, for this to stop attacks with a high probability,
you'd have to reserve a huge chunk of kernel memory for the
quarantines - even if the attacker doesn't know anything about the
status of the quarantine (which isn't necessarily the case, depending
on whether the attacker can abuse microarchitectural data leakage, or
if the attacker can trigger a pure data read through the dangling
pointer), they should still be able to win with a probability around
quarantine_size/allocated_memory_size if they have a heap spraying
primitive without strict limits.

> > However, this randomization alone would not disturb the attacker, because
> > the quarantine stores the attacker's data (the payload) in the sprayed objects.
> > I.e. the reallocated and overwritten vulnerable object contains the payload
> > until the next reallocation (very bad).
> >
> > Hence heap objects should be erased before going to the heap quarantine.
> > Moreover, filling them by zeros gives a chance to detect use-after-free
> > accesses to non-zero data while an object stays in the quarantine (nice!).
> > That functionality already exists in the kernel, it's called init_on_free.
> > I integrated it with CONFIG_SLAB_QUARANTINE in the patch 3/6.
> >
> > During that work I found a bug: in CONFIG_SLAB init_on_free happens too
> > late, and heap objects go to the KASAN quarantine being dirty. See the fix
> > in the patch 2/6.
[...]
> I've made various tests on real hardware and in virtual machines:
>  1) network throughput test using iperf
>      server: iperf -s -f K
>      client: iperf -c 127.0.0.1 -t 60 -f K
>  2) scheduler stress test
>      hackbench -s 4000 -l 500 -g 15 -f 25 -P
>  3) building the defconfig kernel
>      time make -j2
>
> I compared Linux kernel 5.9.0-rc6 with:
>  - init_on_free=off,
>  - init_on_free=on,
>  - CONFIG_SLAB_QUARANTINE=y (which enables init_on_free).
>
> Each test was performed 5 times. I will show the mean values.
> If you are interested, I can share all the results and calculate standard deviation.
>
> Real hardware, Intel Core i7-6500U CPU
>  1) Network throughput test with iperf
>      init_on_free=off: 5467152.2 KBytes/sec
>      init_on_free=on: 3937545 KBytes/sec (-28.0% vs init_on_free=off)
>      CONFIG_SLAB_QUARANTINE: 3858848.6 KBytes/sec (-2.0% vs init_on_free=on)
>  2) Scheduler stress test with hackbench
>      init_on_free=off: 8.5364s
>      init_on_free=on: 8.9858s (+5.3% vs init_on_free=off)
>      CONFIG_SLAB_QUARANTINE: 17.2232s (+91.7% vs init_on_free=on)

These numbers seem really high for a mitigation, especially if that
performance hit does not really buy you deterministic protection
against many bugs.

[...]
> N.B. There was NO performance optimization made for this version of the heap
> quarantine prototype. The main effort was put into researching its security
> properties (hope for your feedback). Performance optimization will be done in
> further steps, if we see that my work is worth doing.

But you are pretty much inherently limited in terms of performance by
the effect the quarantine has on the data cache, right?

It seems to me like, if you want to make UAF exploitation harder at
the heap allocator layer, you could do somewhat more effective things
with a probably much smaller performance budget. Things like
preventing the reallocation of virtual kernel addresses with different
types, such that an attacker can only replace a UAF object with
another object of the same type. (That is not an idea I like very much
either, but I would like it more than this proposal.) (E.g. some
browsers implement things along those lines, I believe.)
