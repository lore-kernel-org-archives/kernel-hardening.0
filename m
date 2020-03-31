Return-Path: <SRS0=yubW=5Q=lists.openwall.com=kernel-hardening-return-18340-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EBBC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 18:12:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 37AD120786
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 18:12:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KAsI4MWL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37AD120786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18340-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10192 invoked by uid 550); 31 Mar 2020 18:12:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10108 invoked from network); 31 Mar 2020 18:12:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v3yIssPSEeZvWeAW+pdQM2euAxC0fXaMIWj8OAY6zQs=;
        b=KAsI4MWLqfiUvnxtz3qcVOWb/O7CFrFTtX5VD0apn31zbo3A4d99vRUqzJMbtgQGC4
         rr4iSH58raWCTtFXk/Q48QZSY1mF4WgnvPYR2SbvYbKzI2w7CfMLf/aZwplbNEK+tpMB
         APIJ6D/gCcjy5Et/eokKCAyBXSw9nebphAIiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v3yIssPSEeZvWeAW+pdQM2euAxC0fXaMIWj8OAY6zQs=;
        b=f14LzvCSODR5Ki8ZMSLEkZCljrRFwAkGeK5eOWHlb9s9oxmc3x/13/GLgRNV0rh7yt
         vNde8CWQfd4LPucLHzhOkNyeZRJVohRAN/IcV0WN3AKrPkSDt3TE+EWFOd16KLScLTKv
         AoBp+v54yXjqu3YWRRnghy3gs5CTzMssIQXxNvwyYuEdH2GiXN9i4pL271Tnl7OslIWY
         m9nPdizvhiWCWJSS0i+jwf7ISAscYopoB0bPEnZJIwyj4txq/4X6XnbtofZRDudV0T1W
         poYevWEdlbLHnPWfcAqAtJFhlLVAiBytzNhoX1MV3VeWWcFp0ccvm8Pj9YiHNPimJTIZ
         z53Q==
X-Gm-Message-State: AGi0Pua47qN5IUAKd/ExDxXwVv5jzaGwAwdJ6wup40oyrqSpG4K+XTNb
	YLu3FqbI4BUGDDzRK3RSaEvgaA==
X-Google-Smtp-Source: APiQypKAD4nnkDQY07cbX5cUOamNGJvBmbvTc5RjhrDUWve16ZurG5HNZ5oMAs0m9fu7vmRcXbZiGg==
X-Received: by 2002:a17:90a:30a9:: with SMTP id h38mr129206pjb.184.1585678350979;
        Tue, 31 Mar 2020 11:12:30 -0700 (PDT)
Date: Tue, 31 Mar 2020 11:12:29 -0700
From: Kees Cook <keescook@chromium.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jann Horn <jannh@google.com>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	bpf <bpf@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: CONFIG_DEBUG_INFO_BTF and CONFIG_GCC_PLUGIN_RANDSTRUCT
Message-ID: <202003311110.2B08091E@keescook>
References: <CAG48ez2sZ58VQ4+LJu39H1M0Y98LhRYR19G_fDAPJPBf7imxuw@mail.gmail.com>
 <CAADnVQ+Ux3-D_7ytRJx_Pz4fStRLS1vkM=-tGZ0paoD7n+JCLQ@mail.gmail.com>
 <CAG48ez0ajun-ujQQqhDRooha1F0BZd3RYKvbJ=8SsRiHAQjUzw@mail.gmail.com>
 <202003301016.D0E239A0@keescook>
 <c332da87-a770-8cf9-c252-5fb64c06c17e@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c332da87-a770-8cf9-c252-5fb64c06c17e@iogearbox.net>

On Tue, Mar 31, 2020 at 12:41:04AM +0200, Daniel Borkmann wrote:
> On 3/30/20 7:20 PM, Kees Cook wrote:
> > On Mon, Mar 30, 2020 at 06:17:32PM +0200, Jann Horn wrote:
> > > On Mon, Mar 30, 2020 at 5:59 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > > On Mon, Mar 30, 2020 at 8:14 AM Jann Horn <jannh@google.com> wrote:
> > > > > 
> > > > > I noticed that CONFIG_DEBUG_INFO_BTF seems to partly defeat the point
> > > > > of CONFIG_GCC_PLUGIN_RANDSTRUCT.
> > > > 
> > > > Is it a theoretical stmt or you have data?
> > > > I think it's the other way around.
> > > > gcc-plugin breaks dwarf and breaks btf.
> > > > But I only looked at gcc patches without applying them.
> > > 
> > > Ah, interesting - I haven't actually tested it, I just assumed
> > > (perhaps incorrectly) that the GCC plugin would deal with DWARF info
> > > properly.
> > 
> > Yeah, GCC appears to create DWARF before the plugin does the
> > randomization[1], so it's not an exposure, but yes, struct randomization
> > is pretty completely incompatible with a bunch of things in the kernel
> > (by design). I'm happy to add negative "depends" in the Kconfig if it
> > helps clarify anything.
> 
> Is this expected to get fixed at some point wrt DWARF? Perhaps would make

No, gcc closed the issue as "won't fix".

> sense then to add a negative "depends" for both DWARF and BTF if the option
> GCC_PLUGIN_RANDSTRUCT is set given both would be incompatible/broken.

I hadn't just to keep wider randconfig build test coverage. That said, I
could make it be: depends COMPILE_TEST || !DWARF ...

I can certainly do that.

-Kees

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=84052

-- 
Kees Cook
