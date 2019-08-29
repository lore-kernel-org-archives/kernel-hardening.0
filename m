Return-Path: <SRS0=P4fD=WZ=lists.openwall.com=kernel-hardening-return-16826-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0306BC3A59F
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 12:39:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 496202339E
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 12:39:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 496202339E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=informatik.wtf
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16826-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29867 invoked by uid 550); 29 Aug 2019 12:38:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29835 invoked from network); 29 Aug 2019 12:38:56 -0000
Date: Thu, 29 Aug 2019 07:38:43 -0500 (CDT)
From: Christopher M Riedl <cmr@informatik.wtf>
To: Daniel Axtens <dja@axtens.net>, linuxppc-dev@ozlabs.org,
	kernel-hardening@lists.openwall.com
Cc: ajd@linux.ibm.com
Message-ID: <1128494624.37921.1567082323737@privateemail.com>
In-Reply-To: <87ef14v5j0.fsf@dja-thinkpad.axtens.net>
References: <20190828034613.14750-1-cmr@informatik.wtf>
 <20190828034613.14750-2-cmr@informatik.wtf>
 <87ef14v5j0.fsf@dja-thinkpad.axtens.net>
Subject: Re: [PATCH v5 1/2] powerpc/xmon: Allow listing and clearing
 breakpoints in read-only mode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev60
X-Originating-Client: open-xchange-appsuite
X-Virus-Scanned: ClamAV using ClamSMTP

> On August 29, 2019 at 1:40 AM Daniel Axtens <dja@axtens.net> wrote:
> 
> 
> Hi Chris,
> 
> > Read-only mode should not prevent listing and clearing any active
> > breakpoints.
> 
> I tested this and it works for me:
> 
> Tested-by: Daniel Axtens <dja@axtens.net>
> 
> > +		if (xmon_is_ro || !scanhex(&a)) {
> 
> It took me a while to figure out what this line does: as I understand
> it, the 'b' command can also be used to install a breakpoint (as well as
> bi/bd). If we are in ro mode or if the input after 'b' doesn't scan as a
> hex string, print the list of breakpoints instead. Anyway, I'm now
> happy with it, so:
>

I can add a comment to that effect in the next version. That entire section
of code could probably be cleaned up a bit - but that's for another patch.
Thanks for testing!

> 
> Reviewed-by: Daniel Axtens <dja@axtens.net>
> 
> Regards,
> Daniel
> 
> >  			/* print all breakpoints */
> >  			printf("   type            address\n");
> >  			if (dabr.enabled) {
> > -- 
> > 2.23.0
