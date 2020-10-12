Return-Path: <SRS0=V0Xu=DT=lists.openwall.com=kernel-hardening-return-20171-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F47C433E7
	for <kernel-hardening@archiver.kernel.org>; Mon, 12 Oct 2020 20:51:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A191420BED
	for <kernel-hardening@archiver.kernel.org>; Mon, 12 Oct 2020 20:51:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUA4p24m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A191420BED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20171-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1259 invoked by uid 550); 12 Oct 2020 20:51:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1210 invoked from network); 12 Oct 2020 20:51:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602535875;
	bh=0GkuUU3uNC/spWLd0lGLXk3f0NEQnPHerA+y4i0HfIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aUA4p24mfdDVp8gVMcJs3cg4QcRdzKI2RfnmgjjYH0yIvLOULOXyZL1YYb40RXCIL
	 0j4QZMJA0d4Jf96ySlvQCMNewtFUSD3KgMkUuWXetoBRKiLSWzbvYrWq0FC+1nMHyw
	 66F2X0FbdKKOd7lh9w7SiCHjg714ONHZLITlgfQo=
Date: Mon, 12 Oct 2020 21:51:09 +0100
From: Will Deacon <will@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v5 25/29] arm64: allow LTO_CLANG and THINLTO to be
 selected
Message-ID: <20201012205108.GA1620@willie-the-truck>
References: <20201009161338.657380-1-samitolvanen@google.com>
 <20201009161338.657380-26-samitolvanen@google.com>
 <20201012083116.GA785@willie-the-truck>
 <202010121344.53780D8CD2@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202010121344.53780D8CD2@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Oct 12, 2020 at 01:44:56PM -0700, Kees Cook wrote:
> On Mon, Oct 12, 2020 at 09:31:16AM +0100, Will Deacon wrote:
> > On Fri, Oct 09, 2020 at 09:13:34AM -0700, Sami Tolvanen wrote:
> > > Allow CONFIG_LTO_CLANG and CONFIG_THINLTO to be enabled.
> > > 
> > > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > > Reviewed-by: Kees Cook <keescook@chromium.org>
> > > ---
> > >  arch/arm64/Kconfig | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > > index ad522b021f35..7016d193864f 100644
> > > --- a/arch/arm64/Kconfig
> > > +++ b/arch/arm64/Kconfig
> > > @@ -72,6 +72,8 @@ config ARM64
> > >  	select ARCH_USE_SYM_ANNOTATIONS
> > >  	select ARCH_SUPPORTS_MEMORY_FAILURE
> > >  	select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
> > > +	select ARCH_SUPPORTS_LTO_CLANG
> > > +	select ARCH_SUPPORTS_THINLTO
> > 
> > Please don't enable this for arm64 until we have the dependency stuff sorted
> > out. I posted patches [1] for this before, but I think they should be part
> > of this series as they don't make sense on their own.
> 
> Oh, hm. We've been trying to trim down this series, since it's already
> quite large. Why can't [1] land first? It would make this easier to deal
> with, IMO.

I'm happy to handle [1] along with the LTO Kconfig change when the time
comes, if that helps. I just don't want to merge dead code!

Will

> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=rwonce/read-barrier-depends
