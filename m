Return-Path: <SRS0=FbfW=5P=lists.openwall.com=kernel-hardening-return-18282-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B54AC43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 00:49:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7B338206CC
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 00:49:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="n6lc+LK1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B338206CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18282-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20152 invoked by uid 550); 29 Mar 2020 22:43:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20124 invoked from network); 29 Mar 2020 22:43:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kl5YMuDzJs4NG/vSYEC77l8Gtiw/O3eg/TM2DvabUpw=;
        b=n6lc+LK1FCt0gR4ZOE1QFdAxCzrUaV/yMDw66ahvhK3Ad302xoFyhH20qVDneO9BBP
         KXQzPPHKnvYI+ID8fIP9iXe/Y9Fp8+ppZpzepTtbO6WdC3jS+Wbf05Ini1/engjN6evw
         TH0DkyuMh9cqLSHwMC2mOj+WiW41pfI0e/7iQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kl5YMuDzJs4NG/vSYEC77l8Gtiw/O3eg/TM2DvabUpw=;
        b=lBNZdIkhJMVRvYSk5TpmbiPpB+0ShaPDewfoKs+bo756Twf3infPFE3NomZg6P0Woj
         oeo2ayJKRWFVZFnJuc4zTSI4IHk0MGW0CKM+zF5e5qB6SYYKHCkdXfmJKvYN+MazcZDJ
         CRDAMFu6/bxqsu4HCjgEN75Aiqukb2RLbn0n0R33USh2VnUp0e4Y3LcuQE0PCE10UMvu
         SxECntEc5kStI9hWnLUyze4i9byZKwAFhVbNXCy5DRC4cySvabt06NBOxKSYNRXHr5Bx
         XVIaktA34b6SjL5bKHahZwE+ye7pHmR7Y5vNYqMOaB0+DE9gPdOSMsqY82ew45Xa7cmf
         f+qw==
X-Gm-Message-State: ANhLgQ0GA87pxjCOHycGaufQWADT+F8+n6nU68qrlT+lfyI4lzL+Ljgu
	DcvOgbbrhhIJqiLiWROTvWEDZQ==
X-Google-Smtp-Source: ADFU+vvd9QEm0i5cPyf+tnFqUbkb5oWWEC4hoOa5TSqI3Q0NsG7wBiz9cwW0Ji6+BaXNXuVVZmpVjA==
X-Received: by 2002:a17:902:6b07:: with SMTP id o7mr9615611plk.141.1585521796466;
        Sun, 29 Mar 2020 15:43:16 -0700 (PDT)
Date: Sun, 29 Mar 2020 15:43:14 -0700
From: Kees Cook <keescook@chromium.org>
To: Adam Zabrocki <pi3@pi3.com.pl>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: Re: Curiosity around 'exec_id' and some problems associated with it
Message-ID: <202003291528.730A329@keescook>
References: <20200324215049.GA3710@pi3.com.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324215049.GA3710@pi3.com.pl>

Hi!

Sorry, I missed this originally because it got filed into my lkml
archive and not kernel-hardening, but no one actually reads lkml
directly, myself included -- it's mostly a thread archive. I'll update
my filters, and I've added a handful of people to CC that might be
interested in looking at this too. Here's the full email, I trimmed
heavily since it's very detailed:
https://lore.kernel.org/lkml/20200324215049.GA3710@pi3.com.pl/

On Tue, Mar 24, 2020 at 10:50:49PM +0100, Adam Zabrocki wrote:
> Some curiosities which are interesting to point out:
> 
>  1) Linus Torvalds in 2012 suspected that such 'overflow' might be possible.
>     You can read more about it here:
> 
>     https://www.openwall.com/lists/kernel-hardening/2012/03/11/4
> 
>  2) Solar Designer in 1999(!) was aware about the problem that 'exit_signal' can
>     be abused. The kernel didn't protect it at all at that time. So he came up
>     with the idea to introduce those two counters to deal with that problem.
>     Originally, these counters were defined as "long long" type. However, during
>     the revising between September 14 and September 16, 1999 he switched from
>     "long long" to "int" and introduced integer wraparound handling. His patches
>     were merged to the kernel 2.0.39 and 2.0.40.
> 
>  3) It is worth to read the Solar Designer's message during the discussion about
>     the fix for the problem CVE-2012-0056 (I'm referencing this problem later in
>     that write-up about "Problem II"):
> 
>     https://www.openwall.com/lists/kernel-hardening/2012/03/11/12

There was some effort made somewhat recently to get this area fixed:
https://lore.kernel.org/linux-fsdevel/1474663238-22134-3-git-send-email-jann@thejh.net/

Nothing ultimately landed, but it's worth seeing if we could revitalize
interest. Part of Jann's series was also related to fixing issues with
cred_guard_mutex, which is getting some traction now too:
https://lore.kernel.org/lkml/AM6PR03MB5170938306F22C3CF61CC573E4CD0@AM6PR03MB5170.eurprd03.prod.outlook.com/

> In short, if you hold the file descriptor open over an execve() (e.g. share it
> with child) the old VM is preserved (refcounted) and might be never released.
> Essentially, mother process' VM will be still in memory (and pointer to it is
> valid) even if the mother process passed an execve().
> This is some kind of 'memory leak' scenario. I did a simple test where process
> open /proc/self/maps file and calls clone() with CLONE_FILES flag. Next mother
> 'overwrite' itself by executing SUID binary (doesn't need to be SUID), and child
> was still able to use the original file descriptor - it's valid.

It'd be worth exploring where the resource counting is happening for
this. I haven't looked to see how much of the VM stays in kernel memory
in this situation. It probably wouldn't be hard to count it against an
rlimit or something.

Thanks for the details! I hope someone will have time to look into this.
It's a bit of a "long timeframe attack", so it's not gotta a lot of
priority (obviously). :)

-Kees

-- 
Kees Cook
