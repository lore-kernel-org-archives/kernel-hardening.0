Return-Path: <SRS0=aFuA=EK=lists.openwall.com=kernel-hardening-return-20364-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA073C2D0A3
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 19:06:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D47CE206B7
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 19:06:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D47CE206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20364-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7699 invoked by uid 550); 4 Nov 2020 19:06:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3670 invoked from network); 4 Nov 2020 18:59:58 -0000
Subject: Re: [PATCH 0/4] aarch64: avoid mprotect(PROT_BTI|PROT_EXEC) [BZ
 #26831]
To: Mark Rutland <mark.rutland@arm.com>, Topi Miettinen <toiwoton@gmail.com>
Cc: Florian Weimer <fweimer@redhat.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 libc-alpha@sourceware.org, Catalin Marinas <catalin.marinas@arm.com>,
 Kees Cook <keescook@chromium.org>,
 Salvatore Mesoraca <s.mesoraca16@gmail.com>,
 Lennart Poettering <mzxreary@0pointer.de>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com,
 linux-hardening@vger.kernel.org
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
 <20201103173438.GD5545@sirena.org.uk>
 <20201104092012.GA6439@willie-the-truck>
 <87h7q54ghy.fsf@oldenburg2.str.redhat.com>
 <d2f51a90-c5d6-99bd-35b8-f4fded073f95@gmail.com>
 <20201104152032.GC7577@C02TD0UTHF1T.local>
From: Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <dd12755d-9487-718e-616a-f342a1801241@arm.com>
Date: Wed, 4 Nov 2020 12:59:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201104152032.GC7577@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

Hi,

On 11/4/20 9:20 AM, Mark Rutland wrote:
> On Wed, Nov 04, 2020 at 11:55:57AM +0200, Topi Miettinen wrote:
>> On 4.11.2020 11.29, Florian Weimer wrote:
>>> * Will Deacon:
>>>
>>>> Is there real value in this seccomp filter if it only looks at mprotect(),
>>>> or was it just implemented because it's easy to do and sounds like a good
>>>> idea?
>>>
>>> It seems bogus to me.  Everyone will just create alias mappings instead,
>>> just like they did for the similar SELinux feature.  See “Example code
>>> to avoid execmem violations” in:
>>>
>>>     <https://www.akkadia.org/drepper/selinux-mem.html>
>>
>> Also note "But this is very dangerous: programs should never use memory
>> regions which are writable and executable at the same time. Assuming that it
>> is really necessary to generate executable code while the program runs the
>> method employed should be reconsidered."
> 
> Sure, and to be clear we're not trying to violate the "at the same time"
> property. We do not want to permit simultaneous PROT_WRITE and PROT_EXEC
> at any instant in time. What we're asking is to not block changing
> permissions to PROT_EXEC in the absence of PROT_WRITE.
> 
> I think that the goal of preventing WRITE -> EXEC transitions for some
> memory is sane, but I think the existing kernel primitives available to
> systemd don't allow us to do that in a robust way because we don't have
> all the relevant state tracked and accessible, and the existing approach
> gets in the way of doing the right thing for other mitigations.
> 
> Consequently I think it would be better going forward to add a more
> robust (kernel) mechanism for enforcement that can distinguish
> WRITE->EXEC from EXEC->EXEC+BTI, and e.g. can be used to forbid aliasing
> mappings with differing W/X permissions. Then userspace could eventually
> transition over to that and get /stronger/ protection while permitting
> the BTI case we'd like to work now.
> 
>> If a service legitimately needs executable and writable mappings (due to
>> JIT, trampolines etc), it's easy to disable the filter whenever really
>> needed with "MemoryDenyWriteExecute=no" (which is the default) in case of
>> systemd or a TE rule like "allow type_t self:process { execmem };" for
>> SELinux. But this shouldn't be the default case, since there are many
>> services which don't need W&X.
>>
>> I'd also question what is the value of BTI if it can be easily circumvented
>> by removing PROT_BTI with mprotect()?
> 
> I agree that turning BTI off is a concern, and to that end I'd like to
> add an enforcement mechanism whereby we could prevent that (ideally the
> same mechanism by which we could prevent WRITE -> EXEC transitions).
> 
> But, as with all things it's a matter of degree. MDWE and BTI are both
> hurdles to an adversary, but neither are absolutes and there are
> approaches to bypass either. By the time someone's issuing mprotect()
> with an arbitrary VA and/or prot, they are liable to have been able to
> do the same with mmap() and circumvent MDWE.
> 
> I'd really like to not have BTI silently disabled in order to work with
> MDWE, because the risk is that it gets silently disabled elsewhere. The
> risk of the changing the kernel to enable BTI for a binary is not well
> known since we don't control other peoples libraries that might end up
> not being compatible somehow with that. The risk of disabling a portion
> of the MDWE protections seems to be the least out of the options we have
> available, as unfortunate as it seems, and I think we can come up with a
> better MDWE approach going forward.

OTOH, You don't really want to blanket disable either protection, and 
unfortunately  you can't really tell until its too late if the service 
is fully BTI enabled. So you either end up disabling MDWE unnecessarily, 
or you delay until the only choice is not enabling BTI.

I guess there is another option too, which is some kind of delayed MDWE 
policy that only turns on once the service has started, but that isn't 
ideal either.

.

> 
> Thanks,
> Mark.
> 

