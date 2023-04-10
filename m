Return-Path: <kernel-hardening-return-21658-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 66FF6C77B61
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Apr 2023 20:47:40 +0000 (UTC)
Received: (qmail 1989 invoked by uid 550); 10 Apr 2023 20:47:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1957 invoked from network); 10 Apr 2023 20:47:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681159638;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wW2CsOzKco12uWWod+vD1N6uU5SvCHMYgWY1z6r3F6M=;
        b=kARiaH+sbyA8AN4sXtY86hjyxA0xBZ2CpHN6GsoQ4XqawGohQKf9bcleripc62j98r
         51+W7GxBOnKKvawhrnucIkpyJ3A05mfeyeh/E0b8Lm3iT/tSNrdoNhbJs2qB4OWtMJJQ
         nJPG2Nh3s7nV55Hwa7PVtHO2vnm0Q6AcX3a9MekSKmVkruEPlMMp1Jp5ljY822nNyWZj
         YM3R0QWN8VcmVK3RaZ1bsIGWqqUDQQac/bbsgHpstpJx+XtFcThw06C2+/r0R4lu1FUy
         DumFfWRhAeFi3mUZtyNB3pnKkW3osBuYCNlV0rhKcS0sZSQ7hxEr1tfj6ciIkd3wJiwX
         ssPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681159638;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wW2CsOzKco12uWWod+vD1N6uU5SvCHMYgWY1z6r3F6M=;
        b=uBZiqSRNFA939DYuBxa8vuhWzNuij292ImJRWcSx564Agh1GUUEf8medMta87ScMeq
         RTQaji1AQloK40IabmRNPiu/CACAbeLbW/tDdWteTuMdI8N2v3Gh3j9q7Ncb4oh1VV5Q
         dZo9Q2VXWyu/WyVmJuw2OuvlROLFCcp720rUQ8Wn7ZbS+pVnGbN+IUah9kgdhYSynAN8
         MhuKJx+5d8NBzUyesoHzXR0wIyT4o5PE/Vl60TORdoIEyYoUF25y9/6wGbBqbShmWwQy
         4idiQV+aa479sqlEYv9gAu2vKNl45WgInW41FJxeGvzwOiOP3j13vccxRz8gyv50yd2R
         kPWg==
X-Gm-Message-State: AAQBX9cHHEe/DN6Olny5gGm/1b++cX8hw2Q4fpy+lCBOXavh78X8S/vQ
	Gi+QpKGa7Iib2xNbjZ4wj40=
X-Google-Smtp-Source: AKy350ZRoGOHgWT/YIps4oRfYxG3Kfq7547hKudtc2Dk4JnS+x9QrNS/nkbYFw1ze1+U5mFuTq2qBw==
X-Received: by 2002:a19:f712:0:b0:4e9:59cd:416c with SMTP id z18-20020a19f712000000b004e959cd416cmr2491997lfe.0.1681159637987;
        Mon, 10 Apr 2023 13:47:17 -0700 (PDT)
Message-ID: <4017c904-9918-3e0c-b687-f55cfc5c4f4d@gmail.com>
Date: Mon, 10 Apr 2023 23:47:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Per-process flag set via prctl() to deny module loading?
To: Tycho Andersen <tycho@tycho.pizza>
Cc: linux-modules <linux-modules@vger.kernel.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <640c4327-0b40-f964-0b5b-c978683ac9ba@gmail.com>
 <ZDQQ0B35NcYwQMyy@tycho.pizza>
Content-Language: en-US
From: Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <ZDQQ0B35NcYwQMyy@tycho.pizza>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.4.2023 16.36, Tycho Andersen wrote:
> On Mon, Apr 10, 2023 at 01:06:00PM +0300, Topi Miettinen wrote:
>> I'd propose to add a per-process flag to irrevocably deny any loading of
>> kernel modules for the process and its children. The flag could be set (but
>> not unset) via prctl() and for unprivileged processes, only when
>> NoNewPrivileges is also set. This would be similar to CAP_SYS_MODULE, but
>> unlike capabilities, there would be no issues with namespaces since the flag
>> isn't namespaced.
>>
>> The implementation should be very simple.
>>
>> Preferably the flag, when configured, would be set by systemd, Firejail and
>> maybe also container managers. The expectation would be that the permission
>> to load modules would be retained only by udev and where SUID needs to be
>> allowed (NoNewPrivileges unset).
> 
> You can do something like this today via STATIC_USERMODEHELPER without
> the need for kernel patches. It is a bit heavyweight for a
> general-purpose system though.

So the user mode helper would be launched whenever there is a module 
request and it would check whether the process is allowed to load 
modules or not? Does it know which process caused the module to be 
loaded and what were its credentials at that time?

-Topi

