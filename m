Return-Path: <kernel-hardening-return-21698-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id AD06FCD37BF
	for <kernel-hardening@archiver.kernel.org>; Sat, 16 Sep 2023 16:31:15 +0000 (UTC)
Received: (qmail 24347 invoked by uid 550); 16 Sep 2023 16:31:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16214 invoked from network); 16 Sep 2023 16:19:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694881145; x=1695485945; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h8L+TF2NB2bKIXmFBrFsqsaXp12HgxVOtYytgv3Hfus=;
        b=YWOG24bxmjnhb3wlhD9tWBVKugzRgYvN817Y1bo3zPp7YQhyp8OxDMH+uUoe1LAbgR
         j252mMvLZAt54mJo59R4VjelYS21Ca88Ma2Ty6vkjq1sPxb0bb+xdvGdFPRNQeZcVsvr
         VA5YMXTDplXHu6uPm9uvRbDxM2bn6dVIHly5IC1oXf0f/a8ewBSvjP0mVWKmiLV/VOjL
         KEViNDWruXeYoJ72cZyLUQ5wOjjP6/WyZreLugDE2ik98TCJ11FkW1QwyW8E47wupr9s
         Ktakts08o3MuEfpRm0+bV6wHnS1DF+GbC/fjupP1opkOcBs42VHx6uCIIcuiWdPqkOWe
         Opcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694881145; x=1695485945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h8L+TF2NB2bKIXmFBrFsqsaXp12HgxVOtYytgv3Hfus=;
        b=FW03c9HCITfrAQCPueHEHZSFqkFC0NZhJYA6dKegiqnw5Jla1Gnn6qbYtanqPUpAR7
         exCE1Rl8BMdL4PzFSnH3VPXp1p+x0PUg1M0EpiZ0Lpf70JYbxXEYSk6h8q5g5ve/fh9x
         AF7wnE8W+4JCoQ3DA5q2Fot9gcJmLyiTO63uGT0VjMmOE6gLn7qkN1l9cIDY5sY6Vx1H
         n6tc4wmZqKhQNtO40Frws4/2lmppL5miv0x4WTd6oeA/FzHBxqBjm55iF8/+AMEmDUMK
         yYex707/yYGoaA5tDztrdLzZ86DAGqZkhNu2+4K4/QR4rVI31B1ufKrY/KvwnZcgg584
         FqFg==
X-Gm-Message-State: AOJu0Yzzu8fZP5hZjLV6YG3LVplWkGKf4luLQzoIfISa1JnOw3amTBAQ
	q70I0qOThaXpoxm/v/rfG1sugb0Bf7TBKxiFX/c=
X-Google-Smtp-Source: AGHT+IE6gvIqWBAlwxxGiQzAX1gu/T0BW4IYuGOri4BCq3hbNBUJcdmd2cR5j04KoGOSIbaFxEkMbAA5/MG01mn7ung=
X-Received: by 2002:a17:90a:ad92:b0:274:8363:c679 with SMTP id
 s18-20020a17090aad9200b002748363c679mr3795739pjq.19.1694881145079; Sat, 16
 Sep 2023 09:19:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230825211426.3798691-1-jannh@google.com> <CACT4Y+YT6A_ZgkWTF+rxKO_mvZ3AEt+BJtcVR1sKL6LKWDC+0Q@mail.gmail.com>
 <CAG48ez34DN_xsj7hio8epvoE8hM3F_xFoqwWYM-_LVZb39_e9A@mail.gmail.com>
In-Reply-To: <CAG48ez34DN_xsj7hio8epvoE8hM3F_xFoqwWYM-_LVZb39_e9A@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 16 Sep 2023 18:18:54 +0200
Message-ID: <CA+fCnZeyS=wr-u4FgJmGLXujcat=oQ+jo-NAt1TtSa_tLEstSg@mail.gmail.com>
Subject: Re: [PATCH] slub: Introduce CONFIG_SLUB_RCU_DEBUG
To: Jann Horn <jannh@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Alexander Potapenko <glider@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 28, 2023 at 4:40=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
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

This is a problem only for the Generic mode, right? You already call
kasan_reset_tag on the rcu_head, which should suppress the reporting
for the tag-based modes.

If so, would it be possible to reuse metadata_access_enable/disable?
They are used for accessing slub_debug metadata and seem to fit nicely
with this case as well.

I also second Macro's comment to add a test for the new functionality.

Thanks for working on this!
