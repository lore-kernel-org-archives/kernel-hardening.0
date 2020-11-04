Return-Path: <SRS0=dNUc=EK=lists.openwall.com=kernel-hardening-return-20358-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3F9C4741F
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 15:19:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CA6EB2074F
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 15:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NptPlEGj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA6EB2074F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20358-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30150 invoked by uid 550); 4 Nov 2020 15:19:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30125 invoked from network); 4 Nov 2020 15:19:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IKIIpB9wqyidyjb1EI8WFpMa+/cnKeKADUKKGpWDv08=;
        b=NptPlEGjmoYRgz9gbQS8+xuGz9yZ8ay7KQ+4RLy0Mi9mgRLXLF7eSZri//Wv+ozuMd
         Za11jHGFTilOW2qjOreq4UpZUbqKBdoZtjPfrkHP1vxN+LpehgkkLLUYLQ/wH0RWeB0E
         /lqqxJ4PWBA8iwO39iRsRwKTO9IHld8M2N848B5uF1c7JhloOl5YJaoZjXpW9YC+P5od
         21A50Sqd7K1N7GuWHBbI4fFpUNKFGtX2LrSUcGUiki5jp3wLqtoCPlOeajTVMknzrxLv
         HSkXI7714dQumN5Lp7mTEe0xTA+SLaSfod1Enr6YV38J8rzHmII/CTrnQV73l1i7dKui
         dWAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IKIIpB9wqyidyjb1EI8WFpMa+/cnKeKADUKKGpWDv08=;
        b=awIzc5uorLaAF7gSSKCYgvn6rL/bwHG8GntHmfosCzIHdFWPHybdP2yK55Xp4BziM4
         Z4atMV7bLJOMtcNpOFzxZ8Js49xZOdYfhw4l+1KrPjht0UdYZzkZWZpLcQ5hlv7Tlmk1
         i2V4DN6tfj6jbxCrkT/U6aeZre0kue7P9xUil5uYxCobpSl6k9uMkwlqv/Ln0ZjqL9S1
         3+R7Q+4vb+eUuWisRqVlKJJZqIGoB63vqOo2WI/mlaAbfWa4ICamPSru/u2K28rvOWxm
         7EAC9uo96wu9OUs+A9j1xyAPONTTqZo71MOQCS19VBh9qAS+B3z+nTQOUxv1MgsNjZEA
         ZBmA==
X-Gm-Message-State: AOAM5320m7XpmTg6duN9LlTtxLt9O7bkd7G123s3RitySKH787Q7W948
	b2YKTGoLoYD7BpEQhvrU5d0=
X-Google-Smtp-Source: ABdhPJxRsNTI+FRktRgXc8IKzV3bqj8ft1XhtV7Y1uPyzyr4gei7EPySND+E7YvldxtAg6TA6B1hkw==
X-Received: by 2002:ac2:58f6:: with SMTP id v22mr10547760lfo.431.1604503163884;
        Wed, 04 Nov 2020 07:19:23 -0800 (PST)
Subject: Re: [PATCH 0/4] aarch64: avoid mprotect(PROT_BTI|PROT_EXEC) [BZ
 #26831]
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Florian Weimer <fweimer@redhat.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 libc-alpha@sourceware.org, Jeremy Linton <jeremy.linton@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>,
 Salvatore Mesoraca <s.mesoraca16@gmail.com>,
 Lennart Poettering <mzxreary@0pointer.de>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com,
 linux-hardening@vger.kernel.org
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
 <20201103173438.GD5545@sirena.org.uk>
 <20201104092012.GA6439@willie-the-truck>
 <87h7q54ghy.fsf@oldenburg2.str.redhat.com>
 <d2f51a90-c5d6-99bd-35b8-f4fded073f95@gmail.com>
 <20201104143500.GC28902@gaia>
From: Topi Miettinen <toiwoton@gmail.com>
Message-ID: <f595e572-40bc-a052-f3f2-763433d6762f@gmail.com>
Date: Wed, 4 Nov 2020 17:19:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201104143500.GC28902@gaia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 4.11.2020 16.35, Catalin Marinas wrote:
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
> [...]
>>> As you can see, this reference implementation creates a PROT_WRITE
>>> mapping aliased to a PROT_EXEC mapping, so it actually reduces security
>>> compared to something that generates the code in an anonymous mapping
>>> and calls mprotect to make it executable.
> [...]
>> If a service legitimately needs executable and writable mappings (due to
>> JIT, trampolines etc), it's easy to disable the filter whenever really
>> needed with "MemoryDenyWriteExecute=no" (which is the default) in case of
>> systemd or a TE rule like "allow type_t self:process { execmem };" for
>> SELinux. But this shouldn't be the default case, since there are many
>> services which don't need W&X.
> 
> I think Drepper's point is that separate X and W mappings, with enough
> randomisation, would be more secure than allowing W&X at the same
> address (but, of course, less secure than not having W at all, though
> that's not always possible).
> 
>> I'd also question what is the value of BTI if it can be easily circumvented
>> by removing PROT_BTI with mprotect()?
> 
> Well, BTI is a protection against JOP attacks. The assumption here is
> that an attacker cannot invoke mprotect() to disable PROT_BTI. If it
> can, it's probably not worth bothering with a subsequent JOP attack, it
> can already call functions directly.

I suppose that the target for the attacker is to eventually perform 
system calls rather than looping forever in JOP/ROP gadgets.

> I see MDWX not as a way of detecting attacks but rather plugging
> inadvertent security holes in certain programs. On arm64, such hardening
> currently gets in the way of another hardening feature, BTI.

I don't think it has to get in the way at all. Why wouldn't something 
simple like this work:

diff --git a/elf/dl-load.c b/elf/dl-load.c
index 646c5dca40..12a74d15e8 100644
--- a/elf/dl-load.c
+++ b/elf/dl-load.c
@@ -1170,8 +1170,13 @@ _dl_map_object_from_fd (const char *name, const 
char *origname, int fd,
             c->prot |= PROT_READ;
           if (ph->p_flags & PF_W)
             c->prot |= PROT_WRITE;
-         if (ph->p_flags & PF_X)
+         if (ph->p_flags & PF_X) {
             c->prot |= PROT_EXEC;
+#ifdef PROT_BTI
+           if (GLRO(dl_bti) & 1)
+             c->prot |= PROT_BTI;
+#endif
+         }
  #endif
           break;

diff --git a/elf/dl-support.c b/elf/dl-support.c
index 7704c101c5..22c7cc7b81 100644
--- a/elf/dl-support.c
+++ b/elf/dl-support.c
@@ -222,7 +222,7 @@ __rtld_lock_define_initialized_recursive (, 
_dl_load_write_lock)


  #ifdef HAVE_AUX_VECTOR
-int _dl_clktck;
+int _dl_clktck, _dl_bti;

  void
  _dl_aux_init (ElfW(auxv_t) *av)
@@ -294,6 +294,11 @@ _dl_aux_init (ElfW(auxv_t) *av)
        case AT_RANDOM:
         _dl_random = (void *) av->a_un.a_val;
         break;
+#ifdef PROT_BTI
+      case AT_BTI:
+       _dl_bti = (void *) av->a_un.a_val;
+       break;
+#endif
        DL_PLATFORM_AUXV
        }
    if (seen == 0xf)

Kernel sets the aux vector to indicate that BTI should be enabled for 
all segments and main exe is already protected.

-Topi
