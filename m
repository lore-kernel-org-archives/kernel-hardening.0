Return-Path: <SRS0=2zIL=YO=lists.openwall.com=kernel-hardening-return-17070-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C099FCA9EB5
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 06:19:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 112E921479
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 06:19:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WOzYqE+L"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 112E921479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17070-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31761 invoked by uid 550); 21 Oct 2019 06:19:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30719 invoked from network); 21 Oct 2019 06:19:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iMdLEV+CTaW2gmBLhEBpHxDKc063E21l+ayq5nzIrFw=;
        b=WOzYqE+LWe+E/HVhSozCNdcMsHavUK6DUIItAaXEkClsKdQaQfB42QALzHNS2WWwYS
         7/nd0om4bK/hNaghrCrAxwLmdR73Z4tXnnuwroc0+54D/uEAdDUy0U3x7XFfcuNcacaM
         G2t2PVl0OEsWAs+ON0q7SJAm80g0Gockqb5V9TwDq9CgrsLxWwFINCmx8t7mDomvn163
         au+GtLS99ib8TAWDJ1J+jgd/h16JcLxkcT/O5E+tFPIrOxgasAcAQUkydYejvXgehJGR
         CJoWn+myZwethBoe0UOOL2ixvKeT7IQpefZS3Izts0s0MnBwR25h089ZPQbW0zpPnsFy
         R5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iMdLEV+CTaW2gmBLhEBpHxDKc063E21l+ayq5nzIrFw=;
        b=abjldrjuZeHFi3NNdVrmmgwmVAgcDa+eWGVCCUDgQydC/Zqc6VDH/VM5cSSzJjemZj
         e8o4MzUV6dXFARsEW+I/p7y7DcVmwBEQGd8e4wIpE45QrdOBrnvK0O0Rw9UAw4ArkFlL
         aQ1hdLY2kEi77cui9zDXTpIX+J8+SysXnowT98/kL26Que3PeAFNuUc1rb569bALsvHp
         +vWUJ0AVoyi72cEWZO3yoACcRPchIjovcKYz/KDScKlPnk6bTwF0k+ZvGjPh2oXafuJ7
         /8M5Bo3s0gqroINenV/qYHlV57ezAIWBCyAkphvNo9GH0+CA4tjrBBsOET/grBtJfmsF
         gFYA==
X-Gm-Message-State: APjAAAUcT7RVLzwrprCb0XOTHkDUHfSAzitZ3tlw08HZeE7hM5em1Xq6
	wkuGN9Tl8ECwdZigH4R7NbrIYYrD65D1N/UO01QSeA==
X-Google-Smtp-Source: APXvYqwtVZTOqZaaU9Te8Vy1PYbGo0mpgYTxtO/oPglrkIr329wlVgskZ9sxWEpAm2PexwLH+zbd9/RN3RL88+vlV/U=
X-Received: by 2002:a1c:64d6:: with SMTP id y205mr1400556wmb.136.1571638773936;
 Sun, 20 Oct 2019 23:19:33 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191018161033.261971-4-samitolvanen@google.com>
In-Reply-To: <20191018161033.261971-4-samitolvanen@google.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 21 Oct 2019 08:19:23 +0200
Message-ID: <CAKv+Gu9u-yO1SRTaT4TfdtckmPT0+JnHR6R=RPYRGfm9AACvCw@mail.gmail.com>
Subject: Re: [PATCH 03/18] arm64: kvm: stop treating register x18 as caller save
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 18 Oct 2019 at 18:10, Sami Tolvanen <samitolvanen@google.com> wrote:
>
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> In preparation of using x18 as a task struct pointer register when
> running in the kernel, stop treating it as caller save in the KVM
> guest entry/exit code. Currently, the code assumes there is no need
> to preserve it for the host, given that it would have been assumed
> clobbered anyway by the function call to __guest_enter(). Instead,
> preserve its value and restore it upon return.
>
> Link: https://patchwork.kernel.org/patch/9836891/
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

You might want to update the commit log to drop the reference to the
task struct pointer.

> ---
>  arch/arm64/kvm/hyp/entry.S | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index e5cc8d66bf53..20bd9a20ea27 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -23,6 +23,7 @@
>         .pushsection    .hyp.text, "ax"
>
>  .macro save_callee_saved_regs ctxt
> +       str     x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
>         stp     x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
>         stp     x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
>         stp     x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
> @@ -38,6 +39,7 @@
>         ldp     x25, x26, [\ctxt, #CPU_XREG_OFFSET(25)]
>         ldp     x27, x28, [\ctxt, #CPU_XREG_OFFSET(27)]
>         ldp     x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
> +       ldr     x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
>  .endm
>
>  /*
> @@ -87,12 +89,9 @@ alternative_else_nop_endif
>         ldp     x14, x15, [x18, #CPU_XREG_OFFSET(14)]
>         ldp     x16, x17, [x18, #CPU_XREG_OFFSET(16)]
>
> -       // Restore guest regs x19-x29, lr
> +       // Restore guest regs x18-x29, lr
>         restore_callee_saved_regs x18
>
> -       // Restore guest reg x18
> -       ldr     x18,      [x18, #CPU_XREG_OFFSET(18)]
> -
>         // Do not touch any register after this!
>         eret
>         sb
> @@ -114,7 +113,7 @@ ENTRY(__guest_exit)
>         // Retrieve the guest regs x0-x1 from the stack
>         ldp     x2, x3, [sp], #16       // x0, x1
>
> -       // Store the guest regs x0-x1 and x4-x18
> +       // Store the guest regs x0-x1 and x4-x17
>         stp     x2, x3,   [x1, #CPU_XREG_OFFSET(0)]
>         stp     x4, x5,   [x1, #CPU_XREG_OFFSET(4)]
>         stp     x6, x7,   [x1, #CPU_XREG_OFFSET(6)]
> @@ -123,9 +122,8 @@ ENTRY(__guest_exit)
>         stp     x12, x13, [x1, #CPU_XREG_OFFSET(12)]
>         stp     x14, x15, [x1, #CPU_XREG_OFFSET(14)]
>         stp     x16, x17, [x1, #CPU_XREG_OFFSET(16)]
> -       str     x18,      [x1, #CPU_XREG_OFFSET(18)]
>
> -       // Store the guest regs x19-x29, lr
> +       // Store the guest regs x18-x29, lr
>         save_callee_saved_regs x1
>
>         get_host_ctxt   x2, x3
> --
> 2.23.0.866.gb869b98d4c-goog
>
