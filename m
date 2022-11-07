Return-Path: <kernel-hardening-return-21578-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id D7F9FC433FE
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Nov 2022 20:57:21 +0000 (UTC)
Received: (qmail 24431 invoked by uid 550); 7 Nov 2022 20:57:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24399 invoked from network); 7 Nov 2022 20:57:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1S/JQnMmN3DjPvkqvFQzgmskknDsfipulGwZNvds56w=;
        b=DjPZ80abs50yysr3vgzBuOIHSiisPDueDD2gradfm5Mc0WVW8bcqmtusRnHYvmQ5xU
         3Oj31BsKULnicqGaR0VWCX63nOp9Z7YjlCzML9GDNvpbnJGvYJHp3sV/g16Q5rHBuzyE
         Fu7Vrtege4aTPrIbIdQHFNkQlb3MFmnTSkDng=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1S/JQnMmN3DjPvkqvFQzgmskknDsfipulGwZNvds56w=;
        b=5RQXCWb0a0zza8PmjjESpYqSHaqR02msZT9uZnmgWP8n9gb/g2xIO7fWXpAv7CcGXi
         mGGg4Sm5eWZRcZAokyw7uRTey5eiNV82t/bZ2Gk24MDbIOuQOqC4qS0IbVsO+zWmNIAS
         jL6OcB/Xy4LR14UpLlkYJug55bsjReeXS1gxcs7T1H41QnSp6/i/HV7cEL8oX4f9ZpQ/
         Fh8CbsFyrS0ZsW9OCNWANgHrJukH9YRpG+njXC9Nd5eO39n4AcQSniG0CpVDWo1d1geW
         mCrBsIZI0SzinNszd2lYph4GEM0Tyx3DtoB44mJGRhcbTEVTXxApuAjO0Jhdrj4psxDO
         aQ8Q==
X-Gm-Message-State: ANoB5plATDNS23vTP7bFu6J7KVMK2XpPLzQo5a28q9G0sE7mNFvNJeiC
	vR/kXoJWOHEGp/KWBjj4iqwvyjAytnI4Lw==
X-Google-Smtp-Source: AA0mqf47ikc0mFlZf6Y0gNC3ntJsMsaisvGEFrpnLwRmqrvfiBufW1Z7FlLVORu+bJktsmshSjX2xQ==
X-Received: by 2002:a05:622a:450:b0:3a5:95de:8967 with SMTP id o16-20020a05622a045000b003a595de8967mr2996952qtx.12.1667854620019;
        Mon, 07 Nov 2022 12:57:00 -0800 (PST)
X-Received: by 2002:a0d:ef07:0:b0:373:5257:f897 with SMTP id
 y7-20020a0def07000000b003735257f897mr30747649ywe.401.1667854613940; Mon, 07
 Nov 2022 12:56:53 -0800 (PST)
MIME-Version: 1.0
References: <20221107201317.324457-1-jannh@google.com>
In-Reply-To: <20221107201317.324457-1-jannh@google.com>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Mon, 7 Nov 2022 12:56:37 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjejeg+mymJQYzjc=TeMkGkcOLTgKg4FY4tz4ueYdMsGQ@mail.gmail.com>
Message-ID: <CAHk-=wjejeg+mymJQYzjc=TeMkGkcOLTgKg4FY4tz4ueYdMsGQ@mail.gmail.com>
Subject: Re: [PATCH] exit: Put an upper limit on how often we can oops
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org, 
	kernel-hardening@lists.openwall.com, Greg KH <gregkh@linuxfoundation.org>, 
	Seth Jenkins <sethjenkins@google.com>, "Eric W . Biederman" <ebiederm@xmission.com>, 
	Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 7, 2022 at 12:13 PM Jann Horn <jannh@google.com> wrote:
>
> I picked 10000 here to also provide safety for the ldsem code on 32-bit
> systems, but you could also argue that the real fix there is to make
> ldsem more robust, and that the limit should be something like 2^31...
>
> An alternative approach would be to always let make_task_dead() take the
> do_task_dead() path and never exit; but that would probably be a more
> disruptive change?

It might be more disruptive, but it might also be a better idea in
some respects: one of the bigger issues we've had with oopses in
inconvenient places is when they then cause even more problems in the
exit path (because the initial oops was horrid).

I'd honestly prefer something higher than 10000, but hey... I would
also prefer something where that legacy 'ldsem' was based on our
current legacy 'struct semaphore' rather than the half-way optimized
'rwsem'. The difference being that 'struct rwsem' tries to be clever
and uses atomic operations, while we long ago decided that anybody who
uses the bad old 'struct semaphore' can just use spinlocks and
non-atomic logic.

It's kind of silly how we try to stuff things into one 'sem->count'
value, when we could just have separate readers and writers counts.

And the only reason we do that is because those kinds of things *do*
matter for contended locks and the rwsem code has it, but I really
think the ldsem code could just always take the spinlock that it
already takes in the slowpath, and just skip any other atomics.

And it shouldn't have a wait_lock thing and two different wait queues
- it should have one wait queue, use that wait queues spinlock *as*
the lock for the semaphore operations, and put readers at the end, and
writers at the beginning as exclusive waiters.

So that ldesc_sem thing is just historical garbage in so many ways.
It's basically a modified copy of an old version of our rwsem, and
hasn't evern been simplified for its intended use, nor has it been
updated to improvements by the actual rwsem code.

Worst of both worlds, in other words.

Oh well. I don't think anybody really cares about the ldsem code,
which is why it is like it is, and probably will remain that way
forever.

I guess 10000 is fine - small enough to test for, big enough that if
somebody really hits it, they only have themselves to blame.

             Linus
