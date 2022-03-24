Return-Path: <kernel-hardening-return-21553-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id B3ADAC433F5
	for <kernel-hardening@archiver.kernel.org>; Thu, 24 Mar 2022 06:52:19 +0000 (UTC)
Received: (qmail 24379 invoked by uid 550); 24 Mar 2022 06:52:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24336 invoked from network); 24 Mar 2022 06:52:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uv9WDFuf73d36aG534OWTYxmQv2bNKKIk/9hpshgIJU=;
        b=Kq8gbI9QPeSROVHNU9dFJEHcWJnqsbuUDwE9QvWau9w5fMGGztvKfyqamgfePWtIP2
         8oUQbzmwhvMTZ9u2HVCqwgMle+PWtNdwGH7Fj7oMF0pqAH35MsL+Or1vbBulcyAt+rvM
         vc9HCHhIocij9414WGtRFt198fp6E08L02GUCFPiP52kJY/HW+9eFT1mltFFZ3BaG3ln
         5kqV/NJgdHc6SXLp+Fymz2qAtXl+EUFnP0gtnTg1Wa85RvSt0irE57CUq1s3FJWKFWfW
         888oKuWc2fQxTuWhxjVsD8mbp8sfCJgRvICccKylPmR/N2tK9/37tW4otVE4laU5vFFv
         MhzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uv9WDFuf73d36aG534OWTYxmQv2bNKKIk/9hpshgIJU=;
        b=JDLMbfIp+EZrvU2su/rn2qZgM3vfza2J2fgYc1edpJIbicq3HGogxFIYwSww4/j1kd
         ZX6xgiD2ToIIS+qHvCGKQyILE/JLE14BwOREprNx5R7JHqJXMZaSdGbSyEiGaAJKrehL
         94qFBnWSNzMvKl0QWeC4ESUaqp9LWqqvoWk3z3BZI2bTQwM5ND7gzdXyr3v9ZhGtEhlj
         7ExsPmZny3yHwCkwXWTALGZPDNW+5dz5VVQFM3eawJViAuuUMK8MIZ+1CUU9xuUK/SuD
         GP7+9Twpe+yRaPfCFSD0LGAZFfkxmfn32yuE3V2mRqHeb4gT6dld30xnpXYTyPo53+fp
         P2kg==
X-Gm-Message-State: AOAM532dFbF6Bs08M3XqBOqGBydF2V8w9inf8b83PK+Lu6fj14giEgSz
	B4K5BcrrXqqPL+eajSIRtWG28uTYtBdPNuGclKA=
X-Google-Smtp-Source: ABdhPJwDfXqglQAx4xkKcgV5qn+FFERkaesBPRjOEZL/Efm6/Fu/ASIYOR/QcdIpx4wkzANYfvK5RODptL0UVCnEAwQ=
X-Received: by 2002:a05:6512:308e:b0:448:5d75:9729 with SMTP id
 z14-20020a056512308e00b004485d759729mr2598646lfd.663.1648104717736; Wed, 23
 Mar 2022 23:51:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9q55ifnzxE9zLuLT=Hgjv=qcvjU-O-c8G=_o_V_O+p44Q@mail.gmail.com>
In-Reply-To: <CAHmME9q55ifnzxE9zLuLT=Hgjv=qcvjU-O-c8G=_o_V_O+p44Q@mail.gmail.com>
From: Sandy Harris <sandyinchina@gmail.com>
Date: Thu, 24 Mar 2022 14:51:45 +0800
Message-ID: <CACXcFmnb87qqzVkw9GfojPNh5sDkYGsqq9TYxUXBvrC1R+Lr3w@mail.gmail.com>
Subject: Re: Large post detailing recent Linux RNG improvements
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"

Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> Thought I should mention here that I've written up the various RNG
> things I've been working on for 5.17 & 5.18 here:
> https://www.zx2c4.com/projects/linux-rng-5.17-5.18/ .
>
> Feel free to discuss on list here if you'd like, or if you see
> something you don't like, I'll happily review patches!

Your code includes:

enum {
    POOL_BITS = BLAKE2S_HASH_SIZE * 8,
    POOL_MIN_BITS = POOL_BITS /* No point in settling for less. */
};

static struct {
    struct blake2s_state hash;
    spinlock_t lock;
    unsigned int entropy_count;
} input_pool = {
    .hash.h = { BLAKE2S_IV0 ^ (0x01010000 | BLAKE2S_HASH_SIZE),
            BLAKE2S_IV1, BLAKE2S_IV2, BLAKE2S_IV3, BLAKE2S_IV4,
            BLAKE2S_IV5, BLAKE2S_IV6, BLAKE2S_IV7 },
    .hash.outlen = BLAKE2S_HASH_SIZE,
    .lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
};

As far as I can tell, you have eliminated the 4K-bit input pool
that this driver has always used & are just using the hash
context as the input pool. To me, this looks like an error.

A side effect of that is losing the latent-entropy attribute
on input_pool[] so we no longer get initialisation from
the plugin. Another error.
