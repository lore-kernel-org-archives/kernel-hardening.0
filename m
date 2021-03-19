Return-Path: <SRS0=xdDP=IR=lists.openwall.com=kernel-hardening-return-21015-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A5DC433DB
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 22:51:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5DA6B61970
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 22:51:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DA6B61970
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=overdrivepizza.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21015-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9763 invoked by uid 550); 19 Mar 2021 22:51:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9728 invoked from network); 19 Mar 2021 22:51:21 -0000
X-Originating-IP: 73.37.121.169
Subject: Re: Fine-grained Forward CFI on top of Intel CET / IBT
From: Joao Moreira <joao@overdrivepizza.com>
To: Kees Cook <keescook@chromium.org>
Cc: x86-64-abi@googlegroups.com, kernel-hardening@lists.openwall.com,
 samitolvanen@google.com, hjl.tools@gmail.com, linux-hardening@vger.kernel.org
References: <0537dc00-db0e-265b-9371-783c55717e74@overdrivepizza.com>
 <202103181230.2CA57FA5@keescook>
 <8e7dfa49-2c74-1349-017c-9a4700557519@overdrivepizza.com>
Message-ID: <632c02ef-efef-c068-1228-1b869d395142@overdrivepizza.com>
Date: Fri, 19 Mar 2021 15:51:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <8e7dfa49-2c74-1349-017c-9a4700557519@overdrivepizza.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US


>> That is a good point about R11 availability. Have you examined kernel
>> images for unintended gadgets? It seems like it'd be rare to find an 
>> arbitrary R11 load
>> followed by an indirect call together, but stranger gadgets show up, and
>> before the BPF JIT obfuscation happened, it was possible for attackers
>> (with sufficient access) to construct a series of immediates that would
>> contain the needed gadgets. (And not all systems run with BPF JIT
>> hardening enabled.)
>
> I haven't. On a CET-enabled environment, these unintended gadgets 
> would need to be preceded with an endbr instruction, otherwise they 
> won't be reachable indirectly. I assume that these cases can still 
> exist (specially in the presence of things like vulnerable BPF JIT or 
> if you consider full non-fineibt-instrumented functions working as 
> gadgets), but that this is a raised bar. Besides that, there are 
> patches like this one (which unfortunately was abandoned) that could 
> come handy:
>
> https://reviews.llvm.org/D88194
>
Actually (as clear in the end of the patch review) this was replaced by 
a different patch, which got in :)

review: https://reviews.llvm.org/D89178

commit: https://reviews.llvm.org/rGf385823e04f300c92ec03dbd660d621cc618a271


o/

Joao

