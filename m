Return-Path: <SRS0=eLAT=CF=lists.openwall.com=kernel-hardening-return-19684-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20ABCC433E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 10:00:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 70BE92075B
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 10:00:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="aKv0rDmK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70BE92075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19684-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4005 invoked by uid 550); 27 Aug 2020 10:00:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3969 invoked from network); 27 Aug 2020 10:00:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598522394;
	bh=kLOwClv6cLLdqgQ6u8r+eTVLWMVWAPwOxRLFW4eZjbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aKv0rDmKS+We0eGWLP28VHPdK3FuCBdHYDM1jJqcogL4tZoqFhx5/DrygPOvX1aSL
	 RUaVxu8O1D7L1O/vPnI0wmlQhjPxwvbhm9QtvwDcPw4iw0Q4GdP7O/uc6A61Ri3KqA
	 LyhjigTVaO6BkxQ/c688Xk4Y6av0OmXCPoDtH50Y=
Date: Thu, 27 Aug 2020 12:00:08 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Mrinal Pandey <mrinalmni@gmail.com>, skhan@linuxfoundation.org,
	Linux-kernel-mentees@lists.linuxfoundation.org,
	keescook@chromium.org, re.emese@gmail.com, maennich@google.com,
	tglx@linutronix.de, akpm@linux-foundation.org,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
	linux-spdx@vger.kernel.org
Subject: Re: [PATCH] scripts: Add intended executable mode and SPDX license
Message-ID: <20200827100008.GA403378@kroah.com>
References: <20200827092405.b6hymjxufn2nvgml@mrinalpandey>
 <20200827094344.GA400189@kroah.com>
 <alpine.DEB.2.21.2008271145370.25858@felia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2008271145370.25858@felia>

On Thu, Aug 27, 2020 at 11:49:31AM +0200, Lukas Bulwahn wrote:
> 
> 
> On Thu, 27 Aug 2020, Greg KH wrote:
> 
> > On Thu, Aug 27, 2020 at 02:54:05PM +0530, Mrinal Pandey wrote:
> > > commit b72231eb7084 ("scripts: add spdxcheck.py self test") added the file
> > > spdxcheck-test.sh to the repository without the executable flag and license
> > > information.
> > > 
> > > commit eb8305aecb95 ("scripts: Coccinelle script for namespace
> > > dependencies.") added the file nsdeps, commit 313dd1b62921 ("gcc-plugins:
> > > Add the randstruct plugin") added the file gcc-plugins/gen-random-seed.sh
> > > and commit 9b4ade226f74 ("xen: build infrastructure for generating
> > > hypercall depending symbols") added the file xen-hypercalls.sh without the
> > > executable bit.
> > > 
> > > Set to usual modes for these files and provide the SPDX license for
> > > spdxcheck-test.sh. No functional changes.
> > > 
> > > Signed-off-by: Mrinal Pandey <mrinalmni@gmail.com>
> > > ---
> > > applies cleanly on next-20200827
> > > 
> > > Kees, Matthias, Thomas, please ack this patch.
> > > 
> > > Andrew, please pick this minor non-urgent cleanup patch once the
> > > mainainers ack.
> > > 
> > >  scripts/gcc-plugins/gen-random-seed.sh | 0
> > >  scripts/nsdeps                         | 0
> > >  scripts/spdxcheck-test.sh              | 1 +
> > >  scripts/xen-hypercalls.sh              | 0
> > >  4 files changed, 1 insertion(+)
> > >  mode change 100644 => 100755 scripts/gcc-plugins/gen-random-seed.sh
> > >  mode change 100644 => 100755 scripts/nsdeps
> > >  mode change 100644 => 100755 scripts/spdxcheck-test.sh
> > >  mode change 100644 => 100755 scripts/xen-hypercalls.sh
> > 
> > This does 2 different things in one patch, shouldn't this be 2 different
> > patches?  One to change the permissions and one to add the SPDX line?
> >
> 
> For me, this was one thing: minor cleanup; and taking one 
> minor patch is easier than taking two, but you make the call. Then, the 
> two or even three patches would also just travel through different trees, 
> the spdx tree and Andrew's.

License "additions" are good to separate from other changes, in case
people have questions/comments/objections about them, they can be easier
to discuss and possibly reverted.

More patches is not a problem :)

thanks,

greg k-h
