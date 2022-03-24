Return-Path: <kernel-hardening-return-21555-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 03931C433F5
	for <kernel-hardening@archiver.kernel.org>; Thu, 24 Mar 2022 14:23:21 +0000 (UTC)
Received: (qmail 21935 invoked by uid 550); 24 Mar 2022 14:23:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14152 invoked from network); 24 Mar 2022 14:12:06 -0000
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Mpm6rTOw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1648131110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jpvlvyj9ao+OhMQB6o8LnQdN+MDbR6s7x0e59J7p0ZY=;
	b=Mpm6rTOwHuGlKLWnUUL81ofDk1JhSMKKir9gkyRQ6OfPDnbNocZwkaJ0mOLZG7/0W9Fyuc
	hIeSUMlIex9yBYBviuXcKSZMWvWOGMPpBcrUNWrQhlSRKXXfBugqRc6HV5OZ8/Rj6LGnsk
	3ifI6g5URM8jAoRazH0Rl5TPdAz9yOE=
X-Gm-Message-State: AOAM531GUThdU0zhXgHP4zyWcy6GG1JqVMVdP9R5PiJtp0oagklA+fr1
	WDAln9wnfibPvsgJP5INA+xDxDON9iH6plh+rVg=
X-Google-Smtp-Source: ABdhPJxDbDInYKblQShnqKX+H9+RZtESX+eqUXrspeN3TYWTxW+KNmnQt73LTBJo0jrJ3hK3an7ncp+B71xhJYgJbrA=
X-Received: by 2002:a25:b854:0:b0:633:8a00:707a with SMTP id
 b20-20020a25b854000000b006338a00707amr4723427ybm.637.1648131109009; Thu, 24
 Mar 2022 07:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9q55ifnzxE9zLuLT=Hgjv=qcvjU-O-c8G=_o_V_O+p44Q@mail.gmail.com>
 <CACXcFmnb87qqzVkw9GfojPNh5sDkYGsqq9TYxUXBvrC1R+Lr3w@mail.gmail.com> <CACXcFmnhHpGQdU7ZcYNqjSss8VHMOtTvmJRETn18p0AY3AsEuQ@mail.gmail.com>
In-Reply-To: <CACXcFmnhHpGQdU7ZcYNqjSss8VHMOtTvmJRETn18p0AY3AsEuQ@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 24 Mar 2022 08:11:38 -0600
X-Gmail-Original-Message-ID: <CAHmME9rWxkjgmXet=gQFWvhB6xvPgvAwkadZHRwdWrNGO6LZ0Q@mail.gmail.com>
Message-ID: <CAHmME9rWxkjgmXet=gQFWvhB6xvPgvAwkadZHRwdWrNGO6LZ0Q@mail.gmail.com>
Subject: Re: Large post detailing recent Linux RNG improvements
To: Sandy Harris <sandyinchina@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"

On Thu, Mar 24, 2022 at 4:29 AM Sandy Harris <sandyinchina@gmail.com> wrote:
> > > Thought I should mention here that I've written up the various RNG
> > > things I've been working on for 5.17 & 5.18 here:
> > > https://www.zx2c4.com/projects/linux-rng-5.17-5.18/ .
> > >
> > > Feel free to discuss on list here if you'd like, or if you see
> > > something you don't like, I'll happily review patches!
> >
> > Your code includes:
> >
> > enum {
> >     POOL_BITS = BLAKE2S_HASH_SIZE * 8,
> >     POOL_MIN_BITS = POOL_BITS /* No point in settling for less. */
> > };
> >
> > static struct {
> >     struct blake2s_state hash;
> >     spinlock_t lock;
> >     unsigned int entropy_count;
> > } input_pool = {
> >     .hash.h = { BLAKE2S_IV0 ^ (0x01010000 | BLAKE2S_HASH_SIZE),
> >             BLAKE2S_IV1, BLAKE2S_IV2, BLAKE2S_IV3, BLAKE2S_IV4,
> >             BLAKE2S_IV5, BLAKE2S_IV6, BLAKE2S_IV7 },
> >     .hash.outlen = BLAKE2S_HASH_SIZE,
> >     .lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
> > };
> >
> > As far as I can tell, you have eliminated the 4K-bit input pool
> > that this driver has always used & are just using the hash
> > context as the input pool. To me, this looks like an error.
> >
> > A side effect of that is losing the latent-entropy attribute
> > on input_pool[] so we no longer get initialisation from
> > the plugin. Another error.
>
> I could see reasonable arguments for reducing the size of
> the input pool since that would save both kernel memory
> and time used by the hash. Personally, though, I would
> not consider anything < 2Kbits without seeing strong
> arguments to justify it.
>
> You seem to have gone to 512 bits without showing
> any analysis to justify it. Have I just missed them?

Explanation in <https://git.kernel.org/pub/scm/linux/kernel/git/crng/random.git/commit/?id=6e8ec2552c7d>.
There's also a link to a paper in there.

Jason
