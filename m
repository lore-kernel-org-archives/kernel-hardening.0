Return-Path: <SRS0=OzGH=Y4=lists.openwall.com=kernel-hardening-return-17263-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0
	tests=BUG6152_INVALID_DATE_TZ_ABSURD,INVALID_DATE_TZ_ABSURD,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB10CA9ECF
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 17:00:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C088C2080F
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 17:00:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C088C2080F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17263-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25883 invoked by uid 550); 4 Nov 2019 17:00:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25860 invoked from network); 4 Nov 2019 17:00:03 -0000
To: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v4 06/17] scs: add accounting
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 04 Nov 2019 18:08:50 +0109
From: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Dave Martin <dave.martin@arm.com>, Kees Cook <keescook@chromium.org>, Laura
 Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Nick
 Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, Miguel
 Ojeda <miguel.ojeda.sandonis@gmail.com>, Masahiro Yamada
 <yamada.masahiro@socionext.com>, clang-built-linux
 <clang-built-linux@googlegroups.com>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>, linux-arm-kernel
 <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CABCJKuegREpQiJCY01B_=nsNJFFCkyxxp63tQOPT=h+yAPifyA@mail.gmail.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com>
 <20191101221150.116536-7-samitolvanen@google.com>
 <791fc70f7bcaf13a89abaee9aae52dfe@www.loen.fr>
 <CABCJKuegREpQiJCY01B_=nsNJFFCkyxxp63tQOPT=h+yAPifyA@mail.gmail.com>
Message-ID: <5aaee4e0339daef7deadf29db9ea1747@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: samitolvanen@google.com, will@kernel.org, catalin.marinas@arm.com, rostedt@goodmis.org, mhiramat@kernel.org, ard.biesheuvel@linaro.org, dave.martin@arm.com, keescook@chromium.org, labbott@redhat.com, mark.rutland@arm.com, ndesaulniers@google.com, jannh@google.com, miguel.ojeda.sandonis@gmail.com, yamada.masahiro@socionext.com, clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false

On 2019-11-04 17:52, Sami Tolvanen wrote:
> On Mon, Nov 4, 2019 at 5:13 AM Marc Zyngier <maz@kernel.org> wrote:
>> Is there any reason why you're not consistently using only one of
>> "#if IS_ENABLED(...)" or "#ifdef ...", but instead a mix of both?
>
> This is to match the style already used in each file. For example,
> fs/proc/meminfo.c uses #ifdef for other configs in the same function,
> and include/linux/mmzone.h uses #if IS_ENABLED(...).

Ah, fair enough.

         M.
-- 
Jazz is not dead. It just smells funny...
