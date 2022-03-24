Return-Path: <kernel-hardening-return-21554-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 7B862C433F5
	for <kernel-hardening@archiver.kernel.org>; Thu, 24 Mar 2022 10:30:04 +0000 (UTC)
Received: (qmail 22229 invoked by uid 550); 24 Mar 2022 10:29:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22194 invoked from network); 24 Mar 2022 10:29:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VhnV11ZIB9XQsFrR+7RyjEctj8mwdwZ8rAPFLvRFWjI=;
        b=UTkdRKxy/4KFYFJbrY18/+BI7r3nUnt/znELOVsFGL9K9mYyozmSoj7RiJT6at0E60
         P4GkOL4NqOo5n5zT908BnYQ49z5vlQqrKAU8G2gVOWYKhPbRJKjn07P5Y99A0kqxCtlE
         sTJsUJdf+WlJTPvZOcwUOG09FtDdGpcCzNtjjpY+7L+cE4UhfGTjORRkATSey2cfzCqY
         LqrvRVIuOMGON12SrhlMVmRd7jkDXxqAFLs8We1jOBNiHIqv2ttkXNQ3YVoxN75m3D3X
         Za0uArP8lrGptCh/KTpLeVI/DqQM9ph4YXWMtWUS8Vzi7QliWlUTpEzEydbZ824lGZIN
         Uo6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VhnV11ZIB9XQsFrR+7RyjEctj8mwdwZ8rAPFLvRFWjI=;
        b=KWJQG0i+8Ie8SbVr5I0wiO68awWxGTNZDH2aXOL7OAUwoukzTY8k/WZVxK69mRA8RX
         1O2SKRUeKqBkVwXW1EsqdYrYppUsYMpp9UihauAMHMmpHIIS5TQKvU2jEoSJC9vaxuNo
         KMcAbkKVKeYrJU8dJBJNEeuF4S4J+43tnO01M3ZPdujopUcfgR0iLuLqpLzTMAWIPWZ9
         xTF3a0zg879aPlt2ic2JmVjwkKOhRP035lsX4b9aJJ/NmlJaDsXcP/G7G/xZURGsAI8a
         8CCm733Je22SY0vI20CiiHJQqgZQtY6W1sZoanIqLRaqhYrwXDAH5vyO4y/s7h06HDUZ
         dRtA==
X-Gm-Message-State: AOAM530sfcaU1Ddmhz+cBKmy5eNfjps8Z7Zzg1GltuaT1Q1O1mrz4c2h
	/qJwNt3+Gq/RFUkzF4PuppHEtZUwhOceb5G8MXo=
X-Google-Smtp-Source: ABdhPJximP+pKDfVRtUrc7EWkUuUx+ODJxHOlUoYNyclqp8nzGphnUgTl6TKfn9FLnPjsX7V55sbW836zvFk7m0NEVQ=
X-Received: by 2002:a05:6512:1294:b0:44a:35a2:a282 with SMTP id
 u20-20020a056512129400b0044a35a2a282mr3174229lfs.269.1648117781114; Thu, 24
 Mar 2022 03:29:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9q55ifnzxE9zLuLT=Hgjv=qcvjU-O-c8G=_o_V_O+p44Q@mail.gmail.com>
 <CACXcFmnb87qqzVkw9GfojPNh5sDkYGsqq9TYxUXBvrC1R+Lr3w@mail.gmail.com>
In-Reply-To: <CACXcFmnb87qqzVkw9GfojPNh5sDkYGsqq9TYxUXBvrC1R+Lr3w@mail.gmail.com>
From: Sandy Harris <sandyinchina@gmail.com>
Date: Thu, 24 Mar 2022 18:29:28 +0800
Message-ID: <CACXcFmnhHpGQdU7ZcYNqjSss8VHMOtTvmJRETn18p0AY3AsEuQ@mail.gmail.com>
Subject: Re: Large post detailing recent Linux RNG improvements
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"

Sandy Harris <sandyinchina@gmail.com> wrote:

> Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> > Thought I should mention here that I've written up the various RNG
> > things I've been working on for 5.17 & 5.18 here:
> > https://www.zx2c4.com/projects/linux-rng-5.17-5.18/ .
> >
> > Feel free to discuss on list here if you'd like, or if you see
> > something you don't like, I'll happily review patches!
>
> Your code includes:
>
> enum {
>     POOL_BITS = BLAKE2S_HASH_SIZE * 8,
>     POOL_MIN_BITS = POOL_BITS /* No point in settling for less. */
> };
>
> static struct {
>     struct blake2s_state hash;
>     spinlock_t lock;
>     unsigned int entropy_count;
> } input_pool = {
>     .hash.h = { BLAKE2S_IV0 ^ (0x01010000 | BLAKE2S_HASH_SIZE),
>             BLAKE2S_IV1, BLAKE2S_IV2, BLAKE2S_IV3, BLAKE2S_IV4,
>             BLAKE2S_IV5, BLAKE2S_IV6, BLAKE2S_IV7 },
>     .hash.outlen = BLAKE2S_HASH_SIZE,
>     .lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
> };
>
> As far as I can tell, you have eliminated the 4K-bit input pool
> that this driver has always used & are just using the hash
> context as the input pool. To me, this looks like an error.
>
> A side effect of that is losing the latent-entropy attribute
> on input_pool[] so we no longer get initialisation from
> the plugin. Another error.

I could see reasonable arguments for reducing the size of
the input pool since that would save both kernel memory
and time used by the hash. Personally, though, I would
not consider anything < 2Kbits without seeing strong
arguments to justify it.

You seem to have gone to 512 bits without showing
any analysis to justify it. Have I just missed them?
