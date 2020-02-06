Return-Path: <SRS0=Uq2t=32=lists.openwall.com=kernel-hardening-return-17722-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5E6C3F68F
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 17:51:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BEFF9214AF
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 17:51:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEFF9214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17722-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17666 invoked by uid 550); 6 Feb 2020 17:51:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17646 invoked from network); 6 Feb 2020 17:51:27 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="404558389"
Message-ID: <a915e1eb131551aa766fde4c14de5a3e825af667.camel@linux.intel.com>
Subject: Re: [RFC PATCH 09/11] kallsyms: hide layout and expose seed
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, 
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org, 
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Date: Thu, 06 Feb 2020 09:51:14 -0800
In-Reply-To: <202002060428.08B14F1@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
	 <20200205223950.1212394-10-kristen@linux.intel.com>
	 <202002060428.08B14F1@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2020-02-06 at 04:32 -0800, Kees Cook wrote:
> On Wed, Feb 05, 2020 at 02:39:48PM -0800, Kristen Carlson Accardi
> wrote:
> > To support finer grained kaslr (fgkaslr), we need to make a couple
> > changes
> > to kallsyms. Firstly, we need to hide our sorted list of symbols,
> > since
> > this will give away our new layout. Secondly, we will export the
> > seed used
> > for randomizing the layout so that it can be used to make a
> > particular
> > layout persist across boots for debug purposes.
> > 
> > Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> > ---
> >  kernel/kallsyms.c | 30 +++++++++++++++++++++++++++++-
> >  1 file changed, 29 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> > index 136ce049c4ad..432b13a3a033 100644
> > --- a/kernel/kallsyms.c
> > +++ b/kernel/kallsyms.c
> > @@ -698,6 +698,21 @@ const char *kdb_walk_kallsyms(loff_t *pos)
> >  }
> >  #endif	/* CONFIG_KGDB_KDB */
> >  
> > +#ifdef CONFIG_FG_KASLR
> > +extern const u64 fgkaslr_seed[] __weak;
> > +
> > +static int proc_fgkaslr_show(struct seq_file *m, void *v)
> > +{
> > +	seq_printf(m, "%llx\n", fgkaslr_seed[0]);
> > +	seq_printf(m, "%llx\n", fgkaslr_seed[1]);
> > +	seq_printf(m, "%llx\n", fgkaslr_seed[2]);
> > +	seq_printf(m, "%llx\n", fgkaslr_seed[3]);
> > +	return 0;
> > +}
> > +#else
> > +static inline int proc_fgkaslr_show(struct seq_file *m, void *v) {
> > return 0; }
> > +#endif
> > +
> 
> I'd like to put the fgkaslr seed exposure behind a separate DEBUG
> config, since it shouldn't be normally exposed. As such, its
> infrastructure should be likely extracted from this and the main
> fgkaslr
> patches and added back separately (and maybe it will entirely vanish
> once the RNG is switched to ChaCha20).

OK, sounds reasonable to me.

> 
> >  static const struct file_operations kallsyms_operations = {
> >  	.open = kallsyms_open,
> >  	.read = seq_read,
> > @@ -707,7 +722,20 @@ static const struct file_operations
> > kallsyms_operations = {
> >  
> >  static int __init kallsyms_init(void)
> >  {
> > -	proc_create("kallsyms", 0444, NULL, &kallsyms_operations);
> > +	/*
> > +	 * When fine grained kaslr is enabled, we don't want to
> > +	 * print out the symbols even with zero pointers because
> > +	 * this reveals the randomization order. If fg kaslr is
> > +	 * enabled, make kallsyms available only to privileged
> > +	 * users.
> > +	 */
> > +	if (!IS_ENABLED(CONFIG_FG_KASLR))
> > +		proc_create("kallsyms", 0444, NULL,
> > &kallsyms_operations);
> > +	else {
> > +		proc_create_single("fgkaslr_seed", 0400, NULL,
> > +					proc_fgkaslr_show);
> > +		proc_create("kallsyms", 0400, NULL,
> > &kallsyms_operations);
> > +	}
> >  	return 0;
> >  }
> >  device_initcall(kallsyms_init);
> > -- 
> > 2.24.1
> 
> In the past, making kallsyms entirely unreadable seemed to break
> weird
> stuff in userspace. How about having an alternative view that just
> contains a alphanumeric sort of the symbol names (and they will
> continue
> to have zeroed addresses for unprivileged users)?
> 
> Or perhaps we wait to hear about this causing a problem, and deal
> with
> it then? :)
> 

Yeah - I don't know what people want here. Clearly, we can't leave
kallsyms the way it is. Removing it entirely is a pretty fast way to
figure out how people use it though :).


