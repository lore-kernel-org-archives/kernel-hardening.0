Return-Path: <SRS0=u7sM=3U=lists.openwall.com=kernel-hardening-return-17644-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD17C33CB2
	for <kernel-hardening@archiver.kernel.org>; Fri, 31 Jan 2020 06:53:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5F7FC20705
	for <kernel-hardening@archiver.kernel.org>; Fri, 31 Jan 2020 06:53:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="o5YxGTLi";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="o8YI7DDa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F7FC20705
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17644-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1249 invoked by uid 550); 31 Jan 2020 06:53:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1215 invoked from network); 31 Jan 2020 06:53:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:mime-version:content-transfer-encoding; s=fm1; bh=
	PK1pmpuptvT5/MkvhBVcvSK+hqg9sA+88hLtr2Io7nw=; b=o5YxGTLi4sIrJXoo
	ugd2krrWcg64RFmiqJ6tdkiGc+adzeQ5z4ig6QeuAXfutLZu11Bc36G1UXTaOgsw
	McqAYwaYsI3d31F5bgjRfskD3QNOmNqWiQG1R3ZwWRmBJs9HQ6nxHd+Jr7w9rDwT
	TsrXMVIwp5ZowfFbIZuI/ZIAMwSyUTu6Ty3Hk+YQsjFZMyjyykhWXH2QHNFuNwxh
	ESpv/hHIuNWv8FfgrY5OY+iDHNtvScWNLCG1GgKPmNALsiXfqqMf7GaZt8UrwwL/
	0tXc0BlHl7E8Xao68bTmHg61lA9Do2j7OFxy5OnuBif1zPDj10vQrYeui+CfdelB
	DdXdbw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:from:in-reply-to:message-id:mime-version:references
	:subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; bh=PK1pmpuptvT5/MkvhBVcvSK+hqg9sA+88hLtr2Io7
	nw=; b=o8YI7DDaHYTjKgapJwAjfU8XvzA5klTJrByUtPe78PgrHGM7HTS1QawvQ
	16SAxyiDIIyl0S8pefOn24dXAcLIQmfHVr/0CBXKmeSzkZ6lwCUlm63CIFNLEYcT
	l+OVW2JwxEmXrl04JtL10DqHdt4lHyho8/ADXrmUjmLPYpdIQJoycdswXMM/zV7Z
	C7soOieAJSFDjaobkbgTqmsgn2WPiVeTIzxwl9Tr0ot62gTb8XiOJjN3fH3faalM
	bf9EbN4gx7PPYjL/C6eRJp72AGezAybDKYhpuX07yLRNA7vAGRhoUeXxOtcPrRcR
	gYd7tEpSqRET554+IRCWJLcZiAm3g==
X-ME-Sender: <xms:384zXrtB6FVk4XR6tDllJEfHkNeAuILY-TgyD1XabzkYj4EgD8cbrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeelgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdduhedmnecujfgurhepkffuhffvffgjfhgtfggggfesthekredttder
    jeenucfhrhhomheptfhushhsvghllhcuvehurhhrvgihuceorhhushgtuhhrsehruhhssh
    gvlhhlrdgttgeqnecuffhomhgrihhnpehoiihlrggsshdrohhrghenucfkphepuddvvddr
    leelrdekvddruddtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomheprhhushgtuhhrsehruhhsshgvlhhlrdgttg
X-ME-Proxy: <xmx:384zXrUlxgQqC9ICJ43oOpsEyI91u7WM6w9FkPnVlVU1xwcw7uAfJg>
    <xmx:384zXvI3kay4eHerKcbi84FZlTABlOHENxFxZ3GWgeKkZ_piQOvYbg>
    <xmx:384zXvNGdYwgFVHIqecB5b3VfI2jaVAXmh5bNmoMgvlQXQwl682hHw>
    <xmx:4M4zXjwODNLVTRcKnDcaIJS-cKYgUuC6EBHlQfgpbo3gkniM8aiF9A>
Message-ID: <0b016861756cbe27e66651b5c21229a06558cb57.camel@russell.cc>
Subject: Re: [PATCH] lkdtm: Test KUAP directional user access unlocks on
 powerpc
From: Russell Currey <ruscur@russell.cc>
To: Christophe Leroy <christophe.leroy@c-s.fr>, keescook@chromium.org, 
	mpe@ellerman.id.au
Cc: linux-kernel@vger.kernel.org, dja@axtens.net, 
	kernel-hardening@lists.openwall.com, linuxppc-dev@lists.ozlabs.org
Date: Fri, 31 Jan 2020 17:53:14 +1100
In-Reply-To: <1b40cea6-0675-731a-58b1-bdc65f1e495e@c-s.fr>
References: <20200131053157.22463-1-ruscur@russell.cc>
	 <1b40cea6-0675-731a-58b1-bdc65f1e495e@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 2020-01-31 at 07:44 +0100, Christophe Leroy wrote:
> 
> Le 31/01/2020 à 06:31, Russell Currey a écrit :
> > Kernel Userspace Access Prevention (KUAP) on powerpc supports
> > allowing only one access direction (Read or Write) when allowing
> > access
> > to or from user memory.
> > 
> > A bug was recently found that showed that these one-way unlocks
> > never
> > worked, and allowing Read *or* Write would actually unlock Read
> > *and*
> > Write.  We should have a test case for this so we can make sure
> > this
> > doesn't happen again.
> > 
> > Like ACCESS_USERSPACE, the correct result is for the test to fault.
> > 
> > At the time of writing this, the upstream kernel still has this bug
> > present, so the test will allow both accesses whereas
> > ACCESS_USERSPACE
> > will correctly fault.
> > 
> > Signed-off-by: Russell Currey <ruscur@russell.cc>
> > ---
> >   drivers/misc/lkdtm/core.c  |  3 +++
> >   drivers/misc/lkdtm/lkdtm.h |  3 +++
> >   drivers/misc/lkdtm/perms.c | 43
> > ++++++++++++++++++++++++++++++++++++++
> >   3 files changed, 49 insertions(+)
> > 
> > diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
> > index ee0d6e721441..baef3c6f48d6 100644
> > --- a/drivers/misc/lkdtm/core.c
> > +++ b/drivers/misc/lkdtm/core.c
> > @@ -137,6 +137,9 @@ static const struct crashtype crashtypes[] = {
> >   	CRASHTYPE(EXEC_USERSPACE),
> >   	CRASHTYPE(EXEC_NULL),
> >   	CRASHTYPE(ACCESS_USERSPACE),
> > +#ifdef CONFIG_PPC_KUAP
> > +	CRASHTYPE(ACCESS_USERSPACE_KUAP),
> > +#endif
> 
> I'm not sure it is a good idea to build this test as a specific test
> for 
> powerpc, more comments below.
> 
> >   	CRASHTYPE(ACCESS_NULL),
> >   	CRASHTYPE(WRITE_RO),
> >   	CRASHTYPE(WRITE_RO_AFTER_INIT),
> > diff --git a/drivers/misc/lkdtm/lkdtm.h
> > b/drivers/misc/lkdtm/lkdtm.h
> > index c56d23e37643..406a3fb32e6f 100644
> > --- a/drivers/misc/lkdtm/lkdtm.h
> > +++ b/drivers/misc/lkdtm/lkdtm.h
> > @@ -57,6 +57,9 @@ void lkdtm_EXEC_RODATA(void);
> >   void lkdtm_EXEC_USERSPACE(void);
> >   void lkdtm_EXEC_NULL(void);
> >   void lkdtm_ACCESS_USERSPACE(void);
> > +#ifdef CONFIG_PPC_KUAP
> > +void lkdtm_ACCESS_USERSPACE_KUAP(void);
> > +#endif
> >   void lkdtm_ACCESS_NULL(void);
> >   
> >   /* lkdtm_refcount.c */
> > diff --git a/drivers/misc/lkdtm/perms.c
> > b/drivers/misc/lkdtm/perms.c
> > index 62f76d506f04..2c9aa0114333 100644
> > --- a/drivers/misc/lkdtm/perms.c
> > +++ b/drivers/misc/lkdtm/perms.c
> > @@ -10,6 +10,9 @@
> >   #include <linux/mman.h>
> >   #include <linux/uaccess.h>
> >   #include <asm/cacheflush.h>
> > +#ifdef CONFIG_PPC_KUAP
> > +#include <asm/uaccess.h>
> > +#endif
> 
> asm/uaccess.h is already included by linux/uaccess.h

I should have actually read the other includes rather than assuming I
needed this, pretty silly

> 
> >   
> >   /* Whether or not to fill the target memory area with
> > do_nothing(). */
> >   #define CODE_WRITE	true
> > @@ -200,6 +203,46 @@ void lkdtm_ACCESS_USERSPACE(void)
> >   	vm_munmap(user_addr, PAGE_SIZE);
> >   }
> >   
> > +/* Test that KUAP's directional user access unlocks work as
> > intended */
> > +#ifdef CONFIG_PPC_KUAP
> > +void lkdtm_ACCESS_USERSPACE_KUAP(void)
> > +{
> > +	unsigned long user_addr, tmp = 0;
> > +	unsigned long *ptr;
> 
> Should be a __user ptr because allow_write_to_user() and friends
> takes 
> __user pointers.
> 
> > +
> > +	user_addr = vm_mmap(NULL, 0, PAGE_SIZE,
> > +			    PROT_READ | PROT_WRITE | PROT_EXEC,
> > +			    MAP_ANONYMOUS | MAP_PRIVATE, 0);
> > +	if (user_addr >= TASK_SIZE) {
> 
> Should use IS_ERR_VALUE() here.
> 
> > +		pr_warn("Failed to allocate user memory\n");
> > +		return;
> > +	}
> > +
> > +	if (copy_to_user((void __user *)user_addr, &tmp, sizeof(tmp)))
> > {
> 
> Should use ptr instead of casted user_addr.
> 
> Why using copy_to_user() for writing an unsigned long ? put_user() 
> should be enough.
> 
> > +		pr_warn("copy_to_user failed\n");
> > +		vm_munmap(user_addr, PAGE_SIZE);
> > +		return;
> > +	}
> > +
> > +	ptr = (unsigned long *)user_addr;
> 
> move before copy_to_user() and use there.

All of the above is from the original ACCESS_USERSPACE test, not to
imply that it's perfect, but I'm not sure it's worth changing in one
place only

> 
> > +
> > +	/* Allowing "write to" should not allow "read from" */
> > +	allow_write_to_user(ptr, sizeof(unsigned long));
> 
> This is powerpc specific. I think we should build this around the 
> user_access_begin()/user_access_end() generic fonctions.
> 
> I'm about to propose an enhancement to this in order to allow
> unlocking 
> only read or write. See discussion at 
> https://patchwork.ozlabs.org/patch/1227926/.
> 
> My plan is to propose my enhancement once powerpc implementation of 
> user_access_begin stuff is merged. I don't know if Michael is still 
> planning to merge the series for 5.6 
> (https://patchwork.ozlabs.org/patch/1228801/ - patch 1 of the series
> has 
> already been merged by Linus in 5.5)

You're correct, making generic user_access_begin() calls aware of
direction solves the arch-specific problem, so unless your series
somehow ends up being unviable (or taking a very long time to get
merged) we can drop this idea and have a generic implementation
instead.

> 
> 
> > +	pr_info("attempting bad read at %px with write allowed\n",
> > ptr);
> > +	tmp = *ptr;
> > +	tmp += 0xc0dec0de;
> > +	prevent_write_to_user(ptr, sizeof(unsigned long));
> 
> Does it work ? I would have thought that if the read fails the
> process 
> will die and the following test won't be performed.

Correct, the ACCESS_USERSPACE test does the same thing.  Splitting this
into separate R and W tests makes sense, even if it is unlikely that
one would be broken without the other.

- Russell

> 
> > +
> > +	/* Allowing "read from" should not allow "write to" */
> > +	allow_read_from_user(ptr, sizeof(unsigned long));
> > +	pr_info("attempting bad write at %px with read allowed\n",
> > ptr);
> > +	*ptr = tmp;
> > +	prevent_read_from_user(ptr, sizeof(unsigned long));
> > +
> > +	vm_munmap(user_addr, PAGE_SIZE);
> > +}
> > +#endif
> > +
> >   void lkdtm_ACCESS_NULL(void)
> >   {
> >   	unsigned long tmp;
> > 
> 
> Christophe

