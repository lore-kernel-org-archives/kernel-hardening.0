Return-Path: <SRS0=EdaY=D7=lists.openwall.com=kernel-hardening-return-20261-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBFDC4363A
	for <kernel-hardening@archiver.kernel.org>; Sat, 24 Oct 2020 11:34:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9956521D43
	for <kernel-hardening@archiver.kernel.org>; Sat, 24 Oct 2020 11:34:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mqiOOs7T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9956521D43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20261-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1784 invoked by uid 550); 24 Oct 2020 11:34:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1747 invoked from network); 24 Oct 2020 11:34:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IoKvQwjpmgnwDqwDMU0dzPR0LnLnshRSMNK/AI0kcxw=;
        b=mqiOOs7TyvklH3y6Ood3stRdGCXNjS2vgVdrSrZQ2N5rvNmXE4ypAGwbOH+pu5ZkZU
         cLFinzJ8s1Tc1dBlP3n6K9U1vTiiudbu4H1PwQEoeFI7WihRODKM6wJlcI16HoaXOosR
         PQtOWyYZ5vxd3flAAaj+Fgat/sdOALkni45sy0aydIfRvlwxm3dwa0l5WDx3QP/dG3y6
         pYy6zdGvNsP3Z9aeTINusM1N7KGKTk/bljhK8h8j6gQ8iHYyydmfoS0E2Io29bJlsvT5
         ZfDv1jpttgUuhifKJENIVwPfjjhn0XCWIAk65JMYKL0UIJotL4bcojoT7g08pknvpe9X
         BBhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IoKvQwjpmgnwDqwDMU0dzPR0LnLnshRSMNK/AI0kcxw=;
        b=iwNw+a29hXpsxsU38A2djfC61cpIRtQi20TIhm3EfaJXH6tQS7qPuQUsOf7L83akL5
         bF8xaWbPA0vT5U/CVRVpSbqxvHkShtMnd0va+Mq+5N4YH3rOYFu+uoie6abIA4/EmLi4
         0OTkRW0oBotqueRG1uS/AZ7ukO3OlT8cojnR3ZuM2XyCEFSJu0+QeGnFEjH9iWAPVn67
         pttXNTBCpaE1ebGeqGLM02ed3dZltnJuflN728SxDFhbQBCsgEcYMOZDENFHSTOL8ok5
         Q6eGxOmGe4uei2Sso2+EH3B/4MzTr8elMm6zXP0J61+cigNoJkqD+QgXslC/BfVzFapD
         x4kw==
X-Gm-Message-State: AOAM533GtvU6ScmCa0ASEGMpWFWf6OOMIuWy6XGLJCmQukreydEirYAZ
	oN/Q191FF0EZNc+qji/pt+s=
X-Google-Smtp-Source: ABdhPJzwvsaTluGQK36qa7V3CiVSFtEKeTqt9O3nz3uBAt8xGRnoa/SVo39MAjPgTAB/taz96NuywQ==
X-Received: by 2002:a19:2355:: with SMTP id j82mr1914155lfj.36.1603539267465;
        Sat, 24 Oct 2020 04:34:27 -0700 (PDT)
Subject: Re: BTI interaction between seccomp filters in systemd and glibc
 mprotect calls, causing service failures
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Jeremy Linton <jeremy.linton@arm.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, libc-alpha@sourceware.org,
 systemd-devel@lists.freedesktop.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@kernel.org>,
 Dave Martin <dave.martin@arm.com>, Catalin Marinas
 <Catalin.Marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 linux-hardening@vger.kernel.org
References: <8584c14f-5c28-9d70-c054-7c78127d84ea@arm.com>
 <20201022075447.GO3819@arm.com>
 <78464155-f459-773f-d0ee-c5bdbeb39e5d@gmail.com>
 <202010221256.A4F95FD11@keescook>
 <180cd894-d42d-2bdb-093c-b5360b0ecb1e@gmail.com>
 <CAJHCu1Jrtx=OVEiTVwPJg7CxRkV83tS=HsYeLoAGRf_tgYq_iQ@mail.gmail.com>
From: Topi Miettinen <toiwoton@gmail.com>
Message-ID: <3cb894d4-049f-aa25-4450-d1df36a1b92e@gmail.com>
Date: Sat, 24 Oct 2020 14:34:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAJHCu1Jrtx=OVEiTVwPJg7CxRkV83tS=HsYeLoAGRf_tgYq_iQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 23.10.2020 20.52, Salvatore Mesoraca wrote:
> Hi,
> 
> On Thu, 22 Oct 2020 at 23:24, Topi Miettinen <toiwoton@gmail.com> wrote:
>> SARA looks interesting. What is missing is a prctl() to enable all W^X
>> protections irrevocably for the current process, then systemd could
>> enable it for services with MemoryDenyWriteExecute=yes.
> 
> SARA actually has a procattr[0] interface to do just that.
> There is also a library[1] to help using it.

That means that /proc has to be available and writable at that point, so 
setting up procattrs has to be done before mount namespaces are set up. 
In general, it would be nice for sandboxing facilities in kernel if 
there would be a way to start enforcing restrictions only at next 
execve(), like setexeccon() for SELinux and aa_change_onexec() for 
AppArmor. Otherwise the exact order of setting up various sandboxing 
options can be very tricky to arrange correctly, since each option may 
have a subtle effect to the sandboxing features enabled later. In case 
of SARA, the operations done between shuffling the mount namespace and 
before execve() shouldn't be affected so it isn't important. Even if it 
did (a new sandboxing feature in the future would need trampolines or 
JIT code generation), maybe the procattr file could be opened early but 
it could be written closer to execve().

-Topi
