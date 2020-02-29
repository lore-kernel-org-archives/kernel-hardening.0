Return-Path: <SRS0=23pA=4R=lists.openwall.com=kernel-hardening-return-18024-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA97C3F2C6
	for <kernel-hardening@archiver.kernel.org>; Sat, 29 Feb 2020 23:01:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E91F424650
	for <kernel-hardening@archiver.kernel.org>; Sat, 29 Feb 2020 23:01:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E91F424650
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=buserror.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18024-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5209 invoked by uid 550); 29 Feb 2020 23:01:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5172 invoked from network); 29 Feb 2020 23:01:10 -0000
Message-ID: <530c49dfd97c811dc53ffc78c594d7133f7eb1e9.camel@buserror.net>
From: Scott Wood <oss@buserror.net>
To: Jason Yan <yanaijie@huawei.com>, Daniel Axtens <dja@axtens.net>, 
 mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, 
 christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, 
 npiggin@gmail.com, keescook@chromium.org,
 kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com
Date: Sat, 29 Feb 2020 16:54:14 -0600
In-Reply-To: <188971ed-f1c4-39b3-c07e-89cc593d88d7@huawei.com>
References: <20200206025825.22934-1-yanaijie@huawei.com>
	 <87tv3drf79.fsf@dja-thinkpad.axtens.net>
	 <8171d326-5138-4f5c-cff6-ad3ee606f0c2@huawei.com>
	 <e8cd8f287934954cfa07dcf76ac73492e2d49a5b.camel@buserror.net>
	 <dd8db870-b607-3f74-d3bc-a8d9f33f9852@huawei.com>
	 <4c0e7fec63dbc7b91fa6c24692c73c256c131f51.camel@buserror.net>
	 <188971ed-f1c4-39b3-c07e-89cc593d88d7@huawei.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2601:449:8480:af0:12bf:48ff:fe84:c9a0
X-SA-Exim-Rcpt-To: yanaijie@huawei.com, dja@axtens.net, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com
X-SA-Exim-Mail-From: oss@buserror.net
Subject: Re: [PATCH v3 0/6] implement KASLR for powerpc/fsl_booke/64
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on baldur.buserror.net)

On Sat, 2020-02-29 at 15:27 +0800, Jason Yan wrote:
> 
> 在 2020/2/29 12:28, Scott Wood 写道:
> > On Fri, 2020-02-28 at 14:47 +0800, Jason Yan wrote:
> > > 
> > > 在 2020/2/28 13:53, Scott Wood 写道:
> > > > 
> > > > I don't see any debug setting for %pK (or %p) to always print the
> > > > actual
> > > > address (closest is kptr_restrict=1 but that only works in certain
> > > > contexts)... from looking at the code it seems it hashes even if kaslr
> > > > is
> > > > entirely disabled?  Or am I missing something?
> > > > 
> > > 
> > > Yes, %pK (or %p) always hashes whether kaslr is disabled or not. So if
> > > we want the real value of the address, we cannot use it. But if you only
> > > want to distinguish if two pointers are the same, it's ok.
> > 
> > Am I the only one that finds this a bit crazy?  If you want to lock a
> > system
> > down then fine, but why wage war on debugging even when there's no
> > randomization going on?  Comparing two pointers for equality is not always
> > adequate.
> > 
> 
> AFAIK, %p hashing is only exist because of many legacy address printings
> and force who really want the raw values to switch to %px or even %lx.
> It's not the opposite of debugging. Raw address printing is not
> forbidden, only people need to estimate the risk of adrdress leaks.

Yes, but I don't see any format specifier to switch to that will hash in a
randomized production environment, but not in a debug or other non-randomized
environment which seems like the ideal default for most debug output.

> 
> Turnning to %p may not be a good idea in this situation. So
> for the REG logs printed when dumping stack, we can disable it when
> KASLR is open. For the REG logs in other places like show_regs(), only
> privileged can trigger it, and they are not combind with a symbol, so
> I think it's ok to keep them.
> 
> diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
> index fad50db9dcf2..659c51f0739a 100644
> --- a/arch/powerpc/kernel/process.c
> +++ b/arch/powerpc/kernel/process.c
> @@ -2068,7 +2068,10 @@ void show_stack(struct task_struct *tsk, unsigned 
> long *stack)
>                  newsp = stack[0];
>                  ip = stack[STACK_FRAME_LR_SAVE];
>                  if (!firstframe || ip != lr) {
> -                       printk("["REG"] ["REG"] %pS", sp, ip, (void *)ip);
> +                       if (IS_ENABLED(CONFIG_RANDOMIZE_BASE))
> +                               printk("%pS", (void *)ip);
> +                       else
> +                               printk("["REG"] ["REG"] %pS", sp, ip, 
> (void *)ip);

This doesn't deal with "nokaslr" on the kernel command line.  It also doesn't
seem like something that every callsite should have to opencode, versus having
an appropriate format specifier behaves as I described above (and I still
don't see why that format specifier should not be "%p").

-Scott


