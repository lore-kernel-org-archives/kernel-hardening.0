Return-Path: <SRS0=creL=5Q=lists.openwall.com=kernel-hardening-return-18342-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E97C2D0EE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 19:58:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E27C320842
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 19:58:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="S+w7GqDb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E27C320842
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18342-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30154 invoked by uid 550); 31 Mar 2020 19:58:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30120 invoked from network); 31 Mar 2020 19:58:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iIE5XFM5K7QbE20yyDiZj6SZSyFq4hlwbNrIPIzU0gY=;
        b=S+w7GqDb769CQ8xv21FIHZaNTBTZm/T6OlidzROuKsDVAboV/EyN3Llh6Rz9mTZIft
         zotPnmEPIB8CQiPZpqd8ptbr4VcDp3TNcS1e4/py50PXxoyy27AenDHwc+9tWLcOub7S
         xUXQTmtjjTRF4Le26nz+prjPz5JX7fc6k5RGU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iIE5XFM5K7QbE20yyDiZj6SZSyFq4hlwbNrIPIzU0gY=;
        b=KqzB21AdXVRtiffARvqhQZhFpUIbjouTN/HnEYV+rK2+4FsvG2mK03KCseI0orrJBO
         bfOyTpLQfj4tQUxDVR7sie8oqGZ1BwmDs07C/vmHa1qvxyEnwUEVoxDlImrb8g0yUCaI
         Tt+rmBrVKy9rjXmRhiw6dnhtQGHNIklrYFqCEOQ2xNrQqSosvx2Hyb/6YgH+yvc5tDvb
         mIywE34O89BICIAaHZ1qrSi5MjFhuKbFuWBIfDqPdWSKYg9NdCOMWJfdzq+vCG9mVEu2
         FmiwV34U0WvfsgNXUtl+HiNHORAyN/0Mt9HggezypfzNRBz57u3ZKPtBwfd20knLWBJ0
         Xnzg==
X-Gm-Message-State: ANhLgQ2AaDLI4eW+vwwQeo3i6b9rb1k1eIeQO7wcYvBPxBvOfOvlNFhc
	2/gSNyNFB+G9CXWO/7H+FP/MBA==
X-Google-Smtp-Source: ADFU+vthYqtijXEiYJ1M7gXE9t+NnabDok25352WJK4rM43tVjWFqpSgeiB1d/0wichYw3yjyVfreg==
X-Received: by 2002:a17:902:8648:: with SMTP id y8mr18766618plt.153.1585684711969;
        Tue, 31 Mar 2020 12:58:31 -0700 (PDT)
Date: Tue, 31 Mar 2020 12:58:30 -0700
From: Kees Cook <keescook@chromium.org>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, Jann Horn <jannh@google.com>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	bpf <bpf@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: CONFIG_DEBUG_INFO_BTF and CONFIG_GCC_PLUGIN_RANDSTRUCT
Message-ID: <202003311257.3372EC63@keescook>
References: <CAG48ez2sZ58VQ4+LJu39H1M0Y98LhRYR19G_fDAPJPBf7imxuw@mail.gmail.com>
 <CAADnVQ+Ux3-D_7ytRJx_Pz4fStRLS1vkM=-tGZ0paoD7n+JCLQ@mail.gmail.com>
 <CAG48ez0ajun-ujQQqhDRooha1F0BZd3RYKvbJ=8SsRiHAQjUzw@mail.gmail.com>
 <202003301016.D0E239A0@keescook>
 <c332da87-a770-8cf9-c252-5fb64c06c17e@iogearbox.net>
 <202003311110.2B08091E@keescook>
 <CAEf4BzYZsiuQGYVozwB=7nNhVYzCr=fQq6PLgHF3M5AXbhZyig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYZsiuQGYVozwB=7nNhVYzCr=fQq6PLgHF3M5AXbhZyig@mail.gmail.com>

On Tue, Mar 31, 2020 at 12:50:07PM -0700, Andrii Nakryiko wrote:
> On Tue, Mar 31, 2020 at 11:12 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Tue, Mar 31, 2020 at 12:41:04AM +0200, Daniel Borkmann wrote:
> > > On 3/30/20 7:20 PM, Kees Cook wrote:
> > > > On Mon, Mar 30, 2020 at 06:17:32PM +0200, Jann Horn wrote:
> > > > > On Mon, Mar 30, 2020 at 5:59 PM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > > On Mon, Mar 30, 2020 at 8:14 AM Jann Horn <jannh@google.com> wrote:
> > > > > > >
> > > > > > > I noticed that CONFIG_DEBUG_INFO_BTF seems to partly defeat the point
> > > > > > > of CONFIG_GCC_PLUGIN_RANDSTRUCT.
> > > > > >
> > > > > > Is it a theoretical stmt or you have data?
> > > > > > I think it's the other way around.
> > > > > > gcc-plugin breaks dwarf and breaks btf.
> > > > > > But I only looked at gcc patches without applying them.
> > > > >
> > > > > Ah, interesting - I haven't actually tested it, I just assumed
> > > > > (perhaps incorrectly) that the GCC plugin would deal with DWARF info
> > > > > properly.
> > > >
> > > > Yeah, GCC appears to create DWARF before the plugin does the
> > > > randomization[1], so it's not an exposure, but yes, struct randomization
> > > > is pretty completely incompatible with a bunch of things in the kernel
> > > > (by design). I'm happy to add negative "depends" in the Kconfig if it
> > > > helps clarify anything.
> > >
> > > Is this expected to get fixed at some point wrt DWARF? Perhaps would make
> >
> > No, gcc closed the issue as "won't fix".
> >
> > > sense then to add a negative "depends" for both DWARF and BTF if the option
> > > GCC_PLUGIN_RANDSTRUCT is set given both would be incompatible/broken.
> >
> > I hadn't just to keep wider randconfig build test coverage. That said, I
> > could make it be: depends COMPILE_TEST || !DWARF ...
> >
> > I can certainly do that.
> 
> I've asked Slava in [0] to disable all three known configs that break
> DWARF and subsequently BTF, I hope it's ok to just do it in one patch.
> Currently all these appear to result in invalid BTF due to various
> DWARF modifications:
> 
>   - DEBUG_INFO_REDUCED (see [1])
>   - DEBUG_INFO_SPLIT (see [0]
>   - GCC_PLUGIN_RANDSTRUCT (this discussion).
> 
>   [0] https://lore.kernel.org/bpf/CAEf4BzadnfAwfa1D0jZb=01Ou783GpK_U7PAYeEJca-L9kdnVA@mail.gmail.com/
>   [1] https://lore.kernel.org/bpf/CAEf4BzZri8KpwLcoPgjiVx_=QmJ2W9UzBkDqSO2rUWMzWogkKg@mail.gmail.com/

Sure! That'd by fine by me. I'd just like it to be a "|| COMPILE_TEST"
for GCC_PLUGIN_RANDSTRUCT. Feel free to CC me for an Ack. :)

-Kees

> 
> 
> >
> > -Kees
> >
> > [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=84052
> >
> > --
> > Kees Cook

-- 
Kees Cook
