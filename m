Return-Path: <SRS0=orZ1=DV=lists.openwall.com=kernel-hardening-return-20202-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6A8C43467
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 18:21:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CDAEF2224D
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 18:21:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="icPeuHkh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDAEF2224D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20202-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32380 invoked by uid 550); 14 Oct 2020 18:21:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32357 invoked from network); 14 Oct 2020 18:21:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4D+6T/0Jyivj7fxKw3DZP3bEv4Hi+6DaIRYNjOGogQc=; b=icPeuHkhwm/7g2D5K7SjNoPM5s
	al/it2gTFcFnA3j1b1bbGIvp9LTWyagOXzUN5jvmI0GDPi6ml4eD0d52R2OwRtyKSvCS+k4demdSu
	VT5KGDheTz5gEsE3WBJE9K02m+nLco4ZktkKbpuxeQdHPW3/i9FtrGhn6R3XCDKJQd/onhJsK73W4
	LKhukfnTNYT9ZUzSX6bJ/yNVJYi9sFnQkAK2Ap4gEoxUpX3920FOVTde0jJ7FAsLgwsBb9awOT8wF
	J2wNgf1SGp7lO6tY4adBbux1qDforNMyg6G3iWIsLIfBozBc0lW3wPEQ/gxl/dF/llRv6F8wwIxxm
	oZgiXiXg==;
Date: Wed, 14 Oct 2020 20:21:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v6 02/25] objtool: Add a pass for generating __mcount_loc
Message-ID: <20201014182115.GF2594@hirez.programming.kicks-ass.net>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-3-samitolvanen@google.com>
 <20201014165004.GA3593121@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014165004.GA3593121@gmail.com>

On Wed, Oct 14, 2020 at 06:50:04PM +0200, Ingo Molnar wrote:
> Meh, adding --mcount as an option to 'objtool check' was a valid hack for a 
> prototype patchset, but please turn this into a proper subcommand, just 
> like 'objtool orc' is.
> 
> 'objtool check' should ... keep checking. :-)

No, no subcommands. orc being a subcommand was a mistake.
