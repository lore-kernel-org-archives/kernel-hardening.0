Return-Path: <SRS0=0AWW=CK=lists.openwall.com=kernel-hardening-return-19716-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA991C433E2
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Sep 2020 04:25:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F14132087D
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Sep 2020 04:25:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tobin.cc header.i=@tobin.cc header.b="jI5K8x8N";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rIJtKYPL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F14132087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=tobin.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19716-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29992 invoked by uid 550); 1 Sep 2020 04:25:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29948 invoked from network); 1 Sep 2020 04:25:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tobin.cc; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=fm1; bh=i1CaXqatYxST7OBQcDDUEW58eAn
	uK/6c6XXGkd4pEJA=; b=jI5K8x8NUS4K7J2dQwNO6c+oXdyD/1Qh0X3fdjn7/Y2
	8jWhwAAeHgWu+2VDBM3FkY8Ezk58qtYuJ5JNhEpovWU2qA5mZRZfGO2Hz4o4ZENj
	ntmQiYN+ibrQd4oXcki+Uyy6ZJz9idRvNPlp3J5YnTRp+MI1TpP6zihNg+zb6osN
	O0huRqCEX/jdjKMBn/q+ZdQEC5HzgjmI1ZXQJY6OosFNZIw9Ibk+VJki0/op8de9
	O9iEu1lKEgKj/swXWEm0Am+vGX0rxaDwKcYmwY/OeL8ro5F8gcCGTj9l230WYHFi
	p8LVPvPF+RlJnVBi+tIyt/l0VVFeOAsrPEn2M9Nf5aA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=i1CaXq
	atYxST7OBQcDDUEW58eAnuK/6c6XXGkd4pEJA=; b=rIJtKYPLY2g/ycsvSiVBxu
	bVN5aGhoLbM5/pj0B8aFXje//kMBYOwuVzKkkWW10uAEiFRRey7PsgBn60ti3Kd1
	raKTcIwP85RG7tBqgvcA46aa8LFnubeOo/yGkoJtT8EgTruwZ5e4FtUAa4S/Sjd3
	9ZUkhZkts5fLET+8Y00Y1+Z35hG3GaOAshuZOm9FZ6kdk3DGjRJfQWw5ECzbGMhI
	CyP54T/xiSTLYtPWlpVZPyPFahqLvTf5djZIFulfSGwNskYZmpo0JnougQlxVlr1
	24wGjrRSbCpDBVIz0VXznInBbops7nDbRNLlNqN0sYZuTFWbLMw2Oemu/8KnZ90A
	==
X-ME-Sender: <xms:Fs1NXwkAdylgcZMy5AHFUEcIH9odvD6aMqAwp4ZxrBQLce-NBquVFg>
    <xme:Fs1NX_019a-SGsmfTQrAAqy32pMGn4wGgR2Js-JTt_7w01Y-BZMsQtvTMHox1jXFX
    qydbf7EgflK5HHCEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefiedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdludegmdenucfjughrpeffhffvuffkfhggtggujgfofgesthdtredt
    ofervdenucfhrhhomhepfdfvohgsihhnucevrdcujfgrrhguihhnghdfuceomhgvsehtoh
    gsihhnrdgttgeqnecuggftrfgrthhtvghrnhepueeiieejueeuhfffuedtfefgieehgeel
    keelleeuuedtgeeuveegtddtffeijeeinecuffhomhgrihhnpehkvghrnhgvlhdrohhrgh
    enucfkphepuddtiedrieelrdduudelrddujeeinecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepmhgvsehtohgsihhnrdgttg
X-ME-Proxy: <xmx:Fs1NX-qihVwq6Ho-mGRvTbp_qlhra0USdftBrTzqw8TZffomlzZL_w>
    <xmx:Fs1NX8kF4NUZMXwQjoTmunWQKTSriJzFEKZikG6GB1zD8S5KgP-1Dg>
    <xmx:Fs1NX-3QJDUdPvscxernT1FzUHv77_hY14sAaE-scXAVTZBKflE7NA>
    <xmx:F81NXzxxiQeXcW1L3GuxJevtR5QZw3YHygA4G_QPH7wnTzNqZZfkXg>
Date: Tue, 1 Sep 2020 14:24:50 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>,
	kernel-hardening@lists.openwall.com,
	Mrinal Pandey <mrinalmni@gmail.com>,
	Tycho Andersen <tycho@tycho.pizza>
Subject: Re: [PATCH] scripts: Add intended executable mode and SPDX license
Message-ID: <20200901042450.GA780@ares>
References: <20200827092405.b6hymjxufn2nvgml@mrinalpandey>
 <20200827130653.GA25408@openwall.com>
 <202008271056.8B4B59C9@keescook>
 <20200901001519.GA567924@cisco>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901001519.GA567924@cisco>
X-Mailer: Mutt 1.9.4 (2018-02-28)
User-Agent: Mutt/1.9.4 (2018-02-28)

On Mon, Aug 31, 2020 at 06:15:19PM -0600, Tycho Andersen wrote:
> On Thu, Aug 27, 2020 at 11:02:00AM -0700, Kees Cook wrote:
> > On Thu, Aug 27, 2020 at 03:06:53PM +0200, Solar Designer wrote:
> > > On Thu, Aug 27, 2020 at 02:54:05PM +0530, Mrinal Pandey wrote:
> > > >  mode change 100644 => 100755 scripts/gcc-plugins/gen-random-seed.sh
> > > 
> > > This is basically the only change relevant to the contribution initially
> > > made via kernel-hardening, and in my opinion (and I am list admin) isn't
> > > worth bringing to the list.  Now we have this bikeshed thread in here
> > > (and I'm guilty for adding to it), and would have more (which I hope
> > > this message of mine will prevent) if changes to something else in the
> > > patch(es) are requested (which Greg KH sort of already did).
> > > 
> > > I recall we previously had lots of "similar" bikeshedding in here when
> > > someone was converting the documentation to rST.  The more bikeshedding
> > > we have, the less actual kernel-hardening work is going to happen,
> > > because the list gets the reputation of yet another kernel maintenance
> > > list rather than the place where actual/potential new contributions to
> > > improve the kernel's security are discussed, and because bikeshedding
> > > makes the most capable people unsubscribe or stop paying attention.
> > > 
> > > How about we remove kernel-hardening from the MAINTAINERS entries it's
> > > currently in? -
> > > 
> > > GCC PLUGINS
> > > M:      Kees Cook <keescook@chromium.org>
> > > R:      Emese Revfy <re.emese@gmail.com>
> > > L:      kernel-hardening@lists.openwall.com
> > > S:      Maintained
> > > F:      Documentation/kbuild/gcc-plugins.rst
> > > F:      scripts/Makefile.gcc-plugins
> > > F:      scripts/gcc-plugin.sh
> > > F:      scripts/gcc-plugins/
> > > 
> > > LEAKING_ADDRESSES
> > > M:      Tobin C. Harding <me@tobin.cc>
> > > M:      Tycho Andersen <tycho@tycho.ws>
> > > L:      kernel-hardening@lists.openwall.com
> > > S:      Maintained
> > > T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git
> > > F:      scripts/leaking_addresses.pl
> > > 
> > > Alternatively, would this be acceptable? -
> > > 
> > > L:      kernel-hardening@lists.openwall.com (only for messages focused on core functionality, not for maintenance detail)
> > > 
> > > I think the latter would be best, if allowed.
> > > 
> > > Kees, please comment (so that we'd hopefully not need that next time),
> > > and if you agree please make a change to MAINTAINERS.
> > 
> > A comment isn't going to really help fix this (much of the CCing is done
> > by scripts, etc).
> > 
> > I've tended to prefer more emails than missing discussions, and I think
> > it's not unreasonable to have the list mentioned in MAINTAINERS for
> > those things. It does, of course, mean that "maintenance" patches get
> > directed there too, as you say.
> > 
> > If it's really something you'd like to avoid, I can drop those
> > references. My instinct is to leave it as-is, but the strength of my
> > opinion is pretty small. Let me know what you prefer...
> 
> One thing about leaking_addresses.pl is that I'm not sure anyone is
> actively using it at this point. I told Tobin I'd help review stuff,
> but I don't even have a GPG key with enough signatures to send PRs.
> I'm slowly working on figuring that out, but in the meantime I wonder
> if we couldn't move it into some self test somehow, so that at least
> nobody adds new leaks? Does that seem worth doing?
> 
> It would then probably go away as a separate perl script and live
> under selftests, which could mean we could drop the reference to the
> list. But that's me making it someone else's problem then, kind of :)
> 
> Also, I'm switching my e-mail address to tycho@tycho.pizza, so future
> replies will be from there.

I don't mind if the reference to kernel-hardening is removed, if in
the event that someone sends a patch that needs input from the kernel
hardening community we can always mail the list.

Thanks,
Tobin
