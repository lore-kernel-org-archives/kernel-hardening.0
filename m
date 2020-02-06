Return-Path: <SRS0=kpIO=32=lists.openwall.com=kernel-hardening-return-17693-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B17C2D0B1
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 10:31:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 64198206CC
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 10:31:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O9XIG10R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64198206CC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17693-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31969 invoked by uid 550); 6 Feb 2020 10:31:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31946 invoked from network); 6 Feb 2020 10:31:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=doRr41+uHYQPX4/to1I/1srPnHzm/CaLlIXj8w9Vubs=; b=O9XIG10RJTp9t1KXQg2NFLAhGf
	+gipjAzct3zUGo4Hyf9EXunyT5NgIUBfSiRIcZJt8HPofZwC8xQet/QxB0qiVlRipsJYmF1Nvm96k
	cQZQmF1xIcEPKZcvzf3CkUzkhwNWRV1SpwSsdISIhizHw7pz61xKYs7HxGgghNYyVtkQlt3f+9JHG
	Fb4dZblXX3+XwHvlmeJoP0sm0Wl0Plbx9z2G5OZtxM9AMBT1WU/sZkZRALvH9fpuNj8TrigZBSNH9
	Z+M8+QiUbaQzhsyC0BtstPUOnyUpGp7GvoV7zWtNYZ4i11n9mcGWZHr300AVj0uwgpw+hRo2dvhJx
	FJXyLhTw==;
Date: Thu, 6 Feb 2020 11:30:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, keescook@chromium.org,
	rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 05/11] x86: Makefile: Add build and config option for
 CONFIG_FG_KASLR
Message-ID: <20200206103055.GV14879@hirez.programming.kicks-ass.net>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-6-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200205223950.1212394-6-kristen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Feb 05, 2020 at 02:39:44PM -0800, Kristen Carlson Accardi wrote:
> Allow user to select CONFIG_FG_KASLR if dependencies are met. Change
> the make file to build with -ffunction-sections if CONFIG_FG_KASLR
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
>  Makefile         |  4 ++++
>  arch/x86/Kconfig | 13 +++++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index c50ef91f6136..41438a921666 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -846,6 +846,10 @@ ifdef CONFIG_LIVEPATCH
>  KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
>  endif
>  
> +ifdef CONFIG_FG_KASLR
> +KBUILD_CFLAGS += -ffunction-sections
> +endif

The GCC manual has:

  -ffunction-sections
  -fdata-sections

      Place each function or data item into its own section in the output
      file if the target supports arbitrary sections. The name of the
      function or the name of the data item determines the section’s name
      in the output file.

      Use these options on systems where the linker can perform
      optimizations to improve locality of reference in the instruction
      space. Most systems using the ELF object format have linkers with
      such optimizations. On AIX, the linker rearranges sections (CSECTs)
      based on the call graph. The performance impact varies.

      Together with a linker garbage collection (linker --gc-sections
      option) these options may lead to smaller statically-linked
      executables (after stripping).

      On ELF/DWARF systems these options do not degenerate the quality of
      the debug information. There could be issues with other object
      files/debug info formats.

      Only use these options when there are significant benefits from
      doing so. When you specify these options, the assembler and linker
      create larger object and executable files and are also slower. These
      options affect code generation. They prevent optimizations by the
      compiler and assembler using relative locations inside a translation
      unit since the locations are unknown until link time. An example of
      such an optimization is relaxing calls to short call instructions.

In particular:

  "They prevent optimizations by the compiler and assembler using
  relative locations inside a translation unit since the locations are
  unknown until link time."

I suppose in practise this only means tail-calls are affected and will
no longer use JMP.d8. Or are more things affected?

(Also, should not the next patch come before this one?)
