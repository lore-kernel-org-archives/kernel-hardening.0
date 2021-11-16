Return-Path: <SRS0=AY4w=QD=lists.openwall.com=kernel-hardening-return-21495-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38D2C433F5
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Nov 2021 18:42:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1272F61BA1
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Nov 2021 18:42:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1272F61BA1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 8063 invoked by uid 550); 16 Nov 2021 18:42:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8026 invoked from network); 16 Nov 2021 18:42:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rpZo5Ukhloxpo3t6te7xJnWQRrow3d4oIhzJ9wNY//s=;
        b=VSNC43P14WmPSZmUrPilJ+DgGj5eVm+rYneRkINAieo4BCqCLBy5QiE+yxx4dMJHrP
         ofgb/NWCMtHijcLBbRJZt2srQLA+UEZ3FYMnXTi4zhVU59bazntvLi1ZB9x1FOAMm3MU
         zC1NqI7P7FvTEoA0kb6E30B9MNDZ7w/u4TNWQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rpZo5Ukhloxpo3t6te7xJnWQRrow3d4oIhzJ9wNY//s=;
        b=0KQGpbJgH4K4lBG9pER5+g3XInBEnfMhZa85w2fwqG3f9dK4XGGtCp1pD1T5jLVBHd
         WvRDywWfkwCagUqU8YF6pZVpYDC/dXQjkOnLf9fNDE3B3bQXYWnf6zEq8DOw6KxzpqF8
         PZjwgoAYuTXwRD6tDIkjg2k1XMGsWERiJOTMiyP9v9qfSiSuMATN06mFFqAQVVEgsY7k
         O6VXMyvkuU+Galt8h6Q/VMVVYMeSjHFUwQ95WtN4+UCHf2y9lRtKozsOPbQ1RiNmm6Vc
         eFQIcmEjgv1hacrH7QHBymNor4AGMZri+4bmcCYfzdLp25G2xQUUaDBZsNcmIu7JWIvK
         lG7g==
X-Gm-Message-State: AOAM5316Je0TdVjj90pl/VgSAycSIxIUYcqhIvKFvR7go8dDnWCbYEK6
	AUdkNqjdIh4uXf3TNq9pfPJdaA==
X-Google-Smtp-Source: ABdhPJycX3gPzRKrPSWv0E+uNTJtZaFFdHv8BhJIhDH//Ix6o2hDequKidyqHX9nzJJNXw16lwDFmQ==
X-Received: by 2002:a17:902:ced1:b0:141:e15d:49e0 with SMTP id d17-20020a170902ced100b00141e15d49e0mr47744243plg.27.1637088110227;
        Tue, 16 Nov 2021 10:41:50 -0800 (PST)
Date: Tue, 16 Nov 2021 10:41:49 -0800
From: Kees Cook <keescook@chromium.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <202111161037.7456C981@keescook>
References: <20211027233215.306111-1-alex.popov@linux.com>
 <ac989387-3359-f8da-23f9-f5f6deca4db8@linux.com>
 <CAHk-=wgRmjkP3+32XPULMLTkv24AkA=nNLa7xxvSg-F0G1sJ9g@mail.gmail.com>
 <77b79f0c-48f2-16dd-1d00-22f3a1b1f5a6@linux.com>
 <CAKXUXMx5Oi-dNVKB+8E-pdrz+ooELMZf=oT_oGXKFrNWejz=fg@mail.gmail.com>
 <20211115110649.4f9cb390@gandalf.local.home>
 <202111151116.933184F716@keescook>
 <59534db5-b251-c0c8-791f-58aca5c00a2b@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59534db5-b251-c0c8-791f-58aca5c00a2b@linux.com>

On Tue, Nov 16, 2021 at 12:12:16PM +0300, Alexander Popov wrote:
> What if the Linux kernel had a LSM module responsible for error handling policy?
> That would require adding LSM hooks to BUG*(), WARN*(), KERN_EMERG, etc.
> In such LSM policy we can decide immediately how to react on the kernel error.
> We can even decide depending on the subsystem and things like that.

That would solve the "atomicity" issue the WARN tracepoint solution has,
and it would allow for very flexible userspace policy.

I actually wonder if the existing panic_on_* sites should serve as a
guide for where to put the hooks. The current sysctls could be replaced
by the hooks and a simple LSM.

-- 
Kees Cook
