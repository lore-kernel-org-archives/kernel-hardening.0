Return-Path: <SRS0=iVYp=AI=lists.openwall.com=kernel-hardening-return-19185-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1831C433DF
	for <kernel-hardening@archiver.kernel.org>; Sat, 27 Jun 2020 20:10:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 262FE20707
	for <kernel-hardening@archiver.kernel.org>; Sat, 27 Jun 2020 20:10:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Hijh+mws"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 262FE20707
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19185-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23618 invoked by uid 550); 27 Jun 2020 20:10:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23598 invoked from network); 27 Jun 2020 20:10:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1593288581;
	bh=0xRFBPnhnaPrlHc1tRYH+09EADTZE+3Mw2WcK+6MPMA=;
	h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
	b=Hijh+mwszlEaeRAwzlRJz3k+6Zcgg+7Z2pgdvcjD8nqCqpSbSnjnlsfVp4+jkoRx1
	 6G5Iokt/9kjDqfodRAjdTwActu90pnedpp7A0kmiVZBtz37r5IkNu5syvVeuf/Wz2B
	 GXQpwxVeHflbGTReLVAg3w/Yz+ZnBFwCbM5Uu+sg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Subject: Re: [PATCH] parisc/kernel/ftrace: Remove function callback casts
To: Oscar Carter <oscar.carter@gmx.com>, Kees Cook <keescook@chromium.org>,
 Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: kernel-hardening@lists.openwall.com, linux-parisc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20200627134348.30601-1-oscar.carter@gmx.com>
From: Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
 c2TFWAS8k6RLkk41ZUU8ENX8+qZx/Q==
Message-ID: <97375269-f6f1-6157-c8a8-3b925232f00c@gmx.de>
Date: Sat, 27 Jun 2020 22:09:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200627134348.30601-1-oscar.carter@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ijfqLiA+RCGLQiCBZppckhhgNlNUWEsBwLIIegBt/vFVeox2CJL
 6v1lNvnCaxVKABnlNGkZFB+o6xaDKeSnC76HrYrxX4pzgVUJBa3FJCKAg09EnkGNy7tWlhd
 3NXe4tjcwgCrC20XGpW0Ysnqpm9x50nC36MlfY3IsDJXMBRraZ2m1wwnnyE16+WoPJevcOe
 w7ciIRlz9UoEGjh9U2F5Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gW/zsCM3uFA=:E+UYYiBJkNhlFVVyunILvs
 vBOAaQZ1vErTvEJDPymkL0EEHZ1JrxZc2XBn07oTWvolQZe3M9dJeupeybT06FJBvzavGFT7w
 DRNdDWnRtLXX/eNTi8+Z9g3vvS8ZRdScAPT5WEdT1h6MhPzmRwJcz8lvIpOpg3iycPTs/6UZb
 tOodBD4nQgXOAIW+Q93O9+SBtHXqYd3HU1pDcHSWsxrnKqRps01e6TTNaI+frHuLyDfaNZvHh
 x44fmPYYgBoSbjmKNvFXoyrpY2fvqL5UA8C7NBdqVMP4Pvg70wjMdt+4jXyQ0QGwTRiVk4BIU
 YDvtqC/FBeosQhKXuo40dlokdORSMkc06hbeWLsjaqqjeXLez4ibdYa4XREgLrbfOt3TmzRFs
 MEFdlnDFK/V6fTG4txTyu+22JODHuxCOGcFnuushhwczory54IcTjuIPYIxTixky0P49JQHZj
 c58AMa2stWqj5aIoUdSHhQF0DyRNc4WoUOb5S1e+/WtZj63wy2XHlkM4ZAvB9zLhM6+8UP9iN
 QezZvSZBjaXMJrSCtv1hC6JAsiIUQKU7KpjCGpnRlvX9J/Ogyr4XmuqH+1cQmMvyDrIoEUnla
 gT03Ilsd//laH4f49LgM17MJN1oArJZBigEhu+Q7cJmrgarL3UBBx4AlHVOa5olfBZ76MOh+q
 ORKrdekZ7FHs6fDim0gQhuMkz5+Hv6MWFTti4D9kqyDOrW28cYIjMWpgRVJPEDWBCBD+OynDS
 N/HcR/WbMSQxZiECoFOJZgwJUm8+2htVmbv18addLsJmSw6PzRnZA0Ygshjgt1TrNwEGqnfCp
 cpJ1Iy1wltLRMT6IluRaeko9fsftIAkrNpbUZZoraamOpU/I2YQyGxk+HiWpLYs76GBujBNUe
 XiaGRFQTXdKKG6piFCzA31OtZa8odI3pmavXKeJhVqLx0y3niMb2aw8e7jzmoMJq6VXg9QOdB
 XGXD9bn8q1Og1B4h97mFPzzP94dVuod47thTTlXeIgRjP2KTZHaDNXRokn+J3j1TZeK/rJ3e0
 jyOf/3S8kdRu7KVgqoIFsum43lcb8U1JoTPXBjF7Mxzy8H4NxgmrA5Be+X2SgbF0fopxoY6ch
 Dnlvqf8zTq5ekUKUPMmV1g2JXAs3N5fgBdTAJA2P1+uJ8JRfXkVe2sc2ZvWc7C9R1eLUQ72X/
 Z0QQ3v69axpGKCvsQ40Sw1VXsnWXsEE9trWIqm1YeM8gXhijI28isQVdj8TvbJuFrYLdlWWfK
 y13CG6itfPwPygxsk

On 27.06.20 15:43, Oscar Carter wrote:
> In an effort to enable -Wcast-function-type in the top-level Makefile to
> support Control Flow Integrity builds, remove all the function callback
> casts.
>
> To do this remove the cast to a function pointer type in the comparison
> statement and add to the right and left operand a cast to unsigned long
> type. This can be done since the comparison is against function address
> (these operands are not function calls).

On some architectures (namely ia64, ppc64 and parisc64) function pointers
actually refer to function descriptors, which in turn point to the real
function address. The compiler usually takes care of such comparism.
That said, casting to "unsigned long" might break this...

> Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
> ---
>  arch/parisc/kernel/ftrace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/parisc/kernel/ftrace.c b/arch/parisc/kernel/ftrace.c
> index 1df0f67ed667..86b49a5fc049 100644
> --- a/arch/parisc/kernel/ftrace.c
> +++ b/arch/parisc/kernel/ftrace.c
> @@ -64,7 +64,7 @@ void notrace __hot ftrace_function_trampoline(unsigned=
 long parent,
>  				function_trace_op, regs);
>
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> -	if (ftrace_graph_return !=3D (trace_func_graph_ret_t) ftrace_stub ||
> +	if ((unsigned long)ftrace_graph_return !=3D (unsigned long)ftrace_stub=
 ||

Untested, but maybe better use:
	dereference_function_descriptor(ftrace_graph_return) !=3D
		dereference_function_descriptor(ftrace_stub)

?
Helge
