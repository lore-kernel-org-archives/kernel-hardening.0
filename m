Return-Path: <SRS0=3fo0=QC=lists.openwall.com=kernel-hardening-return-21475-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41EF2C433EF
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Nov 2021 08:12:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5829B61B95
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Nov 2021 08:12:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5829B61B95
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 16042 invoked by uid 550); 15 Nov 2021 08:12:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16004 invoked from network); 15 Nov 2021 08:12:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=pjGJNnGfp7N4YPL+3tEog9B076yjtwRjSVPNfS56OSM=;
        b=BZeXQQNf4sUHMfeWyEIc/pL9d7eDdipdr3UY8NhmZmrw8aEqL+veJz5rohewQomD/9
         gvjGv+OH7MUauciTQWQYnOXuwsH4I0H4pV59b0eyWWSlTqdhfy8xyOmoREE2DI6snXLz
         UeUnn60CjTcS6eCkct14/Ckb+aRNdG7wFkJgBQxwQdI39R7GK/dKhSi+sJaEuxzuW281
         9trAJgcjSL+DDUqAWjBiEtl/ZO7ZATHqMvwQtVzovbIlK2W7HjxoWc8FGRGIOUnqFPiZ
         PPa9wm7xDaZ2vYDkqexwCjZaxaOsmVbYK8dMC8BEKzaHCIBVkh3YWiqN+bybl/4qX446
         DTEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=pjGJNnGfp7N4YPL+3tEog9B076yjtwRjSVPNfS56OSM=;
        b=iUp5tGG1ovm9Pp9cftZqS8i6e0CZdPa4CtgwAtEOgwOSCyaVtrnzZp7e7QfvspoMVq
         TtYLyEvZUW6z0L3UMP1Gs9XK/MlnFUA3h7XS/xtK7gpuL6N2heNwfMe0ztNJI+iIalSQ
         /0aoWuZ/GgX1xpzdWfFN3mvkLI8MH5ACo+zY8OFyLBeDdRciJ9qqifViRTmV9fx+ZtGR
         9oMMZdrceYvQFgTkUQKqneoJFZOPKlwJGTrpcmHwxTRic/8GlrcRlJhx1gr6lmeWEF4Q
         sKB155GGQMCQWM90rSvB2twpf4ZkIlLe29aEU800OtdlLD/gfmXuDiC4WOKSu4dITNNK
         3o+Q==
X-Gm-Message-State: AOAM5338BBdlaN1MmshknTddxZbOIkuH9p75R9PaedDq/1KalDtFUFxi
	GEX5nczMVahbPiz3v6syfwo=
X-Google-Smtp-Source: ABdhPJzGituTcml7q8z/bFSirZjHN/EzKmPMByct6A039FIlbn7nWDRowe12KRH+XfpvJo86S+l4JA==
X-Received: by 2002:a63:8042:: with SMTP id j63mr23244031pgd.225.1636963951054;
        Mon, 15 Nov 2021 00:12:31 -0800 (PST)
Message-ID: <d4bf6e277e1fc5dbd9026a8fdd705599de87ba6b.camel@gmail.com>
Subject: Re: [PATCH v2 0/2] Introduce the pkill_on_warn parameter
From: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
To: Alexander Popov <alex.popov@linux.com>, Jonathan Corbet
 <corbet@lwn.net>,  Linus Torvalds <torvalds@linux-foundation.org>, Paul
 McKenney <paulmck@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra
 <peterz@infradead.org>, Joerg Roedel <jroedel@suse.de>, Maciej Rozycki
 <macro@orcam.me.uk>,  Muchun Song <songmuchun@bytedance.com>, Viresh Kumar
 <viresh.kumar@linaro.org>, Robin Murphy <robin.murphy@arm.com>, Randy
 Dunlap <rdunlap@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, Petr
 Mladek <pmladek@suse.com>, Kees Cook <keescook@chromium.org>, Luis
 Chamberlain <mcgrof@kernel.org>, Wei Liu <wl@xen.org>, John Ogness
 <john.ogness@linutronix.de>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Alexey Kardashevskiy <aik@ozlabs.ru>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, Jann Horn
 <jannh@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark
 Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Dave
 Hansen <dave.hansen@linux.intel.com>, Steven Rostedt <rostedt@goodmis.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Laura
 Abbott <labbott@kernel.org>, David S Miller <davem@davemloft.net>, Borislav
 Petkov <bp@alien8.de>, Arnd Bergmann <arnd@arndb.de>, Andrew Scull
 <ascull@google.com>, Marc Zyngier <maz@kernel.org>,  Jessica Yu
 <jeyu@kernel.org>, Iurii Zaikin <yzaikin@google.com>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, Wang Qing <wangqing@vivo.com>, Mel Gorman
 <mgorman@suse.de>, Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
 Andrew Klychkov <andrew.a.klychkov@gmail.com>, Mathieu Chouquet-Stringer
 <me@mathieu.digital>, Daniel Borkmann <daniel@iogearbox.net>, Stephen Kitt
 <steve@sk2.org>, Stephen Boyd <sboyd@kernel.org>,  Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Mike Rapoport <rppt@kernel.org>, Bjorn
 Andersson <bjorn.andersson@linaro.org>,
 kernel-hardening@lists.openwall.com,  linux-hardening@vger.kernel.org,
 linux-doc@vger.kernel.org,  linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org,  linux-fsdevel@vger.kernel.org
Cc: notify@kernel.org
Date: Mon, 15 Nov 2021 13:42:12 +0530
In-Reply-To: <20211027233215.306111-1-alex.popov@linux.com>
References: <20211027233215.306111-1-alex.popov@linux.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2021-10-28 at 02:32 +0300, Alexander Popov wrote:
> [...]
> 
> From a security point of view, kernel warning messages provide a lot of
> useful information for attackers. Many GNU/Linux distributions allow
> unprivileged users to read the kernel log, so attackers use kernel
> warning infoleak in vulnerability exploits. 
At the risk of being too simplistic, if the intention is to cut down infoleaks,
why not simply have a config (and/or sysctl) to toggle it - both at kernel build
as well as at runtime via a sysctl.

A minimal starting attempt at this, definitely incomplete (i've not actually written
the config anywhere, sorry, I'd just like to propose this as an idea for now) could
be something like this? (Am calling the kconfig CONFIG_TERSE_DIAGS_ONWARN):

---
 kernel/panic.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index cefd7d82366f..bbf00b0a8110 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -587,10 +587,8 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
    if (args)
        vprintk(args->fmt, args->args);
 
-   print_modules();
-
-   if (regs)
-       show_regs(regs);
+   if (IS_ENABLED(CONFIG_TERSE_DIAGS_ONWARN))
+       return;
 
    if (panic_on_warn) {
        /*
@@ -603,6 +601,11 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
        panic("panic_on_warn set ...\n");
    }   
 
+   print_modules();
+
+   if (regs)
+       show_regs(regs);
+
    if (!regs)
        dump_stack();
 
-- 
2.25.1


Further, am unsure precisely which portions of diagnostic output would be useful
to retain when the config's on. Of course, this "patch" is very premature. Of course,
am open to suggestions on all of this,
Regards

