Return-Path: <SRS0=Nbf+=OT=lists.openwall.com=kernel-hardening-return-21394-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5536AC433EF
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Sep 2021 20:07:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8520261262
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Sep 2021 20:07:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8520261262
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 24526 invoked by uid 550); 29 Sep 2021 20:07:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24506 invoked from network); 29 Sep 2021 20:07:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Qh2eW8LeGi3ecsaiI+luhmjw9dtB3ilPhgER4eDq8qA=;
        b=em8dv1OxQ3CY+GjWZuXKn0XD1KUyGIXo6JnSL4zsriDxpYcBDGVUun35YA90hQEmqi
         nwnf+rGGPeAbcI0LGWcU/iRdas6o494V9gL/n1Kj9aPw+qTvvWnajAqipmtpl+24cqYw
         Xugl3+HDyMIjT8JAMNMYddsZljPijTLJsX6bc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Qh2eW8LeGi3ecsaiI+luhmjw9dtB3ilPhgER4eDq8qA=;
        b=JbmXiF2BkUIwysg+2C9OnIys7uGX2nfB+K7rsmFIncryVnu6aFKI0Q/4tyKfWBE2vY
         qFXDO4JhOYils3K6+RWrMBLFYtFbdzVPjx6SyrokvO/YpUHoE12KyWt2BD5yyUPs0mRQ
         brosrSEDBrJrjh298niDUC+DKStF0tct8VUjvujEklm6vsI4YKBHnBj2RfhZ8DGj97qI
         ms8HpEMXNRMZOcwZhFFGVKUWinTSyPPgkmlHzdqZp3XVF9fZmdzxKUy3JqaOOZIjXgLt
         LPLTyR/HYvmmxP2myR9U3E32zbphHxFYtJA7xVvC3YFM/KFS/arB1T/bOEyKZSczKjjB
         gYbQ==
X-Gm-Message-State: AOAM5337vvvlKFDv3WPnSmlH8n6vJRsKat0EQwCZBc9ZafsN4pBh8Leq
	BkGzKdGPkqns9E8bIc87HvxtQg==
X-Google-Smtp-Source: ABdhPJyASVjN67AZaOARzgD7jg3cw0R30U1AYnQObbDGl6D1dtp9jLVD4UO+Mz+5SVl0hn/odNL7Lw==
X-Received: by 2002:aa7:9846:0:b0:444:5517:fa17 with SMTP id n6-20020aa79846000000b004445517fa17mr494981pfq.85.1632946020896;
        Wed, 29 Sep 2021 13:07:00 -0700 (PDT)
Date: Wed, 29 Sep 2021 13:06:59 -0700
From: Kees Cook <keescook@chromium.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Alexander Popov <alex.popov@linux.com>,
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
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Garnier <thgarnie@google.com>,
	Will Deacon <will.deacon@arm.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Laura Abbott <labbott@redhat.com>,
	David S Miller <davem@davemloft.net>,
	Borislav Petkov <bp@alien8.de>, kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, notify@kernel.org
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
Message-ID: <202109291229.C64A1D9D@keescook>
References: <20210929185823.499268-1-alex.popov@linux.com>
 <323d0784-249d-7fef-6c60-e8426d35b083@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <323d0784-249d-7fef-6c60-e8426d35b083@intel.com>

On Wed, Sep 29, 2021 at 12:03:36PM -0700, Dave Hansen wrote:
> On 9/29/21 11:58 AM, Alexander Popov wrote:
> > --- a/kernel/panic.c
> > +++ b/kernel/panic.c
> > @@ -53,6 +53,7 @@ static int pause_on_oops_flag;
> >  static DEFINE_SPINLOCK(pause_on_oops_lock);
> >  bool crash_kexec_post_notifiers;
> >  int panic_on_warn __read_mostly;
> > +int pkill_on_warn __read_mostly;

I like this idea. I can't tell if Linus would tolerate it, though. But I
really have wanted a middle ground like BUG(). Having only WARN() and
panic() is not very friendly. :(

> >  unsigned long panic_on_taint;
> >  bool panic_on_taint_nousertaint = false;
> >  
> > @@ -610,6 +611,9 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
> >  
> >  	print_oops_end_marker();
> >  
> > +	if (pkill_on_warn && system_state >= SYSTEM_RUNNING)
> > +		do_group_exit(SIGKILL);
> > +
> >  	/* Just a warning, don't kill lockdep. */
> >  	add_taint(taint, LOCKDEP_STILL_OK);
> >  }
> 
> Doesn't this tie into the warning *printing* code?  That's better than
> nothing, for sure.  But, if we're doing this for hardening, I think we
> would want to kill anyone provoking a warning, not just the first one
> that triggered *printing* the warning.

Right, this needs to be moved into the callers of __warn() (i.e.
report_bug(), and warn_slowpath_fmt()), likely with some small
refactoring in report_bug().

-- 
Kees Cook
