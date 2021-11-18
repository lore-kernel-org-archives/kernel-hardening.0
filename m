Return-Path: <SRS0=roqa=QF=lists.openwall.com=kernel-hardening-return-21497-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23756C433EF
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Nov 2021 17:32:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 72E1E61A4E
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Nov 2021 17:32:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 72E1E61A4E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 25899 invoked by uid 550); 18 Nov 2021 17:32:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25864 invoked from network); 18 Nov 2021 17:32:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4ZRY5BIcQHJ120UEZi/XkGexoEr3hEm901+ewWa9TxY=;
        b=Q3we5WCD0xmIJKfl/TfgI5kD/aocwY/0SWDW+zmJNqPz5ybfO4CiNYosT1l9w0Z9zm
         JSfluadZC7peSWt6bagPafCt/4+VUAb2oALOEQL4x1CPXNYnju45tV0Xa3SiAuq6RtfH
         T7werkmqyBzOZjFDtT85I8mV9XupExiLUE+Tg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4ZRY5BIcQHJ120UEZi/XkGexoEr3hEm901+ewWa9TxY=;
        b=Pv0oNEltQiOvahQ4BwZyUMB6+ql9GY4FUW1QsmSMn3022lkSx5XksLIT0xaDDxXLRA
         UOUeLUhzfEKO3nQY/EcN+GRZs30SAVeo41FD2iz/CCmgeDPsV18yV8J9+ySgkLnd0vsU
         mnsbKCgZRirE0Wg13Bhe4CV2wsIqnhU/MFHXCIS/8wFgHSOYUWOrMFC6YIwajXLqB1T2
         ITMS+Jey2qERvduVH+vm6t14f+gt6+7gbzXBjwP47INtLbuOqHEi/wcQDNgSzB9Y7w01
         Wt/5zBl1ZtDieJdCLZn32wU+oEwJDO8JWjBq/UhRLYtTZWO63z8jQdY/ZphWOHg/wszh
         mpKg==
X-Gm-Message-State: AOAM532o50JgckII7NKnfQqpaEwEhuUuC2eoNuaMH/Z9G9qEvkJtcoCW
	0iNeP1/Lgy641pfglXGt/PZevw==
X-Google-Smtp-Source: ABdhPJyN93N2sODujVOpAsK3VlIcdNaAzqqjpLxh42TfDong2nPp+Svl7pb4DHkYFbAHSFyTX54IMA==
X-Received: by 2002:a17:90b:4a43:: with SMTP id lb3mr12564955pjb.222.1637256724619;
        Thu, 18 Nov 2021 09:32:04 -0800 (PST)
Date: Thu, 18 Nov 2021 09:32:03 -0800
From: Kees Cook <keescook@chromium.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Alexander Popov <alex.popov@linux.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Paul McKenney <paulmck@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Joerg Roedel <jroedel@suse.de>, Maciej Rozycki <macro@orcam.me.uk>,
	Muchun Song <songmuchun@bytedance.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, Petr Mladek <pmladek@suse.com>,
	Luis Chamberlain <mcgrof@kernel.org>, Wei Liu <wl@xen.org>,
	John Ogness <john.ogness@linutronix.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andy Lutomirski <luto@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Laura Abbott <labbott@kernel.org>,
	David S Miller <davem@davemloft.net>,
	Borislav Petkov <bp@alien8.de>, Arnd Bergmann <arnd@arndb.de>,
	Andrew Scull <ascull@google.com>, Marc Zyngier <maz@kernel.org>,
	Jessica Yu <jeyu@kernel.org>, Iurii Zaikin <yzaikin@google.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Wang Qing <wangqing@vivo.com>, Mel Gorman <mgorman@suse.de>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Andrew Klychkov <andrew.a.klychkov@gmail.com>,
	Mathieu Chouquet-Stringer <me@mathieu.digital>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stephen Kitt <steve@sk2.org>, Stephen Boyd <sboyd@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Rapoport <rppt@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-hardening@vger.kernel.org,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, notify@kernel.org,
	main@lists.elisa.tech, safety-architecture@lists.elisa.tech,
	devel@lists.elisa.tech, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v2 0/2] Introduce the pkill_on_warn parameter
Message-ID: <202111180930.5FA3EF0F59@keescook>
References: <20211027233215.306111-1-alex.popov@linux.com>
 <ac989387-3359-f8da-23f9-f5f6deca4db8@linux.com>
 <CAHk-=wgRmjkP3+32XPULMLTkv24AkA=nNLa7xxvSg-F0G1sJ9g@mail.gmail.com>
 <77b79f0c-48f2-16dd-1d00-22f3a1b1f5a6@linux.com>
 <CAKXUXMx5Oi-dNVKB+8E-pdrz+ooELMZf=oT_oGXKFrNWejz=fg@mail.gmail.com>
 <20211115110649.4f9cb390@gandalf.local.home>
 <202111151116.933184F716@keescook>
 <59534db5-b251-c0c8-791f-58aca5c00a2b@linux.com>
 <202111161037.7456C981@keescook>
 <fd86a05b-feca-c0a9-c6b0-b2e69c650021@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd86a05b-feca-c0a9-c6b0-b2e69c650021@schaufler-ca.com>

On Tue, Nov 16, 2021 at 11:00:23AM -0800, Casey Schaufler wrote:
> On 11/16/2021 10:41 AM, Kees Cook wrote:
> > On Tue, Nov 16, 2021 at 12:12:16PM +0300, Alexander Popov wrote:
> > > What if the Linux kernel had a LSM module responsible for error handling policy?
> > > That would require adding LSM hooks to BUG*(), WARN*(), KERN_EMERG, etc.
> > > In such LSM policy we can decide immediately how to react on the kernel error.
> > > We can even decide depending on the subsystem and things like that.
> > That would solve the "atomicity" issue the WARN tracepoint solution has,
> > and it would allow for very flexible userspace policy.
> > 
> > I actually wonder if the existing panic_on_* sites should serve as a
> > guide for where to put the hooks. The current sysctls could be replaced
> > by the hooks and a simple LSM.
> 
> Do you really want to make error handling a "security" issue?
> If you add security_bug(), security_warn_on() and the like
> you're begging that they be included in SELinux (AppArmor) policy.
> BPF, too, come to think of it. Is that what you want?

Yeah, that is what I was thinking. This would give the LSM a view into
kernel state, which seems a reasonable thing to do. If system integrity
is compromised, an LSM may want to stop trusting things.

A dedicated error-handling LSM could be added for those hooks that
implemented the existing default panic_on_* sysctls, and could expand on
that logic for other actions.

-- 
Kees Cook
