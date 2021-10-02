Return-Path: <SRS0=di+H=OW=lists.openwall.com=kernel-hardening-return-21412-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D764BC433EF
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 Oct 2021 18:31:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CA27661A0A
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 Oct 2021 18:31:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CA27661A0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 29845 invoked by uid 550); 2 Oct 2021 18:31:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29821 invoked from network); 2 Oct 2021 18:31:50 -0000
Date: Sat, 2 Oct 2021 14:31:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexander Popov <alex.popov@linux.com>, Jonathan Corbet
 <corbet@lwn.net>, Paul McKenney <paulmck@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Peter
 Zijlstra <peterz@infradead.org>, Joerg Roedel <jroedel@suse.de>, Maciej
 Rozycki <macro@orcam.me.uk>, Muchun Song <songmuchun@bytedance.com>, Viresh
 Kumar <viresh.kumar@linaro.org>, Robin Murphy <robin.murphy@arm.com>, Randy
 Dunlap <rdunlap@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, Petr
 Mladek <pmladek@suse.com>, Kees Cook <keescook@chromium.org>, Luis
 Chamberlain <mcgrof@kernel.org>, Wei Liu <wl@xen.org>, John Ogness
 <john.ogness@linutronix.de>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Alexey Kardashevskiy <aik@ozlabs.ru>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Jann Horn
 <jannh@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark
 Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Dave
 Hansen <dave.hansen@linux.intel.com>, Thomas Garnier <thgarnie@google.com>,
 Will Deacon <will.deacon@arm.com>, Ard Biesheuvel
 <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, David S
 Miller <davem@davemloft.net>, Borislav Petkov <bp@alien8.de>,
 kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, notify@kernel.org
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
Message-ID: <20211002143132.3a51a8e0@oasis.local.home>
In-Reply-To: <YVifGtn3LctrWOwg@zeniv-ca.linux.org.uk>
References: <20210929185823.499268-1-alex.popov@linux.com>
	<YVifGtn3LctrWOwg@zeniv-ca.linux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 2 Oct 2021 18:04:10 +0000
Al Viro <viro@zeniv.linux.org.uk> wrote:

> > @@ -610,6 +611,9 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
> >  
> >  	print_oops_end_marker();
> >  
> > +	if (pkill_on_warn && system_state >= SYSTEM_RUNNING)
> > +		do_group_exit(SIGKILL);
> > +  
> 
> Wait a sec...  do_group_exit() is very much not locking-neutral.
> Aren't you introducing a bunch of potential deadlocks by adding
> that?

Perhaps add an irq_work() here to trigger the do_group_exit() from a
"safe" interrupt context?

-- Steve
