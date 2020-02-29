Return-Path: <SRS0=1kBf=4R=lists.openwall.com=kernel-hardening-return-18021-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDEBC3F2D7
	for <kernel-hardening@archiver.kernel.org>; Sat, 29 Feb 2020 04:35:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ED209246A2
	for <kernel-hardening@archiver.kernel.org>; Sat, 29 Feb 2020 04:35:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED209246A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=buserror.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18021-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28374 invoked by uid 550); 29 Feb 2020 04:35:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28342 invoked from network); 29 Feb 2020 04:35:35 -0000
Message-ID: <4c0e7fec63dbc7b91fa6c24692c73c256c131f51.camel@buserror.net>
From: Scott Wood <oss@buserror.net>
To: Jason Yan <yanaijie@huawei.com>, Daniel Axtens <dja@axtens.net>, 
 mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, 
 christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, 
 npiggin@gmail.com, keescook@chromium.org,
 kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com
Date: Fri, 28 Feb 2020 22:28:39 -0600
In-Reply-To: <dd8db870-b607-3f74-d3bc-a8d9f33f9852@huawei.com>
References: <20200206025825.22934-1-yanaijie@huawei.com>
	 <87tv3drf79.fsf@dja-thinkpad.axtens.net>
	 <8171d326-5138-4f5c-cff6-ad3ee606f0c2@huawei.com>
	 <e8cd8f287934954cfa07dcf76ac73492e2d49a5b.camel@buserror.net>
	 <dd8db870-b607-3f74-d3bc-a8d9f33f9852@huawei.com>
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

On Fri, 2020-02-28 at 14:47 +0800, Jason Yan wrote:
> 
> 在 2020/2/28 13:53, Scott Wood 写道:
> > On Wed, 2020-02-26 at 16:18 +0800, Jason Yan wrote:
> > > Hi Daniel,
> > > 
> > > 在 2020/2/26 15:16, Daniel Axtens 写道:
> > > > Maybe replacing the REG format string in KASLR mode would be
> > > > sufficient?
> > > > 
> > > 
> > > Most archs have removed the address printing when dumping stack. Do we
> > > really have to print this?
> > > 
> > > If we have to do this, maybe we can use "%pK" so that they will be
> > > hidden from unprivileged users.
> > 
> > I've found the addresses to be useful, especially if I had a way to dump
> > the
> > stack data itself.  Wouldn't the register dump also be likely to give away
> > the
> > addresses?
> 
> If we have to print the address, then kptr_restrict and dmesg_restrict
> must be set properly so that unprivileged users cannot see them.

And how does that work with crash dumps that could be from any context?

dmesg_restrict is irrelevant as it just controls who can see the dmesg, not
what goes into it.  kptr_restrict=1 will only get the value if you're not in
any sort of IRQ, *and* if the crashing context happened to have CAP_SYSLOG. 
No other value of kptr_restrict will ever get you the raw value.

> > 
> > I don't see any debug setting for %pK (or %p) to always print the actual
> > address (closest is kptr_restrict=1 but that only works in certain
> > contexts)... from looking at the code it seems it hashes even if kaslr is
> > entirely disabled?  Or am I missing something?
> > 
> 
> Yes, %pK (or %p) always hashes whether kaslr is disabled or not. So if
> we want the real value of the address, we cannot use it. But if you only
> want to distinguish if two pointers are the same, it's ok.

Am I the only one that finds this a bit crazy?  If you want to lock a system
down then fine, but why wage war on debugging even when there's no
randomization going on?  Comparing two pointers for equality is not always
adequate.

-Scott


