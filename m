Return-Path: <SRS0=jqCR=33=lists.openwall.com=kernel-hardening-return-17728-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB50C352A2
	for <kernel-hardening@archiver.kernel.org>; Fri,  7 Feb 2020 09:05:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2BE022082E
	for <kernel-hardening@archiver.kernel.org>; Fri,  7 Feb 2020 09:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EbFgLJlU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BE022082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17728-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1780 invoked by uid 550); 7 Feb 2020 09:05:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1757 invoked from network); 7 Feb 2020 09:05:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mz7Ey9gSAauDy/gNIB43lQyeRt2xn0zd/o4g7lTFRzY=;
        b=EbFgLJlUCVtdm+nm5zkXqa6IQ1oUHjUAG8sWUHvhz9ARUDzaZroyehH337WrjDq3ay
         LK32Hr3BEJDbDTRCKxqICnH2TMhsMQ0TmtEaX62cnkitw5tLUPIyqWHYHcZcAJ8YY4RO
         pr6LEHiF7oM5QsnYOoqfZvozpKd5rCilqqGwU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mz7Ey9gSAauDy/gNIB43lQyeRt2xn0zd/o4g7lTFRzY=;
        b=q6J/B1olhi+xkyCRebJkG/dX6nSTzjboheiJxjhSkXZAiE64m5scg/RWig9HIkzUYy
         8bCmrRztegDpfi6A9AFftwyeG4hcT1ivhHZvYpfIZVmNcHNUj6vP5PrPb1MKLuhKFCf9
         bYVInxy9KqL74/vSu6lDTuCdFe3DpXY6yjDMbYSPrLjuAaU03TpLdeKwXSBc2rIAJnFo
         XIWMKu0rXpcSae2U7Sgqy/+J3TVFwwAWFxjv3JjCNbjuwdw158ikhFtaJrABR2SYF3P7
         oQ/yKm72kXDOsmUXiINjmMdcUPN0Udn4VhsZrNZxdh3Z6OkayE+yoYvS0JfW7Q+buXSQ
         HmPA==
X-Gm-Message-State: APjAAAWxA5qSKrYhD88MJfhXfC1rrQQ5pcNRxhbefm47QTV2HA/AEW2k
	7bJPsjWvflOA5EaX4HI6Gmv+zw==
X-Google-Smtp-Source: APXvYqzjyacdcE5uV2m9By4861i/XXZeEXEomnp7R2AYCO4AqIAmoT4qO2IqKdEbRwL+9EhuP/kHTQ==
X-Received: by 2002:aca:4ad8:: with SMTP id x207mr1333594oia.55.1581066305665;
        Fri, 07 Feb 2020 01:05:05 -0800 (PST)
Date: Fri, 7 Feb 2020 01:05:03 -0800
From: Kees Cook <keescook@chromium.org>
To: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 04/11] x86/boot/KASLR: Introduce PRNG for faster
 shuffling
Message-ID: <202002070100.2521E7563@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-5-kristen@linux.intel.com>
 <20200206151001.GA280489@zx2c4.com>
 <CAGiyFdes26XnNeDfaz-vkm+bU7MBYQiK3xty2EigGjOXBGui2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGiyFdes26XnNeDfaz-vkm+bU7MBYQiK3xty2EigGjOXBGui2w@mail.gmail.com>

On Fri, Feb 07, 2020 at 08:23:53AM +0100, Jean-Philippe Aumasson wrote:
> 
> On Thu, Feb 6, 2020 at 4:10 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> 
> > Hey Kees,
> >
> > On Wed, Feb 05, 2020 at 02:39:43PM -0800, Kristen Carlson Accardi wrote:
> > > +#define rot(x, k) (((x)<<(k))|((x)>>(64-(k))))
> > > +static u64 prng_u64(struct prng_state *x)
> > > +{
> > > +     u64 e;
> > > +
> > > +     e = x->a - rot(x->b, 7);
> > > +     x->a = x->b ^ rot(x->c, 13);
> > > +     x->b = x->c + rot(x->d, 37);
> > > +     x->c = x->d + e;
> > > +     x->d = e + x->a;
> > > +
> > > +     return x->d;
> > > +}
> >
> > I haven't looked closely at where the original entropy sources are
> > coming from and how all this works, but on first glance, this prng
> > doesn't look like an especially cryptographically secure one. I realize
> > that isn't necessarily your intention (you're focused on speed), but
> > actually might this be sort of important? If I understand correctly, the
> > objective of this patch set is so that leaking the address of one
> > function doesn't leak the address of all other functions, as is the case
> > with fixed-offset kaslr. But if you leak the addresses of _some_ set of
> > functions, and your prng is bogus, might it be possible to figure out
> > the rest? For some prngs, if you give me the output stream of a few
> > numbers, I can predict the rest. For others, it's not this straight
> > forward, but there are some varieties of similar attacks. If any of that
> > set of concerns turns out to apply to your prng_u64 here, would that
> > undermine kaslr in similar ways as the current fixed-offset variety? Or
> > does it not matter because it's some kind of blinded fixed-size shuffle
> > with complex reasoning that makes this not a problem?
> 
> Let me share my 2 cents:
> 
> That permutation might be safe but afaict it hasn't been analyzed wrt
> modern cryptographic techniques and there might well be differential
> characteristics, statistical biases, etc.
> 
> What about just using SipHash's permutation, already in the kernel? It
> works on 4*u64 words too, and 6 rounds would be enough.
> 
> Doing a basic ops count, we currently have 5 group operations and 3
> rotations per round or 150 and 90 for the 30 init rounds. With SipHash it'd
> be 48 and 36 with the proposed 6 rounds. Probably insignificant speed wise
> as init is only done once but just to show that we'd get both better
> security assurance and better performance.

Yeah, this was never meant to be anything but a POC and after timing
tests, it seemed like an unneeded abstraction but was kept for this
RFC so it was possible to specify a stable seed at boot for debugging,
etc. I think this patch will not survive to v1. :)

-- 
Kees Cook
