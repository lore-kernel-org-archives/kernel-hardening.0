Return-Path: <kernel-hardening-return-21571-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 69D98C04A68
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Jul 2022 16:42:50 +0000 (UTC)
Received: (qmail 19753 invoked by uid 550); 27 Jul 2022 16:42:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19733 invoked from network); 27 Jul 2022 16:42:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AcPJOkIHEC0icvBEnpWtnVKxz/BvRtFJOpxpTEHoQRg=;
        b=dnnAblfbBitvVzSIxg4x60tAPSI8URVjg+EFtGQCO+Egbv95vWxxuJA0seKRUNvCni
         MH/l2lfP3y3m2n82QniX+RZ7l/z/R/u1/iB5fRHweoFmNcwnKUaQHfBq5L2Tk1oDNYlw
         q+xyWk2wZadVAhHiWbYj77fvxQHCyW96l9uJ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AcPJOkIHEC0icvBEnpWtnVKxz/BvRtFJOpxpTEHoQRg=;
        b=5ygEyw1nf1EQ8Wno1xhKTXxmMPDSC4ZlJYO/dBMwBRjSLjSRBxoflJX0O0V+5gZlJk
         P+tqR4/Xcpwamitqc9cq9PoEHXLqXby14fxlJPhOsvECqHTgWa0xlnrVmejRgwy6q9+7
         ogYgXzb/6zNeIUrrIUZJJ+MgM6c1d7wk++j2rb/iAkJ6hmBsfsNiuggRZb9xG2Vc/SLJ
         1uOX3pZ2WqAUmp5Iz26KIJVS/nZlaa7M9PDt/A5LQhBDceTKi37RHbBXDy1SdmJeWDmZ
         xxmf2pDZJGYU1tYF1CUMkkIA/TPaKKpol8fejg7E8fOR1lW1+iwJAbEjXhRa7/p8Velw
         WJXQ==
X-Gm-Message-State: AJIora9idKpnJx7+kHhGR5GR2kV6ugyo7DgIAvwLJ/wpYnm3NLL7Pv7H
	dmE5GIzR+GIbLJXhjbP+Y/6v5uETHXO8cs2B
X-Google-Smtp-Source: AGRyM1unZ8sqk3TWqDgK5ufCxGB4yAkYRBqrWzKwkMLE9klXLlpK+fJD5hGS1DEdLihSxm/4hYdA0A==
X-Received: by 2002:a05:6402:d77:b0:43b:bcdc:ec9b with SMTP id ec55-20020a0564020d7700b0043bbcdcec9bmr24493245edb.183.1658940149762;
        Wed, 27 Jul 2022 09:42:29 -0700 (PDT)
X-Received: by 2002:a05:600c:4ed0:b0:3a3:3ef3:c8d1 with SMTP id
 g16-20020a05600c4ed000b003a33ef3c8d1mr3721170wmq.154.1658940137807; Wed, 27
 Jul 2022 09:42:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210929185823.499268-1-alex.popov@linux.com> <d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
 <20210929194924.GA880162@paulmck-ThinkPad-P17-Gen-1> <YVWAPXSzFNbHz6+U@alley>
 <CAHk-=widOm3FXMPXXK0cVaoFuy3jCk65=5VweLceQCuWdep=Hg@mail.gmail.com> <7c567acd-1cc1-a480-ca5a-d50a9c5a69ef@ispras.ru>
In-Reply-To: <7c567acd-1cc1-a480-ca5a-d50a9c5a69ef@ispras.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Jul 2022 09:42:01 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgSyNh2gZTnC-EoiGs5WNtVu99jcHXxLRUvwMabm37iKg@mail.gmail.com>
Message-ID: <CAHk-=wgSyNh2gZTnC-EoiGs5WNtVu99jcHXxLRUvwMabm37iKg@mail.gmail.com>
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Petr Mladek <pmladek@suse.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Popov <alex.popov@linux.com>, Jonathan Corbet <corbet@lwn.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Peter Zijlstra <peterz@infradead.org>, Joerg Roedel <jroedel@suse.de>, 
	Maciej Rozycki <macro@orcam.me.uk>, Muchun Song <songmuchun@bytedance.com>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Robin Murphy <robin.murphy@arm.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Kees Cook <keescook@chromium.org>, Luis Chamberlain <mcgrof@kernel.org>, Wei Liu <wl@xen.org>, 
	John Ogness <john.ogness@linutronix.de>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Alexey Kardashevskiy <aik@ozlabs.ru>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Jann Horn <jannh@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Thomas Garnier <thgarnie@google.com>, 
	Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Laura Abbott <labbott@redhat.com>, David S Miller <davem@davemloft.net>, Borislav Petkov <bp@alien8.de>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 27, 2022 at 9:17 AM Alexey Khoroshilov
<khoroshilov@ispras.ru> wrote:
>
> We see a number of cases where WARNING is used to inform userspace that
> it is doing something wrong, e.g.
> https://elixir.bootlin.com/linux/v5.19-rc8/source/net/can/j1939/socket.c#L181
> https://elixir.bootlin.com/linux/v5.19-rc8/source/drivers/video/fbdev/core/fbmem.c#L1023

That first case is entirely bogus.

WARN_ON() should only be used for "This cannot happen, but if it does,
I want to know how we got here".

But the second case is fine: Using "pr_warn()" is fine. A kernel
warning (without a backtrace) is a normal thing for something that is
deprecated or questionable, and you want to tell the user that "this
app is doing something wrong".

So if that j1939 thing is something that can be triggered by a user,
then the backtrace should be reported to the driver maintainer, and
then either

 (a) the WARN_ON_ONCE() should just be removed ("ok, this can happen,
we understand why it can happen, and it's fine")

 (b) the problem the WARN_ON_ONCE() reports about should be made
impossible some way

 (c) it might be downgraded to a pr_warn() if people really want to
tell user space that "guys, you're doing something wrong" and it's
considered a useful warning.

Honestly, for something like that j1939 can driver, I doubt (c) is
ever an option. The "return -EBUSY" is the only real information that
a user needs.

               Linus
