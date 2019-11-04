Return-Path: <SRS0=XyzO=Y4=lists.openwall.com=kernel-hardening-return-17260-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0
	tests=BUG6152_INVALID_DATE_TZ_ABSURD,INVALID_DATE_TZ_ABSURD,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F345CA9EB5
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 13:30:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 81EAA20B7C
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 13:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81EAA20B7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17260-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7798 invoked by uid 550); 4 Nov 2019 13:30:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7778 invoked from network); 4 Nov 2019 13:30:41 -0000
To: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v4 03/17] arm64: kvm: stop treating register x18 as  caller save
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 04 Nov 2019 14:39:34 +0109
From: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Dave Martin <dave.martin@arm.com>, Kees Cook <keescook@chromium.org>, Laura
 Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Nick
 Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, Miguel
 Ojeda <miguel.ojeda.sandonis@gmail.com>, Masahiro Yamada
 <yamada.masahiro@socionext.com>, <clang-built-linux@googlegroups.com>,
 <kernel-hardening@lists.openwall.com>,
 <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <79e8f958cbde52a3d90aec24dd4638d9@www.loen.fr>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com>
 <20191101221150.116536-4-samitolvanen@google.com>
 <79e8f958cbde52a3d90aec24dd4638d9@www.loen.fr>
Message-ID: <63921b46250e2eb8eb9fcf0f8ec93b0c@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: samitolvanen@google.com, will@kernel.org, catalin.marinas@arm.com, rostedt@goodmis.org, mhiramat@kernel.org, ard.biesheuvel@linaro.org, dave.martin@arm.com, keescook@chromium.org, labbott@redhat.com, mark.rutland@arm.com, ndesaulniers@google.com, jannh@google.com, miguel.ojeda.sandonis@gmail.com, yamada.masahiro@socionext.com, clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false

On 2019-11-04 12:13, Marc Zyngier wrote:
> Hi Sami,
>
> On 2019-11-01 23:20, Sami Tolvanen wrote:
>> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>
>> In preparation of reserving x18, stop treating it as caller save in
>> the KVM guest entry/exit code. Currently, the code assumes there is
>> no need to preserve it for the host, given that it would have been
>> assumed clobbered anyway by the function call to __guest_enter().
>> Instead, preserve its value and restore it upon return.
>>
>> Link: https://patchwork.kernel.org/patch/9836891/
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> [Sami: updated commit message, switched from x18 to x29 for the 
>> guest
>> context]
>> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
>> Reviewed-by: Kees Cook <keescook@chromium.org>
>
> If you intend for this to be merged via the arm64 tree, please add my
>
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Erm... Muscle memory strikes again. Please ignore the above and use the
following instead:

Reviewed-by: Marc Zyngier <maz@kernel.org>

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
