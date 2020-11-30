Return-Path: <SRS0=/lGi=FE=lists.openwall.com=kernel-hardening-return-20467-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DBEC64E8A
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Nov 2020 11:52:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3BE8120825
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Nov 2020 11:52:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MnNpDy1I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BE8120825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20467-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32627 invoked by uid 550); 30 Nov 2020 11:52:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32607 invoked from network); 30 Nov 2020 11:52:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1606737148;
	bh=ZiZagQtRbUz77A0qHJ/6d4tgOyHKNO+y3elnQs2W+xw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MnNpDy1IneXFXP/lQupOBnMLxBRe5aJE3S3AeMbB5b0qt3ZR65WOmJaShZf3bd0Xx
	 wt8jX8yj5HEw/l01qC8cRnrqIuZ7ah7LMJfsVUDMV4xuXzrh4/7bKTGlnvKmeAcGnj
	 WiTprgJ8Vio2K37i3mmw4xbiu/TLHBswxaM7XYfk=
Date: Mon, 30 Nov 2020 11:52:22 +0000
From: Will Deacon <will@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v7 14/17] arm64: vdso: disable LTO
Message-ID: <20201130115222.GC24563@willie-the-truck>
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201118220731.925424-15-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118220731.925424-15-samitolvanen@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Nov 18, 2020 at 02:07:28PM -0800, Sami Tolvanen wrote:
> Disable LTO for the vDSO by filtering out CC_FLAGS_LTO, as there's no
> point in using link-time optimization for the small about of C code.

"about" => "amount" ?

> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm64/kernel/vdso/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

With the typo fixed:

Acked-by: Will Deacon <will@kernel.org>

Will
