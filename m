Return-Path: <kernel-hardening-return-21695-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 3C4DBEE7FF4
	for <kernel-hardening@archiver.kernel.org>; Mon, 11 Sep 2023 09:50:58 +0000 (UTC)
Received: (qmail 22294 invoked by uid 550); 11 Sep 2023 09:50:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22241 invoked from network); 11 Sep 2023 09:50:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694425833; x=1695030633; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z7Crep/nXO31QV2GDdfwJy1xW9/XIy7CcW7VYLyAKr4=;
        b=13fKZ/VrlCJUq0kEIFTmduGRNH3MsRNNynS4kHw/OtNJHLNrDQX9HDRFc9HQHyBKl5
         D7pbVPZ+HQg7Nou8B40f4Mj3OsRrfNcwaD3MGHBcLqUc1LKmE/O5Q1LPxNnQTGEHmW2G
         Eh6rkfrTNxvaJdWYQI2ryYKxdWwKxL+IZZCK420JgLYd1+bzdMZHShCAj59rUWZUrnHa
         a7VVa1iLD01IpgAhI74b3xxMyFok9AhYaN2VNqBvzY1v0t35S0EkslriLpjnrzW6pLpn
         UVuHtKMz1lOaXp6ib4TTUixHZ2flIkn6bwH9XZGpGwBaSBIeXYQ6xHfjBd80hZ3N9PrT
         kNUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694425833; x=1695030633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z7Crep/nXO31QV2GDdfwJy1xW9/XIy7CcW7VYLyAKr4=;
        b=esULrYNR1I5C6aRWWc6VMuma3DeGoBtDfe+HafZeao1Fvc9p0EUDgPqfHi1v6QGeqs
         472Qp919lxeuqfS1E2Wjy/ERTANsJ6q1lAzF1nLQ+RNIBeqpuu+PbeSNWgB3BjaAf/JH
         8EH2y8NwQvUjsm/NL5EanIUWcEv5dzNZYMzteDILhF9T4z4S1YWeM6ASLgkwvB4TLP1B
         G7ZzfX5Z3lgQbtTgsS0/UNTAdxTvw+qvyjb71mMtwoVu/ps+9WGNmOzKAgWPK77fofXV
         X3V5bp3H/FrTmV/TRUOhg/o/nh1QYrvb6Y5WC5hfDy35LLWP7XW/cYiq5Nxcg4DeFhiT
         31AQ==
X-Gm-Message-State: AOJu0YyXvbHwFLmDxumQW16H/5rbA88kdxk97UGvEBUX8h9aHnhGyOnk
	1E/lskmGjJIE1o0S6gx6WL53De8buG08KXyavedS5g==
X-Google-Smtp-Source: AGHT+IEnufPO9OzBEQuYnjHfCtigVlILM0MT8OrU9srZCX0K/h7wQ9Eugsdqm9Ngd6OahcB6Ilp1x+eyS5q6FsKxT1M=
X-Received: by 2002:a50:954d:0:b0:523:193b:5587 with SMTP id
 v13-20020a50954d000000b00523193b5587mr323171eda.6.1694425832864; Mon, 11 Sep
 2023 02:50:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230825211426.3798691-1-jannh@google.com> <CACT4Y+YT6A_ZgkWTF+rxKO_mvZ3AEt+BJtcVR1sKL6LKWDC+0Q@mail.gmail.com>
 <CAG48ez34DN_xsj7hio8epvoE8hM3F_xFoqwWYM-_LVZb39_e9A@mail.gmail.com>
In-Reply-To: <CAG48ez34DN_xsj7hio8epvoE8hM3F_xFoqwWYM-_LVZb39_e9A@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 11 Sep 2023 11:50:19 +0200
Message-ID: <CACT4Y+YcBeshE811w5KSyYpBqaQ3S_-aKanOGZcHCQvHWHc4Tg@mail.gmail.com>
Subject: Re: [PATCH] slub: Introduce CONFIG_SLUB_RCU_DEBUG
To: Jann Horn <jannh@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Christoph Lameter <cl@linux.com>, 
	Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Aug 2023 at 16:40, Jann Horn <jannh@google.com> wrote:
>
> On Sat, Aug 26, 2023 at 5:32=E2=80=AFAM Dmitry Vyukov <dvyukov@google.com=
> wrote:
> > On Fri, 25 Aug 2023 at 23:15, Jann Horn <jannh@google.com> wrote:
> > > Currently, KASAN is unable to catch use-after-free in SLAB_TYPESAFE_B=
Y_RCU
> > > slabs because use-after-free is allowed within the RCU grace period b=
y
> > > design.
> > >
> > > Add a SLUB debugging feature which RCU-delays every individual
> > > kmem_cache_free() before either actually freeing the object or handin=
g it
> > > off to KASAN, and change KASAN to poison freed objects as normal when=
 this
> > > option is enabled.
> > >
> > > Note that this creates a 16-byte unpoisoned area in the middle of the
> > > slab metadata area, which kinda sucks but seems to be necessary in or=
der
> > > to be able to store an rcu_head in there without triggering an ASAN
> > > splat during RCU callback processing.
> >
> > Nice!
> >
> > Can't we unpoision this rcu_head right before call_rcu() and repoison
> > after receiving the callback?
>
> Yeah, I think that should work. It looks like currently
> kasan_unpoison() is exposed in include/linux/kasan.h but
> kasan_poison() is not, and its inline definition probably means I
> can't just move it out of mm/kasan/kasan.h into include/linux/kasan.h;
> do you have a preference for how I should handle this? Hmm, and it
> also looks like code outside of mm/kasan/ anyway wouldn't know what
> are valid values for the "value" argument to kasan_poison().
> I also have another feature idea that would also benefit from having
> something like kasan_poison() available in include/linux/kasan.h, so I
> would prefer that over adding another special-case function inside
> KASAN for poisoning this piece of slab metadata...
>
> I guess I could define a wrapper around kasan_poison() in
> mm/kasan/generic.c that uses a new poison value for "some other part
> of the kernel told us to poison this area", and then expose that
> wrapper with a declaration in include/mm/kasan.h? Something like:
>
> void kasan_poison_outline(const void *addr, size_t size, bool init)
> {
>   kasan_poison(addr, size, KASAN_CUSTOM, init);
> }

Looks reasonable.

> > What happens on cache destruction?
> > Currently we purge quarantine on cache destruction to be able to
> > safely destroy the cache. I suspect we may need to somehow purge rcu
> > callbacks as well, or do something else.
>
> Ooh, good point, I hadn't thought about that... currently
> shutdown_cache() assumes that all the objects have already been freed,
> then puts the kmem_cache on a list for
> slab_caches_to_rcu_destroy_workfn(), which then waits with an
> rcu_barrier() until the slab's pages are all gone.

I guess this is what the test robot found as well.

> Luckily kmem_cache_destroy() is already a sleepable operation, so
> maybe I should just slap another rcu_barrier() in there for builds
> with this config option enabled... I think that should be fine for an
> option mostly intended for debugging.

This is definitely the simplest option.
I am a bit concerned about performance if massive cache destruction
happens (e.g. maybe during destruction of a set of namespaces for a
container). Net namespace is slow to destroy for this reason IIRC,
there were some optimizations to batch rcu synchronization. And now we
are adding more.
But I don't see any reasonable faster option as well.
So I guess let's do this now and optimize later (or not).
